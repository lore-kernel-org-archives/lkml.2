Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1GGAvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:51:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:60037 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab1GGAvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:51:20 -0400
Date: Thu, 7 Jul 2011 00:51:11 GMT
From: tip-bot for Daniel Drake <dsd@laptop.org>
Message-ID: <tip-cfee95977bea090ae5ec4fd442ebd381792d46c4@git.kernel.org>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, dsd@laptop.org, dilinger@queued.net,
        tglx@linutronix.de, bigeasy@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, dsd@laptop.org, dilinger@queued.net,
        tglx@linutronix.de, bigeasy@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1309019658-1712-11-git-send-email-dsd@laptop.org>
References: <1309019658-1712-11-git-send-email-dsd@laptop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/olpc] x86, olpc: Add XO-1 RTC driver
Git-Commit-ID: cfee95977bea090ae5ec4fd442ebd381792d46c4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Jul 2011 00:51:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cfee95977bea090ae5ec4fd442ebd381792d46c4
Gitweb:     http://git.kernel.org/tip/cfee95977bea090ae5ec4fd442ebd381792d46c4
Author:     Daniel Drake <dsd@laptop.org>
AuthorDate: Sat, 25 Jun 2011 17:34:17 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 6 Jul 2011 14:44:42 -0700

x86, olpc: Add XO-1 RTC driver

Add a driver to configure the XO-1 RTC via CS5536 MSRs, to be used as a
system wakeup source via olpc-xo1-pm.

Device detection is based on finding the relevant device tree node.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Link: http://lkml.kernel.org/r/1309019658-1712-11-git-send-email-dsd@laptop.org
Acked-by: Andres Salomon <dilinger@queued.net>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 .../devicetree/bindings/rtc/olpc-xo1-rtc.txt       |    5 +
 arch/x86/Kconfig                                   |    7 ++
 arch/x86/platform/olpc/Makefile                    |    1 +
 arch/x86/platform/olpc/olpc-xo1-rtc.c              |   81 ++++++++++++++++++++
 include/linux/cs5535.h                             |    5 +
 5 files changed, 99 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/rtc/olpc-xo1-rtc.txt b/Documentation/devicetree/bindings/rtc/olpc-xo1-rtc.txt
new file mode 100644
index 0000000..a2891ce
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/olpc-xo1-rtc.txt
@@ -0,0 +1,5 @@
+OLPC XO-1 RTC
+~~~~~~~~~~~~~
+
+Required properties:
+ - compatible : "olpc,xo1-rtc"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a6aefbb..0a9d573 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2080,6 +2080,13 @@ config OLPC_XO1_PM
 	---help---
 	  Add support for poweroff and suspend of the OLPC XO-1 laptop.
 
+config OLPC_XO1_RTC
+	bool "OLPC XO-1 Real Time Clock"
+	depends on OLPC_XO1_PM && RTC_DRV_CMOS
+	---help---
+	  Add support for the XO-1 real time clock, which can be used as a
+	  programmable wakeup source.
+
 config OLPC_XO1_SCI
 	bool "OLPC XO-1 SCI extras"
 	depends on OLPC && OLPC_XO1_PM && POWER_SUPPLY
diff --git a/arch/x86/platform/olpc/Makefile b/arch/x86/platform/olpc/Makefile
index 1ec5ade..8922b9b 100644
--- a/arch/x86/platform/olpc/Makefile
+++ b/arch/x86/platform/olpc/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_OLPC)		+= olpc.o olpc_ofw.o olpc_dt.o
 obj-$(CONFIG_OLPC_XO1_PM)		+= olpc-xo1-pm.o xo1-wakeup.o
+obj-$(CONFIG_OLPC_XO1_RTC)	+= olpc-xo1-rtc.o
 obj-$(CONFIG_OLPC_XO1_SCI)	+= olpc-xo1-sci.o
diff --git a/arch/x86/platform/olpc/olpc-xo1-rtc.c b/arch/x86/platform/olpc/olpc-xo1-rtc.c
new file mode 100644
index 0000000..a2b4efd
--- /dev/null
+++ b/arch/x86/platform/olpc/olpc-xo1-rtc.c
@@ -0,0 +1,81 @@
+/*
+ * Support for OLPC XO-1 Real Time Clock (RTC)
+ *
+ * Copyright (C) 2011 One Laptop per Child
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/mc146818rtc.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/of.h>
+
+#include <asm/msr.h>
+#include <asm/olpc.h>
+
+static void rtc_wake_on(struct device *dev)
+{
+	olpc_xo1_pm_wakeup_set(CS5536_PM_RTC);
+}
+
+static void rtc_wake_off(struct device *dev)
+{
+	olpc_xo1_pm_wakeup_clear(CS5536_PM_RTC);
+}
+
+static struct resource rtc_platform_resource[] = {
+	[0] = {
+		.start	= RTC_PORT(0),
+		.end	= RTC_PORT(1),
+		.flags	= IORESOURCE_IO,
+	},
+	[1] = {
+		.start	= RTC_IRQ,
+		.end	= RTC_IRQ,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static struct cmos_rtc_board_info rtc_info = {
+	.rtc_day_alarm = 0,
+	.rtc_mon_alarm = 0,
+	.rtc_century = 0,
+	.wake_on = rtc_wake_on,
+	.wake_off = rtc_wake_off,
+};
+
+static struct platform_device xo1_rtc_device = {
+	.name = "rtc_cmos",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(rtc_platform_resource),
+	.dev.platform_data = &rtc_info,
+	.resource = rtc_platform_resource,
+};
+
+static int __init xo1_rtc_init(void)
+{
+	int r;
+	struct device_node *node;
+
+	node = of_find_compatible_node(NULL, NULL, "olpc,xo1-rtc");
+	if (!node)
+		return 0;
+	of_node_put(node);
+
+	pr_info("olpc-xo1-rtc: Initializing OLPC XO-1 RTC\n");
+	rdmsrl(MSR_RTC_DOMA_OFFSET, rtc_info.rtc_day_alarm);
+	rdmsrl(MSR_RTC_MONA_OFFSET, rtc_info.rtc_mon_alarm);
+	rdmsrl(MSR_RTC_CEN_OFFSET, rtc_info.rtc_century);
+
+	r = platform_device_register(&xo1_rtc_device);
+	if (r)
+		return r;
+
+	device_init_wakeup(&xo1_rtc_device.dev, 1);
+	return 0;
+}
+arch_initcall(xo1_rtc_init);
diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
index 72954c6..c077aec 100644
--- a/include/linux/cs5535.h
+++ b/include/linux/cs5535.h
@@ -40,6 +40,10 @@
 #define MSR_MFGPT_NR		0x51400029
 #define MSR_MFGPT_SETUP		0x5140002B
 
+#define MSR_RTC_DOMA_OFFSET	0x51400055
+#define MSR_RTC_MONA_OFFSET	0x51400056
+#define MSR_RTC_CEN_OFFSET	0x51400057
+
 #define MSR_LX_SPARE_MSR	0x80000011	/* DC-specific */
 
 #define MSR_GX_GLD_MSR_CONFIG	0xC0002001
@@ -95,6 +99,7 @@ static inline int cs5535_pic_unreqz_select_high(unsigned int group,
 
 /* CS5536_PM1_EN bits */
 #define CS5536_PM_PWRBTN	(1 << 8)
+#define CS5536_PM_RTC		(1 << 10)
 
 /* CS5536_PM_GPE0_STS bits */
 #define CS5536_GPIOM7_PME_FLAG	(1 << 31)
