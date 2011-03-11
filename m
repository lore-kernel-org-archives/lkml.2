Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab1CKOWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:22:30 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:46390 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499Ab1CKOWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 09:22:25 -0500
Message-ID: <4D7A2FED.3060200@gmail.com>
Date: Fri, 11 Mar 2011 17:21:33 +0300
From: Andrew Vagin <avagin@gmail.com>
Reply-To: avagin@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Pavel Emelyanov <xemul@openvz.org>, Andrey Vagin <avagin@openvz.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: + x86-mm-handle-mm_fault_error-in-kernel-space.patch added to
 -mm tree
References: <20110310142812.GA25224@redhat.com> <4D7926C9.9070206@parallels.com> <20110311111931.GA16052@redhat.com>
In-Reply-To: <20110311111931.GA16052@redhat.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 02:19 PM, Oleg Nesterov wrote:
> On 03/10, Andrew Vagin wrote:
>> On 03/10/2011 05:28 PM, Oleg Nesterov wrote:
>>> (add cc's)
>>>
>>>> Subject: x86/mm: handle mm_fault_error() in kernel space
>>>> From: Andrey Vagin<avagin@openvz.org>
>>>>
>>>> mm_fault_error() should not execute oom-killer, if page fault occurs in
>>>> kernel space.  E.g.  in copy_from_user/copy_to_user.
>>> Why? I don't understand this part.
>> I thought for a bit more...
>>
>> I think we should not execute out_of_memory() in this case at all,
> Why?
>
> Btw, this may be true, but this is irrelevant. If we shouldn't call
> out_of_memory() in this case, then we shouldn't call it at all, even
> if PF_USER.
Yes. We shouldn't call it at all, even if PF_USER.
> Andrew, I think you missed the point. Or I misunderstood. Or both ;)
>
>> because when we return from page fault, we execute the same command and
>> provoke the "same" page fault again
> Sure. And the same happens if the fault occurs in user-space and
> handle_mm_fault() returns VM_FAULT_OOM. This is correct.
When does handle_mm_fault() return VM_FAULT_OOM? It may be if current 
task is killed or a file system returns VM_FAULT_OOM. All allocations of 
memory (alloc_pages(), kmalloc()) calls out_of_memory() themselves, wait 
it and try allocate memory again.
>> Now pls think what is the
>> difference between these page faults?
> The difference is that oom-killer should free the memory in between.
> _OR_ it can decide to kill us, and _this_ case should be fixed.
We wait memory in __alloc_pages_may_oom(). I think now handle_mm_fault() 
returns VM_FAULT_OOM only if OOM-killer killed current task.
>> It has been generated from one
>> place and the program do nothing between those.
> The program does nothing, but the kernel does.
The kernel code may do it in one page fault...

The kernel should return from page fault back to userspace for the task 
to handle the signal or to continue execute userspace code.
>> If handle_mm_fault() returns
>> VM_FAULT_OOM and pagefault occurred from userspace, the current task
>> should be killed by SIGKILL,
> Why do you think the current task should be killed? In this case we
> do not need oom-killer at all, we could always kill the caller of
> alloc_page/etc.
You don't understand. alloc_page calls oom-killer himself, then try 
allocate memory again. Pls look at __alloc_pages_slowpath(). 
__alloc_pages_slowpat may fail if order > 3 || gfp_mask & __GFP_NOFAIL 
|| test_thread_flag(TIF_MEMDIE)

> Suppose that the innocent task (which doesn't use a lot of memory) calls,
> say, sys_read() into the unpopulated memory. Suppose that alloc_page()
> fails because we have a memory hog which tries to eat all memory.
alloc_page() calls oom-killer, which kill a memory hog.
> Do you think the innocent task should be punished in this case?
Probaly you think that oom-killer is called from mm_fault_error() only. 
It's incorrect.
> Assuming that mm/oom_kill.c:out_of_memory() is correct, it should find
> the memory hog and kill it, after that we can retry the fault in a hope
> we have more memory.
>
> PF_USER is not relevant. If the application does mmap() and then
> accesses this memory, memcpy() or copy_from_user() should follow the
> same logic wrt OOM.
>
>> If handle_mm_fault()
>> returns VM_FAULT_OOM and pagefault occurred in kernel space, we should
>> execute no_context() to return from syscall.
> Only if current was killed by oom-killer, that is why my patch checks
> fatal_signal_pending().
>
>> Also note that out_of_memory is usually called from handle_mm_fault() ->
>> ... ->  alloc_page()->...->out_of_memory().
> And note that pagefault_out_of_memory() checks TIF_MEMDIE and calls
> schedule_timeout_uninterruptible(). This is exactly because if we are
> _not_ killed by oom-killer, we are going to retry later once the killed
> task frees the memory.
>
> See?
>
> Oleg.
>

