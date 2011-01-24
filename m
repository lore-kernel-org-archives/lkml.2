Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab1AXCCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 21:02:25 -0500
Received: from smtp-out.google.com ([74.125.121.67]:57365 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab1AXCCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 21:02:04 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/28] ARM: mm: cache-l2x0: Add support for re-enabling l2x0
Date: Sun, 23 Jan 2011 18:01:09 -0800
Message-Id: <1295834493-5019-5-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1295834493-5019-1-git-send-email-ccross@android.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove __init annotation from l2x0_init so it can be used to
reinitialize the l2x0 after it has been reset during suspend.

Add l2x0_enable to re-enable the l2x0 after l2x0_disable if
the l2x0 was not reset.

l2x0_disable cannot use writel, as writel calls wmb(), and wmb()
may call outer_cache_sync, which takes the same spinlock as
l2x0_disable.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/include/asm/hardware/cache-l2x0.h |    3 ++-
 arch/arm/mm/cache-l2x0.c                   |   14 ++++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/hardware/cache-l2x0.h b/arch/arm/include/asm/hardware/cache-l2x0.h
index 5aeec1e..2b4479f 100644
--- a/arch/arm/include/asm/hardware/cache-l2x0.h
+++ b/arch/arm/include/asm/hardware/cache-l2x0.h
@@ -72,7 +72,8 @@
 #define L2X0_AUX_CTRL_EARLY_BRESP_SHIFT		30
 
 #ifndef __ASSEMBLY__
-extern void __init l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask);
+extern void l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask);
+extern void l2x0_enable(void);
 #endif
 
 #endif
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 170c9bb..e525449 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -252,16 +252,26 @@ static void l2x0_flush_range(unsigned long start, unsigned long end)
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
-- 
1.7.3.1

