Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab0LQPfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:35:12 -0500
Received: from www.tglx.de ([62.245.132.106]:60983 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab0LQPfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:35:09 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org, dirk.brandewie@gmail.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 14/15] rtc/cmos: add OF bindings
Date: Fri, 17 Dec 2010 16:33:52 +0100
Message-Id: <1292600033-12271-15-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to load the OF driver based informations from the device
tree. Systems without BIOS may need to perform some initialization.
PowerPC creates a PNP device from the OF information and performs this
kind of initialization in their private PCI quirk. This looks more
generic.

Cc: rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 Documentation/powerpc/dts-bindings/rtc-cmos.txt |   28 ++++++++++++++++
 drivers/rtc/rtc-cmos.c                          |   40 +++++++++++++++++++++++
 2 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/rtc-cmos.txt

diff --git a/Documentation/powerpc/dts-bindings/rtc-cmos.txt b/Documentation/powerpc/dts-bindings/rtc-cmos.txt
new file mode 100644
index 0000000..7382989
--- /dev/null
+++ b/Documentation/powerpc/dts-bindings/rtc-cmos.txt
@@ -0,0 +1,28 @@
+ Motorola mc146818 compatible RTC
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Required properties:
+  - compatible : "motorola,mc146818"
+  - reg : should contain registers location and length.
+
+Optional properties:
+  - interrupts : should contain interrupt.
+  - interrupt-parent : interrupt source phandle.
+  - ctrl-reg : Contains the initial value of the control register also
+    called "Register B".
+  - freq-reg : Contains the initial value of the frequency register also
+    called "Regsiter A".
+
+"Register A" and "B" are usually initialized by the firmware (BIOS for
+instance). If this is not done, it can be performed by the driver.
+
+ISA Example:
+
+	rtc@70 {
+	         compatible = "motorola,mc146818";
+	         interrupts = <8 3>;
+	         interrupt-parent = <&ioapic1>;
+	         ctrl-reg = <2>;
+	         freq-reg = <0x26>;
+	         reg = <1 0x70 2>;
+	 };
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 5856167..8cf0049 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -36,6 +36,8 @@
 #include <linux/platform_device.h>
 #include <linux/mod_devicetable.h>
 #include <linux/log2.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 
 /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
 #include <asm-generic/rtc.h>
@@ -1121,6 +1123,15 @@ static struct pnp_driver cmos_pnp_driver = {
 
 #endif	/* CONFIG_PNP */
 
+#ifdef CONFIG_OF
+static const struct of_device_id of_cmos_match[] = {
+	{
+		.compatible = "motorola,mc146818",
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, of_cmos_match);
+#endif
 /*----------------------------------------------------------------*/
 
 /* Platform setup should have set up an RTC device, when PNP is
@@ -1129,6 +1140,32 @@ static struct pnp_driver cmos_pnp_driver = {
 
 static int __init cmos_platform_probe(struct platform_device *pdev)
 {
+#ifdef CONFIG_OF
+	if (pdev->dev.of_node) {
+		struct device_node *node = pdev->dev.of_node;
+		struct rtc_time time;
+		int ret;
+		const __be32 *val;
+
+		val = of_get_property(node, "ctrl-reg", NULL);
+		if (val)
+			CMOS_WRITE(be32_to_cpup(val), RTC_CONTROL);
+
+		val = of_get_property(node, "freq-reg", NULL);
+		if (val)
+			CMOS_WRITE(be32_to_cpup(val), RTC_FREQ_SELECT);
+
+		get_rtc_time(&time);
+		ret = rtc_valid_tm(&time);
+		if (ret) {
+			struct rtc_time def_time = {
+				.tm_year = 1,
+				.tm_mday = 1,
+			};
+			set_rtc_time(&def_time);
+		}
+	}
+#endif
 	cmos_wake_setup(&pdev->dev);
 	return cmos_do_probe(&pdev->dev,
 			platform_get_resource(pdev, IORESOURCE_IO, 0),
@@ -1157,6 +1194,9 @@ static struct platform_driver cmos_platform_driver = {
 	.shutdown	= cmos_platform_shutdown,
 	.driver = {
 		.name		= (char *) driver_name,
+#if defined(CONFIG_OF)
+		.of_match_table = of_cmos_match,
+#endif
 		.suspend	= cmos_suspend,
 		.resume		= cmos_resume,
 	}
-- 
1.7.3.2

