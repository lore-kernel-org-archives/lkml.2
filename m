Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab0DRSVy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 14:21:54 -0400
Received: from tex.lwn.net ([70.33.254.29]:35356 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757407Ab0DRSVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 14:21:36 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 10/11] viafb: rework the I2C support in the VIA framebuffer driver
Date: Sun, 18 Apr 2010 12:21:12 -0600
Message-Id: <1271614873-5952-11-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1271614873-5952-1-git-send-email-corbet@lwn.net>
References: <1271614873-5952-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Welte <laforge@gnumonks.org>

This patch changes the way how the various I2C busses are used internally
inside the viafb driver:  Previosuly, only a single i2c_adapter was created,
even though two different hardware I2C busses are accessed: A structure member
in a global variable was modified to indicate the bus to be used.

Now, all existing hardware busses are registered with the i2c core, and the
viafb_i2c_{read,write}byte[s]() function take the adapter number as function
call parameter, rather than referring to the global structure member.

[jc: even more painful merge with mainline changes ->2.6.34]
[jc: painful merge with OLPC changes]

Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: ScottFang@viatech.com.cn
Cc: JosephChan@via.com.tw
Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/dvi.c      |   35 ++++-----
 drivers/video/via/lcd.c      |   19 ++---
 drivers/video/via/via_i2c.c  |  171 ++++++++++++++++++++++++++----------------
 drivers/video/via/via_i2c.h  |   43 +++++++----
 drivers/video/via/viafbdev.c |    6 +-
 drivers/video/via/viafbdev.h |    4 +-
 drivers/video/via/vt1636.c   |   36 ++++-----
 drivers/video/via/vt1636.h   |    2 +-
 8 files changed, 182 insertions(+), 134 deletions(-)

diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index abe59b8..be51370 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -96,7 +96,7 @@ int viafb_tmds_trasmitter_identify(void)
 	viaparinfo->chip_info->tmds_chip_info.tmds_chip_name = VT1632_TMDS;
 	viaparinfo->chip_info->
 		tmds_chip_info.tmds_chip_slave_addr = VT1632_TMDS_I2C_ADDR;
