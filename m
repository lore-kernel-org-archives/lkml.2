Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab1DTWvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 18:51:44 -0400
Received: from smtp105.prem.mail.sp1.yahoo.com ([98.136.44.60]:48844 "HELO
	smtp105.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752485Ab1DTWvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 18:51:42 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: sY6_3ngVM1n.xk3nDPtC0fa5PzG8xTCIKD5aLr3_d34l9bi
 WIMzJ4tbF87Qa0J96UYq3tbBf4BJbKpRJ8CfCFcGOTmyCngN9Blgaw8d9wkp
 pySZ2oRJy7QCfBKNr974XsfwccaXpoZjXa0tflnyquOG3sN32pm18szq5MQ9
 dDVv0tR6XWDv09F4cDVZR2VlSBU3kUR9pETMY4nY0roDwZv7DUnUdQJAFh0g
 MzpQO1elXt38H_h9CDsQtc3eAnskIgnkP._qitSJeQrvuiePdk1RISMu11kd
 T13VHAE7W2MG0sOS6HsFmbSI6b6rU3J9r2HvTzr40y12PrTVGf32HErSai8b
 .5nVkJLGI8Vq3VGQg96NwmpUb0_DTnonuKQ--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DAF637D.90606@schaufler-ca.com>
Date: Wed, 20 Apr 2011 15:51:41 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: jmorris@namei.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] SMACK: Add missing rcu_read_lock/unlock for process capability
 walk.
References: <1303336844-31074-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1303336844-31074-1-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/2011 3:00 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> smk_access_entry does a RCU list walk for a list shared with other
> threads. It relies on the caller doing rcu_read_lock().
> One caller forgot to do to this, which could lead to races
> on preemptible kernels.
>
> Move the rcu_read_lock() into smk_access_entry instead.

Nacked-by: Casey Schaufler <casey@schaufler-ca.com>

The lock was moved out of smk_access_entry in support of the
processing done in the smack_mmap_file() hook. Where do you see
a potential race, and which caller "forgot" to do the lock?

Thank you.

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  security/smack/smack_access.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index 7b0d3b3..43b20f3 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -92,6 +92,7 @@ int smk_access_entry(char *subject_label, char *object_label,
>  	int may = -ENOENT;
>  	struct smack_rule *srp;
>  
> +	rcu_read_lock();
>  	list_for_each_entry_rcu(srp, rule_list, list) {
>  		if (srp->smk_subject == subject_label ||
>  		    strcmp(srp->smk_subject, subject_label) == 0) {
> @@ -102,6 +103,7 @@ int smk_access_entry(char *subject_label, char *object_label,
>  			}
>  		}
>  	}
> +	rcu_read_unlock();
>  
>  	return may;
>  }
> @@ -184,9 +186,7 @@ int smk_access_flags(char *subject_label, char *object_label, int request,
>  	 * good. A negative response from smk_access_entry()
>  	 * indicates there is no entry for this pair.
>  	 */
> -	rcu_read_lock();
>  	may = smk_access_entry(subject_label, object_label, &smack_rule_list);
> -	rcu_read_unlock();
>  
>  	if (may > 0 && (request & may) == request)
>  		goto out_audit;

