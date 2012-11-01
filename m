Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762102Ab2KASG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 14:06:26 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:45114 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab2KASGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 14:06:24 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: spi-devel-general@lists.sourceforge.net
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: [PATCH] spi: erase pointer to drvdata on removal
Date: Thu,  1 Nov 2012 14:05:36 -0400
Message-Id: <1351793136-14126-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As for i2c-core, let the SPI core handle the removal of the device's
drvdata, after a remove() or a probe() failure.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 drivers/spi/spi.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 84c2861..fe636fe 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -233,15 +233,25 @@ EXPORT_SYMBOL_GPL(spi_bus_type);
 static int spi_drv_probe(struct device *dev)
 {
 	const struct spi_driver		*sdrv = to_spi_driver(dev->driver);
+	struct spi_device		*sdev = to_spi_device(dev);
+	int				status;
 
-	return sdrv->probe(to_spi_device(dev));
+	status = sdrv->probe(sdev);
+	if (status)
+		spi_set_drvdata(sdev, NULL);
+	return status;
 }
 
 static int spi_drv_remove(struct device *dev)
 {
 	const struct spi_driver		*sdrv = to_spi_driver(dev->driver);
+	struct spi_device		*sdev = to_spi_device(dev);
+	int				status;
 
-	return sdrv->remove(to_spi_device(dev));
+	status = sdrv->remove(sdev);
+	if (status == 0)
+		spi_set_drvdata(sdev, NULL);
+	return status;
 }
 
 static void spi_drv_shutdown(struct device *dev)
-- 
1.7.11.7

