Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2DYHfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 03:35:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379Ab2DYHe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 03:34:59 -0400
From: NeilBrown <neilb@suse.de>
To: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 25 Apr 2012 17:33:11 +1000
Subject: [PATCH 4/6] twl4030_charger: Allow charger to control the regulator
 that feeds it.
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, NeilBrown <neilb@suse.de>
Message-ID: <20120425073310.20124.68293.stgit@notabene.brown>
In-Reply-To: <20120425072931.20124.56635.stgit@notabene.brown>
References: <20120425072931.20124.56635.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The charger needs usb3v1 to be running, so add a new consumer to
keep it running.

This allows the charger to draw current even when the USB driver has
powered down.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/mfd/twl-core.c          |    9 +++++----
 drivers/power/twl4030_charger.c |   15 +++++++++++++++
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 7c2267e..4cbf285 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -723,8 +723,9 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 		static struct regulator_consumer_supply usb1v8 = {
 			.supply =	"usb1v8",
 		};
-		static struct regulator_consumer_supply usb3v1 = {
-			.supply =	"usb3v1",
+		static struct regulator_consumer_supply usb3v1[] = {
+			{ .supply =	"usb3v1" },
+			{ .supply =	"bci3v1" },
 		};
 
 	/* First add the regulators so that they can be used by transceiver */
@@ -752,7 +753,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 				return PTR_ERR(child);
 
 			child = add_regulator_linked(TWL4030_REG_VUSB3V1,
-						      &usb_fixed, &usb3v1, 1,
+						      &usb_fixed, usb3v1, 2,
 						      features);
 			if (IS_ERR(child))
 				return PTR_ERR(child);
@@ -773,7 +774,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 		if (twl_has_regulator() && child) {
 			usb1v5.dev_name = dev_name(child);
 			usb1v8.dev_name = dev_name(child);
-			usb3v1.dev_name = dev_name(child);
+			usb3v1[0].dev_name = dev_name(child);
 		}
 	}
 	if (twl_has_usb() && pdata->usb && twl_class_is_6030()) {
diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index 684662a..d9d8e4a 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -21,6 +21,7 @@
 #include <linux/power_supply.h>
 #include <linux/notifier.h>
 #include <linux/usb/otg.h>
+#include <linux/regulator/machine.h>
 
 #define TWL4030_BCIMSTATEC	0x02
 #define TWL4030_BCIICHG		0x08
@@ -86,6 +87,8 @@ struct twl4030_bci {
 	struct work_struct	work;
 	int			irq_chg;
 	int			irq_bci;
+	struct regulator	*usb_reg;
+	int			usb_enabled;
 
 	unsigned long		event;
 };
@@ -179,6 +182,12 @@ static int twl4030_charger_enable_usb(struct twl4030_bci *bci, bool enable)
 			return -EACCES;
 		}
 
+		/* Need to keep regulator on */
+		if (!bci->usb_enabled) {
+			regulator_enable(bci->usb_reg);
+			bci->usb_enabled = 1;
+		}
+
 		/* forcing the field BCIAUTOUSB (BOOT_BCI[1]) to 1 */
 		ret = twl4030_clear_set_boot_bci(0, TWL4030_BCIAUTOUSB);
 		if (ret < 0)
@@ -189,6 +198,10 @@ static int twl4030_charger_enable_usb(struct twl4030_bci *bci, bool enable)
 			TWL4030_USBFASTMCHG, TWL4030_BCIMFSTS4);
 	} else {
 		ret = twl4030_clear_set_boot_bci(TWL4030_BCIAUTOUSB, 0);
+		if (bci->usb_enabled) {
+			regulator_disable(bci->usb_reg);
+			bci->usb_enabled = 0;
+		}
 	}
 
 	return ret;
@@ -507,6 +520,8 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 	bci->usb.num_properties = ARRAY_SIZE(twl4030_charger_props);
 	bci->usb.get_property = twl4030_bci_get_property;
 
+	bci->usb_reg = regulator_get(bci->dev, "bci3v1");
+
 	ret = power_supply_register(&pdev->dev, &bci->usb);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register usb: %d\n", ret);


