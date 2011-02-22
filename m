Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab1BVGnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 01:43:05 -0500
Received: from smtp-out-090.synserver.de ([212.40.185.90]:1102 "EHLO
	smtp-out-090.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab1BVGnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 01:43:01 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 18504
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Pali Rohar <pali.rohar@gmail.com>, Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v3 16/16] bq27x00: Use single i2c_transfer call for property read
Date: Tue, 22 Feb 2011 07:38:01 +0100
Message-Id: <1298356681-8317-17-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298356681-8317-1-git-send-email-lars@metafoo.de>
References: <1298356681-8317-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grazvydas Ignotas <notasas@gmail.com>

Doing this by using 2 calls sometimes results in unexpected
values being returned on OMAP3 i2c controller.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/bq27x00_battery.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 740a0ac..59e68db 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -565,31 +565,26 @@ static DEFINE_MUTEX(battery_mutex);
 static int bq27x00_read_i2c(struct bq27x00_device_info *di, u8 reg, bool single)
 {
 	struct i2c_client *client = to_i2c_client(di->dev);
-	struct i2c_msg msg;
+	struct i2c_msg msg[2];
 	unsigned char data[2];
 	int ret;
 
 	if (!client->adapter)
 		return -ENODEV;
 
-	msg.addr = client->addr;
-	msg.flags = 0;
-	msg.len = 1;
-	msg.buf = data;
-
-	data[0] = reg;
-	ret = i2c_transfer(client->adapter, &msg, 1);
-
-	if (ret < 0)
-		return ret;
-
+	msg[0].addr = client->addr;
+	msg[0].flags = 0;
+	msg[0].buf = &reg;
+	msg[0].len = sizeof(reg);
+	msg[1].addr = client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].buf = data;
 	if (single)
-		msg.len = 1;
+		msg[1].len = 1;
 	else
-		msg.len = 2;
+		msg[1].len = 2;
 
-	msg.flags = I2C_M_RD;
-	ret = i2c_transfer(client->adapter, &msg, 1);
+	ret = i2c_transfer(client->adapter, msg, ARRAY_SIZE(msg));
 	if (ret < 0)
 		return ret;
 
-- 
1.7.2.3