-	viaparinfo->chip_info->tmds_chip_info.i2c_port = I2CPORTINDEX;
+	viaparinfo->chip_info->tmds_chip_info.i2c_port = VIA_I2C_ADAP_31;
 	if (check_tmds_chip(VT1632_DEVICE_ID_REG, VT1632_DEVICE_ID) != FAIL) {
 		/*
 		 * Currently only support 12bits,dual edge,add 24bits mode later
@@ -110,7 +110,7 @@ int viafb_tmds_trasmitter_identify(void)
 			  viaparinfo->chip_info->tmds_chip_info.i2c_port);
 		return OK;
 	} else {
-		viaparinfo->chip_info->tmds_chip_info.i2c_port = GPIOPORTINDEX;
+		viaparinfo->chip_info->tmds_chip_info.i2c_port = VIA_I2C_ADAP_2C;
 		if (check_tmds_chip(VT1632_DEVICE_ID_REG, VT1632_DEVICE_ID)
 		    != FAIL) {
 			tmds_register_write(0x08, 0x3b);
@@ -160,32 +160,26 @@ int viafb_tmds_trasmitter_identify(void)
 
 static void tmds_register_write(int index, u8 data)
 {
-	viaparinfo->shared->i2c_stuff.i2c_port =
-		viaparinfo->chip_info->tmds_chip_info.i2c_port;
-
-	viafb_i2c_writebyte(viaparinfo->chip_info->tmds_chip_info.
-		tmds_chip_slave_addr, index,
-		     data);
+	viafb_i2c_writebyte(viaparinfo->chip_info->tmds_chip_info.i2c_port,
+			    viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr,
+			    index, data);
 }
 
 static int tmds_register_read(int index)
 {
 	u8 data;
 
-	viaparinfo->shared->i2c_stuff.i2c_port =
-		viaparinfo->chip_info->tmds_chip_info.i2c_port;
-	viafb_i2c_readbyte((u8) viaparinfo->chip_info->
-	    tmds_chip_info.tmds_chip_slave_addr,
-			(u8) index, &data);
+	viafb_i2c_readbyte(viaparinfo->chip_info->tmds_chip_info.i2c_port,
+			   (u8) viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr,
+			   (u8) index, &data);
 	return data;
 }
 
 static int tmds_register_read_bytes(int index, u8 *buff, int buff_len)
 {
-	viaparinfo->shared->i2c_stuff.i2c_port =
-		viaparinfo->chip_info->tmds_chip_info.i2c_port;
-	viafb_i2c_readbytes((u8) viaparinfo->chip_info->tmds_chip_info.
-			 tmds_chip_slave_addr, (u8) index, buff, buff_len);
+	viafb_i2c_readbytes(viaparinfo->chip_info->tmds_chip_info.i2c_port,
+			    (u8) viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr,
+			    (u8) index, buff, buff_len);
 	return 0;
 }
 
@@ -541,9 +535,10 @@ void viafb_dvi_enable(void)
 				else
 					data = 0x37;
 				viafb_i2c_writebyte(viaparinfo->chip_info->
-					     tmds_chip_info.
-					     tmds_chip_slave_addr,
-					     0x08, data);
+						       tmds_chip_info.i2c_port,
+						    viaparinfo->chip_info->
+						       tmds_chip_info.tmds_chip_slave_addr,
+						    0x08, data);
 			}
 		}
 	}
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index ce3f4b6..98ae1c7 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -180,18 +180,16 @@ int viafb_lvds_trasmitter_identify(void)
 	if (machine_is_olpc())
 		return FAIL;
 
-	viaparinfo->shared->i2c_stuff.i2c_port = I2CPORTINDEX;
-	if (viafb_lvds_identify_vt1636()) {
-		viaparinfo->chip_info->lvds_chip_info.i2c_port = I2CPORTINDEX;
+	if (viafb_lvds_identify_vt1636(VIA_I2C_ADAP_31)) {
+		viaparinfo->chip_info->lvds_chip_info.i2c_port = VIA_I2C_ADAP_31;
 		DEBUG_MSG(KERN_INFO
-			  "Found VIA VT1636 LVDS on port i2c 0x31 \n");
+			  "Found VIA VT1636 LVDS on port i2c 0x31\n");
 	} else {
-		viaparinfo->shared->i2c_stuff.i2c_port = GPIOPORTINDEX;
-		if (viafb_lvds_identify_vt1636()) {
+		if (viafb_lvds_identify_vt1636(VIA_I2C_ADAP_26)) {
 			viaparinfo->chip_info->lvds_chip_info.i2c_port =
-				GPIOPORTINDEX;
+				VIA_I2C_ADAP_2C;
 			DEBUG_MSG(KERN_INFO
-				  "Found VIA VT1636 LVDS on port gpio 0x2c \n");
+				  "Found VIA VT1636 LVDS on port gpio 0x2c\n");
 		}
 	}
 
@@ -429,9 +427,8 @@ static int lvds_register_read(int index)
 {
 	u8 data;
 
-	viaparinfo->shared->i2c_stuff.i2c_port = GPIOPORTINDEX;
-	viafb_i2c_readbyte((u8) viaparinfo->chip_info->
-	    lvds_chip_info.lvds_chip_slave_addr,
+	viafb_i2c_readbyte(VIA_I2C_ADAP_2C,
+			(u8) viaparinfo->chip_info->lvds_chip_info.lvds_chip_slave_addr,
 			(u8) index, &data);
 	return data;
 }
diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
index 15543e9..8f8e0bf 100644
--- a/drivers/video/via/via_i2c.c
+++ b/drivers/video/via/via_i2c.c
@@ -1,5 +1,5 @@
 /*
- * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 1998-2009 VIA Technologies, Inc. All Rights Reserved.
  * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
 
  * This program is free software; you can redistribute it and/or
@@ -24,40 +24,44 @@
 static void via_i2c_setscl(void *data, int state)
 {
 	u8 val;
-	struct via_i2c_stuff *via_i2c_chan = (struct via_i2c_stuff *)data;
+	struct via_i2c_adap_cfg *adap_data = data;
 
-	val = viafb_read_reg(VIASR, via_i2c_chan->i2c_port) & 0xF0;
+	printk(KERN_DEBUG "reading index 0x%02x from IO 0x%x\n",
+		adap_data->ioport_index, adap_data->io_port);
+	val = viafb_read_reg(adap_data->io_port,
+			     adap_data->ioport_index) & 0xF0;
 	if (state)
 		val |= 0x20;
 	else
 		val &= ~0x20;
-	switch (via_i2c_chan->i2c_port) {
-	case I2CPORTINDEX:
+	switch (adap_data->type) {
+	case VIA_I2C_I2C:
 		val |= 0x01;
 		break;
-	case GPIOPORTINDEX:
+	case VIA_I2C_GPIO:
 		val |= 0x80;
 		break;
 	default:
-		DEBUG_MSG("via_i2c: specify wrong i2c port.\n");
+		DEBUG_MSG("viafb_i2c: specify wrong i2c type.\n");
 	}
-	viafb_write_reg(via_i2c_chan->i2c_port, VIASR, val);
+	viafb_write_reg(adap_data->ioport_index,
+			adap_data->io_port, val);
 }
 
 static int via_i2c_getscl(void *data)
 {
-	struct via_i2c_stuff *via_i2c_chan = (struct via_i2c_stuff *)data;
+	struct via_i2c_adap_cfg *adap_data = data;
 
-	if (viafb_read_reg(VIASR, via_i2c_chan->i2c_port) & 0x08)
+	if (viafb_read_reg(adap_data->io_port, adap_data->ioport_index) & 0x08)
 		return 1;
 	return 0;
 }
 
 static int via_i2c_getsda(void *data)
 {
-	struct via_i2c_stuff *via_i2c_chan = (struct via_i2c_stuff *)data;
+	struct via_i2c_adap_cfg *adap_data = data;
 
-	if (viafb_read_reg(VIASR, via_i2c_chan->i2c_port) & 0x04)
+	if (viafb_read_reg(adap_data->io_port, adap_data->ioport_index) & 0x04)
 		return 1;
 	return 0;
 }
@@ -65,27 +69,29 @@ static int via_i2c_getsda(void *data)
 static void via_i2c_setsda(void *data, int state)
 {
 	u8 val;
-	struct via_i2c_stuff *via_i2c_chan = (struct via_i2c_stuff *)data;
+	struct via_i2c_adap_cfg *adap_data = data;
 
-	val = viafb_read_reg(VIASR, via_i2c_chan->i2c_port) & 0xF0;
+	val = viafb_read_reg(adap_data->io_port,
+			     adap_data->ioport_index) & 0xF0;
 	if (state)
 		val |= 0x10;
 	else
 		val &= ~0x10;
-	switch (via_i2c_chan->i2c_port) {
-	case I2CPORTINDEX:
+	switch (adap_data->type) {
+	case VIA_I2C_I2C:
 		val |= 0x01;
 		break;
-	case GPIOPORTINDEX:
+	case VIA_I2C_GPIO:
 		val |= 0x40;
 		break;
 	default:
-		DEBUG_MSG("via_i2c: specify wrong i2c port.\n");
+		DEBUG_MSG("viafb_i2c: specify wrong i2c type.\n");
 	}
-	viafb_write_reg(via_i2c_chan->i2c_port, VIASR, val);
+	viafb_write_reg(adap_data->ioport_index,
+			adap_data->io_port, val);
 }
 
-int viafb_i2c_readbyte(u8 slave_addr, u8 index, u8 *pdata)
+int viafb_i2c_readbyte(u8 adap, u8 slave_addr, u8 index, u8 *pdata)
 {
 	u8 mm1[] = {0x00};
 	struct i2c_msg msgs[2];
@@ -97,12 +103,11 @@ int viafb_i2c_readbyte(u8 slave_addr, u8 index, u8 *pdata)
 	mm1[0] = index;
 	msgs[0].len = 1; msgs[1].len = 1;
 	msgs[0].buf = mm1; msgs[1].buf = pdata;
-	i2c_transfer(&viaparinfo->shared->i2c_stuff.adapter, msgs, 2);
-
-	return 0;
+	return i2c_transfer(&viaparinfo->shared->i2c_stuff[adap].adapter,
+			msgs, 2);
 }
 
-int viafb_i2c_writebyte(u8 slave_addr, u8 index, u8 data)
+int viafb_i2c_writebyte(u8 adap, u8 slave_addr, u8 index, u8 data)
 {
 	u8 msg[2] = { index, data };
 	struct i2c_msg msgs;
@@ -111,10 +116,11 @@ int viafb_i2c_writebyte(u8 slave_addr, u8 index, u8 data)
 	msgs.addr = slave_addr / 2;
 	msgs.len = 2;
 	msgs.buf = msg;
-	return i2c_transfer(&viaparinfo->shared->i2c_stuff.adapter, &msgs, 1);
+	return i2c_transfer(&viaparinfo->shared->i2c_stuff[adap].adapter,
+			&msgs, 1);
 }
 
-int viafb_i2c_readbytes(u8 slave_addr, u8 index, u8 *buff, int buff_len)
+int viafb_i2c_readbytes(u8 adap, u8 slave_addr, u8 index, u8 *buff, int buff_len)
 {
 	u8 mm1[] = {0x00};
 	struct i2c_msg msgs[2];
@@ -125,53 +131,88 @@ int viafb_i2c_readbytes(u8 slave_addr, u8 index, u8 *buff, int buff_len)
 	mm1[0] = index;
 	msgs[0].len = 1; msgs[1].len = buff_len;
 	msgs[0].buf = mm1; msgs[1].buf = buff;
-	i2c_transfer(&viaparinfo->shared->i2c_stuff.adapter, msgs, 2);
-	return 0;
+	return i2c_transfer(&viaparinfo->shared->i2c_stuff[adap].adapter,
+			msgs, 2);
 }
 
-int viafb_create_i2c_bus(void *viapar)
+static int create_i2c_bus(struct i2c_adapter *adapter,
+			  struct i2c_algo_bit_data *algo,
+			  struct via_i2c_adap_cfg *adap_cfg,
+			  struct pci_dev *pdev)
 {
-	int ret;
-	struct via_i2c_stuff *i2c_stuff =
-		&((struct viafb_par *)viapar)->shared->i2c_stuff;
-
-	strcpy(i2c_stuff->adapter.name, "via_i2c");
-	i2c_stuff->i2c_port = 0x0;
-	i2c_stuff->adapter.owner = THIS_MODULE;
-	i2c_stuff->adapter.id = 0x01FFFF;
-	i2c_stuff->adapter.class = 0;
-	i2c_stuff->adapter.algo_data = &i2c_stuff->algo;
-	i2c_stuff->adapter.dev.parent = NULL;
-	i2c_stuff->algo.setsda = via_i2c_setsda;
-	i2c_stuff->algo.setscl = via_i2c_setscl;
-	i2c_stuff->algo.getsda = via_i2c_getsda;
-	i2c_stuff->algo.getscl = via_i2c_getscl;
-	i2c_stuff->algo.udelay = 40;
-	i2c_stuff->algo.timeout = 20;
-	i2c_stuff->algo.data = i2c_stuff;
-
-	i2c_set_adapdata(&i2c_stuff->adapter, i2c_stuff);
+	printk(KERN_DEBUG "viafb: creating bus adap=0x%p, algo_bit_data=0x%p, adap_cfg=0x%p\n", adapter, algo, adap_cfg);
+
+	algo->setsda = via_i2c_setsda;
+	algo->setscl = via_i2c_setscl;
+	algo->getsda = via_i2c_getsda;
+	algo->getscl = via_i2c_getscl;
+	algo->udelay = 40;
+	algo->timeout = 20;
+	algo->data = adap_cfg;
+
+	sprintf(adapter->name, "viafb i2c io_port idx 0x%02x",
+		adap_cfg->ioport_index);
+	adapter->owner = THIS_MODULE;
+	adapter->id = 0x01FFFF;
+	adapter->class = I2C_CLASS_DDC;
+	adapter->algo_data = algo;
+	if (pdev)
+		adapter->dev.parent = &pdev->dev;
+	else
+		adapter->dev.parent = NULL;
+	/* i2c_set_adapdata(adapter, adap_cfg); */
 
 	/* Raise SCL and SDA */
-	i2c_stuff->i2c_port = I2CPORTINDEX;
-	via_i2c_setsda(i2c_stuff, 1);
-	via_i2c_setscl(i2c_stuff, 1);
-
-	i2c_stuff->i2c_port = GPIOPORTINDEX;
-	via_i2c_setsda(i2c_stuff, 1);
-	via_i2c_setscl(i2c_stuff, 1);
+	via_i2c_setsda(adap_cfg, 1);
+	via_i2c_setscl(adap_cfg, 1);
 	udelay(20);
 
-	ret = i2c_bit_add_bus(&i2c_stuff->adapter);
-	if (ret == 0)
-		DEBUG_MSG("I2C bus %s registered.\n", i2c_stuff->adapter.name);
-	else
-		DEBUG_MSG("Failed to register I2C bus %s.\n",
-			i2c_stuff->adapter.name);
-	return ret;
+	return i2c_bit_add_bus(adapter);
+}
+
+static struct via_i2c_adap_cfg adap_configs[] = {
+	[VIA_I2C_ADAP_26]	= { VIA_I2C_I2C,  VIASR, 0x26 },
+	[VIA_I2C_ADAP_31]	= { VIA_I2C_I2C,  VIASR, 0x31 },
+	[VIA_I2C_ADAP_25]	= { VIA_I2C_GPIO, VIASR, 0x25 },
+	[VIA_I2C_ADAP_2C]	= { VIA_I2C_GPIO, VIASR, 0x2c },
+	[VIA_I2C_ADAP_3D]	= { VIA_I2C_GPIO, VIASR, 0x3d },
+	{ 0, 0, 0 }
+};
+
+int viafb_create_i2c_busses(struct viafb_par *viapar)
+{
+	int i, ret;
+
+	for (i = 0; i < VIAFB_NUM_I2C; i++) {
+		struct via_i2c_adap_cfg *adap_cfg = &adap_configs[i];
+		struct via_i2c_stuff *i2c_stuff = &viapar->shared->i2c_stuff[i];
+
+		if (adap_cfg->type == 0)
+			break;
+
+		ret = create_i2c_bus(&i2c_stuff->adapter,
+				     &i2c_stuff->algo, adap_cfg,
+				NULL); /* FIXME: PCIDEV */
+		if (ret < 0) {
+			printk(KERN_ERR "viafb: cannot create i2c bus %u:%d\n",
+				i, ret);
+			/* FIXME: properly release previous busses */
+			return ret;
+		}
+	}
+
+	return 0;
 }
 
