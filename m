Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab2IDPMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:12:19 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:34934 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab2IDPKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:10:44 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 11:10:17 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkCAGIWRlBbdWObgWdsb2JhbABFhgW1JSIBARYmJ4IgAQEFIwQLATQSECAFAiYCAlcGE4gRp3uSYIEhkAyBEgOVWZJ/
X-IronPort-AV: E=Sophos;i="4.80,367,1344204000"; 
   d="scan'208";a="561821827"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 14/16] Staging: ipack: Implement device matching on the bus level.
Date: Tue,  4 Sep 2012 17:01:19 +0200
Message-Id: <1346770881-4723-15-git-send-email-siglesias@igalia.com>
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

Devices are match based upon their vendor and device ids.  Since
the individual drivers provide a list of supported ids they do not
need to implement the matching themselves.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   24 +----------------
 drivers/staging/ipack/ipack.c           |   43 ++++++++++++++++++++++++-------
 drivers/staging/ipack/ipack.h           |    2 --
 3 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 829b887..c94a9df 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -777,27 +777,6 @@ static const struct tty_operations ipoctal_fops = {
 	.hangup =		ipoctal_hangup,
 };
 
-static int ipoctal_match(struct ipack_device *dev)
-{
-	int res;
-	unsigned char board_id;
-
-	if ((!dev->bus->ops) || (!dev->bus->ops->map_space) ||
-	    (!dev->bus->ops->unmap_space))
-		return 0;
-
-	res = dev->bus->ops->map_space(dev, 0, IPACK_ID_SPACE);
-	if (res)
-		return 0;
-
-	res = ipoctal_check_model(dev, &board_id);
-	dev->bus->ops->unmap_space(dev, IPACK_ID_SPACE);
-	if (!res)
-		return 1;
-
-	return 0;
-}
-
 static int ipoctal_probe(struct ipack_device *dev)
 {
 	int res;
@@ -858,8 +837,7 @@ static DEFINE_IPACK_DEVICE_TABLE(ipoctal_ids) = {
 MODULE_DEVICE_TABLE(ipack, ipoctal_ids);
 
 static const struct ipack_driver_ops ipoctal_drv_ops = {
-	.match = ipoctal_match,
-	.probe = ipoctal_probe,
+	.probe  = ipoctal_probe,
 	.remove = ipoctal_remove,
 };
 
diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index 9474226..a328629 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -26,20 +26,43 @@ static void ipack_device_release(struct device *dev)
 	kfree(device);
 }
 
-static int ipack_bus_match(struct device *device, struct device_driver *driver)
+static inline const struct ipack_device_id *
+ipack_match_one_device(const struct ipack_device_id *id,
+		       const struct ipack_device *device)
 {
-	int ret;
-	struct ipack_device *dev = to_ipack_dev(device);
-	struct ipack_driver *drv = to_ipack_driver(driver);
+	if ((id->format == IPACK_ANY_ID || id->format == device->id_format) &&
+	    (id->vendor == IPACK_ANY_ID || id->vendor == device->id_vendor) &&
+	    (id->device == IPACK_ANY_ID || id->device == device->id_device))
+		return id;
+	return NULL;
+}
 
-	if ((!drv->ops) || (!drv->ops->match))
-		return -EINVAL;
+static const struct ipack_device_id *
+ipack_match_id(const struct ipack_device_id *ids, struct ipack_device *idev)
+{
+	if (ids) {
+		while (ids->vendor || ids->device) {
+			if (ipack_match_one_device(ids, idev))
+				return ids;
+			ids++;
+		}
+	}
+	return NULL;
+}
 
-	ret = drv->ops->match(dev);
-	if (ret)
-		dev->driver = drv;
+static int ipack_bus_match(struct device *dev, struct device_driver *drv)
+{
+	struct ipack_device *idev = to_ipack_dev(dev);
+	struct ipack_driver *idrv = to_ipack_driver(drv);
+	const struct ipack_device_id *found_id;
 
-	return ret;
+	found_id = ipack_match_id(idrv->id_table, idev);
+	if (found_id) {
+		idev->driver = idrv;
+		return 1;
+	}
+
+	return 0;
 }
 
 static int ipack_bus_probe(struct device *device)
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index e6e38e7..0f482fd 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -84,13 +84,11 @@ struct ipack_device {
 /**
  *	struct ipack_driver_ops -- callbacks to mezzanine driver for installing/removing one device
  *
- *	@match: Match function
  *	@probe: Probe function
  *	@remove: tell the driver that the carrier board wants to remove one device
  */
 
 struct ipack_driver_ops {
-	int (*match) (struct ipack_device *dev);
 	int (*probe) (struct ipack_device *dev);
 	void (*remove) (struct ipack_device *dev);
 };
-- 
1.7.10.4

