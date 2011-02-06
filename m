Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab1BFTed (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:34:33 -0500
Received: from smtp-out-015.synserver.de ([212.40.185.15]:1149 "HELO
	smtp-out-014.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753885Ab1BFTec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:34:32 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24265
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 13/14] POWER: bq27x00: Cleanup bq27x00_i2c_read
Date: Sun,  6 Feb 2011 01:48:10 +0100
Message-Id: <1296953291-10373-14-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296953291-10373-1-git-send-email-lars@metafoo.de>
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some minor stylistic cleanups.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/bq27x00_battery.c |   45 ++++++++++++++++++++------------------
 1 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 83904a2..03d073c 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -558,36 +558,39 @@ static DEFINE_MUTEX(battery_mutex);
 static int bq27x00_read_i2c(struct bq27x00_device_info *di, u8 reg, bool single)
 {
 	struct i2c_client *client = to_i2c_client(di->dev);
-	struct i2c_msg msg[1];
+	struct i2c_msg msg;
 	unsigned char data[2];
 	int err, ret;
 
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
-	err = i2c_transfer(client->adapter, msg, 1);
+	err = i2c_transfer(client->adapter, &msg, 1);
+
+	if (err < 0)
+		return err;
+
+	if (single)
+		msg.len = 1;
+	else
+		msg.len = 2;
+
+	msg.flags = I2C_M_RD;
+	err = i2c_transfer(client->adapter, &msg, 1);
+	if (err < 0)
+		return err;
+
+	if (!single)
+		ret = get_unaligned_le16(data);
+	else
+		ret = data[0];
 
-	if (err >= 0) {
-		if (!single)
-			msg->len = 2;
-		else
-			msg->len = 1;
-
-		msg->flags = I2C_M_RD;
-		err = i2c_transfer(client->adapter, msg, 1);
-		if (err >= 0) {
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

