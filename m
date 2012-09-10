Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab2IJIyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:54:06 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:24804 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab2IJIu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:50:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8CAHGoTVBbdWObgWdsb2JhbABFhge1SiIBARYmJ4IgAQEFIwQLATQSECAFAiYCAlcGE4gUqBWSO4EhjxaBEgOVXYkziVI
X-IronPort-AV: E=Sophos;i="4.80,397,1344204000"; 
   d="scan'208";a="949262494"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 06/20] Staging: ipack: remove field driver from struct ipack_device.
Date: Mon, 10 Sep 2012 10:51:44 +0200
Message-Id: <1347267118-9580-6-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

After a successful match is found the driver field in struct device is
set by the core device code. We can use this field.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.c |   17 +++++++----------
 drivers/staging/ipack/ipack.h |    2 --
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index 6e0b441..4f3c945 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -58,32 +58,29 @@ static int ipack_bus_match(struct device *dev, struct device_driver *drv)
 	const struct ipack_device_id *found_id;
 
 	found_id = ipack_match_id(idrv->id_table, idev);
-	if (found_id) {
-		idev->driver = idrv;
-		return 1;
-	}
-
-	return 0;
+	return found_id ? 1 : 0;
 }
 
 static int ipack_bus_probe(struct device *device)
 {
 	struct ipack_device *dev = to_ipack_dev(device);
+	struct ipack_driver *drv = to_ipack_driver(device->driver);
 
-	if (!dev->driver->ops->probe)
+	if (!drv->ops->probe)
 		return -EINVAL;
 
-	return dev->driver->ops->probe(dev);
+	return drv->ops->probe(dev);
 }
 
 static int ipack_bus_remove(struct device *device)
 {
 	struct ipack_device *dev = to_ipack_dev(device);
+	struct ipack_driver *drv = to_ipack_driver(device->driver);
 
-	if (!dev->driver->ops->remove)
+	if (!drv->ops->remove)
 		return -EINVAL;
 
-	dev->driver->ops->remove(dev);
+	drv->ops->remove(dev);
 	return 0;
 }
 
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index cb77494..d3be8ba67 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -53,7 +53,6 @@ struct ipack_addr_space {
  *	@bus_nr: IP bus number where the device is plugged
  *	@slot: Slot where the device is plugged in the carrier board
  *	@irq: IRQ vector
- *	@driver: Pointer to the ipack_driver that manages the device
  *	@bus: ipack_bus_device where the device is plugged to.
  *	@id_space: Virtual address to ID space.
  *	@io_space: Virtual address to IO space.
@@ -68,7 +67,6 @@ struct ipack_device {
 	unsigned int bus_nr;
 	unsigned int slot;
 	unsigned int irq;
-	struct ipack_driver *driver;
 	struct ipack_bus_device *bus;
 	struct ipack_addr_space id_space;
 	struct ipack_addr_space io_space;
-- 
1.7.10.4

