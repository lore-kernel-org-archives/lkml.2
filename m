Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab2IJNkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:40:21 -0400
Received: from outbound-mail01.westnet.com.au ([203.10.1.242]:11333 "EHLO
	outbound-mail01.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010Ab2IJNkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:40:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAJDsTVB787/Z/2dsb2JhbAANOL5qAQEBAwEnERYqAQULCxIGCRYPCQMCAQIBHxgOBggFAQUCAQEZBIdcAQwRpzGTQYsThjYDlnGSAQ
X-IronPort-AV: E=Sophos;i="4.80,398,1344182400"; 
   d="scan'208";a="264404221"
Message-ID: <504DEDBB.1090404@westnet.com.au>
Date: Mon, 10 Sep 2012 23:40:11 +1000
From: Greg Ungerer <gregungerer@westnet.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] status of execve() work - per-architecture patches solicited
References: <20120907182004.GE13973@ZenIV.linux.org.uk>
In-Reply-To: <20120907182004.GE13973@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On 09/08/2012 04:20 AM, Al Viro wrote:
> 	To architecture maintainers: please, review the current
> situation in git.kernel.org/pub/scm/linux/kernel/git/viro/signal #execve2
> and consider sending the corresponding patches for missing architectures.

I can see you have some m68k patches in there as well.
They tested good on standard m68k (under emulator) and good on non-mmu
ColdFire. But it is geting an exception when I run on ColdFire with MMU
enabled:

...
Creating 1 MTD partitions on "RAM":
0x000000000000-0x0000001b8000 : "ROMfs"
TCP: cubic registered
NET: Registered protocol family 17
VFS: Mounted root (romfs filesystem) readonly on device 31:0.
*** FORMAT ERROR ***   FORMAT=4
Current process id is 1
BAD KERNEL TRAP: 00000000
Modules linked in:
PC: [<0002562a>] 0x02562a
SR: 2704  SP: 0383dfc4  a2: 00000000
d0: 00000000    d1: 00000000    d2: 00000000    d3: 00000000
d4: 00000000    d5: 00000000    a0: 00000000    a1: 00000000
Process init (pid: 1, task=0383a000)
Frame format=4 eff addr=00000000 pc=6000169a
Stack from 0383e000:
Call Trace:
Code: 6610 4cd7 073e 4fef 0020 201f 588f dfdf <4e73> 2228 0004 46fc 2000 
0801 0007 66ff ffff c2ea 598f 4fef ffe8 48d7 78c0 486f
Disabling lock debugging due to kernel taint

It is trapping at the return from exception (rte) in Lreturn.
Looks like it doesn't like the "format" field of the new stack frame
for some reason. If I get a few minutes tomorrow I'll dig into it.

Regards
Greg



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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

