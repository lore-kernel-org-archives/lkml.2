Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab2IDPLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:11:20 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:34934 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab2IDPKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:10:47 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 11:10:17 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkCAGIWRlBbdWObgWdsb2JhbABFhgW1JSIBARYmJ4IgAQEFIwQLAUYQIAUCJgICVwYTiBGne5JggSGQDIESA5VZkn8
X-IronPort-AV: E=Sophos;i="4.80,367,1344204000"; 
   d="scan'208";a="561821831"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 16/16] Staging: ipack: Provide ID Prom through sysfs.
Date: Tue,  4 Sep 2012 17:01:21 +0200
Message-Id: <1346770881-4723-17-git-send-email-siglesias@igalia.com>
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

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index a5ef28f..ff907fa 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -120,6 +120,36 @@ field##_show(struct device *dev, struct device_attribute *attr,		\
 	return sprintf(buf, format_string, idev->field);		\
 }
 
+static ssize_t id_show(struct device *dev,
+		       struct device_attribute *attr, char *buf)
+{
+	unsigned int i, c, l, s;
+	struct ipack_device *idev = to_ipack_dev(dev);
+
+
+	switch (idev->id_format) {
+	case IPACK_ID_VERSION_1:
+		l = 0x7; s = 1; break;
+	case IPACK_ID_VERSION_2:
+		l = 0xf; s = 2; break;
+	default:
+		return -EIO;
+	}
+	c = 0;
+	for (i = 0; i < idev->id_avail; i++) {
+		if (i > 0) {
+			if ((i & l) == 0)
+				buf[c++] = '\n';
+			else if ((i & s) == 0)
+				buf[c++] = ' ';
+		}
+		sprintf(&buf[c], "%02x", idev->id[i]);
+		c += 2;
+	}
+	buf[c++] = '\n';
+	return c;
+}
+
 static ssize_t
 id_vendor_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -160,6 +190,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 ipack_device_attr(id_format, "0x%hhu\n");
 
 static struct device_attribute ipack_dev_attrs[] = {
+	__ATTR_RO(id),
 	__ATTR_RO(id_device),
 	__ATTR_RO(id_format),
 	__ATTR_RO(id_vendor),
-- 
1.7.10.4

