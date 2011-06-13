Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab1FMArX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 20:47:23 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58463 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab1FMArW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 20:47:22 -0400
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Tony Lindgren <tony@atomide.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] ARM: mm: cache-l2x0: Add support for re-enabling l2x0
Date: Sun, 12 Jun 2011 17:46:58 -0700
Message-Id: <1307926019-28958-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove __init annotation from l2x0_init so it can be used to
reinitialize the l2x0 after it has been reset during suspend.

Only print the init messages the first time l2x0_init is called.

Add l2x0_enable to re-enable the l2x0 after l2x0_disable if
the l2x0 was not reset.

l2x0_disable cannot use writel, as writel calls wmb(), and wmb()
may call outer_cache_sync, which takes the same spinlock as
l2x0_disable.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/include/asm/hardware/cache-l2x0.h |    3 ++-
 arch/arm/mm/cache-l2x0.c                   |   18 ++++++++++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/hardware/cache-l2x0.h b/arch/arm/include/asm/hardware/cache-l2x0.h
index 16bd480..8fd87fe 100644
--- a/arch/arm/include/asm/hardware/cache-l2x0.h
+++ b/arch/arm/include/asm/hardware/cache-l2x0.h
@@ -73,7 +73,8 @@
 #define L2X0_AUX_CTRL_EARLY_BRESP_SHIFT		30
 
 #ifndef __ASSEMBLY__
-extern void __init l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask);
+extern void l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask);
+extern void l2x0_enable(void);
 #endif
 
 #endif
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index ef59099..4db0d9c 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -261,16 +261,26 @@ static void l2x0_flush_range(unsigned long start, unsigned long end)
 	spin_unlock_irqrestore(&l2x0_lock, flags);
 }
 
+/* enables l2x0 after l2x0_disable, does not invalidate */
+void l2x0_enable(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&l2x0_lock, flags);
+	writel_relaxed(1, l2x0_base + L2X0_CTRL);
+	spin_unlock_irqrestore(&l2x0_lock, flags);
+}
+
 static void l2x0_disable(void)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&l2x0_lock, flags);
-	writel(0, l2x0_base + L2X0_CTRL);
+	writel_relaxed(0, l2x0_base + L2X0_CTRL);
 	spin_unlock_irqrestore(&l2x0_lock, flags);
 }
 
-void __init l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask)
+void l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask)
 {
 	__u32 aux;
 	__u32 cache_id;
@@ -340,7 +350,7 @@ void __init l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask)
 	outer_cache.disable = l2x0_disable;
 	outer_cache.set_debug = l2x0_set_debug;
 
-	printk(KERN_INFO "%s cache controller enabled\n", type);
-	printk(KERN_INFO "l2x0: %d ways, CACHE_ID 0x%08x, AUX_CTRL 0x%08x, Cache size: %d B\n",
+	pr_info_once("%s cache controller enabled\n", type);
+	pr_info_once("l2x0: %d ways, CACHE_ID 0x%08x, AUX_CTRL 0x%08x, Cache size: %d B\n",
 			ways, cache_id, aux, l2x0_size);
 }
-- 
1.7.4.1

