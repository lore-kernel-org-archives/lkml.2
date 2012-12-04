Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab2LDQ7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 11:59:06 -0500
Received: from smtp2.goneo.de ([212.90.139.82]:32937 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab2LDQ7C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 11:59:02 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.897
To: w.sang@pengutronix.de
Subject: [PATCH RFC] misc/at24: distinguish between eeprom and fram chips
From: Lars Poeschel <poeschel@lemonage.de>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Date: Tue, 4 Dec 2012 17:58:38 +0100
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201212041758.38600.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I wanted to use a fm24c04 i2c fram chip with linux. I grepped the source
and found nothing. I later found that my chip can be handled by at24
eeprom driver. It creates a sysfs file called eeprom to read from and
write to the chip. Userspace has no chance to distinguish if it is
writing an eeprom or a fram chip.

I present this patch for 3 reasons:
1. For other people grepping finding a little more reference.
2. For userspace being able to distinguish eeprom and fram.
3. Raising the bytes per write for fram chips.

What do you kernel developers think ?

Cheers,
Lars
-- >8 --
>From 4fab49fae62390995868e3b6dee7e0693fce5be9 Mon Sep 17 00:00:00 2001
From: Lars Poeschel <poeschel@lemonage.de>
Date: Tue, 4 Dec 2012 15:41:40 +0100
Subject: [PATCH] misc/at24: distinguish between eeprom and fram chips

Add a AT24_FLAGS_FRAM state to the flags to make userspace able to
distinguish if it is using eeprom or fram. The sysfs entry gets the
name "fram" instead of "eeprom".
For frams the bytes/write can be at least 128 bytes, since these
chips have no need to internally buffer writes.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>

diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
index c9e695e..55948a5 100644
--- a/drivers/misc/eeprom/Kconfig
+++ b/drivers/misc/eeprom/Kconfig
@@ -12,6 +12,12 @@ config EEPROM_AT24
 	     24c00, 24c01, 24c02, spd (readonly 24c02), 24c04, 24c08,
 	     24c16, 24c32, 24c64, 24c128, 24c256, 24c512, 24c1024
 
+	  This driver also supports I2C FRAM chips that are feature
+	  compatible to the 24cxx ones. In your at24_platform_data set
+	  .flags = AT24_FLAG_FRAM. These generic names are supported:
+
+	     fm24c04
+
 	  Unless you like data loss puzzles, always be sure that any chip
 	  you configure as a 24c32 (32 kbit) or larger is NOT really a
 	  24c16 (16 kbit) or smaller, and vice versa. Marking the chip
diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index ab1ad41..02a03a1 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -125,6 +125,7 @@ static const struct i2c_device_id at24_ids[] = {
 	{ "24c256", AT24_DEVICE_MAGIC(262144 / 8, AT24_FLAG_ADDR16) },
 	{ "24c512", AT24_DEVICE_MAGIC(524288 / 8, AT24_FLAG_ADDR16) },
 	{ "24c1024", AT24_DEVICE_MAGIC(1048576 / 8, AT24_FLAG_ADDR16) },
+	{ "fm24c04", AT24_DEVICE_MAGIC(4096 / 8, AT24_FLAG_FRAM) },
 	{ "at24", 0 },
 	{ /* END OF LIST */ }
 };
@@ -504,8 +505,13 @@ static int at24_probe(struct i2c_client *client, const 
struct i2c_device_id *id)
 		 * This is slow, but we can't know all eeproms, so we better
 		 * play safe. Specifying custom eeprom-types via platform_data
 		 * is recommended anyhow.
+		 * For fram chips, we can allow minmum 128 bytes, as there is
+		 * no page size and 128 is the smallest so far seen chip.
 		 */
-		chip.page_size = 1;
+		if (chip.flags & AT24_FLAG_FRAM)
+			chip.page_size = 128;
+		else
+			chip.page_size = 1;
 
 		/* update chipdata if OF is present */
 		at24_get_ofdata(client, &chip);
@@ -570,7 +576,10 @@ static int at24_probe(struct i2c_client *client, const 
struct i2c_device_id *id)
 	 * By default, only root should see the data (maybe passwords etc)
 	 */
 	sysfs_bin_attr_init(&at24->bin);
-	at24->bin.attr.name = "eeprom";
+	if (chip.flags & AT24_FLAG_FRAM)
+		at24->bin.attr.name = "fram";
+	else
+		at24->bin.attr.name = "eeprom";
 	at24->bin.attr.mode = chip.flags & AT24_FLAG_IRUGO ? S_IRUGO : S_IRUSR;
 	at24->bin.read = at24_bin_read;
 	at24->bin.size = chip.byte_len;
diff --git a/include/linux/i2c/at24.h b/include/linux/i2c/at24.h
index 285025a..d786b71 100644
--- a/include/linux/i2c/at24.h
+++ b/include/linux/i2c/at24.h
@@ -47,6 +47,7 @@ struct at24_platform_data {
 #define AT24_FLAG_READONLY	0x40	/* sysfs-entry will be read-only */
 #define AT24_FLAG_IRUGO		0x20	/* sysfs-entry will be world-readable */
 #define AT24_FLAG_TAKE8ADDR	0x10	/* take always 8 addresses (24c00) */
+#define AT24_FLAG_FRAM          0x08    /* chip is fram not eeprom */
 
 	void		(*setup)(struct memory_accessor *, void *context);
 	void		*context;
-- 
1.7.10.4

