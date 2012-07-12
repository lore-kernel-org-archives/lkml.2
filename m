Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136Ab2GLKLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:11:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41490 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933619Ab2GLKJL (ORCPT
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
Subject: [PATCH 7/7] mfd/mc13xxx: add support for mc34708
Date: Thu, 12 Jul 2012 11:57:53 +0200
Message-Id: <1342087073-3892-8-git-send-email-u.kleine-koenig@pengutronix.de>
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

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/mfd/mc13xxx-core.c |   21 +++++++++++++++++++++
 drivers/mfd/mc13xxx-i2c.c  |    6 ++++++
 drivers/mfd/mc13xxx-spi.c  |    4 ++++
 drivers/mfd/mc13xxx.h      |    3 ++-
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 7874711..4ce3e1f 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -119,6 +119,11 @@
 #define MC13XXX_REVISION_FAB		(0x03 << 11)
 #define MC13XXX_REVISION_ICIDCODE	(0x3f << 13)
 
+#define MC34708_REVISION_REVMETAL	(0x07 <<  0)
+#define MC34708_REVISION_REVFULL	(0x07 <<  3)
+#define MC34708_REVISION_FIN		(0x07 <<  6)
+#define MC34708_REVISION_FAB		(0x07 <<  9)
+
 #define MC13XXX_ADC1		44
 #define MC13XXX_ADC1_ADEN		(1 << 0)
 #define MC13XXX_ADC1_RAND		(1 << 1)
@@ -424,6 +429,16 @@ static void mc13xxx_print_revision(struct mc13xxx *mc13xxx, u32 revision)
 			maskval(revision, MC13XXX_REVISION_ICIDCODE));
 }
 
+static void mc34708_print_revision(struct mc13xxx *mc13xxx, u32 revision)
+{
+	dev_info(mc13xxx->dev, "%s: rev %d.%d, fin: %d, fab: %d\n",
+			mc13xxx->variant->name,
+			maskval(revision, MC34708_REVISION_REVFULL),
+			maskval(revision, MC34708_REVISION_REVMETAL),
+			maskval(revision, MC34708_REVISION_FIN),
+			maskval(revision, MC34708_REVISION_FAB));
+}
+
 /* These are only exported for mc13xxx-i2c and mc13xxx-spi */
 struct mc13xxx_variant mc13xxx_variant_mc13783 = {
 	.name = "mc13783",
@@ -437,6 +452,12 @@ struct mc13xxx_variant mc13xxx_variant_mc13892 = {
 };
 EXPORT_SYMBOL_GPL(mc13xxx_variant_mc13892);
 
+struct mc13xxx_variant mc13xxx_variant_mc34708 = {
+	.name = "mc34708",
+	.print_revision = mc34708_print_revision,
+};
+EXPORT_SYMBOL_GPL(mc13xxx_variant_mc34708);
+
 static const char *mc13xxx_get_chipname(struct mc13xxx *mc13xxx)
 {
 	return mc13xxx->variant->name;
diff --git a/drivers/mfd/mc13xxx-i2c.c b/drivers/mfd/mc13xxx-i2c.c
index 6c1598c..907abff 100644
--- a/drivers/mfd/mc13xxx-i2c.c
+++ b/drivers/mfd/mc13xxx-i2c.c
@@ -26,6 +26,9 @@ static const struct i2c_device_id mc13xxx_i2c_device_id[] = {
 		.name = "mc13892",
 		.driver_data = (kernel_ulong_t)&mc13xxx_variant_mc13892,
 	}, {
+		.name = "mc34708",
+		.driver_data = (kernel_ulong_t)&mc13xxx_variant_mc34708,
+	}, {
 		/* sentinel */
 	}
 };
@@ -36,6 +39,9 @@ static const struct of_device_id mc13xxx_dt_ids[] = {
 		.compatible = "fsl,mc13892",
 		.data = &mc13xxx_variant_mc13892,
 	}, {
+		.compatible = "fsl,mc34708",
+		.data = &mc13xxx_variant_mc34708,
+	}, {
 		/* sentinel */
 	}
 };
diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
index 75a00c4..08a3bd9 100644
--- a/drivers/mfd/mc13xxx-spi.c
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -33,6 +33,9 @@ static const struct spi_device_id mc13xxx_device_id[] = {
 		.name = "mc13892",
 		.driver_data = (kernel_ulong_t)&mc13xxx_variant_mc13892,
 	}, {
+		.name = "mc34708",
+		.driver_data = (kernel_ulong_t)&mc13xxx_variant_mc34708,
+	}, {
 		/* sentinel */
 	}
 };
@@ -41,6 +44,7 @@ MODULE_DEVICE_TABLE(spi, mc13xxx_device_id);
 static const struct of_device_id mc13xxx_dt_ids[] = {
 	{ .compatible = "fsl,mc13783", .data = &mc13xxx_variant_mc13783, },
 	{ .compatible = "fsl,mc13892", .data = &mc13xxx_variant_mc13892, },
+	{ .compatible = "fsl,mc34708", .data = &mc13xxx_variant_mc34708, },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, mc13xxx_dt_ids);
diff --git a/drivers/mfd/mc13xxx.h b/drivers/mfd/mc13xxx.h
index 78bf4c3..460ec5c 100644
--- a/drivers/mfd/mc13xxx.h
+++ b/drivers/mfd/mc13xxx.h
@@ -24,7 +24,8 @@ struct mc13xxx_variant {
 
 extern struct mc13xxx_variant
 		mc13xxx_variant_mc13783,
-		mc13xxx_variant_mc13892;
+		mc13xxx_variant_mc13892,
+		mc13xxx_variant_mc34708;
 
 struct mc13xxx {
 	struct regmap *regmap;
-- 
1.7.10.4

