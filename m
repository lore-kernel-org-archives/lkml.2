Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab1BKJUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 04:20:51 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45004 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab1BKJUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 04:20:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=p5ewqfW43QyqJaKxP8Pn1xwbx4QRGnGCA2fKitpV+TaJ5as0+0z3dLKw4D5TH0FHWq
         mOY/yTY5VhfFjw/8yN5x85bS97nqHvc91VRS1/AC7WMs3pJmMKDwDkWttC3e1P1i2Zuf
         vYZDBS8zNOTxKIQQ42kZN/JwyyAtBHUO9YWZY=
Subject: [PATCH] rtc: rtc-s3c: fix prototype for s3c_rtc_setaie()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ben@simtec.co.uk, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Content-Type: text/plain
Date: Fri, 11 Feb 2011 17:22:52 +0800
Message-Id: <1297416172.14816.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix s3c_rtc_setaie() prototype to eliminate below compile warning.
drivers/rtc/rtc-s3c.c:383: warning: initialization from incompatible pointer type

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/rtc/rtc-s3c.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index cf953ec..b80fa28 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -77,18 +77,20 @@ static irqreturn_t s3c_rtc_tickirq(int irq, void *id)
 }
 
 /* Update control registers */
-static void s3c_rtc_setaie(int to)
+static int s3c_rtc_setaie(struct device *dev, unsigned int enabled)
 {
 	unsigned int tmp;
 
-	pr_debug("%s: aie=%d\n", __func__, to);
+	pr_debug("%s: aie=%d\n", __func__, enabled);
 
 	tmp = readb(s3c_rtc_base + S3C2410_RTCALM) & ~S3C2410_RTCALM_ALMEN;
 
-	if (to)
+	if (enabled)
 		tmp |= S3C2410_RTCALM_ALMEN;
 
 	writeb(tmp, s3c_rtc_base + S3C2410_RTCALM);
+
+	return 0;
 }
 
 static int s3c_rtc_setpie(struct device *dev, int enabled)
@@ -308,7 +310,7 @@ static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	writeb(alrm_en, base + S3C2410_RTCALM);
 
-	s3c_rtc_setaie(alrm->enabled);
+	s3c_rtc_setaie(dev, alrm->enabled);
 
 	return 0;
 }
@@ -440,7 +442,7 @@ static int __devexit s3c_rtc_remove(struct platform_device *dev)
 	rtc_device_unregister(rtc);
 
 	s3c_rtc_setpie(&dev->dev, 0);
-	s3c_rtc_setaie(0);
+	s3c_rtc_setaie(&dev->dev, 0);
 
 	clk_disable(rtc_clk);
 	clk_put(rtc_clk);
-- 
1.7.2



