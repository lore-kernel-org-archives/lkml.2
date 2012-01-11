Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115Ab2AKWWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 17:22:11 -0500
Received: from mail5.aviatnet.com ([192.147.115.32]:8388 "EHLO
	mail5.aviatnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758174Ab2AKWWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 17:22:07 -0500
Subject: Re: [PATCH v3] rtc: ds1307: generalise ram size and offset
From: Austin Boyle <Austin.Boyle@aviatnet.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20120111110650.GC2605@pengutronix.de>
References: <1326144071.3096.25.camel@pc786-ubu.gnet.global.vpn>
	 <20120111110650.GC2605@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Jan 2012 11:21:56 +1300
Message-ID: <1326320516.3096.64.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.1.193]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Thanks for reviewing the patch.

> I think the stuff related to 'offset' should be in a separate patch with
> specific commit-msg.
Agreed. I will submit a separate patch after this one.

---

This patch generalises NVRAM to support RAM with other size and offset, such
as the 64 bytes of SRAM on the mcp7941x.

Signed-off-by: Austin Boyle <Austin.Boyle@aviatnet.com>
---
this patch is based on Wolfram Sang's tree:
git://git.pengutronix.de/git/wsa/linux-2.6.git ds1307

patch depends on:
rtc: ds1307: comment and format cleanup 21af5f7bd6
rtc: ds1307: simplify irq setup code  8c63e03627
rtc: ds1307: refactor chip_desc table e246db081d
rtc: add initial support for mcp7941x parts e69bba2d3a

--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -105,6 +105,8 @@ enum ds_type {
 struct ds1307 {
 	u8			offset; /* register's offset */
 	u8			regs[11];
+	u16			nvram_offset;
+	u16			nvram_size;
 	enum ds_type		type;
 	unsigned long		flags;
 #define HAS_NVRAM	0		/* bit 0 == sysfs file active */
@@ -119,19 +121,22 @@ struct ds1307 {
 };
 
 struct chip_desc {
-	unsigned		nvram56:1;
 	unsigned		alarm:1;
+	u16			nvram_offset;
+	u16			nvram_size;
 };
 
 static const struct chip_desc chips[last_ds_type] = {
 	[ds_1307] = {
-		.nvram56	= 1,
+		.nvram_offset	= 8,
+		.nvram_size	= 56,
 	},
 	[ds_1337] = {
 		.alarm		= 1,
 	},
 	[ds_1338] = {
-		.nvram56	= 1,
+		.nvram_offset	= 8,
+		.nvram_size	= 56,
 	},
 	[ds_1339] = {
 		.alarm		= 1,
@@ -139,6 +144,11 @@ static const struct chip_desc chips[last_ds_type] = {
 	[ds_3231] = {
 		.alarm		= 1,
 	},
+	[mcp7941x] = {
+		/* this is battery backed SRAM */
+		.nvram_offset	= 0x20,
+		.nvram_size	= 0x40,
+	},
 };
 
 static const struct i2c_device_id ds1307_id[] = {
@@ -543,8 +553,6 @@ static const struct rtc_class_ops ds13xx_rtc_ops = {
 
 /*----------------------------------------------------------------------*/
 
-#define NVRAM_SIZE	56
-
 static ssize_t
 ds1307_nvram_read(struct file *filp, struct kobject *kobj,
 		struct bin_attribute *attr,
@@ -557,14 +565,15 @@ ds1307_nvram_read(struct file *filp, struct kobject *kobj,
 	client = kobj_to_i2c_client(kobj);
 	ds1307 = i2c_get_clientdata(client);
 
-	if (unlikely(off >= NVRAM_SIZE))
+	if (unlikely(off >= ds1307->nvram_size))
 		return 0;
-	if ((off + count) > NVRAM_SIZE)
-		count = NVRAM_SIZE - off;
+	if ((off + count) > ds1307->nvram_size)
+		count = ds1307->nvram_size - off;
 	if (unlikely(!count))
 		return count;
 
-	result = ds1307->read_block_data(client, 8 + off, count, buf);
+	result = ds1307->read_block_data(client, ds1307->nvram_offset + off,
+								count, buf);
 	if (result < 0)
 		dev_err(&client->dev, "%s error %d\n", "nvram read", result);
 	return result;
@@ -582,14 +591,15 @@ ds1307_nvram_write(struct file *filp, struct kobject *kobj,
 	client = kobj_to_i2c_client(kobj);
 	ds1307 = i2c_get_clientdata(client);
 
-	if (unlikely(off >= NVRAM_SIZE))
+	if (unlikely(off >= ds1307->nvram_size))
 		return -EFBIG;
-	if ((off + count) > NVRAM_SIZE)
-		count = NVRAM_SIZE - off;
+	if ((off + count) > ds1307->nvram_size)
+		count = ds1307->nvram_size - off;
 	if (unlikely(!count))
 		return count;
 
-	result = ds1307->write_block_data(client, 8 + off, count, buf);
+	result = ds1307->write_block_data(client, ds1307->nvram_offset + off,
+								count, buf);
 	if (result < 0) {
 		dev_err(&client->dev, "%s error %d\n", "nvram write", result);
 		return result;
@@ -605,7 +615,6 @@ static struct bin_attribute nvram = {
 
 	.read	= ds1307_nvram_read,
 	.write	= ds1307_nvram_write,
-	.size	= NVRAM_SIZE,
 };
 
 /*----------------------------------------------------------------------*/
@@ -638,7 +647,12 @@ static int __devinit ds1307_probe(struct i2c_client *client,
 
 	ds1307->client	= client;
 	ds1307->type	= id->driver_data;
-	ds1307->offset	= 0;
+	if (chip) {
+		if (chip->nvram_size)
+			ds1307->nvram_size = chip->nvram_size;
+		if (chip->nvram_offset)
+			ds1307->nvram_offset = chip->nvram_offset;
+	}
 
 	buf = ds1307->regs;
 	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
@@ -893,11 +907,12 @@ read_rtc:
 		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
 	}
 
-	if (chip && chip->nvram56) {
+	if (chip && chip->nvram_size) {
+		nvram.size = ds1307->nvram_size;
 		err = sysfs_create_bin_file(&client->dev.kobj, &nvram);
 		if (err == 0) {
 			set_bit(HAS_NVRAM, &ds1307->flags);
-			dev_info(&client->dev, "56 bytes nvram\n");
+			dev_info(&client->dev, "%zd bytes nvram\n", nvram.size);
 		}
 	}


