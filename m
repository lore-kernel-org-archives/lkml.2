Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab1FFUnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:43:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45482 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753834Ab1FFUnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:43:39 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19fPOcd7GpfwMGqnGU8LYvjbXvh6MEYXRNMcYgnxm
	pTVU/pogfSPVIe
From: Peter Huewe <peterhuewe@gmx.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 1/2] mfd/ab3550: Use kstrtoul_from_user
Date: Mon,  6 Jun 2011 22:43:31 +0200
Message-Id: <1307393012-32582-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
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
 drivers/mfd/ab3550-core.c |   41 +++++++++++------------------------------
 1 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/drivers/mfd/ab3550-core.c b/drivers/mfd/ab3550-core.c
index 3d7dce6..56ba194 100644
--- a/drivers/mfd/ab3550-core.c
+++ b/drivers/mfd/ab3550-core.c
@@ -879,20 +879,13 @@ static ssize_t ab3550_bank_write(struct file *file,
 	size_t count, loff_t *ppos)
 {
 	struct ab3550 *ab = ((struct seq_file *)(file->private_data))->private;
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
 
 	if (user_bank >= AB3550_NUM_BANKS) {
 		dev_err(&ab->i2c_client[0]->dev,
@@ -902,7 +895,7 @@ static ssize_t ab3550_bank_write(struct file *file,
 
 	ab->debug_bank = user_bank;
 
-	return buf_size;
+	return count;
 }
 
 static int ab3550_address_print(struct seq_file *s, void *p)
@@ -923,27 +916,21 @@ static ssize_t ab3550_address_write(struct file *file,
 	size_t count, loff_t *ppos)
 {
 	struct ab3550 *ab = ((struct seq_file *)(file->private_data))->private;
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
 		dev_err(&ab->i2c_client[0]->dev,
 			"debugfs error input > 0xff\n");
 		return -EINVAL;
 	}
 	ab->debug_address = user_address;
-	return buf_size;
+	return count;
 }
 
 static int ab3550_val_print(struct seq_file *s, void *p)
@@ -971,21 +958,15 @@ static ssize_t ab3550_val_write(struct file *file,
 	size_t count, loff_t *ppos)
 {
 	struct ab3550 *ab = ((struct seq_file *)(file->private_data))->private;
-	char buf[32];
-	int buf_size;
 	unsigned long user_val;
 	int err;
 	u8 regvalue;
 
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
 		dev_err(&ab->i2c_client[0]->dev,
 			"debugfs error input > 0xff\n");
@@ -1002,7 +983,7 @@ static ssize_t ab3550_val_write(struct file *file,
 	if (err)
 		return -EINVAL;
 
-	return buf_size;
+	return count;
 }
 
 static const struct file_operations ab3550_bank_fops = {
-- 
1.7.3.4

