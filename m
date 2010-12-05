Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab0LERxc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:53:32 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab0LERv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:51:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C6XunyVS8hObrK5mvdl9UI0jXjGfQdHM6ML8mY23l+Q3/fHywRV4w8O4Q1rmpr9bld
         dGDGoKextre2dsoyFN9q/6sCyPHe59f7FNCdfBPqcWWtkhif4UpjofoayiZDuZdEdAJE
         o3aa+/16HTDd9Y5u6DlSfBGt2De4it9p8lXc4=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 38/45] kstrtox: convert drivers/rtc/
Date: Sun,  5 Dec 2010 19:49:35 +0200
Message-Id: <1291571382-2719-38-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
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
1.7.2.2

