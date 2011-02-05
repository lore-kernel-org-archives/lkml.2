Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1BEOZu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:25:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54987 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab1BEOWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KXPIeevwRBPHD0gcA1cOQUsH6jXYz33i0/YzRYHyZSnhcM4+JEfsFKd8Kej2r9FzX3
         ZwSbgnPuGK+u4C+ExWhGj9p37EP0GERXcyMNN94FF1ox/3gF7zr/5NCqFnB/vD+FcaPO
         vozDfigSOUasqoz35dWIb/25djzZjbHJnD3Is=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 36/52] kstrtox: convert drivers/rtc/
Date: Sat,  5 Feb 2011 16:20:39 +0200
Message-Id: <1296915654-7458-36-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/rtc/rtc-pcf2123.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-pcf2123.c b/drivers/rtc/rtc-pcf2123.c
index 71bab0e..9e08179 100644
--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -87,13 +87,14 @@ static ssize_t pcf2123_show(struct device *dev, struct device_attribute *attr,
 	struct spi_device *spi = to_spi_device(dev);
 	struct pcf2123_sysfs_reg *r;
 	u8 txbuf[1], rxbuf[1];
-	unsigned long reg;
+	u8 reg;
 	int ret;
 
 	r = container_of(attr, struct pcf2123_sysfs_reg, attr);
 
-	if (strict_strtoul(r->name, 16, &reg))
-		return -EINVAL;
+	ret = kstrtou8(r->name, 16, &reg);
+	if (ret < 0)
+		return ret;
 
 	txbuf[0] = PCF2123_READ | reg;
 	ret = spi_write_then_read(spi, txbuf, 1, rxbuf, 1);
@@ -108,19 +109,17 @@ static ssize_t pcf2123_store(struct device *dev, struct device_attribute *attr,
 	struct spi_device *spi = to_spi_device(dev);
 	struct pcf2123_sysfs_reg *r;
 	u8 txbuf[2];
-	unsigned long reg;
-	unsigned long val;
-
 	int ret;
 
 	r = container_of(attr, struct pcf2123_sysfs_reg, attr);
 
-	if (strict_strtoul(r->name, 16, &reg)
-		|| strict_strtoul(buffer, 10, &val))
-		return -EINVAL;
-
-	txbuf[0] = PCF2123_WRITE | reg;
-	txbuf[1] = val;
+	ret = kstrtou8(r->name, 16, &txbuf[0]);
+	if (ret < 0)
+		return ret;
+	txbuf[0] |= PCF2123_WRITE;
+	ret = kstrtou8(buffer, 10, &txbuf[1]);
+	if (ret < 0)
+		return ret;
 	ret = spi_write(spi, txbuf, sizeof(txbuf));
 	if (ret < 0)
 		return -EIO;
-- 
1.7.3.4

