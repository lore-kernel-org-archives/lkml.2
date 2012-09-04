Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab2IDPKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:10:54 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:34934 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478Ab2IDPKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:10:49 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 11:10:17 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkCAGIWRlBbdWObgWdsb2JhbABFhgW1JSIBARYmJ4IgAQEFIwQLAUYQIAUCJgICVwYTiBGne5JggSGQDIESA5VZkn8
X-IronPort-AV: E=Sophos;i="4.80,367,1344204000"; 
   d="scan'208";a="561821829"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 15/16] Staging: ipack: Expose modalias through sysfs.
Date: Tue,  4 Sep 2012 17:01:20 +0200
Message-Id: <1346770881-4723-16-git-send-email-siglesias@igalia.com>
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

Also include it in the hotplug event so that udev can
provide the respective driver.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index a328629..a5ef28f 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -86,6 +86,31 @@ static int ipack_bus_remove(struct device *device)
 	return 0;
 }
 
+#ifdef CONFIG_HOTPLUG
+
+static int ipack_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	struct ipack_device *idev;
+
+	if (!dev)
+		return -ENODEV;
+
+	idev = to_ipack_dev(dev);
+
+	if (add_uevent_var(env,
+			   "MODALIAS=ipack:f%02Xv%08Xd%08X", idev->id_format,
+			   idev->id_vendor, idev->id_device))
+		return -ENOMEM;
+
+	return 0;
+}
+
+#else /* !CONFIG_HOTPLUG */
+
+#define ipack_uevent NULL
+
+#endif /* !CONFIG_HOTPLUG */
+
 #define ipack_device_attr(field, format_string)				\
 static ssize_t								\
 field##_show(struct device *dev, struct device_attribute *attr,		\
@@ -123,12 +148,22 @@ id_device_show(struct device *dev, struct device_attribute *attr, char *buf)
 	}
 }
 
+static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct ipack_device *idev = to_ipack_dev(dev);
+
+	return sprintf(buf, "ipac:f%02Xv%08Xd%08X", idev->id_format,
+		       idev->id_vendor, idev->id_device);
+}
+
 ipack_device_attr(id_format, "0x%hhu\n");
 
 static struct device_attribute ipack_dev_attrs[] = {
 	__ATTR_RO(id_device),
 	__ATTR_RO(id_format),
 	__ATTR_RO(id_vendor),
+	__ATTR_RO(modalias),
 };
 
 static struct bus_type ipack_bus_type = {
@@ -137,6 +172,7 @@ static struct bus_type ipack_bus_type = {
 	.match     = ipack_bus_match,
 	.remove    = ipack_bus_remove,
 	.dev_attrs = ipack_dev_attrs,
+	.uevent	   = ipack_uevent,
 };
 
 struct ipack_bus_device *ipack_bus_register(struct device *parent, int slots,
-- 
1.7.10.4

