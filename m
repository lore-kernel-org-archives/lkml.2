Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0IJMrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 08:47:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36894 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab0IJMrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 08:47:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xl0JKg1La0MTbaSokdZbHImWkeSVTE/+H8JmO0Wt5NBN54QjAH2cj+7OpdKyLhO0KD
         QNjZkbmNKpEUGDLF8yXh7vhlJLbuU8r9AdkhOsspe+pk9nOIRtOCTh8imwCm6e2LbLSA
         8lez81D+DbG0dQaNjPldWQF9rW6fgVlCaUpOU=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Hunter Adrian <adrian.hunter@nokia.com>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCHv2] mmc_test: move files from sysfs to debugfs
Date: Fri, 10 Sep 2010 15:47:17 +0300
Message-Id: <1284122837-9195-1-git-send-email-ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <4C89DC01.6000601@nokia.com>
References: <4C89DC01.6000601@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As proposed by Greg the more logically is to keep files for mmc_test driver
under debugfs.

Additionally this patch brings seq_file API for show() method. It allows to
write unlimited data to the file.

Example of usage:
  # mount -t debugfs none /sys/kernel/debug
  # modprobe mmc_test
    [  581.395843] mmc_test mmc0:0001: Card claimed for testing.
  # echo 25 > /sys/kernel/debug/mmc0/mmc0\:0001/test
    [  604.568542] mmc0: Starting tests of card mmc0:0001...
    [  604.582733] mmc0: Test case 25. Best-case read performance into scattered pages...
    [  604.923553] mmc0: Transfer of 8192 sectors (4096 KiB) took 0.124664314 seconds (33644 kB/s, 32856 KiB/s)
    [  604.933227] mmc0: Result: OK
    [  604.936248] mmc0: Tests completed.
  # cat /sys/kernel/debug/mmc0/mmc0\:0001/test
    Test 25: 0
    1 8192 0.124664314 33644784

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/mmc/card/mmc_test.c |  142 ++++++++++++++++++++++++++++++++-----------
 1 files changed, 107 insertions(+), 35 deletions(-)

diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index 58d746b..4ea6aab 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -19,6 +19,10 @@
 #include <linux/swap.h>		/* For nr_free_buffer_pages() */
 #include <linux/list.h>
 
+#include <linux/debugfs.h>
+#include <asm/uaccess.h>
+#include <linux/seq_file.h>
+
 #define RESULT_OK		0
 #define RESULT_FAIL		1
 #define RESULT_UNSUP_HOST	2
