Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab0D1WVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:21:20 -0400
Received: from tex.lwn.net ([70.33.254.29]:48836 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236Ab0D1WSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:18:21 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 18/30] via: Do not attempt I/O on inactive I2C adapters
Date: Wed, 28 Apr 2010 16:17:19 -0600
Message-Id: <1272493051-25380-19-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272493051-25380-1-git-send-email-corbet@lwn.net>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an adapter has been configured for GPIO (or off), we should not try to
use it as an I2C port.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via_i2c.c |   14 ++++++++++----
 drivers/video/via/via_i2c.h |    1 +
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
index 3ff60b2..c88450e 100644
--- a/drivers/video/via/via_i2c.c
+++ b/drivers/video/via/via_i2c.c
@@ -115,6 +115,8 @@ int viafb_i2c_readbyte(u8 adap, u8 slave_addr, u8 index, u8 *pdata)
 	u8 mm1[] = {0x00};
 	struct i2c_msg msgs[2];
 
+	if (!via_i2c_par[adap].is_active)
+		return -ENODEV;
 	*pdata = 0;
 	msgs[0].flags = 0;
 	msgs[1].flags = I2C_M_RD;
@@ -130,6 +132,8 @@ int viafb_i2c_writebyte(u8 adap, u8 slave_addr, u8 index, u8 data)
 	u8 msg[2] = { index, data };
 	struct i2c_msg msgs;
 
+	if (!via_i2c_par[adap].is_active)
+		return -ENODEV;
 	msgs.flags = 0;
 	msgs.addr = slave_addr / 2;
 	msgs.len = 2;
@@ -142,6 +146,8 @@ int viafb_i2c_readbytes(u8 adap, u8 slave_addr, u8 index, u8 *buff, int buff_len
 	u8 mm1[] = {0x00};
 	struct i2c_msg msgs[2];
 
+	if (!via_i2c_par[adap].is_active)
+		return -ENODEV;
 	msgs[0].flags = 0;
 	msgs[1].flags = I2C_M_RD;
 	msgs[0].addr = msgs[1].addr = slave_addr / 2;
@@ -198,18 +204,18 @@ static int viafb_i2c_probe(struct platform_device *platdev)
 		struct via_port_cfg *adap_cfg = configs++;
 		struct via_i2c_stuff *i2c_stuff = &via_i2c_par[i];
 
+		i2c_stuff->is_active = 0;
 		if (adap_cfg->type == 0 || adap_cfg->mode != VIA_MODE_I2C)
 			continue;
-
 		ret = create_i2c_bus(&i2c_stuff->adapter,
 				     &i2c_stuff->algo, adap_cfg,
 				NULL); /* FIXME: PCIDEV */
 		if (ret < 0) {
 			printk(KERN_ERR "viafb: cannot create i2c bus %u:%d\n",
 				i, ret);
-			/* FIXME: properly release previous busses */
-			return ret;
+			continue;  /* Still try to make the rest */
 		}
+		i2c_stuff->is_active = 1;
 	}
 
 	return 0;
@@ -225,7 +231,7 @@ static int viafb_i2c_remove(struct platform_device *platdev)
 		 * Only remove those entries in the array that we've
 		 * actually used (and thus initialized algo_data)
 		 */
-		if (i2c_stuff->adapter.algo_data == &i2c_stuff->algo)
+		if (i2c_stuff->is_active)
 			i2c_del_adapter(&i2c_stuff->adapter);
 	}
 	return 0;
diff --git a/drivers/video/via/via_i2c.h b/drivers/video/via/via_i2c.h
index b2332cc..1d18e7d 100644
--- a/drivers/video/via/via_i2c.h
+++ b/drivers/video/via/via_i2c.h
@@ -26,6 +26,7 @@
 
 struct via_i2c_stuff {
 	u16 i2c_port;			/* GPIO or I2C port */
+	u16 is_active;			/* Being used as I2C? */
 	struct i2c_adapter adapter;
 	struct i2c_algo_bit_data algo;
 };
-- 
1.7.0.1

