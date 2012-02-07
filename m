Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab2BGVsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 16:48:31 -0500
Received: from mail4.aviatnet.com ([192.147.115.31]:38734 "EHLO
	mail4.aviatnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab2BGVsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 16:48:30 -0500
Subject: Re: [PATCH v3] rtc: ds1307: generalise ram size and offset
From: Austin Boyle <Austin.Boyle@aviatnet.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20120207145652.GH2539@pengutronix.de>
References: <1326144071.3096.25.camel@pc786-ubu.gnet.global.vpn>
	 <20120111110650.GC2605@pengutronix.de>
	 <1326320516.3096.64.camel@pc786-ubu.gnet.global.vpn>
	 <20120119194541.GA32483@pengutronix.de>
	 <1328143057.3159.34.camel@pc786-ubu.gnet.global.vpn>
	 <1328221704.3159.50.camel@pc786-ubu.gnet.global.vpn>
	 <20120207145652.GH2539@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 8 Feb 2012 10:45:59 +1300
Message-ID: <1328651159.3117.58.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.1.34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtc: ds1307: generalise ram size and offset

From: Austin Boyle <Austin.Boyle@aviatnet.com>

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
+	struct bin_attribute	*nvram;
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
+	if (unlikely(off >= ds1307->nvram->size))
 		return 0;
-	if ((off + count) > NVRAM_SIZE)
-		count = NVRAM_SIZE - off;
+	if ((off + count) > ds1307->nvram->size)
+		count = ds1307->nvram->size - off;
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
+	if (unlikely(off >= ds1307->nvram->size))
 		return -EFBIG;
-	if ((off + count) > NVRAM_SIZE)
-		count = NVRAM_SIZE - off;
+	if ((off + count) > ds1307->nvram->size)
+		count = ds1307->nvram->size - off;
 	if (unlikely(!count))
 		return count;
 
-	result = ds1307->write_block_data(client, 8 + off, count, buf);
+	result = ds1307->write_block_data(client, ds1307->nvram_offset + off,
+								count, buf);
 	if (result < 0) {
 		dev_err(&client->dev, "%s error %d\n", "nvram write", result);
 		return result;
@@ -597,17 +607,6 @@ ds1307_nvram_write(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute nvram = {
-	.attr = {
-		.name	= "nvram",
-		.mode	= S_IRUGO | S_IWUSR,
-	},
-
-	.read	= ds1307_nvram_read,
-	.write	= ds1307_nvram_write,
-	.size	= NVRAM_SIZE,
-};
-
 /*----------------------------------------------------------------------*/
 
 static int __devinit ds1307_probe(struct i2c_client *client,
@@ -893,16 +892,31 @@ read_rtc:
 		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
 	}
 
-	if (chip && chip->nvram56) {
-		err = sysfs_create_bin_file(&client->dev.kobj, &nvram);
-		if (err == 0) {
-			set_bit(HAS_NVRAM, &ds1307->flags);
-			dev_info(&client->dev, "56 bytes nvram\n");
+	if (chip && chip->nvram_size) {
+		ds1307->nvram = kzalloc(sizeof(struct bin_attribute),
+							GFP_KERNEL);
+		if (!ds1307->nvram) {
+			err = -ENOMEM;
+			goto exit_nvram;
+		}
+		ds1307->nvram->attr.name = "nvram";
+		ds1307->nvram->attr.mode = S_IRUGO | S_IWUSR;
+		ds1307->nvram->read = ds1307_nvram_read,
+		ds1307->nvram->write = ds1307_nvram_write,
+		ds1307->nvram->size = chip->nvram_size;
+		ds1307->nvram_offset = chip->nvram_offset;
+		err = sysfs_create_bin_file(&client->dev.kobj, ds1307->nvram);
+		if (err) {
+			kfree(ds1307->nvram);
+			goto exit_nvram;
 		}
+		set_bit(HAS_NVRAM, &ds1307->flags);
+		dev_info(&client->dev, "%d bytes nvram\n", ds1307->nvram->size);
 	}
 
 	return 0;
 
+exit_nvram:
 exit_irq:
 	rtc_device_unregister(ds1307->rtc);
 exit_free:
@@ -919,8 +933,10 @@ static int __devexit ds1307_remove(struct i2c_client *client)
 		cancel_work_sync(&ds1307->work);
 	}
 
-	if (test_and_clear_bit(HAS_NVRAM, &ds1307->flags))
-		sysfs_remove_bin_file(&client->dev.kobj, &nvram);
+	if (test_and_clear_bit(HAS_NVRAM, &ds1307->flags)) {
+		sysfs_remove_bin_file(&client->dev.kobj, ds1307->nvram);
+		kfree(ds1307->nvram);
+	}
 
 	rtc_device_unregister(ds1307->rtc);
 	kfree(ds1307);

