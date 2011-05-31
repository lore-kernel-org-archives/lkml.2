Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab1EaQPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:15:01 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:52223 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757321Ab1EaQO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:14:59 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] genirq: fix descriptor init on non-sparse IRQs
Date: Tue, 31 May 2011 18:14:39 +0200
Message-ID: <1306858479-16622-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The genirq changes are initializing descriptors for sparse IRQs
quite differently from how non-sparse (stacked?) IRQs are
initialized, with the effect that on my platform all IRQs are
default-disabled on sparse IRQs and default-enabled if non-sparse
IRQs are used, crashing some GPIO driver.

Fix this by refactoring the non-sparse IRQs to use the same
descriptor init function as the sparse IRQs. Tested on Ux500.

Signed-off: Linus Walleij <linus.walleij@linaro.org>
---
 kernel/irq/irqdesc.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 886e803..c7ddc87 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -257,13 +257,11 @@ int __init early_irq_init(void)
 	count = ARRAY_SIZE(irq_desc);
 
 	for (i = 0; i < count; i++) {
-		desc[i].irq_data.irq = i;
-		desc[i].irq_data.chip = &no_irq_chip;
 		desc[i].kstat_irqs = alloc_percpu(unsigned int);
-		irq_settings_clr_and_set(desc, ~0, _IRQ_DEFAULT_INIT_FLAGS);
-		alloc_masks(desc + i, GFP_KERNEL, node);
-		desc_smp_init(desc + i, node);
+		alloc_masks(&desc[i], GFP_KERNEL, node);
+		raw_spin_lock_init(&desc[i].lock);
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
+		desc_set_defaults(i, &desc[i], node);
 	}
 	return arch_early_irq_init();
 }
-- 
1.7.3.2

