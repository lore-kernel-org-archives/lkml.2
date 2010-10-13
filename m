Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab0JMIWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 04:22:37 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64946 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab0JMIWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 04:22:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PAmPP4fexOb2+Tx+6nhSzZpUv0LkXW63yDyjXRYcyCeJUkAs3/pXEuVvjAcY2ELkD9
         uH3EhQ1hi+b6ARODN+RVcLhnTgQcBgSY82SNIc25FIMmozh+ScqhTEPhvQxO9Q7Jvqz1
         Pu+v9Ufm6WUG9+lzFkwPAMxYD5Ti9vPl0vNFI=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCHv2] mmc: append a file to change host clock at run time
Date: Wed, 13 Oct 2010 11:22:22 +0300
Message-Id: <1286958142-22461-1-git-send-email-ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <4CB568C0.9030906@nokia.com>
References: <4CB568C0.9030906@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For debugging power managment features there is quite convenient to have a
possibility to change MMC host controller clock at run time. This patch adds
'clock' file under MMC host root of debugfs.

Usage as follows:

	# cat /sys/kernel/debug/mmc0/clock
	52000000

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
 drivers/mmc/core/debugfs.c |   35 +++++++++++++++++++++++++++++++++--
 1 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
index 96d10f4..9b6ec07 100644
--- a/drivers/mmc/core/debugfs.c
+++ b/drivers/mmc/core/debugfs.c
@@ -133,6 +133,33 @@ static const struct file_operations mmc_ios_fops = {
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
+	mmc_claim_host(host);
+	mmc_set_clock(host, (unsigned int) val);
+	mmc_release_host(host);
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
@@ -149,11 +176,15 @@ void mmc_add_host_debugfs(struct mmc_host *host)
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

