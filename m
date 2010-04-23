Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0DWV3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:29:13 -0400
Received: from tex.lwn.net ([70.33.254.29]:50567 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab0DWV2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:28:39 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 07/13] via: Do not attempt I/O on inactive I2C adapters
Date: Fri, 23 Apr 2010 15:28:07 -0600
Message-Id: <1272058093-20914-8-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272058093-20914-1-git-send-email-corbet@lwn.net>
References: <1272058093-20914-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an adapter has been configured for GPIO, we should not try to use it as
an I2C port.  Also fixed a stupid bug which might, in some configurations,
have resulted in a failure to set up ports.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via_i2c.c |   16 +++++++++++-----
 drivers/video/via/via_i2c.h |    1 +
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
index cabf574..dbb2392 100644
--- a/drivers/video/via/via_i2c.c
+++ b/drivers/video/via/via_i2c.c
@@ -117,6 +117,8 @@ int viafb_i2c_readbyte(u8 adap, u8 slave_addr, u8 index, u8 *pdata)
 	u8 mm1[] = {0x00};
 	struct i2c_msg msgs[2];
 
+	if (!via_i2c_par[adap].is_active)
+		return -ENODEV;
 	*pdata = 0;
 	msgs[0].flags = 0;
 	msgs[1].flags = I2C_M_RD;
@@ -132,6 +134,8 @@ int viafb_i2c_writebyte(u8 adap, u8 slave_addr, u8 index, u8 data)
 	u8 msg[2] = { index, data };
 	struct i2c_msg msgs;
 
+	if (!via_i2c_par[adap].is_active)
+		return -ENODEV;
 	msgs.flags = 0;
 	msgs.addr = slave_addr / 2;
 	msgs.len = 2;
@@ -144,6 +148,8 @@ int viafb_i2c_readbytes(u8 adap, u8 slave_addr, u8 index, u8 *buff, int buff_len
 	u8 mm1[] = {0x00};
 	struct i2c_msg msgs[2];
 
+	if (!via_i2c_par[adap].is_active)
+		return -ENODEV;
 	msgs[0].flags = 0;
 	msgs[1].flags = I2C_M_RD;
 	msgs[0].addr = msgs[1].addr = slave_addr / 2;
@@ -200,18 +206,18 @@ static int viafb_i2c_probe(struct platform_device *platdev)
 		struct via_port_cfg *adap_cfg = configs++;
 		struct via_i2c_stuff *i2c_stuff = &via_i2c_par[i];
 
+		i2c_stuff->is_active = 0;
 		if (adap_cfg->type == 0 || adap_cfg->mode != VIA_MODE_I2C)
-			break;
-
+			continue;
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
@@ -227,7 +233,7 @@ static int viafb_i2c_remove(struct platform_device *platdev)
 		 * Only remove those entries in the array that we've
 		 * actually used (and thus initialized algo_data)
 		 */
-		if (i2c_stuff->adapter.algo_data == &i2c_stuff->algo)
+		if (i2c_stuff->is_active)
 			i2c_del_adapter(&i2c_stuff->adapter);
 	}
 	return 0;
diff --git a/drivers/video/via/via_i2c.h b/drivers/video/via/via_i2c.h
index 5f9db66..da3a96a 100644
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

