Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676Ab1FUXll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:41:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65291 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab1FUXjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:39:53 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, Venkatraman S <svenkatr@ti.com>
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v7 04/11] mmc: mmc_test: add debugfs file to list all tests
Date: Wed, 22 Jun 2011 01:38:34 +0200
Message-Id: <1308699521-20556-5-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308699521-20556-1-git-send-email-per.forlin@linaro.org>
References: <1308699521-20556-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a debugfs file "testlist" to print all available tests

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/card/mmc_test.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index 233cdfa..e8508e9 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -2445,6 +2445,32 @@ static const struct file_operations mmc_test_fops_test = {
 	.release	= single_release,
 };
 
+static int mtf_testlist_show(struct seq_file *sf, void *data)
+{
+	int i;
+
+	mutex_lock(&mmc_test_lock);
+
+	for (i = 0; i < ARRAY_SIZE(mmc_test_cases); i++)
+		seq_printf(sf, "%d:\t%s\n", i+1, mmc_test_cases[i].name);
+
+	mutex_unlock(&mmc_test_lock);
+
+	return 0;
+}
+
+static int mtf_testlist_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mtf_testlist_show, inode->i_private);
+}
+
+static const struct file_operations mmc_test_fops_testlist = {
+	.open		= mtf_testlist_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static void mmc_test_free_file_test(struct mmc_card *card)
 {
 	struct mmc_test_dbgfs_file *df, *dfs;
@@ -2476,7 +2502,18 @@ static int mmc_test_register_file_test(struct mmc_card *card)
 
 	if (IS_ERR_OR_NULL(file)) {
 		dev_err(&card->dev,
-			"Can't create file. Perhaps debugfs is disabled.\n");
+			"Can't create test. Perhaps debugfs is disabled.\n");
+		ret = -ENODEV;
+		goto err;
+	}
+
+	if (card->debugfs_root)
+		file = debugfs_create_file("testlist", S_IRUGO,
+			card->debugfs_root, card, &mmc_test_fops_testlist);
+
+	if (IS_ERR_OR_NULL(file)) {
+		dev_err(&card->dev,
+			"Can't create testlist. Perhaps debugfs is disabled.\n");
 		ret = -ENODEV;
 		goto err;
 	}
-- 
1.7.4.1

