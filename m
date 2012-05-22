Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab2EVWr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:47:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56802 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab2EVWr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:47:26 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: of/spi: Supply proper "spi:" modalias prefixes.
Date: Tue, 22 May 2012 15:47:19 -0700
Message-Id: <1337726839-7710-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

To get modprobe to automatically load the proper modules, we need to
prefix things with "spi:".  Partially based on Grant Likely's suggestions.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/of/of_spi.c |    6 +++++-
 drivers/spi/spi.c   |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/of/of_spi.c b/drivers/of/of_spi.c
index 6dbc074..3486d2d 100644
--- a/drivers/of/of_spi.c
+++ b/drivers/of/of_spi.c
@@ -25,6 +25,7 @@ void of_register_spi_devices(struct spi_master *master)
 	struct spi_device *spi;
 	struct device_node *nc;
 	const __be32 *prop;
+	char request_module_modalias[SPI_NAME_SIZE + 4];
 	int rc;
 	int len;
 
@@ -86,7 +87,10 @@ void of_register_spi_devices(struct spi_master *master)
 		spi->dev.of_node = nc;
 
 		/* Register the new device */
-		request_module(spi->modalias);
+		snprintf(request_module_modalias,
+			 sizeof(request_module_modalias),
+			 "%s%s", SPI_MODULE_PREFIX, spi->modalias);
+		request_module(request_module_modalias);
 		rc = spi_add_device(spi);
 		if (rc) {
 			dev_err(&master->dev, "spi_device register error %s\n",
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 3d8f662..da8aac7 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -51,7 +51,7 @@ modalias_show(struct device *dev, struct device_attribute *a, char *buf)
 {
 	const struct spi_device	*spi = to_spi_device(dev);
 
-	return sprintf(buf, "%s\n", spi->modalias);
+	return sprintf(buf, "%s%s\n", SPI_MODULE_PREFIX, spi->modalias);
 }
 
 static struct device_attribute spi_dev_attrs[] = {
