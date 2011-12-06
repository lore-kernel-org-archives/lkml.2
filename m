Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab1LFJd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:33:29 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:60731 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901Ab1LFJdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:33:25 -0500
Message-ID: <4EDDE133.3080903@polito.it>
Date: Tue, 06 Dec 2011 10:32:35 +0100
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        srajiv@linux.vnet.ibm.com, jmorris@namei.org
Subject: Re: [PATCH] ima: fix memory leak and invalid memory reference bugs
References: <1323099519-8922-1-git-send-email-roberto.sassu@polito.it> <1323112233.2061.95.camel@falcor>
In-Reply-To: <1323112233.2061.95.camel@falcor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 08:10 PM, Mimi Zohar wrote:
> On Mon, 2011-12-05 at 16:38 +0100, Roberto Sassu wrote:
>> This patch frees the memory of measurements entries that have already
>> been inserted in the measurements list and prevent the release when the
>> PCR extend operation failed.
>>
>> Signed-off-by: Roberto Sassu<roberto.sassu@polito.it>
>
> Thanks for the updated patch. I still need to test it, but it looks
> good.  The patch description should probably include an explanation of
> how a duplicate measurement is being added.  Something like:
>
> When a new measurement is added to the measurement list, this info is
> cached in the iint for performance.  When the inode is flushed from
> cache, the associated iint is flushed as well.  Subsequent access to the
> inode will cause it to be re-measured and will attempt to unnecessarily
> add it to the measurement list.
>
> This patch fixes a memory leak, by freeing the memory of the unnecessary
> duplicate measurement, and also fixes an invalid memory reference, by
> preventing the freeing of a new valid measurement entry, when the PCR
> extend operation fails.
>

Hi Mimi

do you mean that can i resend this patch as is or should i wait
until you tested it?

Thanks

Roberto Sassu


> thanks,
>
> Mimi
>
>> ---
>>   security/integrity/ima/ima_api.c   |    4 ++--
>>   security/integrity/ima/ima_queue.c |   10 ++++++----
>>   2 files changed, 8 insertions(+), 6 deletions(-)
>>
>> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
>> index 0d50df0..88a2788 100644
>> --- a/security/integrity/ima/ima_api.c
>> +++ b/security/integrity/ima/ima_api.c
>> @@ -178,8 +178,8 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
>>   	strncpy(entry->template.file_name, filename, IMA_EVENT_NAME_LEN_MAX);
>>
>>   	result = ima_store_template(entry, violation, inode);
>> -	if (!result)
>> +	if (!result || result == -EEXIST)
>>   		iint->flags |= IMA_MEASURED;
>> -	else
>> +	if (result<  0)
>>   		kfree(entry);
>>   }
>> diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
>> index 8e28f04..0fe41b81 100644
>> --- a/security/integrity/ima/ima_queue.c
>> +++ b/security/integrity/ima/ima_queue.c
>> @@ -94,7 +94,8 @@ static int ima_pcr_extend(const u8 *hash)
>>
>>   	result = tpm_pcr_extend(TPM_ANY_NUM, CONFIG_IMA_MEASURE_PCR_IDX, hash);
>>   	if (result != 0)
>> -		pr_err("IMA: Error Communicating to TPM chip\n");
>> +		pr_err("IMA: Error Communicating to TPM chip, result: %d\n",
>> +		       result);
>>   	return result;
>>   }
>>
>> @@ -107,13 +108,14 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
>>   	u8 digest[IMA_DIGEST_SIZE];
>>   	const char *audit_cause = "hash_added";
>>   	int audit_info = 1;
>> -	int result = 0;
>> +	int result = 0, tpmresult = 0;
>>
>>   	mutex_lock(&ima_extend_list_mutex);
>>   	if (!violation) {
>>   		memcpy(digest, entry->digest, sizeof digest);
>>   		if (ima_lookup_digest_entry(digest)) {
>>   			audit_cause = "hash_exists";
>> +			result = -EEXIST;
>>   			goto out;
>>   		}
>>   	}
>> @@ -128,8 +130,8 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
>>   	if (violation)		/* invalidate pcr */
>>   		memset(digest, 0xff, sizeof digest);
>>
>> -	result = ima_pcr_extend(digest);
>> -	if (result != 0) {
>> +	tpmresult = ima_pcr_extend(digest);
>> +	if (tpmresult != 0) {
>>   		audit_cause = "TPM error";
>>   		audit_info = 0;
>>   	}
>
>

