Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216Ab2HXT66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 15:58:58 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37009 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760197Ab2HXT6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 15:58:52 -0400
Date: Fri, 24 Aug 2012 23:58:47 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Brian Gerst <brgerst@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <ak@linux.intel.com>
Subject: [RFC] x86: drop unnecessary kernel_eflags variable from 64 bit
Message-ID: <20120824195847.GA31628@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I've been looking for some particular email in my mailbox when
found the patch below (it's dated as August 2011 ;) and think
it's still valid for kernel. Actually there were two patches,
and the second patch was unifying x86-32 with x86-64 but it
was doable as far as I remember.

Anyway, take a look. For debug purpose I've been runing the
kernel on a machine with 2 cpus and when cpus were starting
we're rewritting the kernel_eflags as many times as much cpus
we have. My debug code printed out

[root@neptune ~]# dmesg | grep "eflags"
[   18.459686] cpu_init: kernel_eflags: 46
[   18.782908] cpu_init: kernel_eflags: 46
[root@neptune ~]#

As you may see it has pf and zf flags set, which I suppose
do not mean much for code where we use this variable, ie in
ret_from_fork. The interrupts are off though as expected.

The patch below does substitude this variable with hard-coded
value in a manner of x86-32 code. The only concern I have
is that -- since this `kernel_eflags' was there, it must
be a reason why it was introduced in first place and I failed
to figure out why. Perhaps I need to digg though linux
early time when x86-64 support was introduced?

	Cyrill
---
From: Ian Campbell <ian.campbell@citrix.com>
Subject: [RFC] x86: drop unnecessary kernel_eflags variable from 64 bit

On 64 bit x86 we save the current eflags in cpu_init for use in ret_from_fork.
Strictly speaking reserved bits in EFLAGS should be read as written but in
practise it is unlikely that EFLAGS could ever be extended in this way and the
kernel alread clears any undefined flags early on.

The equivalent 32 bit code simply hard codes 0x0202 as the new EFLAGS.

This change makes 64 bit use the same mechanism to setup the initial EFLAGS on
fork. Note that 64 bit resets EFLAGS before calling schedule_tail() as opposed
to 32 bit which calls schedule_tail() first. Therefore the correct value for
EFLAGS has opposite IF bit.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Brian Gerst <brgerst@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Pekka Enberg <penberg@kernel.org>
CC: Andi Kleen <ak@linux.intel.com>
CC: x86@kernel.org
---
 arch/x86/include/asm/processor.h |    1 -
 arch/x86/kernel/cpu/common.c     |    4 ----
 arch/x86/kernel/entry_64.S       |    2 +-
 3 files changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/processor.h
+++ linux-2.6.git/arch/x86/include/asm/processor.h
@@ -423,7 +423,6 @@ DECLARE_INIT_PER_CPU(irq_stack_union);
 
 DECLARE_PER_CPU(char *, irq_stack_ptr);
 DECLARE_PER_CPU(unsigned int, irq_count);
-extern unsigned long kernel_eflags;
 extern asmlinkage void ignore_sysret(void);
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
Index: linux-2.6.git/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6.git/arch/x86/kernel/cpu/common.c
@@ -1114,8 +1114,6 @@ void syscall_init(void)
 	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
 }
 
-unsigned long kernel_eflags;
-
 /*
  * Copies of the original ist values from the tss are only accessed during
  * debugging, no special alignment required.
@@ -1297,8 +1295,6 @@ void __cpuinit cpu_init(void)
 	fpu_init();
 	xsave_init();
 
-	raw_local_save_flags(kernel_eflags);
-
 	if (is_uv_system())
 		uv_cpu_init();
 }
Index: linux-2.6.git/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/entry_64.S
+++ linux-2.6.git/arch/x86/kernel/entry_64.S
@@ -440,7 +440,7 @@ ENTRY(ret_from_fork)
 
 	LOCK ; btr $TIF_FORK,TI_flags(%r8)
 
-	pushq_cfi kernel_eflags(%rip)
+	pushq_cfi $0x0002
 	popfq_cfi				# reset kernel eflags
 
 	call schedule_tail			# rdi: 'prev' task parameter
