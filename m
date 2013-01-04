Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab3ADHB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 02:01:29 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18288 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3ADHB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 02:01:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 03 Jan 2013 22:57:12 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <mturquette@linaro.org>, <swarren@nvidia.com>, <grant.likely@secretlab.ca>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>,
        <maxime.ripard@free-electrons.com>, <linux@prisktech.co.nz>,
        <josh.cartwright@ni.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 1/7] clk: add common of_clk_init() function
Date: Fri, 4 Jan 2013 12:30:52 +0530
Message-ID: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify of_clk_init function so that it will determine which
driver to initialize based on device tree instead of each driver
registering to it.

Based on a similar patch for drivers/irqchip by Thomas Petazzoni and
drivers/clocksource by Stephen Warren.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 drivers/clk/clk-fixed-rate.c      |    1 +
 drivers/clk/clk.c                 |    9 +++++++++
 include/asm-generic/vmlinux.lds.h |   10 ++++++++++
 include/linux/clk-provider.h      |    6 ++++++
 4 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index af78ed6..f2104df 100644
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -101,4 +101,5 @@ void __init of_fixed_clk_setup(struct device_node *node)
 		of_clk_add_provider(node, of_clk_src_simple_get, clk);
 }
 EXPORT_SYMBOL_GPL(of_fixed_clk_setup);
+CLK_OF_DECLARE(fixed_clk, "fixed-clock", of_fixed_clk_setup);
 #endif
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 037b48a..fb38dd8 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/device.h>
+#include <linux/init.h>
 
 static DEFINE_SPINLOCK(enable_lock);
 static DEFINE_MUTEX(prepare_lock);
@@ -1805,6 +1806,11 @@ struct of_clk_provider {
 	void *data;
 };
 
+extern struct of_device_id __clk_of_table[];
+
+static const struct of_device_id __clk_of_table_sentinel
+	__used __section(__clk_of_table_end);
+
 static LIST_HEAD(of_clk_providers);
 static DEFINE_MUTEX(of_clk_lock);
 
@@ -1933,6 +1939,9 @@ void __init of_clk_init(const struct of_device_id *matches)
 {
 	struct device_node *np;
 
+	if (!matches)
+		matches = __clk_of_table;
+
 	for_each_matching_node(np, matches) {
 		const struct of_device_id *match = of_match_node(matches, np);
 		of_clk_init_cb_t clk_init_cb = match->data;
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 1e744c5..8282f7c 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -158,6 +158,15 @@
 #define CLKSRC_OF_TABLES()
 #endif
 
+#ifdef CONFIG_COMMON_CLK
+#define CLK_OF_TABLES() . = ALIGN(8);				\
+			VMLINUX_SYMBOL(__clk_of_table) = .;	\
+			*(__clk_of_table)			\
+			*(__clk_of_table_end)
+#else
+#define CLK_OF_TABLES()
+#endif
+
 #define KERNEL_DTB()							\
 	STRUCT_ALIGN();							\
 	VMLINUX_SYMBOL(__dtb_start) = .;				\
@@ -502,6 +511,7 @@
 	CPU_DISCARD(init.rodata)					\
 	MEM_DISCARD(init.rodata)					\
 	CLKSRC_OF_TABLES()						\
+	CLK_OF_TABLES()							\
 	KERNEL_DTB()
 
 #define INIT_TEXT							\
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 4989b8a..7f197d7 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -379,7 +379,13 @@ struct clk_onecell_data {
 };
 struct clk *of_clk_src_onecell_get(struct of_phandle_args *clkspec, void *data);
 const char *of_clk_get_parent_name(struct device_node *np, int index);
+
 void of_clk_init(const struct of_device_id *matches);
 
+#define CLK_OF_DECLARE(name, compat, fn)			\
+	static const struct of_device_id __clk_of_table_##name	\
+		__used __section(__clk_of_table)		\
+		= { .compatible = compat, .data = fn };
+
 #endif /* CONFIG_COMMON_CLK */
 #endif /* CLK_PROVIDER_H */
-- 
1.7.4.1

