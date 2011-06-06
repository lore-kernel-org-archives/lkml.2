Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab1FFUns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:43:48 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45659 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757989Ab1FFUno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:43:44 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19WZnEPwF1Wwt4DfAaQcaTTkn04wq88et+2ltehXD
	8Uwl+pSbd3JFAT
From: Peter Huewe <peterhuewe@gmx.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 2/2] mfd/ab8500: Use kstrtoul_from_user
Date: Mon,  6 Jun 2011 22:43:32 +0200
Message-Id: <1307393012-32582-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1307393012-32582-1-git-send-email-peterhuewe@gmx.de>
References: <1307393012-32582-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the code for getting an unsigned long from a
userspace buffer by a simple call to kstroul_from_user.
This makes it easier to read and less error prone.

Kernel Version: v3.0-rc2

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/mfd/ab8500-debugfs.c |   41 +++++++++++------------------------------
 1 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 64748e4..64bdeeb 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -419,20 +419,13 @@ static ssize_t ab8500_bank_write(struct file *file,
 	size_t count, loff_t *ppos)
 {
 	struct device *dev = ((struct seq_file *)(file->private_data))->private;
-	char buf[32];
-	int buf_size;
 	unsigned long user_bank;
 	int err;
 
 	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf) - 1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	buf[buf_size] = 0;
-
-	err = strict_strtoul(buf, 0, &user_bank);
+	err = kstrtoul_from_user(user_buf, count, 0, &user_bank);
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
@@ -459,26 +452,20 @@ static ssize_t ab8500_address_write(struct file *file,
 	size_t count, loff_t *ppos)
 {
 	struct device *dev = ((struct seq_file *)(file->private_data))->private;
-	char buf[32];
-	int buf_size;
 	unsigned long user_address;
 	int err;
 
 	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf) - 1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	buf[buf_size] = 0;
-
-	err = strict_strtoul(buf, 0, &user_address);
+	err = kstrtoul_from_user(user_buf, count, 0, &user_address);
 	if (err)
-		return -EINVAL;
+		return err;
+
 	if (user_address > 0xff) {
 		dev_err(dev, "debugfs error input > 0xff\n");
 		return -EINVAL;
 	}
 	debug_address = user_address;
-	return buf_size;
+	return count;
 }
 
 static int ab8500_val_print(struct seq_file *s, void *p)
@@ -509,20 +496,14 @@ static ssize_t ab8500_val_write(struct file *file,
 	size_t count, loff_t *ppos)
 {
 	struct device *dev = ((struct seq_file *)(file->private_data))->private;
-	char buf[32];
-	int buf_size;
 	unsigned long user_val;
 	int err;
 
 	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf)-1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	buf[buf_size] = 0;
-
-	err = strict_strtoul(buf, 0, &user_val);
+	err = kstrtoul_from_user(user_buf, count, 0, &user_val);
 	if (err)
-		return -EINVAL;
+		return err;
+
 	if (user_val > 0xff) {
 		dev_err(dev, "debugfs error input > 0xff\n");
 		return -EINVAL;
@@ -534,7 +515,7 @@ static ssize_t ab8500_val_write(struct file *file,
 		return -EINVAL;
 	}
 
-	return buf_size;
+	return count;
 }
 
 static const struct file_operations ab8500_bank_fops = {
-- 
1.7.3.4

