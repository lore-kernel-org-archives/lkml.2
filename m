Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab0LEX6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 18:58:12 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45511 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab0LEX6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 18:58:10 -0500
Date: Mon, 6 Dec 2010 10:58:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: linux-next: manual merge of the arm tree with the arm-current tree
Message-Id: <20101206105804.fbfea108.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Today's linux-next merge of the arm tree got a conflict in
arch/arm/common/gic.c between commit
e6afec9b6808eff6dc392ac07c1552e87aebcdf7 ("ARM: 6496/1: GIC: Do not try
to register more then NR_IRQS interrupts") from the arm-current tree and
commit d9522a4675b30f128d4410a6d453ab63edd18e64 ("ARM: GIC: move gic_data
[] initialization into gic_init()") from the arm tree.

I fixed it up (see below) can can carry the fix for a while.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/common/gic.c
index fea1bd7,b6a1d09..0000000
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@@ -207,15 -210,13 +210,13 @@@ void __init gic_cascade_irq(unsigned in
  	set_irq_chained_handler(irq, gic_handle_cascade_irq);
  }
  
- void __init gic_dist_init(unsigned int gic_nr, void __iomem *base,
- 			  unsigned int irq_start)
+ static void __init gic_dist_init(struct gic_chip_data *gic,
+ 	unsigned int irq_start)
  {
 -	unsigned int max_irq, i;
 +	unsigned int gic_irqs, irq_limit, i;
+ 	void __iomem *base = gic->dist_base;
  	u32 cpumask = 1 << smp_processor_id();
  
- 	if (gic_nr >= MAX_GIC_NR)
- 		BUG();
- 
  	cpumask |= cpumask << 8;
  	cpumask |= cpumask << 16;
  
@@@ -259,18 -262,11 +257,18 @@@
  		writel(0xffffffff, base + GIC_DIST_ENABLE_CLEAR + i * 4 / 32);
  
  	/*
 +	 * Limit number of interrupts registered to the platform maximum
 +	 */
- 	irq_limit = gic_data[gic_nr].irq_offset + gic_irqs;
++	irq_limit = gic->irq_offset + gic_irqs;
 +	if (WARN_ON(irq_limit > NR_IRQS))
 +		irq_limit = NR_IRQS;
 +
 +	/*
  	 * Setup the Linux IRQ subsystem.
  	 */
 -	for (i = irq_start; i < gic->irq_offset + max_irq; i++) {
 +	for (i = irq_start; i < irq_limit; i++) {
  		set_irq_chip(i, &gic_chip);
- 		set_irq_chip_data(i, &gic_data[gic_nr]);
+ 		set_irq_chip_data(i, gic);
  		set_irq_handler(i, handle_level_irq);
  		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
  	}
