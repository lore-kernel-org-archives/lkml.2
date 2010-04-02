Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab0DBS7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:59:44 -0400
Received: from p01c12o148.mxlogic.net ([208.65.145.71]:51024 "EHLO
	p01c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0DBS7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:59:37 -0400
X-MXL-Hash: 4bb63e996e5109d4-115f54f721e62442b152aec0edfbacb3e94e89f6
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
CC: "a.zummo@towertech.it" <a.zummo@towertech.it>
Date: Fri, 2 Apr 2010 13:58:36 -0500
Subject: [PATCH] rtc-isl1208: use sysfs_{create/remove}_group
Thread-Topic: [PATCH] rtc-isl1208: use sysfs_{create/remove}_group
Thread-Index: AcrSloAW/nviLiixQHGdfW+b3u/KDA==
Message-ID: <0D753D10438DA54287A00B0270842697636A7E9AF5@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010040101)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=kh70NHw45aoA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=38uLcFpo6nJaFUi5eYvXHw==:17 a=i00gxMtYAAAA:8 a=f0l]
X-AnalysisOut: [4IOkHcRSJuoDl9WIA:9 a=Cg084sTKyuRbXsW7l8aWpPfT9Z4A:4 a=QEX]
X-AnalysisOut: [dDO2ut3YA:10 a=x1WnkoZAwusA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o32IxlmE032388

Instead of individually creating and removing the sysfs device
attribute files, wrap them in an attribute_group and use
sysfs_{create/remove}_group.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>

---

diff --git a/drivers/rtc/rtc-isl1208.c b/drivers/rtc/rtc-isl1208.c
index 054e052..468200c 100644
--- a/drivers/rtc/rtc-isl1208.c
+++ b/drivers/rtc/rtc-isl1208.c
@@ -462,39 +462,16 @@ isl1208_sysfs_store_usr(struct device *dev,
 static DEVICE_ATTR(usr, S_IRUGO | S_IWUSR, isl1208_sysfs_show_usr,
 		   isl1208_sysfs_store_usr);
 
-static int
-isl1208_sysfs_register(struct device *dev)
-{
-	int err;
-
-	err = device_create_file(dev, &dev_attr_atrim);
-	if (err)
-		return err;
-
-	err = device_create_file(dev, &dev_attr_dtrim);
-	if (err) {
-		device_remove_file(dev, &dev_attr_atrim);
-		return err;
-	}
-
-	err = device_create_file(dev, &dev_attr_usr);
-	if (err) {
-		device_remove_file(dev, &dev_attr_atrim);
-		device_remove_file(dev, &dev_attr_dtrim);
-	}
-
-	return 0;
-}
-
-static int
-isl1208_sysfs_unregister(struct device *dev)
-{
-	device_remove_file(dev, &dev_attr_dtrim);
-	device_remove_file(dev, &dev_attr_atrim);
-	device_remove_file(dev, &dev_attr_usr);
+static struct attribute *isl1208_rtc_attrs[] = {
+	&dev_attr_atrim.attr,
+	&dev_attr_dtrim.attr,
+	&dev_attr_usr.attr,
+	NULL
+};
 
-	return 0;
-}
+static const struct attribute_group isl1208_rtc_sysfs_files = {
+	.attrs	= isl1208_rtc_attrs,
+};
 
 static int
 isl1208_probe(struct i2c_client *client, const struct i2c_device_id *id)
@@ -529,7 +506,7 @@ isl1208_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		dev_warn(&client->dev, "rtc power failure detected, "
 			 "please set clock.\n");
 
-	rc = isl1208_sysfs_register(&client->dev);
+	rc = sysfs_create_group(&client->dev.kobj, &isl1208_rtc_sysfs_files);
 	if (rc)
 		goto exit_unregister;
 
@@ -546,7 +523,7 @@ isl1208_remove(struct i2c_client *client)
 {
 	struct rtc_device *rtc = i2c_get_clientdata(client);
 
-	isl1208_sysfs_unregister(&client->dev);
+	sysfs_remove_group(&client->dev.kobj, &isl1208_rtc_sysfs_files);
 	rtc_device_unregister(rtc);
 
 	return 0;
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
