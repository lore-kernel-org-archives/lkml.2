Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab0EXKOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 06:14:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49233 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab0EXKO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 06:14:29 -0400
Date: Mon, 24 May 2010 11:14:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, a.p.zijlstra@chello.nl
Subject: Re: [RESEND PATCH] ARM: fix 'unannotated irqs-on' lockdep warning
Message-ID: <20100524101416.GA21117@n2100.arm.linux.org.uk>
References: <1274615328-27953-1-git-send-email-tom.leiming@gmail.com> <20100523123801.GC950@n2100.arm.linux.org.uk> <AANLkTikRp0EHxshKYq39p18ymoRNAtyHrNm3yq6A49-r@mail.gmail.com> <20100523141300.GD950@n2100.arm.linux.org.uk> <AANLkTinV9Na9zxYMIfTr893Ynnc0YOk2B6uPKEa9s4R1@mail.gmail.com> <20100523194746.GE950@n2100.arm.linux.org.uk> <20100524112355.18424622@tom-lei> <20100524071921.GA17528@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100524071921.GA17528@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 08:19:21AM +0100, Russell King - ARM Linux wrote:
> On Mon, May 24, 2010 at 11:23:55AM +0800, Ming Lei wrote:
> > On Sun, 23 May 2010 20:47:46 +0100
> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > > Moreover, I put to you that it's utterly pointless - and a waste of
> > > CPU time - telling lockdep about the IRQ masking when an exception
> > 
> > Yes, the patch still tries to remove the pointless trace of IRQ masking,
> > such as: replace disable_irq with disable_irq_notrace.
> > 
> > > occurs, and it's also pointless telling lockdep about the IRQ
> > > unmasking when we resume userspace.
> > 
> > Even it is pointless, but if lockdep doesn't see the IRQ unmasking, the 
> > warning "unannotated irqs-on" will be triggered and lockdep doe not work
> > any longer, so we have to remove the warning to make lockdep workable on
> > ARM, could you agree on it?  It is the main purpose of the patch.
> 
> I'm sorry, I think we have a communication issue; you're not understanding
> the points that I'm making.  I feel I'm wasting my time trying to explain
> it.
> 
> I'm not merging your patch as-is because I believe it to be wrong.

Right, I see what the problem is now - it's all to do with threads
created with kernel_thread() confusing lockdep.

I'm of the opinion that all your changes in entry*.S are the wrong
way to fix this - not only does it add additional overhead where
none is really necessary, it adds additional complexity.

So, here's a patch to solve the warning you quoted.

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index acf5e6f..a5f8fd0 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -351,17 +351,25 @@ EXPORT_SYMBOL(dump_fpu);
 
 /*
  * Shuffle the argument into the correct register before calling the
- * thread function.  r1 is the thread argument, r2 is the pointer to
- * the thread function, and r3 points to the exit function.
+ * thread function.  r4 is the thread argument, r5 is the pointer to
+ * the thread function, and r6 points to the exit function.
  */
 extern void kernel_thread_helper(void);
 asm(	".pushsection .text\n"
 "	.align\n"
 "	.type	kernel_thread_helper, #function\n"
 "kernel_thread_helper:\n"
-"	mov	r0, r1\n"
-"	mov	lr, r3\n"
-"	mov	pc, r2\n"
+#ifdef CONFIG_TRACE_IRQFLAGS
+"	bl	trace_hardirqs_on\n"
+#endif
+#if __LINUX_ARM_ARCH__ >= 6
+"	cpsie	i\n"
+#else
+"	msr	cpsr_c, r7\n"
+#endif
+"	mov	r0, r4\n"
+"	mov	lr, r6\n"
+"	mov	pc, r5\n"
 "	.size	kernel_thread_helper, . - kernel_thread_helper\n"
 "	.popsection");
 
@@ -391,11 +399,12 @@ pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 
 	memset(&regs, 0, sizeof(regs));
 
-	regs.ARM_r1 = (unsigned long)arg;
-	regs.ARM_r2 = (unsigned long)fn;
-	regs.ARM_r3 = (unsigned long)kernel_thread_exit;
+	regs.ARM_r4 = (unsigned long)arg;
+	regs.ARM_r5 = (unsigned long)fn;
+	regs.ARM_r6 = (unsigned long)kernel_thread_exit;
+	regs.ARM_r7 = SVC_MODE | PSR_ISETSTATE;
 	regs.ARM_pc = (unsigned long)kernel_thread_helper;
-	regs.ARM_cpsr = SVC_MODE | PSR_ENDSTATE | PSR_ISETSTATE;
+	regs.ARM_cpsr = SVC_MODE | PSR_ENDSTATE | PSR_ISETSTATE | PSR_I_BIT;
 
 	return do_fork(flags|CLONE_VM|CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
 }
