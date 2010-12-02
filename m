Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab0LBKnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 05:43:45 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34257 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab0LBKnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 05:43:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Mm4YCCFHUv3/jPnqVQQx32g1uJ1i7jEJqyExwyNm0I6u/puhtLBoe3YqHQSl+56i20
         mELYch/XQKZw00w/H7Kgbn+NGuamnPI99u8nZmEar9HEZU7iir1iSb0Zg/T4BHSbSnbm
         p+zy2OG+R4WD3C0S7wx6rLatuznhl8MBNXxKM=
Subject: [PATCH v3] soc_camera: Add the ability to bind regulators to
 soc_camedra devices
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 11:43:37 +0100
Message-ID: <1291286617.3215.54.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In certain machines, camera devices are supplied directly
by a number of regulators. This patch add the ability to drive
these regulators directly by the soc_camera driver.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---

v2 changes:
It is used the more standard regulator_bulk API, thanks to
Mark Brown for pointing this.

v3 changes:
- Fixed errors addressed.
- Changed the behaviour of soc_camera_power_set: when powering
  off, the platform .power function have the priority because
  the manipulation of the camera status through gpios, make sense
  only if the camera is powered.

 drivers/media/video/soc_camera.c |   86 ++++++++++++++++++++++++++++---------
 include/media/soc_camera.h       |    5 ++
 2 files changed, 70 insertions(+), 21 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 43848a7..136e54f 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -24,6 +24,7 @@
 #include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 #include <linux/vmalloc.h>
@@ -43,6 +44,51 @@ static LIST_HEAD(hosts);
 static LIST_HEAD(devices);
 static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
 
+static int soc_camera_power_set(struct soc_camera_device *icd,
+				struct soc_camera_link *icl,
+				int power_on)
+{
+	int ret;
+
+	if (power_on) {
+		ret = regulator_bulk_enable(icl->num_regulators,
+					    icl->regulators);
+		if (ret < 0) {
+			dev_err(icd->pdev, "Cannot enable regulators\n");
+			return ret;
+		}
+
+		if (icl->power)
+			ret = icl->power(icd->pdev, power_on);
+		if (ret < 0) {
+			dev_err(icd->pdev,
+				"Platform failed to power-on the camera.\n");
+
+			regulator_bulk_disable(icl->num_regulators,
+					       icl->regulators);
+			return ret;
+		}
+	} else {
+		ret = 0;
+		if (icl->power)
+			ret = icl->power(icd->pdev, 0);
+		if (ret < 0) {
+			dev_err(icd->pdev,
+				"Platform failed to power-off the camera.\n");
+			return ret;
+		}
+
+		ret = regulator_bulk_disable(icl->num_regulators,
+					     icl->regulators);
+		if (ret < 0) {
+			dev_err(icd->pdev, "Cannot disable regulators\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc)
 {
@@ -375,11 +421,9 @@ static int soc_camera_open(struct file *file)
 			},
 		};
 
-		if (icl->power) {
-			ret = icl->power(icd->pdev, 1);
-			if (ret < 0)
-				goto epower;
-		}
+		ret = soc_camera_power_set(icd, icl, 1);
+		if (ret < 0)
+			goto epower;
 
 		/* The camera could have been already on, try to reset */
 		if (icl->reset)
@@ -425,8 +469,7 @@ esfmt:
 eresume:
 	ici->ops->remove(icd);
 eiciadd:
-	if (icl->power)
-		icl->power(icd->pdev, 0);
+	soc_camera_power_set(icd, icl, 0);
 epower:
 	icd->use_count--;
 	mutex_unlock(&icd->video_lock);
@@ -450,8 +493,7 @@ static int soc_camera_close(struct file *file)
 
 		ici->ops->remove(icd);
 
-		if (icl->power)
-			icl->power(icd->pdev, 0);
+		soc_camera_power_set(icd, icl, 0);
 	}
 
 	if (icd->streamer == file)
@@ -941,14 +983,14 @@ static int soc_camera_probe(struct device *dev)
 
 	dev_info(dev, "Probing %s\n", dev_name(dev));
 
-	if (icl->power) {
-		ret = icl->power(icd->pdev, 1);
-		if (ret < 0) {
-			dev_err(dev,
-				"Platform failed to power-on the camera.\n");
-			goto epower;
-		}
-	}
+	ret = regulator_bulk_get(icd->pdev, icl->num_regulators,
+				 icl->regulators);
+	if (ret < 0)
+		goto ereg;
+
+	ret = soc_camera_power_set(icd, icl, 1);
+	if (ret < 0)
+		goto epower;
 
 	/* The camera could have been already on, try to reset */
 	if (icl->reset)
@@ -1021,8 +1063,7 @@ static int soc_camera_probe(struct device *dev)
 
 	ici->ops->remove(icd);
 
-	if (icl->power)
-		icl->power(icd->pdev, 0);
+	soc_camera_power_set(icd, icl, 0);
 
 	mutex_unlock(&icd->video_lock);
 
@@ -1044,9 +1085,10 @@ eadddev:
 evdc:
 	ici->ops->remove(icd);
 eadd:
-	if (icl->power)
-		icl->power(icd->pdev, 0);
+	soc_camera_power_set(icd, icl, 0);
 epower:
+	regulator_bulk_free(icl->num_regulators, icl->regulators);
+ereg:
 	return ret;
 }
 
@@ -1081,6 +1123,8 @@ static int soc_camera_remove(struct device *dev)
 	}
 	soc_camera_free_user_formats(icd);
 
+	regulator_bulk_free(icl->num_regulators, icl->regulators);
+
 	return 0;
 }
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 86e3631..9386db8 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -97,6 +97,7 @@ struct soc_camera_host_ops {
 #define SOCAM_SENSOR_INVERT_DATA	(1 << 4)
 
 struct i2c_board_info;
+struct regulator_bulk_data;
 
 struct soc_camera_link {
 	/* Camera bus id, used to match a camera and a bus */
@@ -108,6 +109,10 @@ struct soc_camera_link {
 	const char *module_name;
 	void *priv;
 
+	/* Optional regulators that have to be managed on power on/off events */
+	struct regulator_bulk_data *regulators;
+	int num_regulators;
+
 	/*
 	 * For non-I2C devices platform platform has to provide methods to
 	 * add a device to the system and to remove
-- 
1.6.3.3


