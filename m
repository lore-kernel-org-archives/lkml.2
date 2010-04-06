Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab0DFF74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 01:59:56 -0400
Received: from smtp.nokia.com ([192.100.122.233]:45477 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab0DFF7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 01:59:17 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [RESEND PATCH v2 3/6] lis3: Introduce platform data for second ff / wu unit
Date: Tue,  6 Apr 2010 08:58:42 +0300
Message-Id: <1270533525-15312-4-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1270533525-15312-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1270533525-15312-1-git-send-email-samu.p.onkalo@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Apr 2010 05:58:58.0585 (UTC) FILETIME=[3FAB8090:01CAD54E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8 bit device has two wakeup / free fall units. It was not possible
to configure the second unit. This patch introduces configuration
entry to the platform data and also corresponding changes to the
8 bit setup function.

High pass filters were enabled by default. Patch introduces configuration
option for high pass filter cut off frequency and also possibility to
disable or enable the filter via platform data.
Since the control is a new one and default state was filter enabled,
new option is used to disable the filter. This way old platform data
is still compatible with the change.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>
Tested-by: Daniel Mack <daniel@caiaq.de>
---
 drivers/hwmon/lis3lv02d.c |   15 +++++++++++++--
 include/linux/lis3lv02d.h |    9 +++++++++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 99fd45d..50f3123 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -524,6 +524,8 @@ EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
 static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
 				struct lis3lv02d_platform_data *p)
 {
+	int ctrl2 = p->hipass_ctrl;
+
 	if (p->click_flags) {
 		dev->write(dev, CLICK_CFG, p->click_flags);
 		dev->write(dev, CLICK_TIMELIMIT, p->click_time_limit);
@@ -540,9 +542,18 @@ static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
 		dev->write(dev, FF_WU_THS_1, p->wakeup_thresh & 0x7f);
 		/* default to 2.5ms for now */
 		dev->write(dev, FF_WU_DURATION_1, 1);
-		/* enable high pass filter for both free-fall units */
-		dev->write(dev, CTRL_REG2, HP_FF_WU1 | HP_FF_WU2);
+		ctrl2 ^= HP_FF_WU1; /* Xor to keep compatible with old pdata*/
+	}
+
+	if (p->wakeup_flags2) {
+		dev->write(dev, FF_WU_CFG_2, p->wakeup_flags2);
+		dev->write(dev, FF_WU_THS_2, p->wakeup_thresh2 & 0x7f);
+		/* default to 2.5ms for now */
+		dev->write(dev, FF_WU_DURATION_2, 1);
+		ctrl2 ^= HP_FF_WU2; /* Xor to keep compatible with old pdata*/
 	}
+	/* Configure hipass filters */
+	dev->write(dev, CTRL_REG2, ctrl2);
 }
 
 /*
diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
index f1ca0dc..d625199 100644
--- a/include/linux/lis3lv02d.h
+++ b/include/linux/lis3lv02d.h
@@ -43,6 +43,15 @@ struct lis3lv02d_platform_data {
 #define LIS3_WAKEUP_Z_HI	(1 << 5)
 	unsigned char wakeup_flags;
 	unsigned char wakeup_thresh;
+	unsigned char wakeup_flags2;
+	unsigned char wakeup_thresh2;
+#define LIS3_HIPASS_CUTFF_8HZ   0
+#define LIS3_HIPASS_CUTFF_4HZ   1
+#define LIS3_HIPASS_CUTFF_2HZ   2
+#define LIS3_HIPASS_CUTFF_1HZ   3
+#define LIS3_HIPASS1_DISABLE    (1 << 2)
+#define LIS3_HIPASS2_DISABLE    (1 << 3)
+	unsigned char hipass_ctrl;
 #define LIS3_NO_MAP		0
 #define LIS3_DEV_X		1
 #define LIS3_DEV_Y		2
-- 
1.6.0.4

