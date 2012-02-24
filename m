Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab2BXAEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 19:04:48 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9938 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400Ab2BXAEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 19:04:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 23 Feb 2012 16:04:44 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 3/3] pinctrl: Move pinctrl-maps debugfs file to top-level
Date: Thu, 23 Feb 2012 17:04:40 -0700
Message-ID: <1330041880-12406-3-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330041880-12406-1-git-send-email-swarren@nvidia.com>
References: <1330041880-12406-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debugfs file pinctrl-maps is a system-wide file, not specific to any
pin controller, so place it in the top-level directory.

Also, move the code implementing the file to keep the order of all the
functions matching the order they're created in pinctrl_init_*debugfs().
The only non-obvious change here is no private data is passed to
debugfs_create_file() or single_open().

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/core.c |   70 ++++++++++++++++++++++++------------------------
 1 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 633b97e..376cede 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -889,28 +889,6 @@ static int pinctrl_gpioranges_show(struct seq_file *s, void *what)
 	return 0;
 }
 
-static int pinctrl_maps_show(struct seq_file *s, void *what)
-{
-	struct pinctrl_maps *maps_node;
-	int i;
-	struct pinctrl_map const *map;
-
-	seq_puts(s, "Pinctrl maps:\n");
-
-	mutex_lock(&pinctrl_maps_mutex);
-	for_each_maps(maps_node, i, map) {
-		seq_printf(s, "%s:\n", map->name);
-		seq_printf(s, "  device: %s\n", map->dev_name);
-		seq_printf(s, "  controlling device %s\n", map->ctrl_dev_name);
-		seq_printf(s, "  function: %s\n", map->function);
-		seq_printf(s, "  group: %s\n", map->group ? map->group :
-			   "(default)");
-	}
-	mutex_unlock(&pinctrl_maps_mutex);
-
-	return 0;
-}
-
 static int pinmux_hogs_show(struct seq_file *s, void *what)
 {
 	struct pinctrl_dev *pctldev = s->private;
@@ -947,6 +925,28 @@ static int pinctrl_devices_show(struct seq_file *s, void *what)
 	return 0;
 }
 
+static int pinctrl_maps_show(struct seq_file *s, void *what)
+{
+	struct pinctrl_maps *maps_node;
+	int i;
+	struct pinctrl_map const *map;
+
+	seq_puts(s, "Pinctrl maps:\n");
+
+	mutex_lock(&pinctrl_maps_mutex);
+	for_each_maps(maps_node, i, map) {
+		seq_printf(s, "%s:\n", map->name);
+		seq_printf(s, "  device: %s\n", map->dev_name);
+		seq_printf(s, "  controlling device %s\n", map->ctrl_dev_name);
+		seq_printf(s, "  function: %s\n", map->function);
+		seq_printf(s, "  group: %s\n", map->group ? map->group :
+			   "(default)");
+	}
+	mutex_unlock(&pinctrl_maps_mutex);
+
+	return 0;
+}
+
 static int pinctrl_show(struct seq_file *s, void *what)
 {
 	struct pinctrl *p;
@@ -988,11 +988,6 @@ static int pinctrl_gpioranges_open(struct inode *inode, struct file *file)
 	return single_open(file, pinctrl_gpioranges_show, inode->i_private);
 }
 
-static int pinctrl_maps_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pinctrl_maps_show, inode->i_private);
-}
-
 static int pinmux_hogs_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, pinmux_hogs_show, inode->i_private);
@@ -1003,6 +998,11 @@ static int pinctrl_devices_open(struct inode *inode, struct file *file)
 	return single_open(file, pinctrl_devices_show, NULL);
 }
 
+static int pinctrl_maps_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinctrl_maps_show, NULL);
+}
+
 static int pinctrl_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, pinctrl_show, NULL);
@@ -1029,22 +1029,22 @@ static const struct file_operations pinctrl_gpioranges_ops = {
 	.release	= single_release,
 };
 
-static const struct file_operations pinctrl_maps_ops = {
-	.open		= pinctrl_maps_open,
+static const struct file_operations pinmux_hogs_ops = {
+	.open		= pinmux_hogs_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= single_release,
 };
 
-static const struct file_operations pinmux_hogs_ops = {
-	.open		= pinmux_hogs_open,
+static const struct file_operations pinctrl_devices_ops = {
+	.open		= pinctrl_devices_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= single_release,
 };
 
-static const struct file_operations pinctrl_devices_ops = {
-	.open		= pinctrl_devices_open,
+static const struct file_operations pinctrl_maps_ops = {
+	.open		= pinctrl_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= single_release,
@@ -1078,8 +1078,6 @@ static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
 			    device_root, pctldev, &pinctrl_groups_ops);
 	debugfs_create_file("gpio-ranges", S_IFREG | S_IRUGO,
 			    device_root, pctldev, &pinctrl_gpioranges_ops);
-	debugfs_create_file("pinctrl-maps", S_IFREG | S_IRUGO,
-			    device_root, pctldev, &pinctrl_maps_ops);
 	debugfs_create_file("pinmux-hogs", S_IFREG | S_IRUGO,
 			    device_root, pctldev, &pinmux_hogs_ops);
 	pinmux_init_device_debugfs(device_root, pctldev);
@@ -1102,6 +1100,8 @@ static void pinctrl_init_debugfs(void)
 
 	debugfs_create_file("pinctrl-devices", S_IFREG | S_IRUGO,
 			    debugfs_root, NULL, &pinctrl_devices_ops);
+	debugfs_create_file("pinctrl-maps", S_IFREG | S_IRUGO,
+			    debugfs_root, NULL, &pinctrl_maps_ops);
 	debugfs_create_file("pinctrl-handles", S_IFREG | S_IRUGO,
 			    debugfs_root, NULL, &pinctrl_ops);
 }
-- 
1.7.0.4

