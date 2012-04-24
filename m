Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab2DXHTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 03:19:23 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53216 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab2DXHTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 03:19:22 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-5e-4f9653f7beee
Message-ID: <4F965413.9010305@kernel.org>
Date: Tue, 24 Apr 2012 16:19:47 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Nick Piggin <npiggin@gmail.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC] propagate gfp_t to page table alloc functions
References: <1335171318-4838-1-git-send-email-minchan@kernel.org> <4F963742.2030607@jp.fujitsu.com> <4F963B8E.9030105@kernel.org> <CAPa8GCA8q=S9sYx-0rDmecPxYkFs=gATGL-Dz0OYXDkwEECJkg@mail.gmail.com>
In-Reply-To: <CAPa8GCA8q=S9sYx-0rDmecPxYkFs=gATGL-Dz0OYXDkwEECJkg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 03:13 PM, Nick Piggin wrote:

> 2012/4/24 Minchan Kim <minchan@kernel.org>:
>> On 04/24/2012 02:16 PM, KAMEZAWA Hiroyuki wrote:
>>
>>> (2012/04/23 17:55), Minchan Kim wrote:
>>>
>>>> As I test some code, I found a problem about deadlock by lockdep.
>>>> The reason I saw the message is __vmalloc calls map_vm_area which calls
>>>> pud/pmd_alloc without gfp_t. so although we call __vmalloc with
>>>> GFP_ATOMIC or GFP_NOIO, it ends up allocating pages with GFP_KERNEL.
>>>> The should be a BUG. This patch fixes it by passing gfp_to to low page
>>>> table allocate functions.
>>>>
>>>> Signed-off-by: Minchan Kim <minchan@kernel.org>
>>>
>>>
>>> Hmm ? vmalloc should support GFP_ATOMIC ?
>>
>>
>> I'm not sure but alloc_large_system_hash already has used.
>> And it's not specific on GFP_ATOMIC.
>> We have to care of GFP_NOFS and GFP_NOIO to prevent deadlock on reclaim
>> context.
>> There are some places to use GFP_NOFS and we don't emit any warning
>> message in case of that.
> 
> What's the lockdep warning?


It's just some private-test code, not-mainlined and lockdep warning is like this.

[ INFO: inconsistent lock state ]
3.4.0-rc3-next-20120417+ #80 Not tainted
---------------------------------
inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.

It seems test code calls vmalloc inside reclaim context so that it enters
reclaim context, again by map_vm_area which allocates pages with GFP_KERNEL.

Of course, I can avoid this problem by fixing the caller but during I look into
this problem, found other places to use gfp_t with "context restriction".


> 

> vmalloc was never supposed to use gfp flags for allocation "context"
> restriction. I.e., it
> was always supposed to have blocking, fs, and io capable allocation
> context. The flags
> were supposed to be a memory type modifier.


You mean "zone modifiers"?

> 
> These different classes of flags is a bit of a problem and source of
> confusion we have.
> We should be doing more checks for them, of course.


It might need some warning in __vmalloc and family which use gfp_t
if the caller use context flags.

> 
> I suspect you need to fix the caller?


Hmm, there are several places to use GFP_NOIO and GFP_NOFS even, GFP_ATOMIC.
I believe it's not trivial now.


> 
> Thanks,
> Nick
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 



-- 
Kind regards,
Minchan Kim