@@ -106,6 +110,18 @@ struct mmc_test_general_result {
 };
 
 /**
+ * struct mmc_test_dbgfs_file - debugfs related file.
+ * @link: double-linked list
+ * @card: card under test
+ * @file: file created under debugfs
+ */
+struct mmc_test_dbgfs_file {
+	struct list_head link;
+	struct mmc_card *card;
+	struct dentry *file;
+};
+
+/**
  * struct mmc_test_card - test information.
  * @card: card under test
  * @scratch: transfer buffer
@@ -2037,14 +2053,12 @@ static void mmc_test_free_result(struct mmc_card *card)
 	mutex_unlock(&mmc_test_lock);
 }
 
-static ssize_t mmc_test_show(struct device *dev,
-	struct device_attribute *attr, char *buf)
+static LIST_HEAD(mmc_test_file_test);
+
+static int mtf_test_show(struct seq_file *sf, void *data)
 {
-	struct mmc_card *card = mmc_dev_to_card(dev);
+	struct mmc_card *card = (struct mmc_card *)sf->private;
 	struct mmc_test_general_result *gr;
-	char *p = buf;
-	size_t len = PAGE_SIZE;
-	int ret;
 
 	mutex_lock(&mmc_test_lock);
 
@@ -2054,49 +2068,44 @@ static ssize_t mmc_test_show(struct device *dev,
 		if (gr->card != card)
 			continue;
 
-		ret = snprintf(p, len, "Test %d: %d\n", gr->testcase + 1,
-			gr->result);
-		if (ret < 0)
-			goto err;
-		if (ret >= len) {
-			ret = -ENOBUFS;
-			goto err;
-		}
-		p += ret;
-		len -= ret;
+		seq_printf(sf, "Test %d: %d\n", gr->testcase + 1, gr->result);
 
 		list_for_each_entry(tr, &gr->tr_lst, link) {
-			ret = snprintf(p, len, "%u %d %lu.%09lu %u\n",
+			seq_printf(sf, "%u %d %lu.%09lu %u\n",
 				tr->count, tr->sectors,
 				(unsigned long)tr->ts.tv_sec,
 				(unsigned long)tr->ts.tv_nsec,
 				tr->rate);
-			if (ret < 0)
-				goto err;
-			if (ret >= len) {
-				ret = -ENOBUFS;
-				goto err;
-			}
-			p += ret;
-			len -= ret;
 		}
 	}
 
-	ret = PAGE_SIZE - len;
-err:
 	mutex_unlock(&mmc_test_lock);
 
-	return ret;
+	return 0;
 }
 
-static ssize_t mmc_test_store(struct device *dev,
-	struct device_attribute *attr, const char *buf, size_t count)
+static int mtf_test_open(struct inode *inode, struct file *file)
 {
-	struct mmc_card *card = mmc_dev_to_card(dev);
+	return single_open(file, mtf_test_show, inode->i_private);
+}
+
+static ssize_t mtf_test_write(struct file *file, const char __user *buf,
+	size_t count, loff_t *pos)
+{
+	struct seq_file *sf = (struct seq_file *)file->private_data;
+	struct mmc_card *card = (struct mmc_card *)sf->private;
 	struct mmc_test_card *test;
+	char lbuf[12];
 	long testcase;
 
-	if (strict_strtol(buf, 10, &testcase))
+	if (count >= sizeof(lbuf))
+		return -EINVAL;
+
+	if (copy_from_user(lbuf, buf, count))
+		return -EFAULT;
+	lbuf[count] = '\0';
+
+	if (strict_strtol(lbuf, 10, &testcase))
 		return -EINVAL;
 
 	test = kzalloc(sizeof(struct mmc_test_card), GFP_KERNEL);
@@ -2135,7 +2144,69 @@ static ssize_t mmc_test_store(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(test, S_IWUSR | S_IRUGO, mmc_test_show, mmc_test_store);
+static const struct file_operations mmc_test_fops_test = {
+	.open		= mtf_test_open,
+	.read		= seq_read,
+	.write		= mtf_test_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void mmc_test_free_file_test(struct mmc_card *card)
+{
+	struct mmc_test_dbgfs_file *df, *dfs;
+
+	mutex_lock(&mmc_test_lock);
+
+	list_for_each_entry_safe(df, dfs, &mmc_test_file_test, link) {
+		if (card && df->card != card)
+			continue;
+		debugfs_remove(df->file);
+		list_del(&df->link);
+		kfree(df);
+	}
+
+	mutex_unlock(&mmc_test_lock);
+}
+
+static int mmc_test_register_file_test(struct mmc_card *card)
+{
+	struct dentry *file = NULL;
+	struct mmc_test_dbgfs_file *df;
+	int ret = 0;
+
+	mutex_lock(&mmc_test_lock);
+
+	if (card->debugfs_root)
+		file = debugfs_create_file("test", S_IWUSR | S_IRUGO,
+			card->debugfs_root, card, &mmc_test_fops_test);
+
+	if (IS_ERR_OR_NULL(file)) {
+		dev_err(&card->dev,
+			"Can't create file. Perhaps debugfs is disabled.\n");
+		ret = -ENODEV;
+		goto err;
+	}
+
+	df = kmalloc(sizeof(struct mmc_test_dbgfs_file), GFP_KERNEL);
+	if (!df) {
+		debugfs_remove(file);
+		dev_err(&card->dev,
+			"Can't allocate memory for internal usage.\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	df->card = card;
+	df->file = file;
+
+	list_add(&df->link, &mmc_test_file_test);
+
+err:
+	mutex_unlock(&mmc_test_lock);
+
+	return ret;
+}
 
 static int mmc_test_probe(struct mmc_card *card)
 {
@@ -2144,7 +2215,7 @@ static int mmc_test_probe(struct mmc_card *card)
 	if (!mmc_card_mmc(card) && !mmc_card_sd(card))
 		return -ENODEV;
 
-	ret = device_create_file(&card->dev, &dev_attr_test);
+	ret = mmc_test_register_file_test(card);
 	if (ret)
 		return ret;
 
@@ -2156,7 +2227,7 @@ static int mmc_test_probe(struct mmc_card *card)
 static void mmc_test_remove(struct mmc_card *card)
 {
 	mmc_test_free_result(card);
-	device_remove_file(&card->dev, &dev_attr_test);
+	mmc_test_free_file_test(card);
 }
 
 static struct mmc_driver mmc_driver = {
@@ -2176,6 +2247,7 @@ static void __exit mmc_test_exit(void)
 {
 	/* Clear stalled data if card is still plugged */
 	mmc_test_free_result(NULL);
+	mmc_test_free_file_test(NULL);
 
 	mmc_unregister_driver(&mmc_driver);
 }
-- 
1.6.3.3

