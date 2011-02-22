Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1BVCl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 21:41:27 -0500
Received: from smtp-out.google.com ([216.239.44.51]:62599 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab1BVClZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 21:41:25 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: konkers@android.com, olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mike@compulab.co.il,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 7/7] ARM: tegra: clock: Disable clocks left on by bootloader
Date: Mon, 21 Feb 2011 18:39:52 -0800
Message-Id: <1298342392-21236-8-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1298342392-21236-1-git-send-email-ccross@android.com>
References: <1298342392-21236-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Iterates through all clocks, disabling any for which the
refcount is 0 but the clock init detected the bootloader
left the clock on.  Can be disabled with command line
tegra_clock.disable_boot_clocks=N

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/clock.c |   44 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
index e028320..6d686ff 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -33,6 +33,9 @@
 #include "board.h"
 #include "clock.h"
 
+#undef MODULE_PARAM_PREFIX
+#define MODULE_PARAM_PREFIX "tegra_clock."
+
 /*
  * Locking:
  *
@@ -416,6 +419,47 @@ void tegra_sdmmc_tap_delay(struct clk *c, int delay)
 	spin_unlock_irqrestore(&c->spinlock, flags);
 }
 
+static bool tegra_disable_boot_clocks = true;
+module_param_named(disable_boot_clocks, tegra_disable_boot_clocks, bool,
+	S_IRUGO | S_IWUSR | S_IWGRP);
+
+/*
+ * Iterate through all clocks, disabling any for which the refcount is 0
+ * but the clock init detected the bootloader left the clock on.
+ */
+static int __init tegra_init_disable_boot_clocks(void)
+{
+	struct clk *c;
+
+	mutex_lock(&clock_list_lock);
+
+	list_for_each_entry(c, &clocks, node) {
+		spin_lock_irq(&c->spinlock);
+
+		if (c->refcnt == 0 && c->state == ON &&
+				c->ops && c->ops->disable) {
+			pr_warn_once("%s clocks left on by bootloader:\n",
+				tegra_disable_boot_clocks ?
+					"Disabling" :
+					"Prevented disabling");
+
+			pr_warn("   %s\n", c->name);
+
+			if (tegra_disable_boot_clocks) {
+				c->ops->disable(c);
+				c->state = OFF;
+			}
+		}
+
+		spin_unlock_irq(&c->spinlock);
+	}
+
+	mutex_unlock(&clock_list_lock);
+
+	return 0;
+}
+late_initcall(tegra_init_disable_boot_clocks);
+
 #ifdef CONFIG_DEBUG_FS
 
 static int __clk_lock_all_spinlocks(void)
-- 
1.7.3.1

