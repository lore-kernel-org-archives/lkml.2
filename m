Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab2LCU2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:28:49 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:49642 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2LCU2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:28:48 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: spi-devel-general@lists.sourceforge.net
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH RESEND] spi: erase pointer to drvdata on removal
Date: Mon,  3 Dec 2012 15:28:24 -0500
Message-Id: <1354566504-17657-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, a SPI device may keep its drvdata whereas it was unbound
from its driver. This may result in accessing an invalid pointer.

As for i2c-core, let the SPI core handle the removal of the device's drvdata,
after a remove(), or a probe() failure.

This is a resent of the previous patch https://lkml.org/lkml/2012/11/1/314

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

