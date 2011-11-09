Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab1KIQUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:20:37 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59733 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab1KIQUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:20:36 -0500
Message-ID: <4EBAA847.1060907@linux.vnet.ibm.com>
Date: Wed, 09 Nov 2011 21:50:23 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, "Rafael J. Wysocki" <rjw@suse.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] thp: reduce khugepaged freezing latency
References: <4EB8E969.6010502@suse.cz> <1320766151-2619-1-git-send-email-aarcange@redhat.com> <1320766151-2619-2-git-send-email-aarcange@redhat.com> <4EB98A83.3040101@linux.vnet.ibm.com> <4EBA75F2.4080800@linux.vnet.ibm.com> <20111109155342.GA1260@google.com>
In-Reply-To: <20111109155342.GA1260@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 09:23 PM, Tejun Heo wrote:
> Hello, Andrea, Srivatsa.
> 
> On Wed, Nov 09, 2011 at 06:15:38PM +0530, Srivatsa S. Bhat wrote:
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 4298aba..67311d1 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -2277,6 +2277,7 @@ static struct page *khugepaged_alloc_hugepage(void)
>>>>  		if (!hpage) {
>>>>  			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
>>>>  			khugepaged_alloc_sleep();
>>>> +			try_to_freeze();
>>>>  		} else
>>>>  			count_vm_event(THP_COLLAPSE_ALLOC);
>>>>  	} while (unlikely(!hpage) &&
>>>> @@ -2331,7 +2332,7 @@ static int khugepaged(void *none)
>>>>  {
>>>>  	struct mm_slot *mm_slot;
>>>>
>>>> -	set_freezable();
>>>> +	set_freezable_with_signal();
>>>>  	set_user_nice(current, 19);
> 
> Oooh, please don't do that.  It's already gone in the pm tree.  It
> would be best if wait_event_freezable_timeout() can be used
> (ie. wakeup condition should be set somewhere) but, if not, something
> like the following sould work.
> 
> static void khugepaged_alloc_sleep(void)
> {
> 	DEFINE_WAIT(wait);
> 	add_wait_queue(&khugepaged_wait, &wait);
> 	try_to_freeze();
> 	schedule_timeout_interruptible(
> 			msecs_to_jiffies(
> 				khugepaged_alloc_sleep_millisecs));
> 	try_to_freeze();
> 	remove_wait_queue(&khugepaged_wait, &wait);
> }
> 												

Right, Andrea this is what I meant. First of all we don't need both
set_freezable_with_signal() _and_ an additional try_to_freeze().
And since we are anyway doing away with set_freezable_with_signal(),
we can just use try_to_freeze() as Tejun suggested above.  

Thanks,
Srivatsa S. Bhat
