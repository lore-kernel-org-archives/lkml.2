Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab0D1WXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:23:17 -0400
Received: from tex.lwn.net ([70.33.254.29]:48833 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757171Ab0D1WSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:18:16 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 11/30] viafb: Only establish i2c busses on ports that always had them
Date: Wed, 28 Apr 2010 16:17:12 -0600
Message-Id: <1272493051-25380-12-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272493051-25380-1-git-send-email-corbet@lwn.net>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...otherwise it seems we run into conflicts with shadowy other users which
don't expect to see i2c taking control of ports it never used to do
anything with.

Reported-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via_i2c.c |   19 +++++++++++++------
 drivers/video/via/via_i2c.h |    1 +
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
index fe5535c..b5253e3 100644
--- a/drivers/video/via/via_i2c.c
+++ b/drivers/video/via/via_i2c.c
@@ -170,13 +170,18 @@ static int create_i2c_bus(struct i2c_adapter *adapter,
 	return i2c_bit_add_bus(adapter);
 }
 
+/*
+ * By default, we only activate busses on ports 2c and 31 to avoid
+ * conflicts with other possible users; that default can be changed
+ * below.
+ */
 static struct via_i2c_adap_cfg adap_configs[] = {
-	[VIA_I2C_ADAP_26]	= { VIA_I2C_I2C,  VIASR, 0x26 },
-	[VIA_I2C_ADAP_31]	= { VIA_I2C_I2C,  VIASR, 0x31 },
-	[VIA_I2C_ADAP_25]	= { VIA_I2C_GPIO, VIASR, 0x25 },
-	[VIA_I2C_ADAP_2C]	= { VIA_I2C_GPIO, VIASR, 0x2c },
-	[VIA_I2C_ADAP_3D]	= { VIA_I2C_GPIO, VIASR, 0x3d },
-	{ 0, 0, 0 }
+	[VIA_I2C_ADAP_26]	= { VIA_I2C_I2C,  VIASR, 0x26, 0 },
+	[VIA_I2C_ADAP_31]	= { VIA_I2C_I2C,  VIASR, 0x31, 1 },
+	[VIA_I2C_ADAP_25]	= { VIA_I2C_GPIO, VIASR, 0x25, 0 },
+	[VIA_I2C_ADAP_2C]	= { VIA_I2C_GPIO, VIASR, 0x2c, 1 },
+	[VIA_I2C_ADAP_3D]	= { VIA_I2C_GPIO, VIASR, 0x3d, 0 },
+	{ 0, 0, 0, 0 }
 };
 
 int viafb_create_i2c_busses(struct viafb_par *viapar)
@@ -189,6 +194,8 @@ int viafb_create_i2c_busses(struct viafb_par *viapar)
 
 		if (adap_cfg->type == 0)
 			break;
+		if (!adap_cfg->is_active)
+			continue;
 
 		ret = create_i2c_bus(&i2c_stuff->adapter,
 				     &i2c_stuff->algo, adap_cfg,
diff --git a/drivers/video/via/via_i2c.h b/drivers/video/via/via_i2c.h
index 00ed978..73d682f 100644
--- a/drivers/video/via/via_i2c.h
+++ b/drivers/video/via/via_i2c.h
@@ -35,6 +35,7 @@ struct via_i2c_adap_cfg {
 	enum via_i2c_type	type;
 	u_int16_t		io_port;
 	u_int8_t		ioport_index;
+	u8			is_active;
 };
 
 struct via_i2c_stuff {
-- 
1.7.0.1

