Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab0I1S5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 14:57:33 -0400
Received: from www.tglx.de ([62.245.132.106]:37746 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757420Ab0I1S5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 14:57:32 -0400
Date: Tue, 28 Sep 2010 20:57:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: x86@kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: Plug memory leak in sparse irq
Message-ID: <alpine.LFD.2.00.1009282052570.2416@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_irq_cfg() is not freeing the cpumask_vars in irq_cfg.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@kernel.org
---
 arch/x86/kernel/apic/io_apic.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -311,9 +311,11 @@ void arch_init_copy_chip_data(struct irq
 	init_copy_irq_2_pin(old_cfg, cfg, node);
 }
 
-static void free_irq_cfg(struct irq_cfg *old_cfg)
+static void free_irq_cfg(struct irq_cfg *cfg)
 {
-	kfree(old_cfg);
+	free_cpumask_var(cfg->domain);
+	free_cpumask_var(cfg->old_domain);
+	kfree(cfg);
 }
 
 void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
