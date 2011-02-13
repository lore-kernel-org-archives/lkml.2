Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1BMJnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 04:43:15 -0500
Received: from smtp-out.google.com ([74.125.121.67]:58554 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab1BMJnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 04:43:01 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/21] ARM: tegra: clock: Disable clocks left on by bootloader
Date: Sun, 13 Feb 2011 01:40:17 -0800
Message-Id: <1297590033-15035-6-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297590033-15035-1-git-send-email-ccross@android.com>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds CONFIG_TEGRA_DISABLE_BOOTLOADER_CLOCKS that iterates
through all clocks, disabling any for which the refcount
is 0 but the clock init detected the bootloader left the
clock on.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/Kconfig |    6 ++++++
 arch/arm/mach-tegra/clock.c |   30 ++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index f0fda77..9f4fc6b 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -57,6 +57,12 @@ config TEGRA_DEBUG_UARTE
 
 endchoice
 
+config TEGRA_DISABLE_BOOTLOADER_CLOCKS
+	bool "Disable clocks left on by bootloader"
+	help
+	  Disables clocks that are detected to be on but haven't
+	  been requested by a kernel driver.
+
 config TEGRA_SYSTEM_DMA
 	bool "Enable system DMA driver for NVIDIA Tegra SoCs"
 	default y
diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
index f55bb83..0ea5d92 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -511,6 +511,36 @@ int __init tegra_init_dvfs(void)
 
 late_initcall(tegra_init_dvfs);
 
+/*
+ * Iterate through all clocks, disabling any for which the refcount is 0
+ * but the clock init detected the bootloader left the clock on.
+ */
+#ifdef CONFIG_TEGRA_DISABLE_BOOTLOADER_CLOCKS
+int __init tegra_disable_boot_clocks(void)
+{
+	unsigned long flags;
+
+	struct clk *c;
+
+	spin_lock_irqsave(&clock_lock, flags);
+
+	list_for_each_entry(c, &clocks, node) {
+		if (c->refcnt == 0 && c->state == ON &&
+				c->ops && c->ops->disable) {
+			pr_warning("Disabling clock %s left on by bootloader\n",
+				c->name);
+			c->ops->disable(c);
+			c->state = OFF;
+		}
+	}
+
+	spin_unlock_irqrestore(&clock_lock, flags);
+
+	return 0;
+}
+late_initcall(tegra_disable_boot_clocks);
+#endif
+
 #ifdef CONFIG_DEBUG_FS
 static struct dentry *clk_debugfs_root;
 
-- 
1.7.3.1

