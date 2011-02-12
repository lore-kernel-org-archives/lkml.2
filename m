Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1BLTkL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 14:40:11 -0500
Received: from smtp-out-246.synserver.de ([212.40.185.246]:1073 "HELO
	smtp-out-246.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752589Ab1BLTjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 14:39:36 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24377
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 03/14] bq27x00: Fix CURRENT_NOW property
Date: Sat, 12 Feb 2011 20:39:02 +0100
Message-Id: <1297539554-13957-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297539554-13957-1-git-send-email-lars@metafoo.de>
References: <1297539554-13957-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pali Rohár <pali.rohar@gmail.com>

According to the bq27000 datasheet the current should be calculated by
the following formula:
    current = AI * 3570 / 20

This patch adjust the drivers code accordingly.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/power/bq27x00_battery.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 4f74659..1b06134 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -44,6 +44,8 @@
 #define BQ27500_FLAG_DSC		BIT(0)
 #define BQ27500_FLAG_FC			BIT(9)
 
+#define BQ27000_RS			20 /* Resistor sense */
+
 /* If the system has several batteries we need a different name for each
  * of them...
  */
@@ -149,7 +151,7 @@ static int bq27x00_battery_current(struct bq27x00_device_info *di)
 
 	if (di->chip == BQ27500) {
 		/* bq27500 returns signed value */
-		curr = (int)(s16)curr;
+		curr = (int)((s16)curr) * 1000;
 	} else {
 		ret = bq27x00_read(BQ27x00_REG_FLAGS, &flags, 0, di);
 		if (ret < 0) {
@@ -160,9 +162,10 @@ static int bq27x00_battery_current(struct bq27x00_device_info *di)
 			dev_dbg(di->dev, "negative current!\n");
 			curr = -curr;
 		}
+		curr = curr * 3570 / BQ27000_RS;
 	}
 
-	return curr * 1000;
+	return curr;
 }
 
 /*
-- 
1.7.2.3