-void viafb_delete_i2c_buss(void *par)
+void viafb_delete_i2c_busses(struct viafb_par *par)
 {
-	i2c_del_adapter(&((struct viafb_par *)par)->shared->i2c_stuff.adapter);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(par->shared->i2c_stuff); i++) {
+		struct via_i2c_stuff *i2c_stuff = &par->shared->i2c_stuff[i];
+		/* only remove those entries in the array that we've
+		 * actually used (and thus initialized algo_data) */
+		if (i2c_stuff->adapter.algo_data == &i2c_stuff->algo)
+			i2c_del_adapter(&i2c_stuff->adapter);
+	}
 }
diff --git a/drivers/video/via/via_i2c.h b/drivers/video/via/via_i2c.h
index 3a13242..00ed978 100644
--- a/drivers/video/via/via_i2c.h
+++ b/drivers/video/via/via_i2c.h
@@ -1,5 +1,5 @@
 /*
- * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 1998-2009 VIA Technologies, Inc. All Rights Reserved.
  * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
 
  * This program is free software; you can redistribute it and/or
@@ -24,23 +24,38 @@
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 
+enum via_i2c_type {
+	VIA_I2C_NONE,
+	VIA_I2C_I2C,
+	VIA_I2C_GPIO,
+};
+
+/* private data for each adapter */
+struct via_i2c_adap_cfg {
+	enum via_i2c_type	type;
+	u_int16_t		io_port;
+	u_int8_t		ioport_index;
+};
+
 struct via_i2c_stuff {
 	u16 i2c_port;			/* GPIO or I2C port */
 	struct i2c_adapter adapter;
 	struct i2c_algo_bit_data algo;
 };
 
