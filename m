Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab2ISMo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 08:44:26 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:43807 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab2ISMoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 08:44:21 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2012 08:44:21 EDT
Message-ID: <5059B892.4030806@synopsys.com>
Date: Wed, 19 Sep 2012 17:50:34 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] status of execve() work - per-architecture patches solicited
References: <20120907182004.GE13973@ZenIV.linux.org.uk>
In-Reply-To: <20120907182004.GE13973@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012 11:50 PM, Al Viro wrote:
> 	To architecture maintainers: please, review the current
> situation in git.kernel.org/pub/scm/linux/kernel/git/viro/signal #execve2
> and consider sending the corresponding patches for missing architectures.
> 
> 	What's getting done is unification of sys_execve()/kernel_execve()
> into arch-independent code.  x86, alpha, arm, s390, um and ppc are already
> converted in #execve2.  The plan is:
> 
> * provide a new primitive - ret_from_kernel_execve(); it takes two pointers
> to struct pt_regs, one being the normal location of pt_regs for a userland
> process, another - new pt_regs just filled by do_execve().  It should copy
> the latter to the former and bugger off to userland.  Called from generic
> kernel_execve() implementation (see fs/exec.c in #execve2).  It almost always
> has to be done in assembler - normally it does equivalent of something
> along the lines of
> 	memmove(normal, new, sizeof(struct pt_regs))
> 	sp = normal, or whatever is needed to get a valid stack
> frame (e.g. on s390 there's ->back_chain that needs to be set to
> NULL)
> 	set other registers ret_from_sys_call expects to be set (e.g.
> i386 syscall entry has current_thread_info() value cached in %ebp and
> since it's a callee-saved register there, ret_from_sys_call expects to
> find that value still in %ebp, so we need to set it); basically, check
> what has to be set in ret_from_fork - it tends to jump to the same place.
> 	goto ret_from_sys_call, or whatever the equivalent is called on
> particular architecture.
> * define __ARCH_WANT_KERNEL_EXECVE in unistd.h, remove your old kernel_execve()
> * pull whatever work you'd been doing *after* do_execve() call in your
> sys_execve() (most of the architectures don't do anything after that anyway)
> into start_thread(); that's the point of no return for execve(2) and if we
> get there, we'll either succeed or get killed with SIGKILL.  The same goes
> for compat variant of execve(), with s/start_thread/compat_start_thread/.
> * define __ARCH_WANT_SYS_EXECVE in unistd.h, kill your sys_execve() and
> compat counterpart (if any).
> * if there's a better way to calculate task_pt_regs(current), you can provide
> it in your ptrace.h - macro should be called current_pt_regs(); it's optional.
> 
> 	Status: x86, arm, um, s390 - converted, tested, seem to work. alpha
> and ppc - need testing.  The rest - hadn't touched yet.  unicore32 and
> blackfin should be trivial to convert (they are doing kernel_execve() in
> that manner already).  Other may be more or less tricky - depends on how
> gnarly their return from syscall path happens to be.  I'll do what I can
> and test what I can (some on emulators, some on real hardware), but for quite
> a few architectures I've no way to test.  Nor am I fond of sniffing dozens
> of variants of assembler glue, to put it mildly.
> 
> 	Patches and/or help with testing setups would be very welcome.
> 


Hi Al,

It must be noted that despite having seemingly independent
__ARCH_WANT_(KERNEL|SYS)_EXECVE, arches which have a kernel syscall trap
based kernel_execve(), e.g. MIPS, can't implement __ARCH_WANT_SYS_EXECVE
alone - they need to first convert
to __ARCH_WANT_KERNEL_EXECVE as well (although it probably doesn't make
sense for anyone to just implement one - but in terms of staging -
having only one, breaks stuff IMHO).

The reason being, for non converted kernel_execve(), the call-stack
leading to sys_execve (e.g. init_post -> run_init_process ->
kernel_execve ->..)  would cause the pt_regs layout to be slightly
offsetted from bottom of stack - not exactly where
current_pt_regs()/task_pt_regs(current) would point to in general. Thus
on return path the update by start_thread() won't be visible to asm glue
at expected location.

I ran into this myself - when doing the execve switch for ARC Linux port
(currently being "pre-reviewed" by tglx before submission to lkml).


-Vineet
