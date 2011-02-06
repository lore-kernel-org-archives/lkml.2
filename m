Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1BFUDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:03:40 -0500
Received: from smtp-out-016.synserver.de ([212.40.185.16]:1133 "HELO
	smtp-out-014.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753928Ab1BFUDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:03:37 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24265
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 03/14] POWER: bq27x00: Fix current now property
Date: Sun,  6 Feb 2011 01:48:00 +0100
Message-Id: <1296953291-10373-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296953291-10373-1-git-send-email-lars@metafoo.de>
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pali Rohár <pali.rohar@gmail.com>

According to the bq27000 datasheet to obtain the current value in Micro-ampere
from the AI register it has to be transformed by the following formula:
    current = AI * 3570 / 20

This patch adjust the drivers code accordingly.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
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

