Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab1BOW12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 17:27:28 -0500
Received: from www.tglx.de ([62.245.132.106]:56191 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756397Ab1BOW11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 17:27:27 -0500
Date: Tue, 15 Feb 2011 23:27:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: BUG: ARM: MMP and PXA: nr_irqs > NR_IRQS
In-Reply-To: <4D5AF54D.3020208@metafoo.de>
Message-ID: <alpine.LFD.2.00.1102152307480.26192@localhost6.localdomain6>
References: <4D5AF54D.3020208@metafoo.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Lars-Peter Clausen wrote:
> 
> I stumbled upon this while looking through the existing archs using SPARSE_IRQ.
> Even with SPARSE_IRQ the NR_IRQS is still the upper limit for the number of IRQs.
> 
> Both PXA and MMP set NR_IRQS to IRQ_BOARD_START, with IRQ_BOARD_START being the
> number of IRQs used by the core.
> In various machine files the nr_irqs field of the ARM machine defintion struct
> is then set to "IRQ_BOARD_START + NR_BOARD_IRQS".
> As a result "nr_irqs" will greater then NR_IRQS which then again causes the
> "allocated_irqs" bitmap in the core irq code to be accessed beyond its size
> overwriting unrelated data.
> 
> So as a fix I suggest setting NR_IRQS to a large a enough value like 1024 or
> something.

Thanks for pointing that out! The core code really misses a check. :(

I just checked and by chance the compiler/linker places data behind
that bitmap which gets initialized later on those two platforms. So
this went silently unnoticed.

So the obvious fix is to add a sanity check in early_irq_init() and
break all affected platforms. Though that check wants to be backported
to stable as well, which will require to fix all known problematic
platforms and probably some more yet not known ones as well. Lots of
churn.

We really should get rid of NR_IRQS as the limiting factor - we should
get rid of !sparse_irq as well, but that's a different problem.

So I came up with a fix which addresses the issue at hand, is small
enough to backport and does not require more backports.

Further it allows us later to extend nr_irqs on demand, by simply
reallocating the bit field under sparse_irq_lock().

Comments ?

Thanks,

	tglx

Index: linux-2.6/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6.orig/kernel/irq/irqdesc.c
+++ linux-2.6/kernel/irq/irqdesc.c
@@ -94,10 +94,10 @@ int nr_irqs = NR_IRQS;
 EXPORT_SYMBOL_GPL(nr_irqs);
 
 static DEFINE_MUTEX(sparse_irq_lock);
-static DECLARE_BITMAP(allocated_irqs, NR_IRQS);
 
 #ifdef CONFIG_SPARSE_IRQ
 
+static unsigned long *allocated_irqs;
 static RADIX_TREE(irq_desc_tree, GFP_KERNEL);
 
 static void irq_insert_desc(unsigned int irq, struct irq_desc *desc)
@@ -217,6 +217,9 @@ int __init early_irq_init(void)
 	initcnt = arch_probe_nr_irqs();
 	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d %d\n", NR_IRQS, nr_irqs, initcnt);
 
+	allocated_irqs = kzalloc(BITS_TO_LONGS(nr_irqs) * sizeof(unsigned long),
+				 GFP_KERNEL);
+
 	for (i = 0; i < initcnt; i++) {
 		desc = alloc_desc(i, node);
 		set_bit(i, allocated_irqs);
@@ -227,6 +230,8 @@ int __init early_irq_init(void)
 
 #else /* !CONFIG_SPARSE_IRQ */
 
+static DECLARE_BITMAP(allocated_irqs, NR_IRQS);
+
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
 		.status		= IRQ_DEFAULT_INIT_FLAGS,
