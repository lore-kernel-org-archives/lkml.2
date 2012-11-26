Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2KZLhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:37:13 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55705 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab2KZLhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:37:10 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: linus.walleij@linaro.org, grant.likely@secretlab.ca
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, lee.jones@linaro.org,
        Vipul Kumar Samar <vipulkumar.samar@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2] gpio: stmpe: Add DT support for stmpe gpio
Date: Mon, 26 Nov 2012 17:06:51 +0530
Message-Id: <1e773c8f35fed89f6eb6cc44f393fb76ba4ae3e2.1353929710.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 26 Nov 2012 11:36:59.0418 (UTC) FILETIME=[589DC7A0:01CDCBCA]
X-MC-Unique: 112112611370108601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qAQBbHFX023763

From: Vipul Kumar Samar <vipulkumar.samar@st.com>

This patch allows the STMPE GPIO driver to be successfully probed and
initialised when Device Tree support is enabled. Bindings are mentioned in
Documentation too.

Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V1->V2:
- Fixed norequest-mask as st,norequest-mask in Binding Documentation
- Added Acked-by from Lee Jones

 Documentation/devicetree/bindings/gpio/gpio-stmpe.txt | 18 ++++++++++++++++++
 drivers/gpio/gpio-stmpe.c                             | 10 ++++++++--
 drivers/mfd/stmpe.c                                   |  2 ++
 3 files changed, 28 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-stmpe.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-stmpe.txt b/Documentation/devicetree/bindings/gpio/gpio-stmpe.txt
new file mode 100644
index 0000000..a0e4cf8
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-stmpe.txt
@@ -0,0 +1,18 @@
+STMPE gpio
+----------
+
+Required properties:
+ - compatible: "st,stmpe-gpio"
+
+Optional properties:
+ - st,norequest-mask: bitmask specifying which GPIOs should _not_ be requestable
+   due to different usage (e.g. touch, keypad)
+
+Node name must be stmpe_gpio and should be child node of stmpe node to which it
+belongs.
+
+Example:
+	stmpe_gpio {
+		compatible = "st,stmpe-gpio";
+		st,norequest-mask = <0x20>;	//gpio 5 can't be used
+	};
diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
index dce3472..522c90e 100644
--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@ -12,6 +12,7 @@
 #include <linux/gpio.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/of.h>
 #include <linux/mfd/stmpe.h>
 
 /*
@@ -304,6 +305,7 @@ static void stmpe_gpio_irq_remove(struct stmpe_gpio *stmpe_gpio)
 static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
 {
 	struct stmpe *stmpe = dev_get_drvdata(pdev->dev.parent);
+	struct device_node *np = pdev->dev.of_node;
 	struct stmpe_gpio_platform_data *pdata;
 	struct stmpe_gpio *stmpe_gpio;
 	int ret;
@@ -321,13 +323,17 @@ static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
 
 	stmpe_gpio->dev = &pdev->dev;
 	stmpe_gpio->stmpe = stmpe;
-	stmpe_gpio->norequest_mask = pdata ? pdata->norequest_mask : 0;
-
 	stmpe_gpio->chip = template_chip;
 	stmpe_gpio->chip.ngpio = stmpe->num_gpios;
 	stmpe_gpio->chip.dev = &pdev->dev;
 	stmpe_gpio->chip.base = pdata ? pdata->gpio_base : -1;
 
+	if (pdata)
+		stmpe_gpio->norequest_mask = pdata->norequest_mask;
+	else if (np)
+		of_property_read_u32(np, "st,norequest-mask",
+				&stmpe_gpio->norequest_mask);
+
 	if (irq >= 0)
 		stmpe_gpio->irq_base = stmpe->irq_base + STMPE_INT_GPIO(0);
 	else
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 0d5f7b7..8b164f3 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -295,12 +295,14 @@ static struct resource stmpe_gpio_resources[] = {
 
 static struct mfd_cell stmpe_gpio_cell = {
 	.name		= "stmpe-gpio",
+	.of_compatible	= "st,stmpe-gpio",
 	.resources	= stmpe_gpio_resources,
 	.num_resources	= ARRAY_SIZE(stmpe_gpio_resources),
 };
 
 static struct mfd_cell stmpe_gpio_cell_noirq = {
 	.name		= "stmpe-gpio",
+	.of_compatible	= "st,stmpe-gpio",
 	/* gpio cell resources consist of an irq only so no resources here */
 };
 
-- 
1.7.12.rc2.18.g61b472e


