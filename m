Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab1FTVCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 17:02:01 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:57817 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755677Ab1FTVB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 17:01:58 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18hQDdb80AhGIzYRIw4+EJJpFvNccUKJLs3+T5cM1
	G+w2t7nKwzKaxh
From: Peter Huewe <peterhuewe@gmx.de>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 2/2 v4] mfd/ab8500: Convert to kstrtou8_from_user
Date: Mon, 20 Jun 2011 23:01:38 +0200
Message-Id: <1308603698-32166-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110620195037.GA2534@p183.telecom.by>
References: <20110620195037.GA2534@p183.telecom.by>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the code for getting an number from a
userspace buffer by a simple call to kstrou8_from_user.
This makes it easier to read and less error prone.

Since the old buffers held only values up to 255, we don't need
kstrtoul, but rather kstrtou8.

Kernel Version: v3.0-rc3

Changes in v2:
- Use kstrtou8 instead of kstrtoul due to small numbers
- Dropped then unnecessary checks
Changes in v3:
- The local struct dev variable isn't needed anymore
Changes in v4:
- Drop unneccesary now local variables and casts
- Change the debug_address and debug_bank members to u8 since they hold
only values up to 255, and also remove the now superfluous u8 casts

(Remarks from Alexey Dobriyan, Thanks!)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/mfd/ab8500-debugfs.c |   74 ++++++++++++-----------------------------
 1 files changed, 22 insertions(+), 52 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 64748e4..5d3cd35 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -14,8 +14,8 @@
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/ab8500.h>
 
-static u32 debug_bank;
-static u32 debug_address;
+static u8 debug_bank;
+static u8 debug_address;
 
 /**
  * struct ab8500_reg_range
@@ -357,7 +357,7 @@ static int ab8500_registers_print(struct seq_file *s, void *p)
 {
 	struct device *dev = s->private;
 	unsigned int i;
-	u32 bank = debug_bank;
+	u8 bank = debug_bank;
 
 	seq_printf(s, AB8500_NAME_STRING " register values:\n");
 
@@ -372,7 +372,7 @@ static int ab8500_registers_print(struct seq_file *s, void *p)
 			int err;
 
 			err = abx500_get_register_interruptible(dev,
-				(u8)bank, (u8)reg, &value);
+				bank, (u8)reg, &value);
 			if (err < 0) {
 				dev_err(dev, "ab->read fail %d\n", err);
 				return err;
@@ -419,20 +419,13 @@ static ssize_t ab8500_bank_write(struct file *file,
 	size_t count, loff_t *ppos)
 {
 	struct device *dev = ((struct seq_file *)(file->private_data))->private;
-	char buf[32];
-	int buf_size;
-	unsigned long user_bank;
+	u8 user_bank;
 	int err;
 
-	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf) - 1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	buf[buf_size] = 0;
-
-	err = strict_strtoul(buf, 0, &user_bank);
+	/* Get userspace string and convert to number */
+	err = kstrtou8_from_user(user_buf, count, 0, &user_bank);
 	if (err)
-		return -EINVAL;
+		return err;
 
 	if (user_bank >= AB8500_NUM_BANKS) {
 		dev_err(dev, "debugfs error input > number of banks\n");
@@ -441,7 +434,7 @@ static ssize_t ab8500_bank_write(struct file *file,
 
 	debug_bank = user_bank;
 
-	return buf_size;
+	return count;
 }
 
 static int ab8500_address_print(struct seq_file *s, void *p)
@@ -458,27 +451,14 @@ static ssize_t ab8500_address_write(struct file *file,
 	const char __user *user_buf,
 	size_t count, loff_t *ppos)
 {
-	struct device *dev = ((struct seq_file *)(file->private_data))->private;
-	char buf[32];
-	int buf_size;
-	unsigned long user_address;
 	int err;
 
-	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf) - 1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	buf[buf_size] = 0;
-
-	err = strict_strtoul(buf, 0, &user_address);
+	/* Get userspace string and convert to number*/
+	err = kstrtou8_from_user(user_buf, count, 0, &debug_address);
 	if (err)
-		return -EINVAL;
-	if (user_address > 0xff) {
-		dev_err(dev, "debugfs error input > 0xff\n");
-		return -EINVAL;
-	}
-	debug_address = user_address;
-	return buf_size;
+		return err;
+
+	return count;
 }
 
 static int ab8500_val_print(struct seq_file *s, void *p)
@@ -488,7 +468,7 @@ static int ab8500_val_print(struct seq_file *s, void *p)
 	u8 regvalue;
 
 	ret = abx500_get_register_interruptible(dev,
-		(u8)debug_bank, (u8)debug_address, &regvalue);
+		debug_bank, debug_address, &regvalue);
 	if (ret < 0) {
 		dev_err(dev, "abx500_get_reg fail %d, %d\n",
 			ret, __LINE__);
@@ -509,32 +489,22 @@ static ssize_t ab8500_val_write(struct file *file,
 	size_t count, loff_t *ppos)
 {
 	struct device *dev = ((struct seq_file *)(file->private_data))->private;
-	char buf[32];
-	int buf_size;
-	unsigned long user_val;
+	u8 user_val;
 	int err;
 
-	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf)-1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	buf[buf_size] = 0;
-
-	err = strict_strtoul(buf, 0, &user_val);
+	/* Get userspace string and convert to number */
+	err = kstrtou8_from_user(user_buf, count, 0, &user_val);
 	if (err)
-		return -EINVAL;
-	if (user_val > 0xff) {
-		dev_err(dev, "debugfs error input > 0xff\n");
-		return -EINVAL;
-	}
+		return err;
+
 	err = abx500_set_register_interruptible(dev,
-		(u8)debug_bank, debug_address, (u8)user_val);
+		debug_bank, debug_address, user_val);
 	if (err < 0) {
 		printk(KERN_ERR "abx500_set_reg failed %d, %d", err, __LINE__);
 		return -EINVAL;
 	}
 
-	return buf_size;
+	return count;
 }
 
 static const struct file_operations ab8500_bank_fops = {
-- 
1.7.3.4

