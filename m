Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab1KBU7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:59:23 -0400
Received: from mail5.aviatnet.com ([192.147.115.32]:20567 "EHLO
	mail5.aviatnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1KBU7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:59:21 -0400
Subject: [PATCH] rtc: ds1307: generalise ram size and offset
From: Austin Boyle <Austin.Boyle@aviatnet.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: <rtc-linux@googlegroups.com>, David Anderson <danders.dev@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        <linux-kernel@vger.kernel.org>,
        Austin Boyle <Austin.Boyle@aviatnet.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 3 Nov 2011 09:59:15 +1300
Message-ID: <1320267555.3000.13.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.1.193]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Austin Boyle <Austin.Boyle@aviatnet.com>

This patch generalises NVRAM to support RAM with other size and offset, such
as the 64 bytes of SRAM on the MCP7941x.

Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: David Anderson <danders.dev@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Austin Boyle <Austin.Boyle@aviatnet.com>
---
this patch is based on Wolfram Sang's tree:
git://git.pengutronix.de/git/wsa/linux-2.6.git ds1307

patch depends on:
rtc: ds1307: comment and format cleanup 21af5f7bd6
rtc: ds1307: simplify irq setup code  8c63e03627
rtc: ds1307: refactor chip_desc table e246db081d
rtc: add initial support for mcp7941x parts e69bba2d3a

