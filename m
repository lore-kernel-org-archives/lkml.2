Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab1KPNlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:41:47 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:46249 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328Ab1KPNlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:41:46 -0500
Subject: Re: [PATCH 1/2] ima: split ima_add_digest_entry() function
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmorris@namei.org, Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Date: Wed, 16 Nov 2011 08:38:10 -0500
In-Reply-To: <1321438229-18925-1-git-send-email-roberto.sassu@polito.it>
References: <1321438229-18925-1-git-send-email-roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1321450690.1901.24.camel@falcor>
Mime-Version: 1.0
x-cbid: 11111613-7408-0000-0000-000000DB5F6C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 11:10 +0100, Roberto Sassu wrote:
> The ima_add_digest_entry() function has been split in order to avoid
> adding an entry in the measurements list for which the PCR extend
> operation subsequently fails. Required memory is allocated earlier in the
> new function ima_prepare_template_entry() and the template entry is added
> after ima_pcr_extend().
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>

Not adding a measurement would certainly resolve the problems with
validating the measurement list against the PCR, but poses a risk that
something was read/executed that wasn't included in the measurement
list.  One solution would be for IMA to queue these measurements for the
TPM, but, I think, a better solution would be for the tpm driver to
queue them.

thanks,

Mimi

> ---
>  security/integrity/ima/ima_queue.c |   35 ++++++++++++++++++++++++++---------
>  1 files changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
> index 8e28f04..ddc7e18 100644
> --- a/security/integrity/ima/ima_queue.c
> +++ b/security/integrity/ima/ima_queue.c
> @@ -59,30 +59,41 @@ static struct ima_queue_entry *ima_lookup_digest_entry(u8 *digest_value)
>  	return ret;
>  }
> 
> -/* ima_add_template_entry helper function:
> - * - Add template entry to measurement list and hash table.
> +/* ima_prepare_template_entry helper function:
> + * - prepare template entry before adding it to the measurement list.
>   *
>   * (Called with ima_extend_list_mutex held.)
>   */
> -static int ima_add_digest_entry(struct ima_template_entry *entry)
> +static struct ima_queue_entry *ima_prepare_template_entry(
> +					struct ima_template_entry *entry)
>  {
>  	struct ima_queue_entry *qe;
> -	unsigned int key;
> 
>  	qe = kmalloc(sizeof(*qe), GFP_KERNEL);
>  	if (qe == NULL) {
>  		pr_err("IMA: OUT OF MEMORY ERROR creating queue entry.\n");
> -		return -ENOMEM;
> +		goto out;
>  	}
>  	qe->entry = entry;
> +out:
> +	return qe;
> +}
> +
> +/* ima_add_digest_entry helper function:
> + * - Add template entry to measurement list and hash table.
> + *
> + * (Called with ima_extend_list_mutex held.)
> + */
> +static void ima_add_digest_entry(struct ima_queue_entry *qe)
> +{
> +	unsigned int key;
> 
>  	INIT_LIST_HEAD(&qe->later);
>  	list_add_tail_rcu(&qe->later, &ima_measurements);
> 
>  	atomic_long_inc(&ima_htable.len);
> -	key = ima_hash_key(entry->digest);
> +	key = ima_hash_key(qe->entry->digest);
>  	hlist_add_head_rcu(&qe->hnext, &ima_htable.queue[key]);
> -	return 0;
>  }
> 
>  static int ima_pcr_extend(const u8 *hash)
> @@ -104,6 +115,7 @@ static int ima_pcr_extend(const u8 *hash)
>  int ima_add_template_entry(struct ima_template_entry *entry, int violation,
>  			   const char *op, struct inode *inode)
>  {
> +	struct ima_queue_entry *qe;
>  	u8 digest[IMA_DIGEST_SIZE];
>  	const char *audit_cause = "hash_added";
>  	int audit_info = 1;
> @@ -118,10 +130,11 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
>  		}
>  	}
> 
> -	result = ima_add_digest_entry(entry);
> -	if (result < 0) {
> +	qe = ima_prepare_template_entry(entry);
> +	if (qe == NULL) {
>  		audit_cause = "ENOMEM";
>  		audit_info = 0;
> +		result = -ENOMEM;
>  		goto out;
>  	}
> 
> @@ -132,7 +145,11 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
>  	if (result != 0) {
>  		audit_cause = "TPM error";
>  		audit_info = 0;
> +		kfree(qe);
> +		goto out;
>  	}
> +
> +	ima_add_digest_entry(qe);
>  out:
>  	mutex_unlock(&ima_extend_list_mutex);
>  	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode,


