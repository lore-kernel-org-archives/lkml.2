Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab1JRP3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:29:38 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:41203 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab1JRP3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:29:36 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Cc: linus.ml.walleij@gmail.com, zdevai@gmail.com, linux@arm.linux.org.uk,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 3/6] IIO:CORE add global list of registered IIO devices.
Date: Tue, 18 Oct 2011 16:29:33 +0100
Message-Id: <1318951776-19393-4-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1318951776-19393-1-git-send-email-jic23@cam.ac.uk>
References: <1318951776-19393-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed for inkernel interfaces.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/iio/iio.c       |    9 +++++++++
 include/linux/iio/iio.h |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/iio/iio.c b/drivers/iio/iio.c
index 9e6acc1..246a093 100644
--- a/drivers/iio/iio.c
+++ b/drivers/iio/iio.c
@@ -15,6 +15,9 @@
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
 
+static DEFINE_MUTEX(iio_device_list_lock);
+static LIST_HEAD(iio_device_list);
+
 static DEFINE_IDA(iio_ida);
 
 static struct bus_type iio_bus_type = {
@@ -91,6 +94,9 @@ static void iio_dev_release(struct device *device)
 {
 	struct iio_dev *indio_dev = container_of(device, struct iio_dev, dev);
 	iio_device_unregister_sysfs(indio_dev);
+	mutex_lock(&iio_device_list_lock);
+	list_del(&indio_dev->dev_list_entry);
+	mutex_unlock(&iio_device_list_lock);
 }
 
 static struct device_type iio_dev_type = {
@@ -559,6 +565,9 @@ int iio_device_register(struct iio_dev *indio_dev)
 	if (ret)
 		goto error_free_sysfs;
 
+	mutex_lock(&iio_device_list_lock);
+	list_add(&indio_dev->dev_list_entry, &iio_device_list);
+	mutex_unlock(&iio_device_list_lock);
 	return 0;
 
 error_free_sysfs:
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index beedc5c..f14e7dc 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -192,6 +192,7 @@ struct iio_info {
  * @info:		[DRIVER] callbacks and constant info from driver
  * @groups:		[INTERN] attribute groups
  * @groupcounter:	[INTERN] index of next attribute group
+ * @dev_list_entry:	[INTERN] entry in global list of iio devices
  **/
 struct iio_dev {
 	int				id;
-- 
1.7.7

