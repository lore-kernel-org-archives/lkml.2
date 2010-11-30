Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab0K3RNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:13:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37637 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab0K3RNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:13:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=sOToXy78cZhDFAawu631GLc5O4M3VUY9XKtP675uKuJuTH1uQnCs0+BprOr0JSMsW2
         YDihQSAabMETzSZ00lFVYQRJEOH2mH2kyLhlq9ueFyXK+yOuYtPvgZ1XqGP7EfmWgEyR
         Z0zss7BTWueiSEmczZUITwo4rc9AGVzOpf+Ng=
Subject: [PATCH v2] soc_camera: Add the ability to bind regulators to
 soc_camedra devices
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 18:12:56 +0100
Message-ID: <1291137176.6537.20.camel@realization>
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

 drivers/media/video/soc_camera.c |   73 +++++++++++++++++++++++++++-----------
 include/media/soc_camera.h       |    5 +++
 2 files changed, 57 insertions(+), 21 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 43848a7..f1c2094 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -43,6 +43,41 @@ static LIST_HEAD(hosts);
 static LIST_HEAD(devices);
 static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
 
+static int soc_camera_power_set(struct soc_camera_device *icd,
+				struct soc_camera_link *icl,
+				int power_on)
+{
+	int ret = 0;
+
+	if (power_on) {
+		ret = regulator_bulk_enable(icl->num_regulators,
+					    icl->regulators);
+	} else {
+		ret = regulator_bulk_disable(icl->num_regulators,
+					     icl->regulators);
+	}
+	if (ret < 0) {
+		dev_err(icd->pdev, "Cannot %s regulators",
+			power_on ? "ENABLE" : "DISABLE");
+		goto err;
+	}
+
+	if (icl->power) {
+		ret = icl->power(icd->pdev, power_on);
+		if (ret < 0) {
+			dev_err(icd->pdev,
+				"Platform failed to power %s the camera.\n",
+				power_on ? "ON" : "OFF");
+			goto err;
+		}
+	}
+
+	return 0;
+
+err:
+	return ret;
+}
+
 const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc)
 {
@@ -375,11 +410,9 @@ static int soc_camera_open(struct file *file)
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
@@ -425,8 +458,7 @@ esfmt:
 eresume:
 	ici->ops->remove(icd);
 eiciadd:
-	if (icl->power)
-		icl->power(icd->pdev, 0);
+	soc_camera_power_set(icd, icl, 0);
 epower:
 	icd->use_count--;
 	mutex_unlock(&icd->video_lock);
@@ -450,8 +482,7 @@ static int soc_camera_close(struct file *file)
 
 		ici->ops->remove(icd);
 
-		if (icl->power)
-			icl->power(icd->pdev, 0);
+		soc_camera_power_set(icd, icl, 0);
 	}
 
 	if (icd->streamer == file)
@@ -941,14 +972,14 @@ static int soc_camera_probe(struct device *dev)
 
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
+	if (ret)
+		goto epower;
+
+	ret = soc_camera_power_set(icd, icl, 1);
+	if (ret < 0)
+		goto epower;
 
 	/* The camera could have been already on, try to reset */
 	if (icl->reset)
@@ -1021,8 +1052,7 @@ static int soc_camera_probe(struct device *dev)
 
 	ici->ops->remove(icd);
 
-	if (icl->power)
-		icl->power(icd->pdev, 0);
+	soc_camera_power_set(icd, icl, 0);
 
 	mutex_unlock(&icd->video_lock);
 
@@ -1044,8 +1074,7 @@ eadddev:
 evdc:
 	ici->ops->remove(icd);
 eadd:
-	if (icl->power)
-		icl->power(icd->pdev, 0);
+	soc_camera_power_set(icd, icl, 0);
 epower:
 	return ret;
 }
@@ -1081,6 +1110,8 @@ static int soc_camera_remove(struct device *dev)
 	}
 	soc_camera_free_user_formats(icd);
 
+	regulator_bulk_free(icl->num_regulators, icl->regulators);
+
 	return 0;
 }
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 86e3631..3e6b903 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -15,6 +15,7 @@
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/pm.h>
+#include <linux/regulator/consumer.h>
 #include <linux/videodev2.h>
 #include <media/videobuf-core.h>
 #include <media/v4l2-device.h>
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



