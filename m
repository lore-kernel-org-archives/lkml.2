Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab1FTTqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:46:50 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:55102 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755888Ab1FTTqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:46:47 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+BRDoFiAeB8HiHZGTrsskZ7wPpbdPDzmt7uvUZI1
	1xlA0+RubVm+2x
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
Subject: [PATCH 2/2 v2] mfd/ab8500: Convert to kstrtou8_from_user
Date: Mon, 20 Jun 2011 21:46:29 +0200
Message-Id: <1308599189-28555-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <BANLkTikKRVP4PW48YtR+mMMNsaxTDxoGtw@mail.gmail.com>
References: <BANLkTikKRVP4PW48YtR+mMMNsaxTDxoGtw@mail.gmail.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the code for getting an number from a
userspace buffer by a simple call to kstrou8_from_user.
This makes it easier to read and less error prone.

This patch replaces the code for getting an number from a
userspace buffer by a simple call to kstrou8_from_user.
This makes it easier to read and less error prone.

Since the old buffers held only values up to 255, we don't need
kstrtoul, but rather kstrtou8.

Kernel Version: v3.0-rc3

Changes in v2:
- Use kstrtou8 instead of kstrtoul due to small numbers
- Dropped then unnecessary checks
(Both remarks from Alexey Dobriyan, Thanks!)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/mfd/ab8500-debugfs.c |   61 +++++++++++------------------------------
 1 files changed, 17 insertions(+), 44 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 64748e4..7304919 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
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
@@ -459,26 +452,16 @@ static ssize_t ab8500_address_write(struct file *file,
 	size_t count, loff_t *ppos)
 {
 	struct device *dev = ((struct seq_file *)(file->private_data))->private;
-	char buf[32];
-	int buf_size;
-	unsigned long user_address;
+	u8 user_address;
 	int err;
 
-	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf) - 1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	buf[buf_size] = 0;
-
-	err = strict_strtoul(buf, 0, &user_address);
+	/* Get userspace string and convert to number*/
+	err = kstrtou8_from_user(user_buf, count, 0, &user_address);
 	if (err)
-		return -EINVAL;
-	if (user_address > 0xff) {
-		dev_err(dev, "debugfs error input > 0xff\n");
-		return -EINVAL;
-	}
+		return err;
+
 	debug_address = user_address;
-	return buf_size;
+	return count;
 }
 
 static int ab8500_val_print(struct seq_file *s, void *p)
@@ -509,24 +492,14 @@ static ssize_t ab8500_val_write(struct file *file,
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
 		(u8)debug_bank, debug_address, (u8)user_val);
 	if (err < 0) {
@@ -534,7 +507,7 @@ static ssize_t ab8500_val_write(struct file *file,
 		return -EINVAL;
 	}
 
-	return buf_size;
+	return count;
 }
 
 static const struct file_operations ab8500_bank_fops = {
-- 
1.7.3.4

