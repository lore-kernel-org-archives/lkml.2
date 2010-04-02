Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab0DBTRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:17:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661Ab0DBTRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:17:32 -0400
Date: Fri, 2 Apr 2010 12:12:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jason Wessel <jason.wessel@windriver.com>,
       Will Deacon <will.deacon@arm.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 4/5] kgdb: Use atomic operators which use barriers
In-Reply-To: <1270233145-29335-5-git-send-email-jason.wessel@windriver.com>
Message-ID: <alpine.LFD.2.00.1004021205080.3634@i5.linux-foundation.org>
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com> <1270233145-29335-2-git-send-email-jason.wessel@windriver.com> <1270233145-29335-3-git-send-email-jason.wessel@windriver.com> <1270233145-29335-4-git-send-email-jason.wessel@windriver.com>
 <1270233145-29335-5-git-send-email-jason.wessel@windriver.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Apr 2010, Jason Wessel wrote:
>
> A cpu_relax() does not mandate that there is an smp memory barrier.
> As a result on the arm smp architecture the kernel debugger can hang
> on entry from time to time, as shown by the kgdb regression tests.
> 
> The solution is simply to use the atomic operators which include a
> proper smp memory barrier, instead of using atomic_set() and
> atomic_read().

Hmm. While I absolutely agree that 'cpu_relax()' does not imply a memory 
barrier, I disagree that this change should be needed. If ARM has odd 
semantics where it will never see changes in a busy loop, then ARM is 
buggy, and that has _nothing_ to do with the Linux notion of memory 
barriers.

The _whole_ point of "cpu_relax()" is to have busy loops. And the point of 
busy loops is that they are waiting for something to change. So if this 
loop:

>  		for_each_online_cpu(i) {
> -			while (atomic_read(&cpu_in_kgdb[i]))
> +			while (atomic_add_return(0, &cpu_in_kgdb[i]))
>  				cpu_relax();
>  		}

can somehow lock up because "cpu_relax()" doesn't work with an infinite 
"while (atomic_read(..))" loop, then the ARM implementation of cpu_relax() 
is buggy.

Here's a simple example of exactly these kinds of busy loops waiting for 
something to change using cpu_relax() from generic kernel code:

	ipc/mqueue.c-		while (ewp->state == STATE_PENDING)
	ipc/mqueue.c:			cpu_relax();

	ipc/msg.c-		while (msg == NULL) {
	ipc/msg.c:			cpu_relax();

	kernel/sched.c-		while (task_is_waking(p))
	kernel/sched.c:			cpu_relax();

	kernel/smp.c-	while (data->flags & CSD_FLAG_LOCK)
	kernel/smp.c:		cpu_relax();

so I'd like to understand what the ARM issue is.

Does ARM have some broken cache coherency model where writes by other 
CPU's _never_ show up unless the reading CPU does some memory sync thing? 
If so, then cpu_relax() obviously does need to do that syncing 
instruction.

And no, that does NOT mean that "cpu_relax()" has any memory barrier 
semantics. All it means is that cpu_relax() obviously is some 
architecture-specific way of saying "I'm in a busy loop, waiting for 
something". 

		Linus
