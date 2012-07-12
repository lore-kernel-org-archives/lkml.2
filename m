Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160Ab2GLKLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:11:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41489 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933592Ab2GLKJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:09:11 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>,
        =?UTF-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        Marc Reilly <marc@cpdesign.com.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 6/7] mfd/mc13xxx: change probing details for mc13xxx devices
Date: Thu, 12 Jul 2012 11:57:52 +0200
Message-Id: <1342087073-3892-7-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes auto-detection of which variant of mc13xxx is used because
mc34708 uses a different layout in the revision register that doesn't
allow differentiation any more.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/mfd/mc13xxx-core.c |   77 ++++++++++++++++----------------------------
 drivers/mfd/mc13xxx-i2c.c  |   16 +++++----
 drivers/mfd/mc13xxx-spi.c  |   25 +++++++-------
 drivers/mfd/mc13xxx.h      |   17 ++++++----
 4 files changed, 60 insertions(+), 75 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index f0ea3b8..7874711 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -410,62 +410,36 @@ static irqreturn_t mc13xxx_irq_thread(int irq, void *data)
 	return IRQ_RETVAL(handled);
 }
 
-static const char *mc13xxx_chipname[] = {
-	[MC13XXX_ID_MC13783] = "mc13783",
-	[MC13XXX_ID_MC13892] = "mc13892",
-};
-
 #define maskval(reg, mask)	(((reg) & (mask)) >> __ffs(mask))
-static int mc13xxx_identify(struct mc13xxx *mc13xxx)
+static void mc13xxx_print_revision(struct mc13xxx *mc13xxx, u32 revision)
 {
-	u32 icid;
-	u32 revision;
-	int ret;
-
-	/*
-	 * Get the generation ID from register 46, as apparently some older
-	 * IC revisions only have this info at this location. Newer ICs seem to
-	 * have both.
-	 */
-	ret = mc13xxx_reg_read(mc13xxx, 46, &icid);
-	if (ret)
-		return ret;
-
-	icid = (icid >> 6) & 0x7;
-
-	switch (icid) {
-	case 2:
-		mc13xxx->ictype = MC13XXX_ID_MC13783;
-		break;
-	case 7:
-		mc13xxx->ictype = MC13XXX_ID_MC13892;
-		break;
-	default:
-		mc13xxx->ictype = MC13XXX_ID_INVALID;
-		break;
-	}
+	dev_info(mc13xxx->dev, "%s: rev: %d.%d, "
+			"fin: %d, fab: %d, icid: %d/%d\n",
+			mc13xxx->variant->name,
+			maskval(revision, MC13XXX_REVISION_REVFULL),
+			maskval(revision, MC13XXX_REVISION_REVMETAL),
+			maskval(revision, MC13XXX_REVISION_FIN),
+			maskval(revision, MC13XXX_REVISION_FAB),
+			maskval(revision, MC13XXX_REVISION_ICID),
+			maskval(revision, MC13XXX_REVISION_ICIDCODE));
+}
 
-	if (mc13xxx->ictype == MC13XXX_ID_MC13783 ||
-			mc13xxx->ictype == MC13XXX_ID_MC13892) {
-		ret = mc13xxx_reg_read(mc13xxx, MC13XXX_REVISION, &revision);
-
-		dev_info(mc13xxx->dev, "%s: rev: %d.%d, "
-				"fin: %d, fab: %d, icid: %d/%d\n",
-				mc13xxx_chipname[mc13xxx->ictype],
-				maskval(revision, MC13XXX_REVISION_REVFULL),
-				maskval(revision, MC13XXX_REVISION_REVMETAL),
-				maskval(revision, MC13XXX_REVISION_FIN),
-				maskval(revision, MC13XXX_REVISION_FAB),
-				maskval(revision, MC13XXX_REVISION_ICID),
-				maskval(revision, MC13XXX_REVISION_ICIDCODE));
-	}
+/* These are only exported for mc13xxx-i2c and mc13xxx-spi */
+struct mc13xxx_variant mc13xxx_variant_mc13783 = {
+	.name = "mc13783",
+	.print_revision = mc13xxx_print_revision,
+};
+EXPORT_SYMBOL_GPL(mc13xxx_variant_mc13783);
 
-	return (mc13xxx->ictype == MC13XXX_ID_INVALID) ? -ENODEV : 0;
-}
+struct mc13xxx_variant mc13xxx_variant_mc13892 = {
+	.name = "mc13892",
+	.print_revision = mc13xxx_print_revision,
+};
+EXPORT_SYMBOL_GPL(mc13xxx_variant_mc13892);
 
 static const char *mc13xxx_get_chipname(struct mc13xxx *mc13xxx)
 {
-	return mc13xxx_chipname[mc13xxx->ictype];
+	return mc13xxx->variant->name;
 }
 
 int mc13xxx_get_flags(struct mc13xxx *mc13xxx)