--- a/drivers/rtc/rtc-ds1307.c	2011-10-10 11:22:22.674690998 +1300
+++ b/drivers/rtc/rtc-ds1307.c	2011-11-03 09:13:06.662159569 +1300
@@ -104,10 +104,12 @@ enum ds_type {
 
 struct ds1307 {
 	u8			offset; /* register's offset */
+	u16			ram_offset;
+	u16			ram_size;
 	u8			regs[11];
 	enum ds_type		type;
 	unsigned long		flags;
-#define HAS_NVRAM	0		/* bit 0 == sysfs file active */
+#define HAS_RAM	0			/* bit 0 == sysfs file active */
 #define HAS_ALARM	1		/* bit 1 == irq claimed */
 	struct i2c_client	*client;
 	struct rtc_device	*rtc;
@@ -119,19 +121,19 @@ struct ds1307 {
 };
 
 struct chip_desc {
-	unsigned		nvram56:1;
+	unsigned		ram:1;
 	unsigned		alarm:1;
 };
 
 static const struct chip_desc chips[last_ds_type] = {
 	[ds_1307] = {
-		.nvram56	= 1,
+		.ram		= 1,
 	},
 	[ds_1337] = {
 		.alarm		= 1,
 	},
 	[ds_1338] = {
-		.nvram56	= 1,
+		.ram		= 1,
 	},
 	[ds_1339] = {
 		.alarm		= 1,
@@ -139,6 +141,9 @@ static const struct chip_desc chips[last
 	[ds_3231] = {
 		.alarm		= 1,
 	},
+	[mcp7941x] = {
+		.ram		= 1,
+	},
 };
 
 static const struct i2c_device_id ds1307_id[] = {
@@ -543,10 +548,8 @@ static const struct rtc_class_ops ds13xx
 
 /*----------------------------------------------------------------------*/
 
-#define NVRAM_SIZE	56
-
 static ssize_t
-ds1307_nvram_read(struct file *filp, struct kobject *kobj,
+ds1307_ram_read(struct file *filp, struct kobject *kobj,
 		struct bin_attribute *attr,
 		char *buf, loff_t off, size_t count)
 {
@@ -557,21 +560,22 @@ ds1307_nvram_read(struct file *filp, str
 	client = kobj_to_i2c_client(kobj);
 	ds1307 = i2c_get_clientdata(client);
 
-	if (unlikely(off >= NVRAM_SIZE))
+	if (unlikely(off >= ds1307->ram_size))
 		return 0;
-	if ((off + count) > NVRAM_SIZE)
-		count = NVRAM_SIZE - off;
+	if ((off + count) > ds1307->ram_size)
+		count = ds1307->ram_size - off;
 	if (unlikely(!count))
 		return count;
 
-	result = ds1307->read_block_data(client, 8 + off, count, buf);
+	result = ds1307->read_block_data(client, ds1307->ram_offset + off,
+								count, buf);
 	if (result < 0)
-		dev_err(&client->dev, "%s error %d\n", "nvram read", result);
+		dev_err(&client->dev, "%s error %d\n", "ram read", result);
 	return result;
 }
 
 static ssize_t
-ds1307_nvram_write(struct file *filp, struct kobject *kobj,
+ds1307_ram_write(struct file *filp, struct kobject *kobj,
 		struct bin_attribute *attr,
 		char *buf, loff_t off, size_t count)
 {
@@ -582,30 +586,30 @@ ds1307_nvram_write(struct file *filp, st
 	client = kobj_to_i2c_client(kobj);
 	ds1307 = i2c_get_clientdata(client);
 
-	if (unlikely(off >= NVRAM_SIZE))
+	if (unlikely(off >= ds1307->ram_size))
 		return -EFBIG;
-	if ((off + count) > NVRAM_SIZE)
-		count = NVRAM_SIZE - off;
+	if ((off + count) > ds1307->ram_size)
+		count = ds1307->ram_size - off;
 	if (unlikely(!count))
 		return count;
 
-	result = ds1307->write_block_data(client, 8 + off, count, buf);
+	result = ds1307->write_block_data(client, ds1307->ram_offset + off,
+								count, buf);
 	if (result < 0) {
-		dev_err(&client->dev, "%s error %d\n", "nvram write", result);
+		dev_err(&client->dev, "%s error %d\n", "ram write", result);
 		return result;
 	}
 	return count;
 }
 
-static struct bin_attribute nvram = {
+static struct bin_attribute ram = {
 	.attr = {
-		.name	= "nvram",
+		.name	= "ram",
 		.mode	= S_IRUGO | S_IWUSR,
 	},
 
-	.read	= ds1307_nvram_read,
-	.write	= ds1307_nvram_write,
-	.size	= NVRAM_SIZE,
+	.read	= ds1307_ram_read,
+	.write	= ds1307_ram_write,
 };
 
 /*----------------------------------------------------------------------*/
@@ -692,6 +696,9 @@ static int __devinit ds1307_probe(struct
 		break;
 
 	case rx_8025:
+		ds1307->ram_size = 64; /* 64 bytes SRAM */
+		ds1307->ram_offset = 0x20;
+
 		tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
 				RX8025_REG_CTRL1 << 4 | 0x08, 2, buf);
 		if (tmp != 2) {
@@ -758,6 +765,8 @@ static int __devinit ds1307_probe(struct
 		break;
 	case ds_1388:
 		ds1307->offset = 1; /* Seconds starts at 1 */
+		ds1307->ram_size = 56; /* 56 bytes NVRAM */
+		ds1307->ram_offset = 8;
 		break;
 	default:
 		break;
@@ -893,11 +902,12 @@ read_rtc:
 		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
 	}
 
-	if (chip && chip->nvram56) {
-		err = sysfs_create_bin_file(&client->dev.kobj, &nvram);
+	if (chip && chip->ram) {
+		ram.size = ds1307->ram_size;
+		err = sysfs_create_bin_file(&client->dev.kobj, &ram);
 		if (err == 0) {
-			set_bit(HAS_NVRAM, &ds1307->flags);
-			dev_info(&client->dev, "56 bytes nvram\n");
+			set_bit(HAS_RAM, &ds1307->flags);
+			dev_info(&client->dev, "%zd bytes ram\n", ram.size);
 		}
 	}
 
@@ -919,8 +929,8 @@ static int __devexit ds1307_remove(struc
 		cancel_work_sync(&ds1307->work);
 	}
 
-	if (test_and_clear_bit(HAS_NVRAM, &ds1307->flags))
-		sysfs_remove_bin_file(&client->dev.kobj, &nvram);
+	if (test_and_clear_bit(HAS_RAM, &ds1307->flags))
+		sysfs_remove_bin_file(&client->dev.kobj, &ram);
 
 	rtc_device_unregister(ds1307->rtc);
 	kfree(ds1307);


