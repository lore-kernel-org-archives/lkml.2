Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab2DAHhz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 03:37:55 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:41533 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2DAHhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 03:37:47 -0400
From: Marc Reilly <marc@cpdesign.com.au>
To: sameo@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-i2c@vger.kernel.org,
        u.kleine-koenig@pengutronix.de, oskar@scara.com,
        linux-kernel@vger.kernel.org, alexg@meprolight.com,
        Marc Reilly <marc@cpdesign.com.au>
Subject: [PATCH v5 1/4] mfd: mc13xxx-core: Prepare for separate spi and i2c backends.
Date: Sun,  1 Apr 2012 16:41:36 +1000
Message-Id: <1333262499-25871-2-git-send-email-marc@cpdesign.com.au>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1333262499-25871-1-git-send-email-marc@cpdesign.com.au>
References: <1333262499-25871-1-git-send-email-marc@cpdesign.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch abstracts the bus specific operations from the driver core.
Generic init and cleanup is consolidated into mc13xxx_common_*.
spi specific functions are renamed to reflect such.
(The irq member of the mc13xxx struct is no longer redundant, it's used
to store the irq for cleanup time).

Signed-off-by: Marc Reilly <marc@cpdesign.com.au>
---
 drivers/mfd/mc13xxx-core.c |  187 ++++++++++++++++++++++++++------------------
 1 files changed, 112 insertions(+), 75 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 7122386..0753402 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -22,8 +22,18 @@
 #include <linux/of_device.h>
 #include <linux/of_gpio.h>
 