-#define I2CPORT           0x3c4
-#define I2CPORTINDEX      0x31
-#define GPIOPORT          0x3C4
-#define GPIOPORTINDEX     0x2C
-#define I2C_BUS             1
-#define GPIO_BUS            2
-#define DELAYPORT           0x3C3
-
-int viafb_i2c_readbyte(u8 slave_addr, u8 index, u8 *pdata);
-int viafb_i2c_writebyte(u8 slave_addr, u8 index, u8 data);
-int viafb_i2c_readbytes(u8 slave_addr, u8 index, u8 *buff, int buff_len);
-int viafb_create_i2c_bus(void *par);
-void viafb_delete_i2c_buss(void *par);
+enum viafb_i2c_adap {
+	VIA_I2C_ADAP_26,
+	VIA_I2C_ADAP_31,
+	VIA_I2C_ADAP_25,
+	VIA_I2C_ADAP_2C,
+	VIA_I2C_ADAP_3D,
+};
+
+int viafb_i2c_readbyte(u8 adap, u8 slave_addr, u8 index, u8 *pdata);
+int viafb_i2c_writebyte(u8 adap, u8 slave_addr, u8 index, u8 data);
+int viafb_i2c_readbytes(u8 adap, u8 slave_addr, u8 index, u8 *buff, int buff_len);
+
+struct viafb_par;
+int viafb_create_i2c_busses(struct viafb_par *par);
+void viafb_delete_i2c_busses(struct viafb_par *par);
 #endif /* __VIA_I2C_H__ */
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 8955ab4..fa10049 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1775,7 +1775,7 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 		viafb_dual_fb = 0;
 
 	/* Set up I2C bus stuff */
