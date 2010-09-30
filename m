Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0I3XWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:22:39 -0400
Received: from www.tglx.de ([62.245.132.106]:52771 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab0I3XRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:17:09 -0400
Message-Id: <20100930221740.449419120@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:16:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 20/47] x86: Remove useless reinitialization of irq descriptors
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=x86-remove-useless-gunk.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The descriptors are already initialized in exaclty this way.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/irqinit.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/irqinit.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/irqinit.c
+++ linux-2.6-tip/arch/x86/kernel/irqinit.c
@@ -100,6 +100,8 @@ int vector_used_by_percpu_irq(unsigned i
 
 void __init init_ISA_irqs(void)
 {
+	struct irq_chip *chip = legacy_pic->chip;
+	const char *name = chip->name;
 	int i;
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
@@ -107,19 +109,8 @@ void __init init_ISA_irqs(void)
 #endif
 	legacy_pic->init(0);
 
-	/*
-	 * 16 old-style INTA-cycle interrupts:
-	 */
-	for (i = 0; i < legacy_pic->nr_legacy_irqs; i++) {
-		struct irq_desc *desc = irq_to_desc(i);
-
-		desc->status = IRQ_DISABLED;
-		desc->action = NULL;
-		desc->depth = 1;
-
-		set_irq_chip_and_handler_name(i, &i8259A_chip,
-					      handle_level_irq, "XT");
-	}
+	for (i = 0; i < legacy_pic->nr_legacy_irqs; i++)
+		set_irq_chip_and_handler_name(i, chip, handle_level_irq, name);
 }
 
 void __init init_IRQ(void)


