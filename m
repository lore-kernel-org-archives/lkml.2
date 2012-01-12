Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab2ALUjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:39:03 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:50301 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab2ALUi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:38:57 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Jan Beulich <JBeulich@novell.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nitin Gupta <ngupta@vflare.org>,
        Matthew Wilcox <matthew@wil.cx>, Chris Mason <chris.mason@oracle.com>,
        Rik Riel <riel@redhat.com>
Subject: [PATCH 3/4] mm: cleancache: report statistics via debugfs instead of sysfs.
Date: Thu, 12 Jan 2012 15:36:19 -0500
Message-Id: <1326400580-16853-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1326400580-16853-1-git-send-email-konrad.wilk@oracle.com>
References: <1326400580-16853-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F0F44BB.0052,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Magenheimer <dan.magenheimer@oracle.com>

[v9: akpm@linux-foundation.org: sysfs->debugfs; no longer need Doc/ABI file]

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Reviewed-by: Konrad Wilk <konrad.wilk@oracle.com>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Rik Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 .../ABI/testing/sysfs-kernel-mm-cleancache         |   11 ---
 Documentation/vm/cleancache.txt                    |    4 +-
 mm/cleancache.c                                    |   68 ++++++-------------
 3 files changed, 24 insertions(+), 59 deletions(-)
 delete mode 100644 Documentation/ABI/testing/sysfs-kernel-mm-cleancache

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-cleancache b/Documentation/ABI/testing/sysfs-kernel-mm-cleancache
deleted file mode 100644
index 662ae64..0000000
--- a/Documentation/ABI/testing/sysfs-kernel-mm-cleancache
+++ /dev/null
@@ -1,11 +0,0 @@
-What:		/sys/kernel/mm/cleancache/
-Date:		April 2011
-Contact:	Dan Magenheimer <dan.magenheimer@oracle.com>
-Description:
-		/sys/kernel/mm/cleancache/ contains a number of files which
-		record a count of various cleancache operations
-		(sum across all filesystems):
-			succ_gets
-			failed_gets
-			puts
-			flushes
diff --git a/Documentation/vm/cleancache.txt b/Documentation/vm/cleancache.txt
index e0a5356..f726717 100644
--- a/Documentation/vm/cleancache.txt
+++ b/Documentation/vm/cleancache.txt
@@ -84,8 +84,8 @@ lock the page to ensure serial behavior.
 
 CLEANCACHE PERFORMANCE METRICS
 
-Cleancache monitoring is done by sysfs files in the
-/sys/kernel/mm/cleancache directory.  The effectiveness of cleancache
+If properly configured, monitoring of cleancache is done via debugfs in
+the /sys/kernel/debug/mm/cleancache directory.  The effectiveness of cleancache
 can be measured (across all filesystems) with:
 
 succ_gets	- number of gets that were successful
diff --git a/mm/cleancache.c b/mm/cleancache.c
index b9c198b..deb9f2c 100644
--- a/mm/cleancache.c
+++ b/mm/cleancache.c
@@ -15,6 +15,7 @@
 #include <linux/fs.h>
 #include <linux/exportfs.h>
 #include <linux/mm.h>
+#include <linux/debugfs.h>
 #include <linux/cleancache.h>
 
 /*
@@ -33,11 +34,15 @@ EXPORT_SYMBOL(cleancache_enabled);
  */
 static struct cleancache_ops cleancache_ops;
 
-/* useful stats available in /sys/kernel/mm/cleancache */
-static unsigned long cleancache_succ_gets;
-static unsigned long cleancache_failed_gets;
-static unsigned long cleancache_puts;
-static unsigned long cleancache_flushes;
+/*
+ * Counters available via /sys/kernel/debug/frontswap (if debugfs is
+ * properly configured.  These are for information only so are not protected
+ * against increment races.
+ */
+static u64 cleancache_succ_gets;
+static u64 cleancache_failed_gets;
+static u64 cleancache_puts;
+static u64 cleancache_invalidates;
 
 /*
  * register operations for cleancache, returning previous thus allowing
@@ -163,7 +168,7 @@ void __cleancache_invalidate_page(struct address_space *mapping,
 		if (cleancache_get_key(mapping->host, &key) >= 0) {
 			(*cleancache_ops.invalidate_page)(pool_id,
 							  key, page->index);
-			cleancache_flushes++;
+			cleancache_invalidates++;
 		}
 	}
 }
@@ -199,48 +204,19 @@ void __cleancache_invalidate_fs(struct super_block *sb)
 }
 EXPORT_SYMBOL(__cleancache_invalidate_fs);
 
-#ifdef CONFIG_SYSFS
-
-/* see Documentation/ABI/xxx/sysfs-kernel-mm-cleancache */
-
-#define CLEANCACHE_SYSFS_RO(_name) \
-	static ssize_t cleancache_##_name##_show(struct kobject *kobj, \
-				struct kobj_attribute *attr, char *buf) \
-	{ \
-		return sprintf(buf, "%lu\n", cleancache_##_name); \
-	} \
-	static struct kobj_attribute cleancache_##_name##_attr = { \
-		.attr = { .name = __stringify(_name), .mode = 0444 }, \
-		.show = cleancache_##_name##_show, \
-	}
-
-CLEANCACHE_SYSFS_RO(succ_gets);
-CLEANCACHE_SYSFS_RO(failed_gets);
-CLEANCACHE_SYSFS_RO(puts);
-CLEANCACHE_SYSFS_RO(flushes);
-
-static struct attribute *cleancache_attrs[] = {
-	&cleancache_succ_gets_attr.attr,
-	&cleancache_failed_gets_attr.attr,
-	&cleancache_puts_attr.attr,
-	&cleancache_flushes_attr.attr,
-	NULL,
-};
-
-static struct attribute_group cleancache_attr_group = {
-	.attrs = cleancache_attrs,
-	.name = "cleancache",
-};
-
-#endif /* CONFIG_SYSFS */
-
 static int __init init_cleancache(void)
 {
-#ifdef CONFIG_SYSFS
-	int err;
-
-	err = sysfs_create_group(mm_kobj, &cleancache_attr_group);
-#endif /* CONFIG_SYSFS */
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *root = debugfs_create_dir("cleancache", NULL);
+	if (root == NULL)
+		return -ENXIO;
+	debugfs_create_u64("succ_gets", S_IRUGO, root, &cleancache_succ_gets);
+	debugfs_create_u64("failed_gets", S_IRUGO,
+				root, &cleancache_failed_gets);
+	debugfs_create_u64("puts", S_IRUGO, root, &cleancache_puts);
+	debugfs_create_u64("invalidates", S_IRUGO,
+				root, &cleancache_invalidates);
+#endif
 	return 0;
 }
 module_init(init_cleancache)
-- 
1.7.7.4

