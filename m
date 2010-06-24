Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab0FXUMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 16:12:09 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:60197 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab0FXUMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 16:12:06 -0400
Subject: [PATCH 3/3] of: refactor of_modalias_node() and remove explicit match
	table.
To: devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: avorontsov@ru.mvista.com, ben-linux@fluff.org, wg@denx.de
Date: Thu, 24 Jun 2010 14:12:00 -0600
Message-ID: <20100624201200.10527.60038.stgit@angua>
In-Reply-To: <20100624200509.10527.513.stgit@angua>
References: <20100624200509.10527.513.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tightens up the behaviour of of_modalias_node() to be more
predicatable and to eliminate the explicit of_modalias_tablep[] that
is currently used to override the first entry in the compatible list
of a device.  The override table was needed originally because spi
and i2c drivers had no way to do of-style matching.  Now that all
devices can have an of_node pointer, and all drivers can have an
of_match_table, the explicit override table is no longer needed
because each driver can specify its own OF-style match data.

The mpc8349emitx-mcu driver is modified to explicitly specify the
correct device to bind against.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |    6 ++
 drivers/mmc/host/mmc_spi.c                     |    8 +++
 drivers/of/base.c                              |   64 +++---------------------
 3 files changed, 23 insertions(+), 55 deletions(-)

diff --git a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
index 59b0ed1..70798ac 100644
--- a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
+++ b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
@@ -160,10 +160,16 @@ static const struct i2c_device_id mcu_ids[] = {
 };
 MODULE_DEVICE_TABLE(i2c, mcu_ids);
 
+static struct of_device_id mcu_of_match_table[] __devinitdata = {
+	{ .compatible = "fsl,mcu-mpc8349emitx", },
+	{ },
+};
+
 static struct i2c_driver mcu_driver = {
 	.driver = {
 		.name = "mcu-mpc8349emitx",
 		.owner = THIS_MODULE,
+		.of_match_table = mcu_of_match_table,
 	},
 	.probe = mcu_probe,
 	.remove	= __devexit_p(mcu_remove),
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index ad847a2..7b0f3ef 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1533,12 +1533,20 @@ static int __devexit mmc_spi_remove(struct spi_device *spi)
 	return 0;
 }
 
+#if defined(CONFIG_OF)
+static struct of_device_id mmc_spi_of_match_table[] __devinitdata = {
+	{ .compatible = "mmc-spi-slot", },
+};
+#endif
 
 static struct spi_driver mmc_spi_driver = {
 	.driver = {
 		.name =		"mmc_spi",
 		.bus =		&spi_bus_type,
 		.owner =	THIS_MODULE,
+#if defined(CONFIG_OF)
+		.of_match_table = mmc_spi_of_match_table,
+#endif
 	},
 	.probe =	mmc_spi_probe,
 	.remove =	__devexit_p(mmc_spi_remove),
diff --git a/drivers/of/base.c b/drivers/of/base.c
index b5ad974..e3f7af8 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -545,74 +545,28 @@ struct device_node *of_find_matching_node(struct device_node *from,
 EXPORT_SYMBOL(of_find_matching_node);
 
 /**
- * of_modalias_table: Table of explicit compatible ==> modalias mappings
- *
- * This table allows particulare compatible property values to be mapped
- * to modalias strings.  This is useful for busses which do not directly
- * understand the OF device tree but are populated based on data contained
- * within the device tree.  SPI and I2C are the two current users of this
- * table.
- *
- * In most cases, devices do not need to be listed in this table because
- * the modalias value can be derived directly from the compatible table.
- * However, if for any reason a value cannot be derived, then this table
- * provides a method to override the implicit derivation.
- *
- * At the moment, a single table is used for all bus types because it is
- * assumed that the data size is small and that the compatible values
- * should already be distinct enough to differentiate between SPI, I2C
- * and other devices.
- */
-struct of_modalias_table {
-	char *of_device;
-	char *modalias;
-};
-static struct of_modalias_table of_modalias_table[] = {
-	{ "fsl,mcu-mpc8349emitx", "mcu-mpc8349emitx" },
-	{ "mmc-spi-slot", "mmc_spi" },
-};
-
-/**
  * of_modalias_node - Lookup appropriate modalias for a device node
  * @node:	pointer to a device tree node
  * @modalias:	Pointer to buffer that modalias value will be copied into
  * @len:	Length of modalias value
  *
- * Based on the value of the compatible property, this routine will determine
- * an appropriate modalias value for a particular device tree node.  Two
- * separate methods are attempted to derive a modalias value.
+ * Based on the value of the compatible property, this routine will attempt
+ * to choose an appropriate modalias value for a particular device tree node.
+ * It does this by stripping the manufacturer prefix (as delimited by a ',')
+ * from the first entry in the compatible list property.
  *
- * First method is to lookup the compatible value in of_modalias_table.
- * Second is to strip off the manufacturer prefix from the first
- * compatible entry and use the remainder as modalias
- *
- * This routine returns 0 on success
+ * This routine returns 0 on success, <0 on failure.
  */
 int of_modalias_node(struct device_node *node, char *modalias, int len)
 {
-	int i, cplen;
-	const char *compatible;
-	const char *p;
-
-	/* 1. search for exception list entry */
-	for (i = 0; i < ARRAY_SIZE(of_modalias_table); i++) {
-		compatible = of_modalias_table[i].of_device;
-		if (!of_device_is_compatible(node, compatible))
-			continue;
-		strlcpy(modalias, of_modalias_table[i].modalias, len);
-		return 0;
-	}
+	const char *compatible, *p;
+	int cplen;
 
 	compatible = of_get_property(node, "compatible", &cplen);
-	if (!compatible)
+	if (!compatible || strlen(compatible) > cplen)
 		return -ENODEV;
-
-	/* 2. take first compatible entry and strip manufacturer */
 	p = strchr(compatible, ',');
-	if (!p)
-		return -ENODEV;
-	p++;
-	strlcpy(modalias, p, len);
+	strlcpy(modalias, p ? p + 1 : compatible, len);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(of_modalias_node);

