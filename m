Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab1KBRGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:06:38 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:54268 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab1KBRGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:06:33 -0400
Message-ID: <4EB1784C.4090903@oracle.com>
Date: Wed, 02 Nov 2011 10:05:16 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20111031 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Julia Lawall <julia@diku.dk>, Mark Fasheh <mfasheh@suse.com>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] fs/ocfs2/dlm: Eliminate update of list_for_each_entry
 loop cursor
References: <Pine.LNX.4.64.1008071108540.5821@ask.diku.dk> <20100812000355.GA7195@mail.oracle.com> <20111102073928.GA23750@mwanda>
In-Reply-To: <20111102073928.GA23750@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4EB17876.0124,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think it got lost in the shuffle. We had decided to use the list_for_each().
The code is simpler to understand than the other proposed fix.

Joel, do you want me to send a patch?

On 11/02/2011 12:39 AM, Dan Carpenter wrote:
> What ever happened with this?  The bug is still there in the latest
> kernel.
>
> I think from previous discussion about this that we only ever have
> one lock so lock->ml.cookie is always equal to ml->cookie and we
> never set lock to NULL.  So we never actually hit the NULL deref.
> But it should probably still be cleaned up.
>
> regards,
> dan carpenter
>
> On Wed, Aug 11, 2010 at 05:03:56PM -0700, Joel Becker wrote:
>> On Sat, Aug 07, 2010 at 11:09:13AM +0200, Julia Lawall wrote:
>>> From: Julia Lawall<julia@diku.dk>
>>>
>>> list_for_each_entry uses its first argument to move from one element to the
>>> next, so modifying it can break the iteration.
>> 	Thanks for catching the bug.  It was introduced by 800deef3
>> [ocfs2: use list_for_each_entry where benefical].  I blame Christoph.
>>
>>> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
>>> index 9dfaac7..7084a11 100644
>>> --- a/fs/ocfs2/dlm/dlmrecovery.c
>>> +++ b/fs/ocfs2/dlm/dlmrecovery.c
>>> @@ -1792,10 +1792,10 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
>>>   			for (j = DLM_GRANTED_LIST; j<= DLM_BLOCKED_LIST; j++) {
>>>   				tmpq = dlm_list_idx_to_ptr(res, j);
>>>   				list_for_each_entry(lock, tmpq, list) {
>>> -					if (lock->ml.cookie != ml->cookie)
>>> +					if (lock->ml.cookie != ml->cookie) {
>>>   						lock = NULL;
>>> -					else
>>>   						break;
>>> +					}
>>>   				}
>>>   				if (lock)
>>>   					break;
>> 	However, this is not the correct solution.  The goal of the
>> original code, which used to use list_for_each(), was to leave lock
>> non-NULL if the cookie was found.  Your version merely exits the loop on
>> the first non-matching entry, always leaving lock==NULL if there is a
>> non-matching entry.
>> 	One possible solution is to return the original code:
>>
>> --8<-----------------------------------------------------------------
>> @@ -1747,7 +1747,7 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
>>   				     struct dlm_migratable_lockres *mres)
>>   {
>>   	struct dlm_migratable_lock *ml;
>> -	struct list_head *queue;
>> +	struct list_head *queue, *iter;
>>   	struct list_head *tmpq = NULL;
>>   	struct dlm_lock *newlock = NULL;
>>   	struct dlm_lockstatus *lksb = NULL;
>> @@ -1791,11 +1791,12 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
>>   			spin_lock(&res->spinlock);
>>   			for (j = DLM_GRANTED_LIST; j<= DLM_BLOCKED_LIST; j++) {
>>   				tmpq = dlm_list_idx_to_ptr(res, j);
>> -				list_for_each_entry(lock, tmpq, list) {
>> -					if (lock->ml.cookie != ml->cookie)
>> -						lock = NULL;
>> -					else
>> +				list_for_each(iter, tmpq) {
>> +					lock = list_entry(iter, struct dlm_lock, list);
>> +
>> +					if (lock->ml.cookie == ml->cookie)
>>   						break;
>> +					lock = NULL;
>>   				}
>>   				if (lock)
>>   					break;
>> -->8-----------------------------------------------------------------
>>
>> 	Another approach would be to keep list_for_each_entry() around,
>> but use a better check for entry existence:
>>
>> --8<-----------------------------------------------------------------
>> @@ -1792,13 +1792,12 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
>>   			for (j = DLM_GRANTED_LIST; j<= DLM_BLOCKED_LIST; j++) {
>>   				tmpq = dlm_list_idx_to_ptr(res, j);
>>   				list_for_each_entry(lock, tmpq, list) {
>> -					if (lock->ml.cookie != ml->cookie)
>> -						lock = NULL;
>> -					else
>> +					if (lock->ml.cookie == ml->cookie)
>>   						break;
>>   				}
>> -				if (lock)
>> +				if (&lock->list != tmpq)
>>   					break;
>> +				lock = NULL;
>>   			}
>>
>>   			/* lock is always created locally first, and
>> -->8-----------------------------------------------------------------
>>
>> 	I think I like the second one better.  Sunil, what do you think?
>>
>> Joel
>>
>> -- 
>>
>> Life's Little Instruction Book #335
>>
>> 	"Every so often, push your luck."
>>
>> Joel Becker
>> Consulting Software Developer
>> Oracle
>> E-mail: joel.becker@oracle.com
>> Phone: (650) 506-8127
>> --
>> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

