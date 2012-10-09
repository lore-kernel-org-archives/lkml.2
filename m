Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab2JIWtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 18:49:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41307 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755016Ab2JIWtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 18:49:49 -0400
Date: Tue, 9 Oct 2012 23:49:46 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] firmware: Convert firmware path setup from an array to
	a list
Message-ID: <20121009224946.GA2285@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to support dynamic listing/updating of firmware
paths via procfs, this patch converts the firmware path configuration
from an array to a list.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/firmware_class.c | 72 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 64 insertions(+), 8 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8154145..2153eab 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -36,13 +36,13 @@ MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
 MODULE_LICENSE("GPL");
 
-static const char *fw_path[] = {
-	"/lib/firmware/updates/" UTS_RELEASE,
-	"/lib/firmware/updates",
-	"/lib/firmware/" UTS_RELEASE,
-	"/lib/firmware"
+struct fw_path_rec {
+	const char *name;
+	struct list_head list;
 };
 
+static LIST_HEAD(fw_path_list);
+
 /* Don't inline this: 'struct kstat' is biggish */
 static noinline long fw_file_size(struct file *file)
 {
@@ -78,13 +78,14 @@ static bool fw_read_file_contents(struct file *file, struct firmware *fw)
 
 static bool fw_get_filesystem_firmware(struct firmware *fw, const char *name)
 {
-	int i;
 	bool success = false;
 	char *path = __getname();
+	struct fw_path_rec *fwp;
 
-	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
+	list_for_each_entry(fwp, &fw_path_list, list) {
 		struct file *file;
-		snprintf(path, PATH_MAX, "%s/%s", fw_path[i], name);
+		snprintf(path, PATH_MAX, "%s/%s", fwp->name,
+			 name);
 
 		file = filp_open(path, O_RDONLY, 0);
 		if (IS_ERR(file))
@@ -1385,6 +1386,50 @@ static int fw_cache_piggyback_on_request(const char *name)
 }
 #endif
 
+static void fw_free_path_list(void)
+{
+	struct fw_path_rec *fwp;
+
+	while (!list_empty(&fw_path_list)) {
+		fwp = list_first_entry(&fw_path_list,
+				       struct fw_path_rec,
+				       list);
+		kfree(fwp->name);
+		list_del(&fwp->list);
+		kfree(fwp);
+	}
+}
+
+static int fw_populate_path_list(void)
+{
+	int i;
+	struct fw_path_rec *fwp;
+	static const char *fw_path[] = {
+		"/lib/firmware/updates/" UTS_RELEASE,
+		"/lib/firmware/updates",
+		"/lib/firmware/" UTS_RELEASE,
+		"/lib/firmware"
+	};
+
+	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
+		fwp = kmalloc(sizeof(*fwp), GFP_KERNEL);
+		if (!fwp)
+			goto err_fwp_alloc;
+		fwp->name = kstrdup(fw_path[i], GFP_KERNEL);
+		if (!fwp->name)
+			goto err_fwp_name_alloc;
+		list_add_tail(&fwp->list, &fw_path_list);
+	}
+
+	return 0;
+
+err_fwp_name_alloc:
+	kfree(fwp);
+err_fwp_alloc:
+	fw_free_path_list();
+	return -ENOMEM;
+}
+
 static void __init fw_cache_init(void)
 {
 	spin_lock_init(&fw_cache.lock);
@@ -1409,7 +1454,17 @@ static void __init fw_cache_init(void)
 
 static int __init firmware_class_init(void)
 {
+	int ret;
+
 	fw_cache_init();
+
+	ret = fw_populate_path_list();
+	if (ret < 0) {
+		pr_err("%s: Failed to populate firmware path list: %d\n",
+		       __func__, ret);
+		return ret;
+	}
+
 	return class_register(&firmware_class);
 }
 
@@ -1419,6 +1474,7 @@ static void __exit firmware_class_exit(void)
 	unregister_syscore_ops(&fw_syscore_ops);
 	unregister_pm_notifier(&fw_cache.pm_notify);
 #endif
+	fw_free_path_list();
 	class_unregister(&firmware_class);
 }
 
-- 
1.7.12.2

