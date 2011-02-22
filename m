Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab1BVGnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 01:43:04 -0500
Received: from smtp-out-090.synserver.de ([212.40.185.90]:1075 "EHLO
	smtp-out-090.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1BVGm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 01:42:58 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 18504
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Pali Rohar <pali.rohar@gmail.com>, Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v3 15/16] bq27x00: Cleanup bq27x00_i2c_read
Date: Tue, 22 Feb 2011 07:38:00 +0100
Message-Id: <1298356681-8317-16-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298356681-8317-1-git-send-email-lars@metafoo.de>
References: <1298356681-8317-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some minor stylistic cleanups.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Tested-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/power/bq27x00_battery.c |   45 ++++++++++++++++++++------------------
 1 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index b44555f..740a0ac 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -565,36 +565,39 @@ static DEFINE_MUTEX(battery_mutex);
 static int bq27x00_read_i2c(struct bq27x00_device_info *di, u8 reg, bool single)
 {
 	struct i2c_client *client = to_i2c_client(di->dev);
-	struct i2c_msg msg[1];
+	struct i2c_msg msg;
 	unsigned char data[2];
 	int ret;
 
 	if (!client->adapter)
 		return -ENODEV;
 
-	msg->addr = client->addr;
-	msg->flags = 0;
-	msg->len = 1;
-	msg->buf = data;
+	msg.addr = client->addr;
+	msg.flags = 0;
+	msg.len = 1;
+	msg.buf = data;
 
 	data[0] = reg;
-	ret = i2c_transfer(client->adapter, msg, 1);
+	ret = i2c_transfer(client->adapter, &msg, 1);
+
+	if (ret < 0)
+		return ret;
+
+	if (single)
+		msg.len = 1;
+	else
+		msg.len = 2;
+
+	msg.flags = I2C_M_RD;
+	ret = i2c_transfer(client->adapter, &msg, 1);
+	if (ret < 0)
+		return ret;
+
+	if (!single)
+		ret = get_unaligned_le16(data);
+	else
+		ret = data[0];
 
-	if (ret >= 0) {
-		if (!single)
-			msg->len = 2;
-		else
-			msg->len = 1;
-
-		msg->flags = I2C_M_RD;
-		ret = i2c_transfer(client->adapter, msg, 1);
-		if (ret >= 0) {
-			if (!single)
-				ret = get_unaligned_le16(data);
-			else
-				ret = data[0];
-		}
-	}
 	return ret;
 }
 
-- 
1.7.2.3

