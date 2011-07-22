Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1GVDiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 23:38:05 -0400
Received: from lunge.queued.net ([173.255.254.236]:55527 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1GVDiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 23:38:04 -0400
Date: Thu, 21 Jul 2011 20:38:01 -0700
From: Andres Salomon <dilinger@queued.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org
Subject: [PATCH 3/3] staging: olpc_dcon: replace remaining calls to
 i2c_smbus_read/write
Message-ID: <20110721203801.5d3f5008@debxo>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dcon_read and dcon_write; shorter, and understands the dcon_priv
struct.  This transition was started long ago.  This converts the
last few i2c_smbus_* callers.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index ae18cd4..8726805 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -65,11 +65,10 @@ static s32 dcon_read(struct dcon_priv *dcon, u8 reg)
 
 static int dcon_hw_init(struct dcon_priv *dcon, int is_init)
 {
-	struct i2c_client *client = dcon->client;
 	uint16_t ver;
 	int rc = 0;
 
-	ver = i2c_smbus_read_word_data(client, DCON_REG_ID);
+	ver = dcon_read(dcon, DCON_REG_ID);
 	if ((ver >> 8) != 0xDC) {
 		printk(KERN_ERR "olpc-dcon:  DCON ID not 0xDCxx: 0x%04x "
 				"instead.\n", ver);
@@ -95,10 +94,10 @@ static int dcon_hw_init(struct dcon_priv *dcon, int is_init)
 	}
 
 	/* SDRAM setup/hold time */
-	i2c_smbus_write_word_data(client, 0x3a, 0xc040);
-	i2c_smbus_write_word_data(client, 0x41, 0x0000);
-	i2c_smbus_write_word_data(client, 0x41, 0x0101);
-	i2c_smbus_write_word_data(client, 0x42, 0x0101);
+	dcon_write(dcon, 0x3a, 0xc040);
+	dcon_write(dcon, 0x41, 0x0000);
+	dcon_write(dcon, 0x41, 0x0101);
+	dcon_write(dcon, 0x42, 0x0101);
 
 	/* Colour swizzle, AA, no passthrough, backlight */
 	if (is_init) {
@@ -107,11 +106,11 @@ static int dcon_hw_init(struct dcon_priv *dcon, int is_init)
 		if (useaa)
 			dcon->disp_mode |= MODE_COL_AA;
 	}
-	i2c_smbus_write_word_data(client, DCON_REG_MODE, dcon->disp_mode);
+	dcon_write(dcon, DCON_REG_MODE, dcon->disp_mode);
 
 
 	/* Set the scanline to interrupt on during resume */
-	i2c_smbus_write_word_data(client, DCON_REG_SCAN_INT, resumeline);
+	dcon_write(dcon, DCON_REG_SCAN_INT, resumeline);
 
 err:
 	return rc;
-- 
1.7.2.5

