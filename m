Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab2IMAJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:09:43 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46488 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab2IMAIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 20:08:41 -0400
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [PATCH v2 1/2] OMAP: mailbox: add device tree support
Date: Wed, 12 Sep 2012 19:08:14 -0500
Message-Id: <1347494898-16671-2-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347494898-16671-1-git-send-email-omar.luna@linaro.org>
References: <1347494898-16671-1-git-send-email-omar.luna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt driver to use DT if provided.

Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 .../devicetree/bindings/arm/omap/mailbox.txt       |    9 +++++++++
 arch/arm/mach-omap2/devices.c                      |    3 +++
 arch/arm/mach-omap2/mailbox.c                      |   12 ++++++++++++
 3 files changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/omap/mailbox.txt

diff --git a/Documentation/devicetree/bindings/arm/omap/mailbox.txt b/Documentation/devicetree/bindings/arm/omap/mailbox.txt
new file mode 100644
index 0000000..c57c0d5
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/omap/mailbox.txt
@@ -0,0 +1,9 @@
+OMAP Mailbox module
+
+Required properties:
+ compatible : should be "ti,omap2-mailbox" for OMAP2 mailbox
+ compatible : should be "ti,omap3-mailbox" for OMAP3 mailbox
+ compatible : should be "ti,omap4-mailbox" for OMAP4 mailbox
+
+Optional properties:
+ None
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index c00c689..19093fb 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -279,6 +279,9 @@ static inline void __init omap_init_mbox(void)
 	struct omap_hwmod *oh;
 	struct platform_device *pdev;
 
+	if (of_have_populated_dt())
+		return;
+
 	oh = omap_hwmod_lookup("mailbox");
 	if (!oh) {
 		pr_err("%s: unable to find hwmod\n", __func__);
diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
index 6875be8..80beadf 100644
--- a/arch/arm/mach-omap2/mailbox.c
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/pm_runtime.h>
@@ -400,11 +401,22 @@ static int __devexit omap2_mbox_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#if defined(CONFIG_OF)
+static const struct of_device_id omap_mailbox_of_match[] = {
+	{ .compatible = "ti,omap2-mailbox" },
+	{ .compatible = "ti,omap3-mailbox" },
+	{ .compatible = "ti,omap4-mailbox" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, omap_mailbox_of_match);
+#endif
+
 static struct platform_driver omap2_mbox_driver = {
 	.probe = omap2_mbox_probe,
 	.remove = __devexit_p(omap2_mbox_remove),
 	.driver = {
 		.name = "omap-mailbox",
+		.of_match_table = of_match_ptr(omap_mailbox_of_match),
 	},
 };
 
-- 
1.7.9.5

