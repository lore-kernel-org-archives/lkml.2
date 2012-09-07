Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab2IGSUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:20:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36555 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab2IGSUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:20:05 -0400
Date: Fri, 7 Sep 2012 19:20:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] status of execve() work - per-architecture patches solicited
Message-ID: <20120907182004.GE13973@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	To architecture maintainers: please, review the current
situation in git.kernel.org/pub/scm/linux/kernel/git/viro/signal #execve2
and consider sending the corresponding patches for missing architectures.

	What's getting done is unification of sys_execve()/kernel_execve()
into arch-independent code.  x86, alpha, arm, s390, um and ppc are already
converted in #execve2.  The plan is:

* provide a new primitive - ret_from_kernel_execve(); it takes two pointers
to struct pt_regs, one being the normal location of pt_regs for a userland
process, another - new pt_regs just filled by do_execve().  It should copy
the latter to the former and bugger off to userland.  Called from generic
kernel_execve() implementation (see fs/exec.c in #execve2).  It almost always
has to be done in assembler - normally it does equivalent of something
along the lines of
	memmove(normal, new, sizeof(struct pt_regs))
	sp = normal, or whatever is needed to get a valid stack
frame (e.g. on s390 there's ->back_chain that needs to be set to
NULL)
	set other registers ret_from_sys_call expects to be set (e.g.
i386 syscall entry has current_thread_info() value cached in %ebp and
since it's a callee-saved register there, ret_from_sys_call expects to
find that value still in %ebp, so we need to set it); basically, check
what has to be set in ret_from_fork - it tends to jump to the same place.
	goto ret_from_sys_call, or whatever the equivalent is called on
particular architecture.
* define __ARCH_WANT_KERNEL_EXECVE in unistd.h, remove your old kernel_execve()
* pull whatever work you'd been doing *after* do_execve() call in your
sys_execve() (most of the architectures don't do anything after that anyway)
into start_thread(); that's the point of no return for execve(2) and if we
get there, we'll either succeed or get killed with SIGKILL.  The same goes
for compat variant of execve(), with s/start_thread/compat_start_thread/.
* define __ARCH_WANT_SYS_EXECVE in unistd.h, kill your sys_execve() and
compat counterpart (if any).
* if there's a better way to calculate task_pt_regs(current), you can provide
it in your ptrace.h - macro should be called current_pt_regs(); it's optional.

	Status: x86, arm, um, s390 - converted, tested, seem to work. alpha
and ppc - need testing.  The rest - hadn't touched yet.  unicore32 and
blackfin should be trivial to convert (they are doing kernel_execve() in
that manner already).  Other may be more or less tricky - depends on how
gnarly their return from syscall path happens to be.  I'll do what I can
and test what I can (some on emulators, some on real hardware), but for quite
a few architectures I've no way to test.  Nor am I fond of sniffing dozens
of variants of assembler glue, to put it mildly.

	Patches and/or help with testing setups would be very welcome.
