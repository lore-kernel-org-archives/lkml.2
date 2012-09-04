Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab2IDPKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:10:49 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:8843 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433Ab2IDPKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:10:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkCAGIWRlBbdWObgWdsb2JhbABFhgW1JSIBARYmJ4IgAQEFIwQLAUYQIAUCJgICVwYTiBGne5JggSGQDIESA5VZkn8
X-IronPort-AV: E=Sophos;i="4.80,367,1344204000"; 
   d="scan'208";a="561821823"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 10/16] Staging: ipack: Parse vendor and device id.
Date: Tue,  4 Sep 2012 17:01:15 +0200
Message-Id: <1346770881-4723-11-git-send-email-siglesias@igalia.com>
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

Also expose the values through sysfs.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.c |   81 +++++++++++++++++++++++++++++++++++++++--
 drivers/staging/ipack/ipack.h |    4 +-
 2 files changed, 80 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index da9e7bd..9474226 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -63,11 +63,57 @@ static int ipack_bus_remove(struct device *device)
 	return 0;
 }
 
+#define ipack_device_attr(field, format_string)				\
+static ssize_t								\
+field##_show(struct device *dev, struct device_attribute *attr,		\
+		char *buf)						\
+{									\
+	struct ipack_device *idev = to_ipack_dev(dev);			\
+	return sprintf(buf, format_string, idev->field);		\
+}
+
+static ssize_t
+id_vendor_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct ipack_device *idev = to_ipack_dev(dev);
+	switch (idev->id_format) {
+	case IPACK_ID_VERSION_1:
+		return sprintf(buf, "0x%02x\n", idev->id_vendor);
+	case IPACK_ID_VERSION_2:
+		return sprintf(buf, "0x%06x\n", idev->id_vendor);
+	default:
+		return -EIO;
+	}
+}
+
+static ssize_t
+id_device_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct ipack_device *idev = to_ipack_dev(dev);
+	switch (idev->id_format) {
+	case IPACK_ID_VERSION_1:
+		return sprintf(buf, "0x%02x\n", idev->id_device);
+	case IPACK_ID_VERSION_2:
+		return sprintf(buf, "0x%04x\n", idev->id_device);
+	default:
+		return -EIO;
+	}
+}
+
+ipack_device_attr(id_format, "0x%hhu\n");
+
+static struct device_attribute ipack_dev_attrs[] = {
+	__ATTR_RO(id_device),
+	__ATTR_RO(id_format),
+	__ATTR_RO(id_vendor),
+};
+
 static struct bus_type ipack_bus_type = {
-	.name  = "ipack",
-	.probe = ipack_bus_probe,
-	.match = ipack_bus_match,
-	.remove = ipack_bus_remove,
+	.name      = "ipack",
+	.probe     = ipack_bus_probe,
+	.match     = ipack_bus_match,
+	.remove    = ipack_bus_remove,
+	.dev_attrs = ipack_dev_attrs,
 };
 
 struct ipack_bus_device *ipack_bus_register(struct device *parent, int slots,
@@ -118,6 +164,23 @@ void ipack_driver_unregister(struct ipack_driver *edrv)
 }
 EXPORT_SYMBOL_GPL(ipack_driver_unregister);
 
+static void ipack_parse_id1(struct ipack_device *dev)
+{
+	u8 *id = dev->id;
+
+	dev->id_vendor = id[4];
+	dev->id_device = id[5];
+}
+
+static void ipack_parse_id2(struct ipack_device *dev)
+{
+	__be16 *id = (__be16 *) dev->id;
+
+	dev->id_vendor = ((be16_to_cpu(id[3]) & 0xff) << 16)
+			 + be16_to_cpu(id[4]);
+	dev->id_device = be16_to_cpu(id[5]);
+}
+
 static int ipack_device_read_id(struct ipack_device *dev)
 {
 	u8 __iomem *idmem;
@@ -183,6 +246,16 @@ static int ipack_device_read_id(struct ipack_device *dev)
 			dev->id[i] = ioread8(idmem + i);
 	}
 
+	/* now we can finally work with the copy */
+	switch (dev->id_format) {
+	case IPACK_ID_VERSION_1:
+		ipack_parse_id1(dev);
+		break;
+	case IPACK_ID_VERSION_2:
+		ipack_parse_id2(dev);
+		break;
+	}
+
 out:
 	dev->bus->ops->unmap_space(dev, IPACK_ID_SPACE);
 
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index 2851e33..a3cd559 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -74,8 +74,10 @@ struct ipack_device {
 	struct ipack_addr_space io_space;
 	struct ipack_addr_space mem_space;
 	struct device dev;
-	unsigned char           *id;
+	u8                      *id;
 	size_t			 id_avail;
+	u32			 id_vendor;
+	u32			 id_device;
 	u8			 id_format;
 };
 
-- 
1.7.10.4

