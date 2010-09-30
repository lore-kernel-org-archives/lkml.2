Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab0I3XZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:25:17 -0400
Received: from www.tglx.de ([62.245.132.106]:34739 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab0I3XZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:25:15 -0400
Message-Id: <20100930221738.572997675@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:14:33 -0000
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
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>, stable@kernel.org
Subject: [patch 01/47] x86: Plug memory leak in sparse irq
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=x86-plug-memory-leak-in-sparse-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_irq_cfg() is not freeing the cpumask_vars in irq_cfg. Fixing this
triggers a use after free caused by the fact that copying struct
irq_cfg is done with memcpy, which copies the pointer not the cpumask.

Fix both places.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
LKML-Reference: <alpine.LFD.2.00.1009282052570.2416@localhost6.localdomain6>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@kernel.org
---
 arch/x86/kernel/apic/io_apic.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -307,14 +307,19 @@ void arch_init_copy_chip_data(struct irq
 
 	old_cfg = get_irq_desc_chip_data(old_desc);
 
-	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
+	cfg->vector = old_cfg->vector;
+	cfg->move_in_progress = old_cfg->move_in_progress;
+	cpumask_copy(cfg->domain, old_cfg->domain);
+	cpumask_copy(cfg->old_domain, old_cfg->old_domain);
 
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