@@ -653,13 +627,16 @@ int mc13xxx_common_init(struct mc13xxx *mc13xxx,
 		struct mc13xxx_platform_data *pdata, int irq)
 {
 	int ret;
+	u32 revision;
 
 	mc13xxx_lock(mc13xxx);
 
-	ret = mc13xxx_identify(mc13xxx);
+	ret = mc13xxx_reg_read(mc13xxx, MC13XXX_REVISION, &revision);
 	if (ret)
 		goto err_revision;
 
+	mc13xxx_print_revision(mc13xxx, revision);
+
 	/* mask all irqs */
 	ret = mc13xxx_reg_write(mc13xxx, MC13XXX_IRQMASK0, 0x00ffffff);
 	if (ret)
diff --git a/drivers/mfd/mc13xxx-i2c.c b/drivers/mfd/mc13xxx-i2c.c
index e00e885..6c1598c 100644
--- a/drivers/mfd/mc13xxx-i2c.c
+++ b/drivers/mfd/mc13xxx-i2c.c
@@ -24,7 +24,7 @@
 static const struct i2c_device_id mc13xxx_i2c_device_id[] = {
 	{
 		.name = "mc13892",
-		.driver_data = MC13XXX_ID_MC13892,
+		.driver_data = (kernel_ulong_t)&mc13xxx_variant_mc13892,
 	}, {
 		/* sentinel */
 	}
@@ -34,7 +34,7 @@ MODULE_DEVICE_TABLE(i2c, mc13xxx_i2c_device_id);
 static const struct of_device_id mc13xxx_dt_ids[] = {
 	{
 		.compatible = "fsl,mc13892",
-		.data = (void *) &mc13xxx_i2c_device_id[0],
+		.data = &mc13xxx_variant_mc13892,
 	}, {
 		/* sentinel */
 	}
@@ -76,11 +76,15 @@ static int mc13xxx_i2c_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	ret = mc13xxx_common_init(mc13xxx, pdata, client->irq);
+	if (client->dev.of_node) {
+		const struct of_device_id *of_id =
+			of_match_device(mc13xxx_dt_ids, &client->dev);
+		mc13xxx->variant = of_id->data;
+	} else {
+		mc13xxx->variant = (void *)id->driver_data;
+	}
 
-	if (ret == 0 && (id->driver_data != mc13xxx->ictype))
-		dev_warn(mc13xxx->dev,
-				"device id doesn't match auto detection!\n");
+	ret = mc13xxx_common_init(mc13xxx, pdata, client->irq);
 
 	return ret;
 }
diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
index b99e728..75a00c4 100644
--- a/drivers/mfd/mc13xxx-spi.c
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -28,10 +28,10 @@
 static const struct spi_device_id mc13xxx_device_id[] = {
 	{
 		.name = "mc13783",
-		.driver_data = MC13XXX_ID_MC13783,
+		.driver_data = (kernel_ulong_t)&mc13xxx_variant_mc13783,
 	}, {
 		.name = "mc13892",
-		.driver_data = MC13XXX_ID_MC13892,
+		.driver_data = (kernel_ulong_t)&mc13xxx_variant_mc13892,
 	}, {
 		/* sentinel */
 	}
@@ -39,8 +39,8 @@ static const struct spi_device_id mc13xxx_device_id[] = {
 MODULE_DEVICE_TABLE(spi, mc13xxx_device_id);
 
 static const struct of_device_id mc13xxx_dt_ids[] = {
-	{ .compatible = "fsl,mc13783", .data = (void *) MC13XXX_ID_MC13783, },
-	{ .compatible = "fsl,mc13892", .data = (void *) MC13XXX_ID_MC13892, },
+	{ .compatible = "fsl,mc13783", .data = &mc13xxx_variant_mc13783, },
+	{ .compatible = "fsl,mc13892", .data = &mc13xxx_variant_mc13892, },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, mc13xxx_dt_ids);
@@ -145,19 +145,18 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
 		return ret;
 	}
 
-	ret = mc13xxx_common_init(mc13xxx, pdata, spi->irq);
+	if (spi->dev.of_node) {
+		const struct of_device_id *of_id =
+			of_match_device(mc13xxx_dt_ids, &spi->dev);
 
-	if (ret) {
-		dev_set_drvdata(&spi->dev, NULL);
+		mc13xxx->variant = of_id->data;
 	} else {
-		const struct spi_device_id *devid =
-			spi_get_device_id(spi);
-		if (!devid || devid->driver_data != mc13xxx->ictype)
-			dev_warn(mc13xxx->dev,
-				"device id doesn't match auto detection!\n");
+		const struct spi_device_id *id_entry = spi_get_device_id(spi);
+
+		mc13xxx->variant = (void *)id_entry->driver_data;
 	}
 
-	return ret;
+	return mc13xxx_common_init(mc13xxx, pdata, spi->irq);
 }
 
 static int __devexit mc13xxx_spi_remove(struct spi_device *spi)
diff --git a/drivers/mfd/mc13xxx.h b/drivers/mfd/mc13xxx.h
index bbba06f..78bf4c3 100644
--- a/drivers/mfd/mc13xxx.h
+++ b/drivers/mfd/mc13xxx.h
@@ -13,19 +13,24 @@
 #include <linux/regmap.h>
 #include <linux/mfd/mc13xxx.h>
 
-enum mc13xxx_id {
-	MC13XXX_ID_MC13783,
-	MC13XXX_ID_MC13892,
-	MC13XXX_ID_INVALID,
+#define MC13XXX_NUMREGS 0x3f
+
+struct mc13xxx;
+
+struct mc13xxx_variant {
+	const char *name;
+	void (*print_revision)(struct mc13xxx *mc13xxx, u32 revision);
 };
 
-#define MC13XXX_NUMREGS 0x3f
+extern struct mc13xxx_variant
+		mc13xxx_variant_mc13783,
+		mc13xxx_variant_mc13892;
 
 struct mc13xxx {
 	struct regmap *regmap;
 
 	struct device *dev;
-	enum mc13xxx_id ictype;
+	const struct mc13xxx_variant *variant;
 
 	struct mutex lock;
 	int irq;
-- 
1.7.10.4