+enum mc13xxx_id {
+	MC13XXX_ID_MC13783,
+	MC13XXX_ID_MC13892,
+	MC13XXX_ID_INVALID,
+};
+
 struct mc13xxx {
 	struct spi_device *spidev;
+
+	struct device *dev;
+	enum mc13xxx_id ictype;
+
 	struct mutex lock;
 	int irq;
 	int flags;
@@ -144,36 +154,32 @@ struct mc13xxx {
 void mc13xxx_lock(struct mc13xxx *mc13xxx)
 {
 	if (!mutex_trylock(&mc13xxx->lock)) {
-		dev_dbg(&mc13xxx->spidev->dev, "wait for %s from %pf\n",
+		dev_dbg(mc13xxx->dev, "wait for %s from %pf\n",
 				__func__, __builtin_return_address(0));
 
 		mutex_lock(&mc13xxx->lock);
 	}
-	dev_dbg(&mc13xxx->spidev->dev, "%s from %pf\n",
+	dev_dbg(mc13xxx->dev, "%s from %pf\n",
 			__func__, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(mc13xxx_lock);
 
 void mc13xxx_unlock(struct mc13xxx *mc13xxx)
 {
-	dev_dbg(&mc13xxx->spidev->dev, "%s from %pf\n",
+	dev_dbg(mc13xxx->dev, "%s from %pf\n",
 			__func__, __builtin_return_address(0));
 	mutex_unlock(&mc13xxx->lock);
 }
 EXPORT_SYMBOL(mc13xxx_unlock);
 
 #define MC13XXX_REGOFFSET_SHIFT 25
-int mc13xxx_reg_read(struct mc13xxx *mc13xxx, unsigned int offset, u32 *val)
+static int mc13xxx_spi_reg_read(struct mc13xxx *mc13xxx,
+				unsigned int offset, u32 *val)
 {
 	struct spi_transfer t;
 	struct spi_message m;
 	int ret;
 
-	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
-
-	if (offset > MC13XXX_NUMREGS)
-		return -EINVAL;
-
 	*val = offset << MC13XXX_REGOFFSET_SHIFT;
 
 	memset(&t, 0, sizeof(t));
@@ -195,26 +201,17 @@ int mc13xxx_reg_read(struct mc13xxx *mc13xxx, unsigned int offset, u32 *val)
 
 	*val &= 0xffffff;
 
-	dev_vdbg(&mc13xxx->spidev->dev, "[0x%02x] -> 0x%06x\n", offset, *val);
-
 	return 0;
 }
-EXPORT_SYMBOL(mc13xxx_reg_read);
 
-int mc13xxx_reg_write(struct mc13xxx *mc13xxx, unsigned int offset, u32 val)
+static int mc13xxx_spi_reg_write(struct mc13xxx *mc13xxx, unsigned int offset,
+		u32 val)
 {
 	u32 buf;
 	struct spi_transfer t;
 	struct spi_message m;
 	int ret;
 
-	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
-
-	dev_vdbg(&mc13xxx->spidev->dev, "[0x%02x] <- 0x%06x\n", offset, val);
-
-	if (offset > MC13XXX_NUMREGS || val > 0xffffff)
-		return -EINVAL;
-
 	buf = 1 << 31 | offset << MC13XXX_REGOFFSET_SHIFT | val;
 
 	memset(&t, 0, sizeof(t));
@@ -235,6 +232,34 @@ int mc13xxx_reg_write(struct mc13xxx *mc13xxx, unsigned int offset, u32 val)
 
 	return 0;
 }
+
+int mc13xxx_reg_read(struct mc13xxx *mc13xxx, unsigned int offset, u32 *val)
+{
+	int ret;
+
+	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
+
+	if (offset > MC13XXX_NUMREGS)
+		return -EINVAL;
+
+	ret = mc13xxx_spi_reg_read(mc13xxx, offset, val);
+	dev_vdbg(mc13xxx->dev, "[0x%02x] -> 0x%06x\n", offset, *val);
+
+	return ret;
+}
+EXPORT_SYMBOL(mc13xxx_reg_read);
+
+int mc13xxx_reg_write(struct mc13xxx *mc13xxx, unsigned int offset, u32 val)
+{
+	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
+
+	dev_vdbg(mc13xxx->dev, "[0x%02x] <- 0x%06x\n", offset, val);
+
+	if (offset > MC13XXX_NUMREGS || val > 0xffffff)
+		return -EINVAL;
+
+	return mc13xxx_spi_reg_write(mc13xxx, offset, val);
+}
 EXPORT_SYMBOL(mc13xxx_reg_write);
 
 int mc13xxx_reg_rmw(struct mc13xxx *mc13xxx, unsigned int offset,
@@ -439,7 +464,7 @@ static int mc13xxx_irq_handle(struct mc13xxx *mc13xxx,
 			if (handled == IRQ_HANDLED)
 				num_handled++;
 		} else {
-			dev_err(&mc13xxx->spidev->dev,
+			dev_err(mc13xxx->dev,
 					"BUG: irq %u but no handler\n",
 					baseirq + irq);
 
@@ -475,25 +500,23 @@ static irqreturn_t mc13xxx_irq_thread(int irq, void *data)
 	return IRQ_RETVAL(handled);
 }
 
-enum mc13xxx_id {
-	MC13XXX_ID_MC13783,
-	MC13XXX_ID_MC13892,
-	MC13XXX_ID_INVALID,
-};
-
 static const char *mc13xxx_chipname[] = {
 	[MC13XXX_ID_MC13783] = "mc13783",
 	[MC13XXX_ID_MC13892] = "mc13892",
 };
 
 #define maskval(reg, mask)	(((reg) & (mask)) >> __ffs(mask))
-static int mc13xxx_identify(struct mc13xxx *mc13xxx, enum mc13xxx_id *id)
+static int mc13xxx_identify(struct mc13xxx *mc13xxx)
 {
 	u32 icid;
 	u32 revision;
-	const char *name;
 	int ret;
 
+	/*
+	 * Get the generation ID from register 46, as apparently some older
+	 * IC revisions only have this info at this location. Newer ICs seem to
+	 * have both.
+	 */
 	ret = mc13xxx_reg_read(mc13xxx, 46, &icid);
 	if (ret)
 		return ret;
@@ -502,26 +525,23 @@ static int mc13xxx_identify(struct mc13xxx *mc13xxx, enum mc13xxx_id *id)
 
 	switch (icid) {
 	case 2:
-		*id = MC13XXX_ID_MC13783;
-		name = "mc13783";
+		mc13xxx->ictype = MC13XXX_ID_MC13783;
 		break;
 	case 7:
-		*id = MC13XXX_ID_MC13892;
-		name = "mc13892";
+		mc13xxx->ictype = MC13XXX_ID_MC13892;
 		break;
 	default:
-		*id = MC13XXX_ID_INVALID;
+		mc13xxx->ictype = MC13XXX_ID_INVALID;
 		break;
 	}
 
-	if (*id == MC13XXX_ID_MC13783 || *id == MC13XXX_ID_MC13892) {
+	if (mc13xxx->ictype == MC13XXX_ID_MC13783 ||
+			mc13xxx->ictype == MC13XXX_ID_MC13892) {
 		ret = mc13xxx_reg_read(mc13xxx, MC13XXX_REVISION, &revision);
-		if (ret)
-			return ret;
 
-		dev_info(&mc13xxx->spidev->dev, "%s: rev: %d.%d, "
+		dev_info(mc13xxx->dev, "%s: rev: %d.%d, "
 				"fin: %d, fab: %d, icid: %d/%d\n",
-				mc13xxx_chipname[*id],
+				mc13xxx_chipname[mc13xxx->ictype],
 				maskval(revision, MC13XXX_REVISION_REVFULL),
 				maskval(revision, MC13XXX_REVISION_REVMETAL),
 				maskval(revision, MC13XXX_REVISION_FIN),
@@ -530,26 +550,12 @@ static int mc13xxx_identify(struct mc13xxx *mc13xxx, enum mc13xxx_id *id)
 				maskval(revision, MC13XXX_REVISION_ICIDCODE));
 	}
 
-	if (*id != MC13XXX_ID_INVALID) {
-		const struct spi_device_id *devid =
-			spi_get_device_id(mc13xxx->spidev);
-		if (!devid || devid->driver_data != *id)
-			dev_warn(&mc13xxx->spidev->dev, "device id doesn't "
-					"match auto detection!\n");
-	}
-
-	return 0;
+	return (mc13xxx->ictype == MC13XXX_ID_INVALID) ? -ENODEV : 0;
 }
 
 static const char *mc13xxx_get_chipname(struct mc13xxx *mc13xxx)
 {
-	const struct spi_device_id *devid =
-		spi_get_device_id(mc13xxx->spidev);
-
-	if (!devid)
-		return NULL;
-
-	return mc13xxx_chipname[devid->driver_data];
+	return mc13xxx_chipname[mc13xxx->ictype];
 }
 
 int mc13xxx_get_flags(struct mc13xxx *mc13xxx)
@@ -589,7 +595,7 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
 	};
 	init_completion(&adcdone_data.done);
 
-	dev_dbg(&mc13xxx->spidev->dev, "%s\n", __func__);
+	dev_dbg(mc13xxx->dev, "%s\n", __func__);
 
 	mc13xxx_lock(mc13xxx);
 
@@ -631,7 +637,7 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
 		return -EINVAL;
 	}
 
-	dev_dbg(&mc13xxx->spidev->dev, "%s: request irq\n", __func__);
+	dev_dbg(mc13xxx->dev, "%s: request irq\n", __func__);
 	mc13xxx_irq_request(mc13xxx, MC13XXX_IRQ_ADCDONE,
 			mc13xxx_handler_adcdone, __func__, &adcdone_data);
 	mc13xxx_irq_ack(mc13xxx, MC13XXX_IRQ_ADCDONE);
@@ -689,7 +695,7 @@ static int mc13xxx_add_subdevice_pdata(struct mc13xxx *mc13xxx,
 	if (!cell.name)
 		return -ENOMEM;
 
-	return mfd_add_devices(&mc13xxx->spidev->dev, -1, &cell, 1, NULL, 0);
+	return mfd_add_devices(mc13xxx->dev, -1, &cell, 1, NULL, 0);
 }
 
 static int mc13xxx_add_subdevice(struct mc13xxx *mc13xxx, const char *format)
@@ -700,7 +706,7 @@ static int mc13xxx_add_subdevice(struct mc13xxx *mc13xxx, const char *format)
 #ifdef CONFIG_OF
 static int mc13xxx_probe_flags_dt(struct mc13xxx *mc13xxx)
 {
-	struct device_node *np = mc13xxx->spidev->dev.of_node;
+	struct device_node *np = mc13xxx->dev.of_node;
 
 	if (!np)
 		return -ENODEV;
@@ -746,13 +752,17 @@ static const struct of_device_id mc13xxx_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, mc13xxx_dt_ids);
 
-static int mc13xxx_probe(struct spi_device *spi)
+static int mc13xxx_common_init(struct mc13xxx *mc13xxx,
+		struct mc13xxx_platform_data *pdata, int irq);
+
+static void mc13xxx_common_cleanup(struct mc13xxx *mc13xxx);
+
+static int mc13xxx_spi_probe(struct spi_device *spi)
 {
 	const struct of_device_id *of_id;
 	struct spi_driver *sdrv = to_spi_driver(spi->dev.driver);
 	struct mc13xxx *mc13xxx;
 	struct mc13xxx_platform_data *pdata = dev_get_platdata(&spi->dev);
-	enum mc13xxx_id id;
 	int ret;
 
 	of_id = of_match_device(mc13xxx_dt_ids, &spi->dev);
@@ -768,13 +778,34 @@ static int mc13xxx_probe(struct spi_device *spi)
 	spi->bits_per_word = 32;
 	spi_setup(spi);
 
+	mc13xxx->dev = &spi->dev;
 	mc13xxx->spidev = spi;
 
+	ret = mc13xxx_common_init(mc13xxx, pdata, spi->irq);
+
+	if (ret) {
+		dev_set_drvdata(&spi->dev, NULL);
+	} else {
+		const struct spi_device_id *devid =
+			spi_get_device_id(mc13xxx->spidev);
+		if (!devid || devid->driver_data != mc13xxx->ictype)
+			dev_warn(mc13xxx->dev,
+				"device id doesn't match auto detection!\n");
+	}
+
+	return ret;
+}
+
+static int mc13xxx_common_init(struct mc13xxx *mc13xxx,
+		struct mc13xxx_platform_data *pdata, int irq)
+{
+	int ret;
+
 	mutex_init(&mc13xxx->lock);
 	mc13xxx_lock(mc13xxx);
 
-	ret = mc13xxx_identify(mc13xxx, &id);
-	if (ret || id == MC13XXX_ID_INVALID)
+	ret = mc13xxx_identify(mc13xxx);
+	if (ret)
 		goto err_revision;
 
 	/* mask all irqs */
@@ -786,18 +817,19 @@ static int mc13xxx_probe(struct spi_device *spi)
 	if (ret)
 		goto err_mask;
 
-	ret = request_threaded_irq(spi->irq, NULL, mc13xxx_irq_thread,
+	ret = request_threaded_irq(irq, NULL, mc13xxx_irq_thread,
 			IRQF_ONESHOT | IRQF_TRIGGER_HIGH, "mc13xxx", mc13xxx);
 
 	if (ret) {
 err_mask:
 err_revision:
 		mc13xxx_unlock(mc13xxx);
-		dev_set_drvdata(&spi->dev, NULL);
 		kfree(mc13xxx);
 		return ret;
 	}
 
+	mc13xxx->irq = irq;
+
 	mc13xxx_unlock(mc13xxx);
 
 	if (mc13xxx_probe_flags_dt(mc13xxx) < 0 && pdata)
@@ -831,39 +863,44 @@ err_revision:
 	return 0;
 }
 
-static int __devexit mc13xxx_remove(struct spi_device *spi)
+static int __devexit mc13xxx_spi_remove(struct spi_device *spi)
 {
 	struct mc13xxx *mc13xxx = dev_get_drvdata(&spi->dev);
 
-	free_irq(mc13xxx->spidev->irq, mc13xxx);
+	mc13xxx_common_cleanup(mc13xxx);
 
-	mfd_remove_devices(&spi->dev);
+	return 0;
+}
 
-	kfree(mc13xxx);
+static void mc13xxx_common_cleanup(struct mc13xxx *mc13xxx)
+{
+	free_irq(mc13xxx->irq, mc13xxx);
 
-	return 0;
+	mfd_remove_devices(mc13xxx->dev);
+
+	kfree(mc13xxx);
 }
 
-static struct spi_driver mc13xxx_driver = {
+static struct spi_driver mc13xxx_spi_driver = {
 	.id_table = mc13xxx_device_id,
 	.driver = {
 		.name = "mc13xxx",
 		.owner = THIS_MODULE,
 		.of_match_table = mc13xxx_dt_ids,
 	},
-	.probe = mc13xxx_probe,
-	.remove = __devexit_p(mc13xxx_remove),
+	.probe = mc13xxx_spi_probe,
+	.remove = __devexit_p(mc13xxx_spi_remove),
 };
 
 static int __init mc13xxx_init(void)
 {
-	return spi_register_driver(&mc13xxx_driver);
+	return spi_register_driver(&mc13xxx_spi_driver);
 }
 subsys_initcall(mc13xxx_init);
 
 static void __exit mc13xxx_exit(void)
 {
-	spi_unregister_driver(&mc13xxx_driver);
+	spi_unregister_driver(&mc13xxx_spi_driver);
 }
 module_exit(mc13xxx_exit);
 
-- 
1.7.3.4

