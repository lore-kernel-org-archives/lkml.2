Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab1KBRhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:37:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35953 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab1KBRhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:37:50 -0400
Message-ID: <4EB17FE1.7050307@polito.it>
Date: Wed, 02 Nov 2011 18:37:37 +0100
From: Roberto Sassu <roberto.sassu@polito.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.lsm,gmane.linux.kernel
To: David Safford <safford@watson.ibm.com>
CC: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@us.ibm.com, dhowells@redhat.com,
        jmorris@namei.org
Subject: Re: [PATCH 1/2] trusted-key: allow overwriting the migratable flag
References: <1320237682-3857-1-git-send-email-roberto.sassu@polito.it> <1320253136.3225.13.camel@localhost>
In-Reply-To: <1320253136.3225.13.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2011 05:58 PM, David Safford wrote:
> On Wed, 2011-11-02 at 13:41 +0100, Roberto Sassu wrote:
>> The migratable should be modifiable during the key update() method. This
>> allows for example to update a migratable trusted key, wrapped by a TPM
>> key, to a a non-migratable one sealed under the SRK with a PCR set.
>>
>> Signed-off-by: Roberto Sassu<roberto.sassu@polito.it>
>
> I can see a use case for updating a migratable key to a non-migratable
> one - such as keeping a migratable master on a flash drive, and keeping
> only the non-migratable copy on-line. I certainly don't want the
> ability to change a non-migratable to migratable, as that would defeat
> the entire purpose of non-migratable.
>
> I don't think this patch actually does either, though.
>
>> ---
>>   security/keys/trusted.c |    1 -
>>   1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/security/keys/trusted.c b/security/keys/trusted.c
>> index 0c33e2e..8777015 100644
>> --- a/security/keys/trusted.c
>> +++ b/security/keys/trusted.c
>> @@ -1036,7 +1036,6 @@ static int trusted_update(struct key *key, const void *data, size_t datalen)
>>   		goto out;
>>   	}
>>   	/* copy old key values, and reseal with new pcrs */
>> -	new_p->migratable = p->migratable;
>
> Taking out this line appears only to remove a redundant assignment.
> We can only get here if the old key is already migratable, and the
> earlier trusted_payload_alloc() initializes the new copy to
> migratable by default. I don't see how the flag can be changed
> with this patch. Perhaps I'm missing something or this was just
> the start, and there is more to come?
>

Hi Dave

i think this line should be removed because it overwrites
the assignment made in datablob_parse() -> getoptions().

You can see this behaviour by executing the following commands:

1) keyctl add trusted kmk "new 32" @u
2) keyctl update $(keyctl search @u trusted kmk) "update migratable=0"
3) keyctl update $(keyctl search @u trusted kmk) "update migratable=0"

The third operation should fail because of the lines at the
begin of trusted_update():

---------
	if (!p->migratable)
		return -EPERM;
---------

but instead, without the patch, it is performed successfully.

Thanks

Roberto Sassu


> dave
>
>>   	new_p->key_len = p->key_len;
>>   	memcpy(new_p->key, p->key, p->key_len);
>>   	dump_payload(p);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

