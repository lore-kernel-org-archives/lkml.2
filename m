Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab1KIMpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:45:51 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53635 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab1KIMpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:45:50 -0500
Message-ID: <4EBA75F2.4080800@linux.vnet.ibm.com>
Date: Wed, 09 Nov 2011 18:15:38 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: "Rafael J. Wysocki" <rjw@suse.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] thp: reduce khugepaged freezing latency
References: <4EB8E969.6010502@suse.cz> <1320766151-2619-1-git-send-email-aarcange@redhat.com> <1320766151-2619-2-git-send-email-aarcange@redhat.com> <4EB98A83.3040101@linux.vnet.ibm.com>
In-Reply-To: <4EB98A83.3040101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11110903-3568-0000-0000-000000A9AB60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 01:31 AM, Srivatsa S. Bhat wrote:
> On 11/08/2011 08:59 PM, Andrea Arcangeli wrote:
>> Lack of set_freezable_with_signal() prevented khugepaged to be waken
>> up (and prevented to sleep again) across the
>> schedule_timeout_interruptible() calls after freezing() becomes
>> true. The tight loop in khugepaged_alloc_hugepage() also missed one
>> try_to_freeze() call in case alloc_hugepage() would repeatedly fail in
>> turn preventing the loop to break and to reach the try_to_freeze() in
>> the khugepaged main loop.
>>
>> khugepaged would still freeze just fine by trying again the next
>> minute but it's better if it freezes immediately.
>>
>> Reported-by: Jiri Slaby <jslaby@suse.cz>
>> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
>> ---
>>  mm/huge_memory.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 4298aba..67311d1 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2277,6 +2277,7 @@ static struct page *khugepaged_alloc_hugepage(void)
>>  		if (!hpage) {
>>  			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
>>  			khugepaged_alloc_sleep();
>> +			try_to_freeze();
>>  		} else
>>  			count_vm_event(THP_COLLAPSE_ALLOC);
>>  	} while (unlikely(!hpage) &&
>> @@ -2331,7 +2332,7 @@ static int khugepaged(void *none)
>>  {
>>  	struct mm_slot *mm_slot;
>>
>> -	set_freezable();
>> +	set_freezable_with_signal();
>>  	set_user_nice(current, 19);
>>
>>  	/* serialize with start_khugepaged() */
>>
> 
> Why do we need to use both set_freezable_with_signal() and an additional
> try_to_freeze()? Won't just using either one of them be good enough?
> Or am I missing something here?
> 

Moreover, please note that Tejun Heo has sent patches to remove
set_freezable_with_signal() altogether (he has even cleaned up the last
existing user: usb_storage). So it wouldn't be good to start using it again,
if it can be avoided.

http://thread.gmane.org/gmane.linux.kernel/1209416

Thanks,
Srivatsa S. Bhat

