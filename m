Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab1HQFLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 01:11:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab1HQFLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 01:11:44 -0400
MIME-Version: 1.0
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 17 Aug 2011 13:11:22 +0800
Message-ID: <CAGsJ_4wpZGfJDX_q833f-aS16g=_0armXqtqYxcfW2MXN8KpVg@mail.gmail.com>
Subject: [RFC] ARM: l2x0: suspend/resume entries
To: Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        workgroup.linux@csr.com, Olof Johansson <olof@lixom.net>,
        tglx@linutronix.de, weizeng.he@csr.com,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/7 Rob Herring <robherring2@gmail.com>:
> From: Rob Herring <rob.herring@calxeda.com>
>
> This adds probing for ARM L2x0 cache controllers via device tree. Support
> includes the L210, L220, and PL310 controllers. The binding allows setting
> up cache RAM latencies and filter addresses (PL310 only).
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Based on this patch, I simply modified some codes to add preliminary
suspend/resume entries for l2 cache and request for comments. it is
not a formal patch.

From: Barry Song <Baohua.Song@csr.com>
Subject: [RFC][PATCH] ARM: L2X0: add suspend/resume syscore ops

Signed-off-by: Barry Song <Baohua.Song@csr.com>
---
 arch/arm/mm/cache-l2x0.c |   74 ++++++++++++++++++++++++++++++++++++---------
 1 files changed, 59 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index c035b9a..8db89b5 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -32,6 +32,11 @@ static void __iomem *l2x0_base;
 static DEFINE_SPINLOCK(l2x0_lock);
 static uint32_t l2x0_way_mask;	/* Bitmask of active ways */
 static uint32_t l2x0_size;
+static uint32_t l2x0_aux_val;
+static uint32_t l2x0_aux_mask;
+static void (*l2x0_setup)(const struct device_node *np,
+                __u32 *aux_val, __u32 *aux_mask);
+static struct device_node *l2x0_np;

 static inline void cache_wait_way(void __iomem *reg, unsigned long mask)
 {
@@ -280,7 +285,7 @@ static void l2x0_disable(void)
 	spin_unlock_irqrestore(&l2x0_lock, flags);
 }

-void __init l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask)
+void l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask)
 {
 	__u32 aux;
 	__u32 cache_id;
@@ -431,26 +436,65 @@ static const struct of_device_id l2x0_ids[]
__initconst = {
 	{}
 };

-int __init l2x0_of_init(__u32 aux_val, __u32 aux_mask)
+static void l2x0_arch_init(void)
 {
-	struct device_node *np;
-	void (*l2_setup)(const struct device_node *np,
-		__u32 *aux_val, __u32 *aux_mask);
+	/* L2 configuration can only be changed if the cache is disabled */
+	if (!(readl_relaxed(l2x0_base + L2X0_CTRL) & 1)) {
+		if (l2x0_setup)
+			l2x0_setup(l2x0_np, &l2x0_aux_val, &l2x0_aux_mask);
+	}
+
+	l2x0_init(l2x0_base, l2x0_aux_val, l2x0_aux_mask);
+}
+
+#ifdef CONFIG_PM
+#include <linux/syscore_ops.h>
+
+static int l2x0_pm_suspend(void)
+{
+        l2x0_flush_all();
+        l2x0_clean_all();
+        l2x0_disable();
+        return 0;
+}
+
+static void l2x0_pm_resume(void)
+{
+	l2x0_arch_init();
+}
+
+static struct syscore_ops l2x0_pm_syscore_ops = {
+        .suspend        = l2x0_pm_suspend,
+        .resume         = l2x0_pm_resume,
+};

-	np = of_find_matching_node(NULL, l2x0_ids);
-	if (!np)
+static void __init l2x0_pm_init(void)
+{
+        register_syscore_ops(&l2x0_pm_syscore_ops);
+}
+
+#else
+static inline void l2x0_pm_init(void) { }
+#endif /* CONFIG_PM */
+
+
+int __init l2x0_of_init(__u32 aux_val, __u32 aux_mask)
+{
+	l2x0_np = of_find_matching_node(NULL, l2x0_ids);
+	if (!l2x0_np)
 		return -ENODEV;
-	l2x0_base = of_iomap(np, 0);
+	l2x0_base = of_iomap(l2x0_np, 0);
 	if (!l2x0_base)
 		return -ENOMEM;

-	/* L2 configuration can only be changed if the cache is disabled */
-	if (!(readl_relaxed(l2x0_base + L2X0_CTRL) & 1)) {
-		l2_setup = of_match_node(l2x0_ids, np)->data;
-		if (l2_setup)
-			l2_setup(np, &aux_val, &aux_mask);
-	}
-	l2x0_init(l2x0_base, aux_val, aux_mask);
+	l2x0_setup = of_match_node(l2x0_ids, l2x0_np)->data;
+
+	l2x0_aux_val = aux_val;
+	l2x0_aux_mask = aux_mask;
+
+	l2x0_arch_init();
+	l2x0_pm_init();
 	return 0;
 }
+
 #endif
-- 
1.7.1
