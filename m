Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab2JRQHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:07:07 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:36651 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753163Ab2JRQHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:07:03 -0400
From: Roland Stigge <stigge@antcom.de>
To: a.zummo@towertech.it, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, s.hauer@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 2/2] rtc-imxdi: Add devicetree support
Date: Thu, 18 Oct 2012 18:06:09 +0200
Message-Id: <1350576370-29098-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350576370-29098-1-git-send-email-stigge@antcom.de>
References: <1350576370-29098-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support to the rtc-imxdi driver.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 Documentation/devicetree/bindings/rtc/imxdi-rtc.txt |   17 +++++++++++++++++
 drivers/rtc/rtc-imxdi.c                             |   11 +++++++++++
 2 files changed, 28 insertions(+)

--- /dev/null
+++ linux-2.6/Documentation/devicetree/bindings/rtc/imxdi-rtc.txt
@@ -0,0 +1,17 @@
+* i.MX25 Real Time Clock controller
+
+This binding supports the following chips: i.MX25, i.MX53
+
+Required properties:
+- compatible: should be: "fsl,imx25-rtc"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+- interrupts: rtc alarm interrupt
+
+Example:
+
+rtc@80056000 {
+	compatible = "fsl,imx53-rtc", "fsl,imx25-rtc";
+	reg = <0x80056000 2000>;
+	interrupts = <29>;
+};
--- linux-2.6.orig/drivers/rtc/rtc-imxdi.c
+++ linux-2.6/drivers/rtc/rtc-imxdi.c
@@ -37,6 +37,7 @@
 #include <linux/rtc.h>
 #include <linux/sched.h>
 #include <linux/workqueue.h>
+#include <linux/of.h>
 
 /* DryIce Register Definitions */
 
@@ -493,10 +494,20 @@ static int __devexit dryice_rtc_remove(s
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id dryice_dt_ids[] = {
+	{ .compatible = "fsl,imx25-rtc" },
+	{ /* sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, dryice_dt_ids);
+#endif
+
 static struct platform_driver dryice_rtc_driver = {
 	.driver = {
 		   .name = "imxdi_rtc",
 		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(dryice_dt_ids),
 		   },
 	.remove = __devexit_p(dryice_rtc_remove),
 };
