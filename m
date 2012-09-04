Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab2IDPNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:13:07 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:8843 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419Ab2IDPKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:10:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkCAGIWRlBbdWObgWdsb2JhbABFhgW1JSIBARYmJ4IgAQEFIwQLAUYQIAUCJgICVwYTiBGne5JggSGQDIESA5VZkn8
X-IronPort-AV: E=Sophos;i="4.80,367,1344204000"; 
   d="scan'208";a="561821821"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 09/16] Staging: ipack: Read the ID space during device registration.
Date: Tue,  4 Sep 2012 17:01:14 +0200
Message-Id: <1346770881-4723-10-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
References: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

We keep a copy of the ID space for later use.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.c |   80 +++++++++++++++++++++++++++++++++++++++++
 drivers/staging/ipack/ipack.h |    5 +++
 2 files changed, 85 insertions(+)

diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index c1cd97a..da9e7bd 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -22,6 +22,7 @@ static DEFINE_IDA(ipack_ida);
 static void ipack_device_release(struct device *dev)
 {
 	struct ipack_device *device = to_ipack_dev(dev);
+	kfree(device->id);
 	kfree(device);
 }
 
@@ -117,6 +118,77 @@ void ipack_driver_unregister(struct ipack_driver *edrv)
 }
 EXPORT_SYMBOL_GPL(ipack_driver_unregister);
 
+static int ipack_device_read_id(struct ipack_device *dev)
+{
+	u8 __iomem *idmem;
+	int i;
+	int ret = 0;
+
+	ret = dev->bus->ops->map_space(dev, 0, IPACK_ID_SPACE);
+	if (ret) {
+		dev_err(&dev->dev, "error mapping memory\n");
+		return ret;
+	}
+	idmem = dev->id_space.address;
+
+	/* Determine ID PROM Data Format.  If we find the ids "IPAC" or "IPAH"
+	 * we are dealing with a IndustryPack  format 1 device.  If we detect
+	 * "VITA4 " (16 bit big endian formatted) we are dealing with a
+	 * IndustryPack format 2 device */
+	if ((ioread8(idmem + 1) == 'I') &&
+			(ioread8(idmem + 3) == 'P') &&
+			(ioread8(idmem + 5) == 'A') &&
+			((ioread8(idmem + 7) == 'C') ||
+			 (ioread8(idmem + 7) == 'H'))) {
+		dev->id_format = IPACK_ID_VERSION_1;
+		dev->id_avail = ioread8(idmem + 0x15);
+		if ((dev->id_avail < 0x0c) || (dev->id_avail > 0x40)) {
+			dev_warn(&dev->dev, "invalid id size");
+			dev->id_avail = 0x0c;
+		}
+	} else if ((ioread8(idmem + 0) == 'I') &&
+			(ioread8(idmem + 1) == 'V') &&
+			(ioread8(idmem + 2) == 'A') &&
+			(ioread8(idmem + 3) == 'T') &&
+			(ioread8(idmem + 4) == ' ') &&
+			(ioread8(idmem + 5) == '4')) {
+		dev->id_format = IPACK_ID_VERSION_2;
+		dev->id_avail = ioread16be(idmem + 0x16);
+		if ((dev->id_avail < 0x1a) || (dev->id_avail > 0x40)) {
+			dev_warn(&dev->dev, "invalid id size");
+			dev->id_avail = 0x1a;
+		}
+	} else {
+		dev->id_format = IPACK_ID_VERSION_INVALID;
+		dev->id_avail = 0;
+	}
+
+	if (!dev->id_avail) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	/* Obtain the amount of memory required to store a copy of the complete
+	 * ID ROM contents */
+	dev->id = kmalloc(dev->id_avail, GFP_KERNEL);
+	if (!dev->id) {
+		dev_err(&dev->dev, "dev->id alloc failed.\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+	for (i = 0; i < dev->id_avail; i++) {
+		if (dev->id_format == IPACK_ID_VERSION_1)
+			dev->id[i] = ioread8(idmem + (i << 1) + 1);
+		else
+			dev->id[i] = ioread8(idmem + i);
+	}
+
+out:
+	dev->bus->ops->unmap_space(dev, IPACK_ID_SPACE);
+
+	return ret;
+}
+
 struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
 					   int slot, int irqv)
 {
@@ -137,8 +209,16 @@ struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
 	dev_set_name(&dev->dev,
 		     "ipack-dev.%u.%u", dev->bus_nr, dev->slot);
 
+	ret = ipack_device_read_id(dev);
+	if (ret < 0) {
+		dev_err(&dev->dev, "error reading device id section.\n");
+		kfree(dev);
+		return NULL;
+	}
+
 	ret = device_register(&dev->dev);
 	if (ret < 0) {
+		kfree(dev->id);
 		kfree(dev);
 		return NULL;
 	}
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index 703142d..2851e33 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -12,6 +12,8 @@
 #include <linux/mod_devicetable.h>
 #include <linux/device.h>
 
+#include "ipack_ids.h"
+
 #define IPACK_IDPROM_OFFSET_I			0x01
 #define IPACK_IDPROM_OFFSET_P			0x03
 #define IPACK_IDPROM_OFFSET_A			0x05
@@ -72,6 +74,9 @@ struct ipack_device {
 	struct ipack_addr_space io_space;
 	struct ipack_addr_space mem_space;
 	struct device dev;
+	unsigned char           *id;
+	size_t			 id_avail;
+	u8			 id_format;
 };
 
 /**
-- 
1.7.10.4

