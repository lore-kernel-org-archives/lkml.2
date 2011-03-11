Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab1CKL22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 06:28:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab1CKL21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 06:28:27 -0500
Date: Fri, 11 Mar 2011 12:19:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Vagin <avagin@parallels.com>
Cc: Andrey Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: + x86-mm-handle-mm_fault_error-in-kernel-space.patch added to
	-mm tree
Message-ID: <20110311111931.GA16052@redhat.com>
References: <20110310142812.GA25224@redhat.com> <4D7926C9.9070206@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7926C9.9070206@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10, Andrew Vagin wrote:
>
> On 03/10/2011 05:28 PM, Oleg Nesterov wrote:
>> (add cc's)
>>
>>> Subject: x86/mm: handle mm_fault_error() in kernel space
>>> From: Andrey Vagin<avagin@openvz.org>
>>>
>>> mm_fault_error() should not execute oom-killer, if page fault occurs in
>>> kernel space.  E.g.  in copy_from_user/copy_to_user.
>> Why? I don't understand this part.
> I thought for a bit more...
>
> I think we should not execute out_of_memory() in this case at all,

Why?

Btw, this may be true, but this is irrelevant. If we shouldn't call
out_of_memory() in this case, then we shouldn't call it at all, even
if PF_USER.

Andrew, I think you missed the point. Or I misunderstood. Or both ;)

> because when we return from page fault, we execute the same command and
> provoke the "same" page fault again

Sure. And the same happens if the fault occurs in user-space and
handle_mm_fault() returns VM_FAULT_OOM. This is correct.

> Now pls think what is the
> difference between these page faults?

The difference is that oom-killer should free the memory in between.
_OR_ it can decide to kill us, and _this_ case should be fixed.

> It has been generated from one
> place and the program do nothing between those.

The program does nothing, but the kernel does.

> If handle_mm_fault() returns
> VM_FAULT_OOM and pagefault occurred from userspace, the current task
> should be killed by SIGKILL,

Why do you think the current task should be killed? In this case we
do not need oom-killer at all, we could always kill the caller of
alloc_page/etc.

Suppose that the innocent task (which doesn't use a lot of memory) calls,
say, sys_read() into the unpopulated memory. Suppose that alloc_page()
fails because we have a memory hog which tries to eat all memory.

Do you think the innocent task should be punished in this case?

Assuming that mm/oom_kill.c:out_of_memory() is correct, it should find
the memory hog and kill it, after that we can retry the fault in a hope
we have more memory.

PF_USER is not relevant. If the application does mmap() and then
accesses this memory, memcpy() or copy_from_user() should follow the
same logic wrt OOM.

> If handle_mm_fault()
> returns VM_FAULT_OOM and pagefault occurred in kernel space, we should
> execute no_context() to return from syscall.

Only if current was killed by oom-killer, that is why my patch checks
fatal_signal_pending().

> Also note that out_of_memory is usually called from handle_mm_fault() ->
> ... -> alloc_page()->...->out_of_memory().

And note that pagefault_out_of_memory() checks TIF_MEMDIE and calls
schedule_timeout_uninterruptible(). This is exactly because if we are
_not_ killed by oom-killer, we are going to retry later once the killed
task frees the memory.

See?

Oleg.

