Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2IYDzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 23:55:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34367 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab2IYDyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 23:54:52 -0400
Message-ID: <1348545276.18124.0.camel@phoenix>
Subject: [PATCH] memory: emif: Add ifdef CONFIG_DEBUG_FS guard for
 emif_debugfs_[init|exit]
From: Axel Lin <axel.lin@ingics.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Aneesh V <aneesh@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, linux-kernel@vger.kernel.org
Date: Tue, 25 Sep 2012 11:54:36 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ifdef CONFIG_DEBUG_FS guard for emif_debugfs_[init|exit], and adds stub
functions for the case CONFIG_DEBUG_FS is not set.

When CONFIG_DEBUG_FS is enabled, debugfs_create_dir and debugfs_create_file
return NULL on failure, fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/memory/emif.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 1424ae3..06d31c9 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -75,6 +75,7 @@ static unsigned long	irq_state;
 static u32		t_ck; /* DDR clock period in ps */
 static LIST_HEAD(device_list);
 
+#ifdef CONFIG_DEBUG_FS
 static void do_emif_regdump_show(struct seq_file *s, struct emif_data *emif,
 	struct emif_regs *regs)
 {
@@ -166,23 +167,23 @@ static int __init_or_module emif_debugfs_init(struct emif_data *emif)
 	int		ret;
 
 	dentry = debugfs_create_dir(dev_name(emif->dev), NULL);
-	if (IS_ERR(dentry)) {
-		ret = PTR_ERR(dentry);
+	if (!dentry) {
+		ret = -ENOMEM;
 		goto err0;
 	}
 	emif->debugfs_root = dentry;
 
 	dentry = debugfs_create_file("regcache_dump", S_IRUGO,
 			emif->debugfs_root, emif, &emif_regdump_fops);
-	if (IS_ERR(dentry)) {
-		ret = PTR_ERR(dentry);
+	if (!dentry) {
+		ret = -ENOMEM;
 		goto err1;
 	}
 
 	dentry = debugfs_create_file("mr4", S_IRUGO,
 			emif->debugfs_root, emif, &emif_mr4_fops);
-	if (IS_ERR(dentry)) {
-		ret = PTR_ERR(dentry);
+	if (!dentry) {
+		ret = -ENOMEM;
 		goto err1;
 	}
 
@@ -198,6 +199,16 @@ static void __exit emif_debugfs_exit(struct emif_data *emif)
 	debugfs_remove_recursive(emif->debugfs_root);
 	emif->debugfs_root = NULL;
 }
+#else
+static inline int __init_or_module emif_debugfs_init(struct emif_data *emif)
+{
+	return 0;
+}
+
+static inline void __exit emif_debugfs_exit(struct emif_data *emif)
+{
+}
+#endif
 
 /*
  * Calculate the period of DDR clock from frequency value
-- 
1.7.9.5



