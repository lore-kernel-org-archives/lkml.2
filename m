Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab0JLPRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:17:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46690 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab0JLPRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:17:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dcXpKhPMY0Ohr5oeypI/wP6jjoHdvmNWl3B3kqbiO83c7X/UPNpeqCnIRHAqFF1jOK
         y+X87c67zKvlQDE5A6rP4/SuSGch39SFGkvjUPxJkdZV1o3UypxUJRxOF0NYPNdA3ovM
         GsVUaN5cWjYtE5Fmkm1YcF8laY9GtJoGmIKfs=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH] mmc: append a file to change host clock at run time
Date: Tue, 12 Oct 2010 18:17:22 +0300
Message-Id: <1286896642-27772-1-git-send-email-ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For debugging power managment features there is quite convenient to have a
possibility to change MMC host controller clock at run time. This patch adds
'clock' file under MMC host root of debugfs.

Usage as follows:

	# cat /sys/kernel/debug/mmc0/clock
	24000000

	# echo "1000000000" > /sys/kernel/debug/mmc0/clock
	# cat /sys/kernel/debug/mmc0/clock
	52000000

	# echo "48000000" > /sys/kernel/debug/mmc0/clock
	# cat /sys/kernel/debug/mmc0/clock
	48000000

The second piece of example shows limits which are applied accordingly to used
host driver.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/mmc/core/debugfs.c |   33 +++++++++++++++++++++++++++++++--
 1 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
index 96d10f4..4ff109f 100644
--- a/drivers/mmc/core/debugfs.c
+++ b/drivers/mmc/core/debugfs.c
@@ -133,6 +133,31 @@ static const struct file_operations mmc_ios_fops = {
 	.release	= single_release,
 };
 
+static int mmc_clock_opt_get(void *data, u64 *val)
+{
+	struct mmc_host *host = data;
+
+	*val = host->ios.clock;
+
+	return 0;
+}
+
+static int mmc_clock_opt_set(void *data, u64 val)
+{
+	struct mmc_host *host = data;
+
+	/* We need this check due to input value is u64 */
+	if (val > host->f_max)
+		return -EINVAL;
+
+	mmc_set_clock(host, (unsigned int) val);
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(mmc_clock_fops, mmc_clock_opt_get, mmc_clock_opt_set,
+	"%llu\n");
+
 void mmc_add_host_debugfs(struct mmc_host *host)
 {
 	struct dentry *root;
@@ -149,11 +174,15 @@ void mmc_add_host_debugfs(struct mmc_host *host)
 	host->debugfs_root = root;
 
 	if (!debugfs_create_file("ios", S_IRUSR, root, host, &mmc_ios_fops))
-		goto err_ios;
+		goto err_node;
+
+	if (!debugfs_create_file("clock", S_IRUSR | S_IWUSR, root, host,
+			&mmc_clock_fops))
+		goto err_node;
 
 	return;
 
-err_ios:
+err_node:
 	debugfs_remove_recursive(root);
 	host->debugfs_root = NULL;
 err_root:
-- 
1.6.3.3