-	rc = viafb_create_i2c_bus(viaparinfo);
+	rc = viafb_create_i2c_busses(viaparinfo);
 	if (rc)
 		goto out_fb_release;
 
@@ -1964,7 +1964,7 @@ out_fb1_release:
 out_unmap_screen:
 	iounmap(viafbinfo->screen_base);
 out_delete_i2c:
-	viafb_delete_i2c_buss(viaparinfo);
+	viafb_delete_i2c_busses(viaparinfo);
 out_fb_release:
 	framebuffer_release(viafbinfo);
 	return rc;
@@ -1980,7 +1980,7 @@ static void __devexit via_pci_remove(struct pci_dev *pdev)
 	iounmap((void *)viafbinfo->screen_base);
 	iounmap(viaparinfo->shared->engine_mmio);
 
-	viafb_delete_i2c_buss(viaparinfo);
+	viafb_delete_i2c_busses(viaparinfo);
 
 	framebuffer_release(viafbinfo);
 	if (viafb_dual_fb)
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index 61b5953..4bc00ec 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -37,11 +37,13 @@
 #define VERSION_OS          0	/* 0: for 32 bits OS, 1: for 64 bits OS */
 #define VERSION_MINOR       4
 
+#define VIAFB_NUM_I2C		5
+
 struct viafb_shared {
 	struct proc_dir_entry *proc_entry;	/*viafb proc entry */
 
 	/* I2C stuff */
-	struct via_i2c_stuff i2c_stuff;
+	struct via_i2c_stuff i2c_stuff[VIAFB_NUM_I2C];
 
 	/* All the information will be needed to set engine */
 	struct tmds_setting_information tmds_setting_info;
diff --git a/drivers/video/via/vt1636.c b/drivers/video/via/vt1636.c
index a6b3749..4589c6e 100644
--- a/drivers/video/via/vt1636.c
+++ b/drivers/video/via/vt1636.c
@@ -27,9 +27,8 @@ u8 viafb_gpio_i2c_read_lvds(struct lvds_setting_information
 {
 	u8 data;
 
-	viaparinfo->shared->i2c_stuff.i2c_port = plvds_chip_info->i2c_port;
-	viafb_i2c_readbyte(plvds_chip_info->lvds_chip_slave_addr, index, &data);
-
+	viafb_i2c_readbyte(plvds_chip_info->i2c_port,
+			   plvds_chip_info->lvds_chip_slave_addr, index, &data);
 	return data;
 }
 
@@ -39,14 +38,13 @@ void viafb_gpio_i2c_write_mask_lvds(struct lvds_setting_information
 {
 	int index, data;
 
-	viaparinfo->shared->i2c_stuff.i2c_port = plvds_chip_info->i2c_port;
-
 	index = io_data.Index;
 	data = viafb_gpio_i2c_read_lvds(plvds_setting_info, plvds_chip_info,
 		index);
 	data = (data & (~io_data.Mask)) | io_data.Data;
 
-	viafb_i2c_writebyte(plvds_chip_info->lvds_chip_slave_addr, index, data);
+	viafb_i2c_writebyte(plvds_chip_info->i2c_port,
+			    plvds_chip_info->lvds_chip_slave_addr, index, data);
 }
 
 void viafb_init_lvds_vt1636(struct lvds_setting_information
@@ -159,7 +157,7 @@ void viafb_disable_lvds_vt1636(struct lvds_setting_information
 	}
 }
 
-bool viafb_lvds_identify_vt1636(void)
+bool viafb_lvds_identify_vt1636(u8 i2c_adapter)
 {
 	u8 Buffer[2];
 
@@ -170,23 +168,23 @@ bool viafb_lvds_identify_vt1636(void)
 	VT1636_LVDS_I2C_ADDR;
 
 	/* Check vendor ID first: */
-	viafb_i2c_readbyte((u8) viaparinfo->chip_info->lvds_chip_info.
-	lvds_chip_slave_addr,
-		    0x00, &Buffer[0]);
-	viafb_i2c_readbyte((u8) viaparinfo->chip_info->lvds_chip_info.
-		lvds_chip_slave_addr,
-		    0x01, &Buffer[1]);
+	viafb_i2c_readbyte(i2c_adapter,
+			   (u8) viaparinfo->chip_info->lvds_chip_info.lvds_chip_slave_addr,
+			   0x00, &Buffer[0]);
+	viafb_i2c_readbyte(i2c_adapter,
+			   (u8) viaparinfo->chip_info->lvds_chip_info.lvds_chip_slave_addr,
+			   0x01, &Buffer[1]);
 
 	if (!((Buffer[0] == 0x06) && (Buffer[1] == 0x11)))
 		return false;
 
 	/* Check Chip ID: */
-	viafb_i2c_readbyte((u8) viaparinfo->chip_info->lvds_chip_info.
-	lvds_chip_slave_addr,
-		    0x02, &Buffer[0]);
-	viafb_i2c_readbyte((u8) viaparinfo->chip_info->lvds_chip_info.
-		lvds_chip_slave_addr,
-		    0x03, &Buffer[1]);
+	viafb_i2c_readbyte(i2c_adapter,
+			   (u8) viaparinfo->chip_info->lvds_chip_info.lvds_chip_slave_addr,
+			   0x02, &Buffer[0]);
+	viafb_i2c_readbyte(i2c_adapter,
+			   (u8) viaparinfo->chip_info->lvds_chip_info.lvds_chip_slave_addr,
+			   0x03, &Buffer[1]);
 	if ((Buffer[0] == 0x45) && (Buffer[1] == 0x33)) {
 		viaparinfo->chip_info->lvds_chip_info.lvds_chip_name =
 			VT1636_LVDS;
diff --git a/drivers/video/via/vt1636.h b/drivers/video/via/vt1636.h
index 2a150c5..4c1314e 100644
--- a/drivers/video/via/vt1636.h
+++ b/drivers/video/via/vt1636.h
@@ -22,7 +22,7 @@
 #ifndef _VT1636_H_
 #define _VT1636_H_
 #include "chip.h"
-bool viafb_lvds_identify_vt1636(void);
+bool viafb_lvds_identify_vt1636(u8 i2c_adapter);
 void viafb_init_lvds_vt1636(struct lvds_setting_information
 	*plvds_setting_info, struct lvds_chip_information *plvds_chip_info);
 void viafb_enable_lvds_vt1636(struct lvds_setting_information
-- 
1.7.0.1

