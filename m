Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1FPNZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:25:26 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:53358 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1FPNZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:25:22 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH] i2c-isch: Add module parameter which actually set the clock divider
Date: Thu, 16 Jun 2011 15:24:38 +0200
Message-Id: <1308230678-28861-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was observed the Host Clock Divider was not written by the driver. It
was still set to (default) 0 which caused garbage on SMBus.
This driver adds 2 parameters which are used to calculate the divider
appropriately.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
 drivers/i2c/busses/i2c-isch.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-isch.c b/drivers/i2c/busses/i2c-isch.c
index 0682f8f..520bbd5 100644
--- a/drivers/i2c/busses/i2c-isch.c
+++ b/drivers/i2c/busses/i2c-isch.c
@@ -40,6 +40,7 @@
 /* SCH SMBus address offsets */
 #define SMBHSTCNT	(0 + sch_smba)
 #define SMBHSTSTS	(1 + sch_smba)
+#define SMBHSTCLK	(2 + sch_smba)
 #define SMBHSTADD	(4 + sch_smba) /* TSA */
 #define SMBHSTCMD	(5 + sch_smba)
 #define SMBHSTDAT0	(6 + sch_smba)
@@ -58,6 +59,8 @@
 
 static unsigned short sch_smba;
 static struct i2c_adapter sch_adapter;
+static int smbus_speed = 100; /* SMBus bus speed in Kbps */
+static int backbone_speed = 33000; /* backbone speed in KHz */
 
 /*
  * Start the i2c transaction -- the i2c_access will prepare the transaction
@@ -156,6 +159,9 @@ static s32 sch_access(struct i2c_adapter *adap, u16 addr,
 		dev_dbg(&sch_adapter.dev, "SMBus busy (%02x)\n", temp);
 		return -EAGAIN;
 	}
+	dev_dbg(&sch_adapter.dev, "access speed: %d KHz\n", smbus_speed);
+	outb((backbone_speed / 4) / smbus_speed, SMBHSTCLK);
+
 	dev_dbg(&sch_adapter.dev, "access size: %d %s\n", size,
 		(read_write)?"READ":"WRITE");
 	switch (size) {
@@ -323,3 +329,5 @@ MODULE_LICENSE("GPL");
 module_init(i2c_sch_init);
 module_exit(i2c_sch_exit);
 MODULE_ALIAS("platform:isch_smbus");
+module_param(smbus_speed, int, (S_IRUSR | S_IWUSR));
+module_param(backbone_speed, int, (S_IRUSR | S_IWUSR));
-- 
1.7.3.4

