Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab2F0NzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:55:04 -0400
Received: from mail-wg0-f74.google.com ([74.125.82.74]:58706 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab2F0NyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:54:22 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>
Cc: Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 3/8 v3] i2c: i801: check INTR after every transaction
Date: Wed, 27 Jun 2012 21:54:10 +0800
Message-Id: <1340805255-8041-4-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per ICH10 datasheet [1] pg. 711, after completing a block transaction,
INTR should be checked & cleared separately, only after BYTE_DONE is
first cleared:

  When the last byte of a block message is received, the host controller
sets DS. However, it does not set the INTR bit (and generate another
interrupt) until DS is cleared. Thus, for a block message of n bytes,
the ICH10 will generate n+1 interrupts.

[1] http://www.intel.com/content/dam/doc/datasheet/io-controller-hub-10-family-datasheet.pdf

Currently, the INTR bit was only checked & cleared separately if the PEC
was used.
This patch checks and clears INTR at the very end of every successful
transaction, regardless of whether the PEC is used.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/i2c/busses/i2c-i801.c |   46 ++++++++++++++++++++--------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 8b74e1e..6a53338 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -257,6 +257,24 @@ static int i801_check_post(struct i801_priv *priv, int status, int timeout)
 	return result;
 }
 
+/* wait for INTR bit as advised by Intel */
+static void i801_wait_intr(struct i801_priv *priv)
+{
+	int timeout = 0;
+	int status;
+
+	status = inb_p(SMBHSTSTS(priv));
+	while ((!(status & SMBHSTSTS_INTR)) && (timeout++ < MAX_RETRIES)) {
+		usleep_range(250, 500);
+		status = inb_p(SMBHSTSTS(priv));
+	}
+
+	if (timeout > MAX_RETRIES)
+		dev_dbg(&priv->pci_dev->dev, "INTR Timeout!\n");
+
+	outb_p(status, SMBHSTSTS(priv));
+}
+
 static int i801_transaction(struct i801_priv *priv, int xact)
 {
 	int status;
@@ -281,26 +299,9 @@ static int i801_transaction(struct i801_priv *priv, int xact)
 	if (result < 0)
 		return result;
 
-	outb_p(SMBHSTSTS_INTR, SMBHSTSTS(priv));
-	return 0;
-}
+	i801_wait_intr(priv);
 
-/* wait for INTR bit as advised by Intel */
-static void i801_wait_hwpec(struct i801_priv *priv)
-{
-	int timeout = 0;
-	int status;
-
-	status = inb_p(SMBHSTSTS(priv));
-	while ((!(status & SMBHSTSTS_INTR)) && (timeout++ < MAX_RETRIES)) {
-		usleep_range(250, 500);
-		status = inb_p(SMBHSTSTS(priv));
-	}
-
-	if (timeout > MAX_RETRIES)
-		dev_dbg(&priv->pci_dev->dev, "PEC Timeout!\n");
-
-	outb_p(status, SMBHSTSTS(priv));
+	return 0;
 }
 
 static int i801_block_transaction_by_block(struct i801_priv *priv,
@@ -416,9 +417,11 @@ static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
 			outb_p(data->block[i+1], SMBBLKDAT(priv));
 
 		/* signals SMBBLKDAT ready */
-		outb_p(SMBHSTSTS_BYTE_DONE | SMBHSTSTS_INTR, SMBHSTSTS(priv));
+		outb_p(SMBHSTSTS_BYTE_DONE, SMBHSTSTS(priv));
 	}
 
+	i801_wait_intr(priv);
+
 	return 0;
 }
 
@@ -474,9 +477,6 @@ static int i801_block_transaction(struct i801_priv *priv,
 							     read_write,
 							     command, hwpec);
 
-	if (result == 0 && hwpec)
-		i801_wait_hwpec(priv);
-
 	if (command == I2C_SMBUS_I2C_BLOCK_DATA
 	 && read_write == I2C_SMBUS_WRITE) {
 		/* restore saved configuration register value */
-- 
1.7.7.3

