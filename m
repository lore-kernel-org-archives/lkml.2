Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab1KPOhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:37:24 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55620 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827Ab1KPOhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:37:22 -0500
Message-ID: <4EC3CA9A.3070401@polito.it>
Date: Wed, 16 Nov 2011 15:37:14 +0100
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmorris@namei.org, Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ima: split ima_add_digest_entry() function
References: <1321438229-18925-1-git-send-email-roberto.sassu@polito.it> <1321450690.1901.24.camel@falcor>
In-Reply-To: <1321450690.1901.24.camel@falcor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 02:38 PM, Mimi Zohar wrote:
> On Wed, 2011-11-16 at 11:10 +0100, Roberto Sassu wrote:
>> The ima_add_digest_entry() function has been split in order to avoid
>> adding an entry in the measurements list for which the PCR extend
>> operation subsequently fails. Required memory is allocated earlier in the
>> new function ima_prepare_template_entry() and the template entry is added
>> after ima_pcr_extend().
>>
>> Signed-off-by: Roberto Sassu<roberto.sassu@polito.it>
>

Hi Mimi

i don't know if this condition can happen, but suppose that
for whatever reason the PCR extend fails. In this case, since
the PCR is not extended, the measurements list can be modified,
by removing the non-measured entry, without this fact being
detected by the verifier. So, probably we can avoid to display
the entry.


> Not adding a measurement would certainly resolve the problems with
> validating the measurement list against the PCR, but poses a risk that
> something was read/executed that wasn't included in the measurement
> list.  One solution would be for IMA to queue these measurements for the
> TPM, but, I think, a better solution would be for the tpm driver to
> queue them.
>

I think this solution will not prevent that some measurements
are not included in the list, because, if i understand correctly,
queuing an operation means that the latter can be executed after
the list mutex is released. After that, a malicious program may
corrupt the queue, hiding its presence to the verifier.

There is also another issue to solve (but i don't know if this
can really happen): a process requests a system call but, at the
time IMA is invoked, there is not enough memory for allocating
a template entry. However, it may continue its execution if,
meanwhile, some memory resources are freed.

In my opinion, a viable solution may be to return an error in
the IMA hooks when an inode cannot be properly measured (exactly
as the ima-appraisal extension does). For compatibility reasons,
this feature can be disabled by introducing a new kernel parameter
that tell IMA to ignore errors.

Thanks

Roberto Sassu


> thanks,
>
> Mimi
>
>> ---
>>   security/integrity/ima/ima_queue.c |   35 ++++++++++++++++++++++++++---------
>>   1 files changed, 26 insertions(+), 9 deletions(-)
>>
>> diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
>> index 8e28f04..ddc7e18 100644
>> --- a/security/integrity/ima/ima_queue.c
>> +++ b/security/integrity/ima/ima_queue.c
>> @@ -59,30 +59,41 @@ static struct ima_queue_entry *ima_lookup_digest_entry(u8 *digest_value)
>>   	return ret;
>>   }
>>
>> -/* ima_add_template_entry helper function:
>> - * - Add template entry to measurement list and hash table.
>> +/* ima_prepare_template_entry helper function:
>> + * - prepare template entry before adding it to the measurement list.
>>    *
>>    * (Called with ima_extend_list_mutex held.)
>>    */
>> -static int ima_add_digest_entry(struct ima_template_entry *entry)
>> +static struct ima_queue_entry *ima_prepare_template_entry(
>> +					struct ima_template_entry *entry)
>>   {
>>   	struct ima_queue_entry *qe;
>> -	unsigned int key;
>>
>>   	qe = kmalloc(sizeof(*qe), GFP_KERNEL);
>>   	if (qe == NULL) {
>>   		pr_err("IMA: OUT OF MEMORY ERROR creating queue entry.\n");
>> -		return -ENOMEM;
>> +		goto out;
>>   	}
>>   	qe->entry = entry;
>> +out:
>> +	return qe;
>> +}
>> +
>> +/* ima_add_digest_entry helper function:
>> + * - Add template entry to measurement list and hash table.
>> + *
>> + * (Called with ima_extend_list_mutex held.)
>> + */
>> +static void ima_add_digest_entry(struct ima_queue_entry *qe)
>> +{
>> +	unsigned int key;
>>
>>   	INIT_LIST_HEAD(&qe->later);
>>   	list_add_tail_rcu(&qe->later,&ima_measurements);
>>
>>   	atomic_long_inc(&ima_htable.len);
>> -	key = ima_hash_key(entry->digest);
>> +	key = ima_hash_key(qe->entry->digest);
>>   	hlist_add_head_rcu(&qe->hnext,&ima_htable.queue[key]);
>> -	return 0;
>>   }
>>
>>   static int ima_pcr_extend(const u8 *hash)
>> @@ -104,6 +115,7 @@ static int ima_pcr_extend(const u8 *hash)
>>   int ima_add_template_entry(struct ima_template_entry *entry, int violation,
>>   			   const char *op, struct inode *inode)
>>   {
>> +	struct ima_queue_entry *qe;
>>   	u8 digest[IMA_DIGEST_SIZE];
>>   	const char *audit_cause = "hash_added";
>>   	int audit_info = 1;
>> @@ -118,10 +130,11 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
>>   		}
>>   	}
>>
>> -	result = ima_add_digest_entry(entry);
>> -	if (result<  0) {
>> +	qe = ima_prepare_template_entry(entry);
>> +	if (qe == NULL) {
>>   		audit_cause = "ENOMEM";
>>   		audit_info = 0;
>> +		result = -ENOMEM;
>>   		goto out;
>>   	}
>>
>> @@ -132,7 +145,11 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
>>   	if (result != 0) {
>>   		audit_cause = "TPM error";
>>   		audit_info = 0;
>> +		kfree(qe);
>> +		goto out;
>>   	}
>> +
>> +	ima_add_digest_entry(qe);
>>   out:
>>   	mutex_unlock(&ima_extend_list_mutex);
>>   	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode,
>
>

