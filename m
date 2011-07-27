Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab1G0Sco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 14:32:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:49903 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab1G0Scm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 14:32:42 -0400
Date: Wed, 27 Jul 2011 20:32:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "N, Mugunthan V" <mugunthanvnm@ti.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: RE: [ANNOUNCE] 3.0-rt3
In-Reply-To: <45EE9921DD12714AB1D7B7B9D2FE208B0230256D48BF@dbde03.ent.ti.com>
Message-ID: <alpine.LFD.2.02.1107272029430.2660@ionos>
References: <alpine.LFD.2.02.1107241223560.2702@ionos> <45EE9921DD12714AB1D7B7B9D2FE208B0230256D48BF@dbde03.ent.ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, N, Mugunthan V wrote:

Please do not top post.

> I am testing 3.0-rt3 on AM3517 - Arm Cortex A8. As the kernel from the
> mainline is not booting I am using a patch to boot AM3517 kernel on top of
> the mainline kernel. Its crashing when I start hackbench and cyclictest.
> 
> There were two warnings while starting the test and then the kernel crashes.
> Attaching the patch and the rt-config file.
> 
> [  266.001220] BUG: sleeping function called from invalid context at
> kernel/rtmutex.c:645

That should be fixed by the patch below.

> [  267.494995] ------------[ cut here ]------------
> [  267.495086] WARNING: at kernel/lockdep.c:939 __bfs+0x1f8/0x254()

Could you please disable CONFIG_RCU_BOOST ?

Thanks,

	tglx

Index: linux-2.6/arch/arm/include/asm/mmu.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/mmu.h
+++ linux-2.6/arch/arm/include/asm/mmu.h
@@ -6,7 +6,7 @@
 typedef struct {
 #ifdef CONFIG_CPU_HAS_ASID
 	unsigned int id;
-	spinlock_t id_lock;
+	raw_spinlock_t id_lock;
 #endif
 	unsigned int kvm_seq;
 } mm_context_t;
Index: linux-2.6/arch/arm/mm/context.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/context.c
+++ linux-2.6/arch/arm/mm/context.c
@@ -31,7 +31,7 @@ DEFINE_PER_CPU(struct mm_struct *, curre
 void __init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 {
 	mm->context.id = 0;
-	spin_lock_init(&mm->context.id_lock);
+	raw_spin_lock_init(&mm->context.id_lock);
 }
 
 static void flush_context(void)
@@ -58,7 +58,7 @@ static void set_mm_context(struct mm_str
 	 * the broadcast. This function is also called via IPI so the
 	 * mm->context.id_lock has to be IRQ-safe.
 	 */
-	spin_lock_irqsave(&mm->context.id_lock, flags);
+	raw_spin_lock_irqsave(&mm->context.id_lock, flags);
 	if (likely((mm->context.id ^ cpu_last_asid) >> ASID_BITS)) {
 		/*
 		 * Old version of ASID found. Set the new one and
@@ -67,7 +67,7 @@ static void set_mm_context(struct mm_str
 		mm->context.id = asid;
 		cpumask_clear(mm_cpumask(mm));
 	}
-	spin_unlock_irqrestore(&mm->context.id_lock, flags);
+	raw_spin_unlock_irqrestore(&mm->context.id_lock, flags);
 
 	/*
 	 * Set the mm_cpumask(mm) bit for the current CPU.
