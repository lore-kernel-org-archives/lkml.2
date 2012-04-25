Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2DYHek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 03:34:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab2DYHei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 03:34:38 -0400
From: NeilBrown <neilb@suse.de>
To: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 25 Apr 2012 17:33:10 +1000
Subject: [PATCH 2/6] twl4030_charger: add backup-battery charging.
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, NeilBrown <neilb@suse.de>
Message-ID: <20120425073310.20124.17469.stgit@notabene.brown>
In-Reply-To: <20120425072931.20124.56635.stgit@notabene.brown>
References: <20120425072931.20124.56635.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows a voltage and current (bb_uvolts and bb_uamps)
to be specified in the platform_data, and charging of the backup
battery will be enabled with those specification.

As it is not possible to monitor the backup battery at all
there is no new device created to represent it.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/power/twl4030_charger.c |   59 +++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/twl.h         |    2 +
 2 files changed, 61 insertions(+)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index 3e6e991..0511610 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -28,6 +28,7 @@
 #define TWL4030_BCIVBUS		0x0c
 #define TWL4030_BCIMFSTS4	0x10
 #define TWL4030_BCICTL1		0x23
+#define TWL4030_BB_CFG		0x12
 
 #define TWL4030_BCIAUTOWEN	BIT(5)
 #define TWL4030_CONFIG_DONE	BIT(4)
@@ -37,6 +38,17 @@
 #define TWL4030_USBFASTMCHG	BIT(2)
 #define TWL4030_STS_VBUS	BIT(7)
 #define TWL4030_STS_USB_ID	BIT(2)
+#define TWL4030_BBCHEN		BIT(4)
+#define TWL4030_BBSEL_MASK	0b1100
+#define TWL4030_BBSEL_2V5	0b0000
+#define TWL4030_BBSEL_3V0	0b0100
+#define TWL4030_BBSEL_3V1	0b1000
+#define TWL4030_BBSEL_3V2	0b1100
+#define TWL4030_BBISEL_MASK	0b11
+#define TWL4030_BBISEL_25uA	0b00
+#define TWL4030_BBISEL_150uA	0b01
+#define TWL4030_BBISEL_500uA	0b10
+#define TWL4030_BBISEL_1000uA	0b11
 
 /* BCI interrupts */
 #define TWL4030_WOVF		BIT(0) /* Watchdog overflow */
@@ -202,6 +214,49 @@ static int twl4030_charger_enable_ac(bool enable)
 }
 
 /*
+ * Enable/Disable charging of Backup Battery.
+ */
+static int twl4030_charger_enable_backup(int uvolt, int uamp)
+{
+	int ret;
+	u8 flags;
+
+	if (uvolt < 2500000 ||
+	    uamp < 25) {
+		/* disable charging of backup battery */
+		ret = twl4030_clear_set(TWL4030_MODULE_PM_RECEIVER,
+					TWL4030_BBCHEN, 0, TWL4030_BB_CFG);
+		return ret;
+	}
+
+	flags = TWL4030_BBCHEN;
+	if (uvolt >= 3200000)
+		flags |= TWL4030_BBSEL_3V2;
+	else if (uvolt >= 3100000)
+		flags |= TWL4030_BBSEL_3V1;
+	else if (uvolt >= 3000000)
+		flags |= TWL4030_BBSEL_3V0;
+	else
+		flags |= TWL4030_BBSEL_2V5;
+
+	if (uamp >= 1000)
+		flags |= TWL4030_BBISEL_1000uA;
+	else if (uamp >= 500)
+		flags |= TWL4030_BBISEL_500uA;
+	else if (uamp >= 150)
+		flags |= TWL4030_BBISEL_150uA;
+	else
+		flags |= TWL4030_BBISEL_25uA;
+
+	ret = twl4030_clear_set(TWL4030_MODULE_PM_RECEIVER,
+				TWL4030_BBSEL_MASK | TWL4030_BBISEL_MASK,
+				flags,
+				TWL4030_BB_CFG);
+
+	return ret;
+}
+
+/*
  * TWL4030 CHG_PRES (AC charger presence) events
  */
 static irqreturn_t twl4030_charger_interrupt(int irq, void *arg)
@@ -424,6 +479,7 @@ static enum power_supply_property twl4030_charger_props[] = {
 static int __init twl4030_bci_probe(struct platform_device *pdev)
 {
 	struct twl4030_bci *bci;
+	struct twl4030_bci_platform_data *pdata = pdev->dev.platform_data;
 	int ret;
 	u32 reg;
 
@@ -503,6 +559,8 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 
 	twl4030_charger_enable_ac(true);
 	twl4030_charger_enable_usb(bci, true);
+	twl4030_charger_enable_backup(pdata->bb_uvolt,
+				      pdata->bb_uamp);
 
 	return 0;
 
@@ -531,6 +589,7 @@ static int __exit twl4030_bci_remove(struct platform_device *pdev)
 
 	twl4030_charger_enable_ac(false);
 	twl4030_charger_enable_usb(bci, false);
+	twl4030_charger_enable_backup(0, 0);
 
 	/* mask interrupts */
 	twl_i2c_write_u8(TWL4030_MODULE_INTERRUPTS, 0xff,
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 1f90de0..b526031 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -557,6 +557,8 @@ struct twl4030_clock_init_data {
 struct twl4030_bci_platform_data {
 	int *battery_tmp_tbl;
 	unsigned int tblsize;
+	int	bb_uvolt;	/* voltage to charge backup battery */
+	int	bb_uamp;	/* current for backup battery charging */
 };
 
 /* TWL4030_GPIO_MAX (18) GPIOs, with interrupts */


