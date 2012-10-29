Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2J2NZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:25:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46454 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2J2NZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:25:38 -0400
Date: Mon, 29 Oct 2012 13:25:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, Jonas Bonn <jonas@southpole.se>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Richard Kuo <rkuo@codeaurora.org>, Lennox Wu <lennox.wu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Chris Zankel <chris@zankel.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [update] Re: new execve/kernel_thread design
Message-ID: <20121029132521.GW2616@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
 <20121026183107.GQ2616@ZenIV.linux.org.uk>
 <20121029085339.0ea11bc6@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029085339.0ea11bc6@mschwide>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 08:53:39AM +0100, Martin Schwidefsky wrote:

> Oops, sorry. I tested this weeks ago but it seems I never wrote a mail to
> indicate success. The current git kernel works just fine.

"Current git" being what?  Linus' tree?  linux-next?  signal.git#arch-s390?
FWIW, the relevant diff against mainline is below, linux-next already
contains it.

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 3f3d9ca..3cdc0f1 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -136,6 +136,7 @@ config S390
 	select KTIME_SCALAR if 32BIT
 	select HAVE_ARCH_SECCOMP_FILTER
 	select GENERIC_KERNEL_THREAD
+	select GENERIC_KERNEL_EXECVE
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
 
diff --git a/arch/s390/include/asm/unistd.h b/arch/s390/include/asm/unistd.h
index bbbae41..ccbcab7 100644
--- a/arch/s390/include/asm/unistd.h
+++ b/arch/s390/include/asm/unistd.h
@@ -54,7 +54,6 @@
 #   define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
 # endif
 #define __ARCH_WANT_SYS_EXECVE
-#define __ARCH_WANT_KERNEL_EXECVE
 
 /*
  * "Conditional" syscalls
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index ef46f66..aa8f2ba 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -330,40 +330,18 @@ ENTRY(ret_from_fork)
 	la	%r11,STACK_FRAME_OVERHEAD(%r15)
 	l	%r12,__LC_THREAD_INFO
 	l	%r13,__LC_SVC_NEW_PSW+4
-	tm	__PT_PSW+1(%r11),0x01	# forking a kernel thread ?
-	je	1f
 	l	%r1,BASED(.Lschedule_tail)
 	basr	%r14,%r1		# call schedule_tail
 	TRACE_IRQS_ON
 	ssm	__LC_SVC_NEW_PSW	# reenable interrupts
-	j	sysc_tracenogo
-
-1:	# it's a kernel thread
-	st	%r15,__PT_R15(%r11)	# store stack pointer for new kthread
-	l	%r1,BASED(.Lschedule_tail)
-	basr	%r14,%r1		# call schedule_tail
-	TRACE_IRQS_ON
-	ssm	__LC_SVC_NEW_PSW	# reenable interrupts
-	lm	%r9,%r11,__PT_R9(%r11)	# load gprs
+	tm	__PT_PSW+1(%r11),0x01	# forking a kernel thread ?
+	jne	sysc_tracenogo
+	# it's a kernel thread
+	lm	%r9,%r10,__PT_R9(%r11)	# load gprs
 ENTRY(kernel_thread_starter)
 	la	%r2,0(%r10)
 	basr	%r14,%r9
-	la	%r2,0
-	br	%r11			# do_exit
-
-#
-# kernel_execve function needs to deal with pt_regs that is not
-# at the usual place
-#
-ENTRY(ret_from_kernel_execve)
-	ssm	__LC_PGM_NEW_PSW	# disable I/O and ext. interrupts
-	lr	%r15,%r2
-	lr	%r11,%r2
-	ahi	%r15,-STACK_FRAME_OVERHEAD
-	xc	__SF_BACKCHAIN(4,%r15),__SF_BACKCHAIN(%r15)
-	l	%r12,__LC_THREAD_INFO
-	ssm	__LC_SVC_NEW_PSW	# reenable interrupts
-	j	sysc_return
+	j	sysc_tracenogo
 
 /*
  * Program check handler routine
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index 07d8de3..499e95e 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -352,33 +352,17 @@ sysc_tracenogo:
 ENTRY(ret_from_fork)
 	la	%r11,STACK_FRAME_OVERHEAD(%r15)
 	lg	%r12,__LC_THREAD_INFO
-	tm	__PT_PSW+1(%r11),0x01	# forking a kernel thread ?
-	je	1f
 	brasl	%r14,schedule_tail
 	TRACE_IRQS_ON
 	ssm	__LC_SVC_NEW_PSW	# reenable interrupts
-	j	sysc_tracenogo
-1:	# it's a kernel thread
-	stg	%r15,__PT_R15(%r11)	# store stack pointer for new kthread
-	brasl	%r14,schedule_tail
-	TRACE_IRQS_ON
-	ssm	__LC_SVC_NEW_PSW	# reenable interrupts
-	lmg	%r9,%r11,__PT_R9(%r11)	# load gprs
+	tm	__PT_PSW+1(%r11),0x01	# forking a kernel thread ?
+	jne	sysc_tracenogo
+	# it's a kernel thread
+	lmg	%r9,%r10,__PT_R9(%r11)	# load gprs
 ENTRY(kernel_thread_starter)
 	la	%r2,0(%r10)
 	basr	%r14,%r9
-	la	%r2,0
-	br	%r11			# do_exit
-
-ENTRY(ret_from_kernel_execve)
-	ssm	__LC_PGM_NEW_PSW	# disable I/O and ext. interrupts
-	lgr	%r15,%r2
-	lgr	%r11,%r2
-	aghi	%r15,-STACK_FRAME_OVERHEAD
-	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
-	lg	%r12,__LC_THREAD_INFO
-	ssm	__LC_SVC_NEW_PSW	# reenable interrupts
-	j	sysc_return
+	j	sysc_tracenogo
 
 /*
  * Program check handler routine
