Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab1AMKvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 05:51:22 -0500
Received: from www.tglx.de ([62.245.132.106]:45471 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756190Ab1AMKvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 05:51:18 -0500
Date: Thu, 13 Jan 2011 11:50:42 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, x86@kernel.org, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v2] rtc/cmos: add OF bindings
Message-ID: <20110113105042.GB23275@www.tglx.de>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de> <1292600033-12271-15-git-send-email-bigeasy@linutronix.de> <20110112000442.GJ2131@angua.secretlab.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110112000442.GJ2131@angua.secretlab.ca>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
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

* Grant Likely | 2011-01-11 17:04:42 [-0700]:

>It's usually cleaner to break the of-specific probe stuff into a
>separate function that can be #ifdef'ed out as a whole instead of
>having #ifdef blocks inside the probe functions.  Aside from that this
>patch looks good to me.

Done.

 Documentation/powerpc/dts-bindings/rtc-cmos.txt |   28 ++++++++++++++
 drivers/rtc/rtc-cmos.c                          |   46 +++++++++++++++++++++++
 2 files changed, 74 insertions(+), 0 deletions(-)
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
index 5856167..95a08dd 100644
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
@@ -1121,6 +1123,46 @@ static struct pnp_driver cmos_pnp_driver = {
 
 #endif	/* CONFIG_PNP */
 
+#ifdef CONFIG_OF
+static const struct of_device_id of_cmos_match[] = {
+	{
+		.compatible = "motorola,mc146818",
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, of_cmos_match);
+
+static __init void cmos_of_init(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct rtc_time time;
+	int ret;
+	const __be32 *val;
+
+	if (!node)
+		return;
+
+	val = of_get_property(node, "ctrl-reg", NULL);
+	if (val)
+		CMOS_WRITE(be32_to_cpup(val), RTC_CONTROL);
+
+	val = of_get_property(node, "freq-reg", NULL);
+	if (val)
+		CMOS_WRITE(be32_to_cpup(val), RTC_FREQ_SELECT);
+
+	get_rtc_time(&time);
+	ret = rtc_valid_tm(&time);
+	if (ret) {
+		struct rtc_time def_time = {
+			.tm_year = 1,
+			.tm_mday = 1,
+		};
+		set_rtc_time(&def_time);
+	}
+}
+#else
+static inline void cmos_of_init(struct platform_device *pdev) {}
+#endif
 /*----------------------------------------------------------------*/
 
 /* Platform setup should have set up an RTC device, when PNP is
@@ -1129,6 +1171,7 @@ static struct pnp_driver cmos_pnp_driver = {
 
 static int __init cmos_platform_probe(struct platform_device *pdev)
 {
+	cmos_of_init(pdev);
 	cmos_wake_setup(&pdev->dev);
 	return cmos_do_probe(&pdev->dev,
 			platform_get_resource(pdev, IORESOURCE_IO, 0),
@@ -1157,6 +1200,9 @@ static struct platform_driver cmos_platform_driver = {
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



Sebastian
