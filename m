Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab1BWVxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:53:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:57161 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab1BWVxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:53:36 -0500
Date: Wed, 23 Feb 2011 21:53:06 GMT
From: tip-bot for Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, hpa@zytor.com,
        mingo@redhat.com, dirk.brandewie@gmail.com, tglx@linutronix.de,
        bigeasy@linutronix.de, a.zummo@towertech.it
Reply-To: mingo@redhat.com, hpa@zytor.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, dirk.brandewie@gmail.com,
        bigeasy@linutronix.de, tglx@linutronix.de, a.zummo@towertech.it
In-Reply-To: <1298405266-1624-12-git-send-email-bigeasy@linutronix.de>
References: <1298405266-1624-12-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] rtc: cmos: Add OF bindings
Message-ID: <tip-3bcbaf6e08d8d82cde781997bd2c56dda87049b5@git.kernel.org>
Git-Commit-ID: 3bcbaf6e08d8d82cde781997bd2c56dda87049b5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 21:53:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3bcbaf6e08d8d82cde781997bd2c56dda87049b5
Gitweb:     http://git.kernel.org/tip/3bcbaf6e08d8d82cde781997bd2c56dda87049b5
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Tue, 22 Feb 2011 21:07:46 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 23 Feb 2011 22:27:55 +0100

rtc: cmos: Add OF bindings

This allows to load the OF driver based informations from the device
tree. Systems without BIOS may need to perform some initialization.
PowerPC creates a PNP device from the OF information and performs this
kind of initialization in their private PCI quirk. This looks more
generic.

This patch also avoids registering the platform RTC driver on X86 if
we have a device tree blob. Otherwise we would setup the device based
on the hardcoded information in arch/x86 rather than the device tree
based one.

[ tglx: Changed "int of_have_populated_dt()" to bool as recommended by
        Grant ]

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: sodaville@linutronix.de
Cc: devicetree-discuss@lists.ozlabs.org
Cc: rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>
LKML-Reference: <1298405266-1624-12-git-send-email-bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/devicetree/bindings/rtc/rtc-cmos.txt |   28 ++++++++++++
 arch/x86/kernel/rtc.c                              |    3 +
 drivers/rtc/rtc-cmos.c                             |   45 ++++++++++++++++++++
 include/linux/of.h                                 |   12 +++++
 4 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/rtc/rtc-cmos.txt b/Documentation/devicetree/bindings/rtc/rtc-cmos.txt
new file mode 100644
index 0000000..7382989
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/rtc-cmos.txt
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
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 6f39cab..3f2ad26 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -6,6 +6,7 @@
 #include <linux/acpi.h>
 #include <linux/bcd.h>
 #include <linux/pnp.h>
+#include <linux/of.h>
 
 #include <asm/vsyscall.h>
 #include <asm/x86_init.h>
@@ -236,6 +237,8 @@ static __init int add_rtc_cmos(void)
 		}
 	}
 #endif
+	if (of_have_populated_dt())
+		return 0;
 
 	platform_device_register(&rtc_device);
 	dev_info(&rtc_device.dev,
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index c7ff8df..159b95e 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -37,6 +37,8 @@
 #include <linux/mod_devicetable.h>
 #include <linux/log2.h>
 #include <linux/pm.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 
 /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
 #include <asm-generic/rtc.h>
@@ -1123,6 +1125,47 @@ static struct pnp_driver cmos_pnp_driver = {
 
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
+#define of_cmos_match NULL
+#endif
 /*----------------------------------------------------------------*/
 
 /* Platform setup should have set up an RTC device, when PNP is
@@ -1131,6 +1174,7 @@ static struct pnp_driver cmos_pnp_driver = {
 
 static int __init cmos_platform_probe(struct platform_device *pdev)
 {
+	cmos_of_init(pdev);
 	cmos_wake_setup(&pdev->dev);
 	return cmos_do_probe(&pdev->dev,
 			platform_get_resource(pdev, IORESOURCE_IO, 0),
@@ -1162,6 +1206,7 @@ static struct platform_driver cmos_platform_driver = {
 #ifdef CONFIG_PM
 		.pm		= &cmos_pm_ops,
 #endif
+		.of_match_table = of_cmos_match,
 	}
 };
 
diff --git a/include/linux/of.h b/include/linux/of.h
index d9dd664..266db1d 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -70,6 +70,11 @@ extern struct device_node *allnodes;
 extern struct device_node *of_chosen;
 extern rwlock_t devtree_lock;
 
+static inline bool of_have_populated_dt(void)
+{
+	return allnodes != NULL;
+}
+
 static inline bool of_node_is_root(const struct device_node *node)
 {
 	return node && (node->parent == NULL);
@@ -222,5 +227,12 @@ extern void of_attach_node(struct device_node *);
 extern void of_detach_node(struct device_node *);
 #endif
 
+#else
+
+static inline bool of_have_populated_dt(void)
+{
+	return false;
+}
+
 #endif /* CONFIG_OF */
 #endif /* _LINUX_OF_H */
