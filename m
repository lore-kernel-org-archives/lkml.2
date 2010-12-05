Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab0LERvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:51:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab0LERv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:51:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nlLplXWoBwEc+ak6QkL/6yAiq2Do/ZNWEXq4vjyT3rPOeMbCK+JjybKO+4JPxyCk/7
         sfSF0Xb2/X//6AjS+OyZ3W21OVxUCTlA6UYIIdCDKvZFw7st2V/p7djqlYX7IrobocG1
         Ida6O4QpvEQBmF0ZCXLPGCds6+rcOvGHdj9rc=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 29/45] kstrtox: convert drivers/mfd/
Date: Sun,  5 Dec 2010 19:49:26 +0200
Message-Id: <1291571382-2719-29-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/mfd/ab3100-core.c    |   16 +++----------
 drivers/mfd/ab3550-core.c    |   48 +++++++++++++++--------------------------
 drivers/mfd/ab8500-debugfs.c |   41 +++++++++++++----------------------
 3 files changed, 37 insertions(+), 68 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 4193af5..5b1c8ac 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -497,7 +497,7 @@ static ssize_t ab3100_get_set_reg(struct file *file,
 	char buf[32];
 	ssize_t buf_size;
 	int regp;
-	unsigned long user_reg;
+	u8 reg;
 	int err;
 	int i = 0;
 
@@ -520,22 +520,19 @@ static ssize_t ab3100_get_set_reg(struct file *file,
 	/*
 	 * Advance pointer to end of string then terminate
 	 * the register string. This is needed to satisfy
-	 * the strict_strtoul() function.
+	 * the kstrtou8() function.
 	 */
 	while ((i < buf_size) && (buf[i] != ' '))
 		i++;
 	buf[i] = '\0';
 
-	err = strict_strtoul(&buf[regp], 16, &user_reg);
+	err = kstrtou8(&buf[regp], 16, &reg);
 	if (err)
 		return err;
-	if (user_reg > 0xff)
-		return -EINVAL;
 
 	/* Either we read or we write a register here */
 	if (!priv->mode) {
 		/* Reading */
-		u8 reg = (u8) user_reg;
 		u8 regvalue;
 
 		ab3100_get_register_interruptible(ab3100, reg, &regvalue);
@@ -545,8 +542,6 @@ static ssize_t ab3100_get_set_reg(struct file *file,
 			 reg, regvalue);
 	} else {
 		int valp;
-		unsigned long user_value;
-		u8 reg = (u8) user_reg;
 		u8 value;
 		u8 regvalue;
 
@@ -563,13 +558,10 @@ static ssize_t ab3100_get_set_reg(struct file *file,
 			i++;
 		buf[i] = '\0';
 
-		err = strict_strtoul(&buf[valp], 16, &user_value);
+		err = kstrtou8(&buf[valp], 16, &value);
 		if (err)
 			return err;
-		if (user_reg > 0xff)
-			return -EINVAL;
 
-		value = (u8) user_value;
 		ab3100_set_register_interruptible(ab3100, reg, value);
 		ab3100_get_register_interruptible(ab3100, reg, &regvalue);
 
diff --git a/drivers/mfd/ab3550-core.c b/drivers/mfd/ab3550-core.c
index 8a98739..7e471d9 100644
--- a/drivers/mfd/ab3550-core.c
+++ b/drivers/mfd/ab3550-core.c
@@ -73,8 +73,8 @@ struct ab3550 {
 	u8 startup_events[AB3550_NUM_EVENT_REG];
 	bool startup_events_read;
 #ifdef CONFIG_DEBUG_FS
-	unsigned int debug_bank;
-	unsigned int debug_address;
+	u8 debug_bank;
+	u8 debug_address;
 #endif
 };
 
@@ -865,7 +865,7 @@ static int ab3550_bank_print(struct seq_file *s, void *p)
 {
 	struct ab3550 *ab = s->private;
 
-	seq_printf(s, "%d\n", ab->debug_bank);
+	seq_printf(s, "%hhu\n", ab->debug_bank);
 	return 0;
 }
 
@@ -881,7 +881,7 @@ static ssize_t ab3550_bank_write(struct file *file,
 	struct ab3550 *ab = ((struct seq_file *)(file->private_data))->private;
 	char buf[32];
 	int buf_size;
-	unsigned long user_bank;
+	u8 user_bank;
 	int err;
 
 	/* Get userspace string and assure termination */
@@ -890,7 +890,7 @@ static ssize_t ab3550_bank_write(struct file *file,
 		return -EFAULT;
 	buf[buf_size] = 0;
 
-	err = strict_strtoul(buf, 0, &user_bank);
+	err = kstrtou8(buf, 0, &user_bank);
 	if (err)
 		return -EINVAL;
 
@@ -925,7 +925,6 @@ static ssize_t ab3550_address_write(struct file *file,
 	struct ab3550 *ab = ((struct seq_file *)(file->private_data))->private;
 	char buf[32];
 	int buf_size;
-	unsigned long user_address;
 	int err;
 
 	/* Get userspace string and assure termination */
@@ -934,15 +933,9 @@ static ssize_t ab3550_address_write(struct file *file,
 		return -EFAULT;
 	buf[buf_size] = 0;
 
-	err = strict_strtoul(buf, 0, &user_address);
-	if (err)
-		return -EINVAL;
-	if (user_address > 0xff) {
-		dev_err(&ab->i2c_client[0]->dev,
-			"debugfs error input > 0xff\n");
-		return -EINVAL;
-	}
-	ab->debug_address = user_address;
+	err = kstrtou8(buf, 0, &ab->debug_address);
+	if (err < 0)
+		return err;
 	return buf_size;
 }
 
@@ -952,8 +945,8 @@ static int ab3550_val_print(struct seq_file *s, void *p)
 	int err;
 	u8 regvalue;
 
-	err = get_register_interruptible(ab, (u8)ab->debug_bank,
-		(u8)ab->debug_address, &regvalue);
+	err = get_register_interruptible(ab, ab->debug_bank,
+		ab->debug_address, &regvalue);
 	if (err)
 		return -EINVAL;
 	seq_printf(s, "0x%02X\n", regvalue);
@@ -973,7 +966,7 @@ static ssize_t ab3550_val_write(struct file *file,
 	struct ab3550 *ab = ((struct seq_file *)(file->private_data))->private;
 	char buf[32];
 	int buf_size;
-	unsigned long user_val;
+	u8 user_val;
 	int err;
 	u8 regvalue;
 
@@ -983,22 +976,17 @@ static ssize_t ab3550_val_write(struct file *file,
 		return -EFAULT;
 	buf[buf_size] = 0;
 
-	err = strict_strtoul(buf, 0, &user_val);
-	if (err)
-		return -EINVAL;
-	if (user_val > 0xff) {
-		dev_err(&ab->i2c_client[0]->dev,
-			"debugfs error input > 0xff\n");
-		return -EINVAL;
-	}
+	err = kstrtou8(buf, 0, &user_val);
+	if (err < 0)
+		return err;
 	err = mask_and_set_register_interruptible(
-		ab, (u8)ab->debug_bank,
-		(u8)ab->debug_address, 0xFF, (u8)user_val);
+		ab, ab->debug_bank,
+		ab->debug_address, 0xFF, user_val);
 	if (err)
 		return -EINVAL;
 
-	get_register_interruptible(ab, (u8)ab->debug_bank,
-		(u8)ab->debug_address, &regvalue);
+	get_register_interruptible(ab, ab->debug_bank,
+		ab->debug_address, &regvalue);
 	if (err)
 		return -EINVAL;
 
diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 8d1e05a..2a4c317 100644
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
-       u32 bank = debug_bank;
+       u8 bank = debug_bank;
 
        seq_printf(s, AB8500_NAME_STRING " register values:\n");
 
@@ -372,7 +372,7 @@ static int ab8500_registers_print(struct seq_file *s, void *p)
                        int err;
 
                        err = abx500_get_register_interruptible(dev,
-                               (u8)bank, (u8)reg, &value);
+                               bank, (u8)reg, &value);
                        if (err < 0) {
                                dev_err(dev, "ab->read fail %d\n", err);
                                return err;
@@ -406,7 +406,7 @@ static const struct file_operations ab8500_registers_fops = {
 
 static int ab8500_bank_print(struct seq_file *s, void *p)
 {
-       return seq_printf(s, "%d\n", debug_bank);
+       return seq_printf(s, "%u\n", debug_bank);
 }
 
 static int ab8500_bank_open(struct inode *inode, struct file *file)
@@ -421,7 +421,7 @@ static ssize_t ab8500_bank_write(struct file *file,
        struct device *dev = ((struct seq_file *)(file->private_data))->private;
        char buf[32];
        int buf_size;
-       unsigned long user_bank;
+       u8 user_bank;
        int err;
 
        /* Get userspace string and assure termination */
@@ -430,9 +430,9 @@ static ssize_t ab8500_bank_write(struct file *file,
                return -EFAULT;
        buf[buf_size] = 0;
 
-       err = strict_strtoul(buf, 0, &user_bank);
+       err = kstrtou8(buf, 0, &user_bank);
        if (err)
-               return -EINVAL;
+               return err;
 
        if (user_bank >= AB8500_NUM_BANKS) {
                dev_err(dev, "debugfs error input > number of banks\n");
@@ -458,10 +458,8 @@ static ssize_t ab8500_address_write(struct file *file,
        const char __user *user_buf,
        size_t count, loff_t *ppos)
 {
-       struct device *dev = ((struct seq_file *)(file->private_data))->private;
        char buf[32];
        int buf_size;
-       unsigned long user_address;
        int err;
 
        /* Get userspace string and assure termination */
@@ -470,14 +468,9 @@ static ssize_t ab8500_address_write(struct file *file,
                return -EFAULT;
        buf[buf_size] = 0;
 
-       err = strict_strtoul(buf, 0, &user_address);
+       err = kstrtou8(buf, 0, &debug_address);
        if (err)
-               return -EINVAL;
-       if (user_address > 0xff) {
-               dev_err(dev, "debugfs error input > 0xff\n");
-               return -EINVAL;
-       }
-       debug_address = user_address;
+               return err;
        return buf_size;
 }
 
@@ -488,7 +481,7 @@ static int ab8500_val_print(struct seq_file *s, void *p)
        u8 regvalue;
 
        ret = abx500_get_register_interruptible(dev,
-               (u8)debug_bank, (u8)debug_address, &regvalue);
+               debug_bank, debug_address, &regvalue);
        if (ret < 0) {
                dev_err(dev, "abx500_get_reg fail %d, %d\n",
                        ret, __LINE__);
@@ -511,7 +504,7 @@ static ssize_t ab8500_val_write(struct file *file,
        struct device *dev = ((struct seq_file *)(file->private_data))->private;
        char buf[32];
        int buf_size;
-       unsigned long user_val;
+       u8 user_val;
        int err;
 
        /* Get userspace string and assure termination */
@@ -520,15 +513,11 @@ static ssize_t ab8500_val_write(struct file *file,
                return -EFAULT;
        buf[buf_size] = 0;
 
-       err = strict_strtoul(buf, 0, &user_val);
+       err = kstrtou8(buf, 0, &user_val);
        if (err)
-               return -EINVAL;
-       if (user_val > 0xff) {
-               dev_err(dev, "debugfs error input > 0xff\n");
-               return -EINVAL;
-       }
+               return err;
        err = abx500_set_register_interruptible(dev,
-               (u8)debug_bank, debug_address, (u8)user_val);
+               debug_bank, debug_address, user_val);
        if (err < 0) {
                printk(KERN_ERR "abx500_set_reg failed %d, %d", err, __LINE__);
                return -EINVAL;
-- 
1.7.2.2

