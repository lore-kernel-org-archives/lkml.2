Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969Ab1KBSom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:44:42 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18118 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab1KBSg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:36:58 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706947"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 02/34] msm: clock: Always use an array to iterate over clocks
Date: Wed,  2 Nov 2011 11:35:59 -0700
Message-Id: <1320258991-22325-3-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

If the array of clk_lookups contains aliases for the same struct
clk, msm_clock_init() will add the clock to the clocks list
twice.  This would cause list corruption so let's just remove the
clocks list and any associated code and iterate over the array
instead.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock.c              |   27 ++++++++++-----------------
 arch/arm/mach-msm/clock.h              |    1 -
 arch/arm/mach-msm/include/mach/board.h |    2 +-
 3 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index d9145df..e23e4c2 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -15,7 +15,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/list.h>
 #include <linux/err.h>
 #include <linux/spinlock.h>
 #include <linux/pm_qos.h>
@@ -27,9 +26,7 @@
 
 #include "clock.h"
 
-static DEFINE_MUTEX(clocks_mutex);
 static DEFINE_SPINLOCK(clocks_lock);
-static LIST_HEAD(clocks);
 
 /*
  * Standard clock functions defined in include/linux/clk.h
@@ -135,21 +132,18 @@ EXPORT_SYMBOL(clk_set_flags);
  * generic to support different clocks.
  */
 static struct clk *ebi1_clk;
+static struct clk_lookup *msm_clocks;
+static unsigned msm_num_clocks;
 
-void __init msm_clock_init(struct clk_lookup *clock_tbl, unsigned num_clocks)
+void __init msm_clock_init(struct clk_lookup *clock_tbl, size_t num_clocks)
 {
-	unsigned n;
-
-	mutex_lock(&clocks_mutex);
-	for (n = 0; n < num_clocks; n++) {
-		clkdev_add(&clock_tbl[n]);
-		list_add_tail(&clock_tbl[n].clk->list, &clocks);
-	}
-	mutex_unlock(&clocks_mutex);
+	clkdev_add_table(clock_tbl, num_clocks);
 
 	ebi1_clk = clk_get(NULL, "ebi1_clk");
 	BUG_ON(ebi1_clk == NULL);
 
+	msm_clocks = clock_tbl;
+	msm_num_clocks = num_clocks;
 }
 
 /* The bootloader and/or AMSS may have left various clocks enabled.
@@ -158,13 +152,13 @@ void __init msm_clock_init(struct clk_lookup *clock_tbl, unsigned num_clocks)
  */
 static int __init clock_late_init(void)
 {
+	unsigned i, count = 0;
 	unsigned long flags;
-	struct clk *clk;
-	unsigned count = 0;
 
 	clock_debug_init();
-	mutex_lock(&clocks_mutex);
-	list_for_each_entry(clk, &clocks, list) {
+	for (i = 0; i < msm_num_clocks; i++) {
+		struct clk *clk = msm_clocks[i].clk;
+
 		clock_debug_add(clk);
 		if (clk->flags & CLKFLAG_AUTO_OFF) {
 			spin_lock_irqsave(&clocks_lock, flags);
@@ -175,7 +169,6 @@ static int __init clock_late_init(void)
 			spin_unlock_irqrestore(&clocks_lock, flags);
 		}
 	}
-	mutex_unlock(&clocks_mutex);
 	pr_info("clock_late_init() disabled %d unused clocks\n", count);
 	return 0;
 }
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 2c007f6..32a43d4 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -53,7 +53,6 @@ struct clk {
 	uint32_t flags;
 	struct clk_ops *ops;
 	const char *dbg_name;
-	struct list_head list;
 };
 
 #define OFF CLKFLAG_AUTO_OFF
diff --git a/arch/arm/mach-msm/include/mach/board.h b/arch/arm/mach-msm/include/mach/board.h
index 2ce8f1f..1e4c50e 100644
--- a/arch/arm/mach-msm/include/mach/board.h
+++ b/arch/arm/mach-msm/include/mach/board.h
@@ -41,7 +41,7 @@ void __init msm_add_devices(void);
 void __init msm_map_common_io(void);
 void __init msm_init_irq(void);
 void __init msm_init_gpio(void);
-void __init msm_clock_init(struct clk_lookup *clock_tbl, unsigned num_clocks);
+void __init msm_clock_init(struct clk_lookup *clock_tbl, size_t num_clocks);
 void __init msm_acpu_clock_init(struct msm_acpu_clock_platform_data *);
 int __init msm_add_sdcc(unsigned int controller,
 			struct msm_mmc_platform_data *plat,
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

