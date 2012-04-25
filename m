Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493Ab2DYT67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 15:58:59 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:40881 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758289Ab2DYT66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 15:58:58 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Curt Wohlgemuth <curtw@google.com>, Mike Frysinger <vapier@gentoo.org>,
        Jens Axboe <axboe@kernel.dk>, Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH 1/2] mm: backing-dev - Removed debug_stats entry from backing_dev_info and handled debug fs failue cases
Date: Thu, 26 Apr 2012 01:28:34 +0530
Message-Id: <1335383914-19371-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1)  "stats" file part of "bdi->debug_dir" directory we dont have to maintain, especially 
    for removal purpose (directory recursive removal is will do), another dentry for "stats" file
    in backing_dev_info.

2)  Handled failure casess of debug fs entry creation 


Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 include/linux/backing-dev.h |    1 -
 mm/backing-dev.c            |   15 ++++++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index b1038bd..a9ad582 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -106,7 +106,6 @@ struct backing_dev_info {
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debug_dir;
-	struct dentry *debug_stats;
 #endif
 };
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index dd8e2aa..00ee55c 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -136,15 +136,20 @@ static const struct file_operations bdi_debug_stats_fops = {
 
 static void bdi_debug_register(struct backing_dev_info *bdi, const char *name)
 {
-	bdi->debug_dir = debugfs_create_dir(name, bdi_debug_root);
-	bdi->debug_stats = debugfs_create_file("stats", 0444, bdi->debug_dir,
-					       bdi, &bdi_debug_stats_fops);
+	if (bdi_debug_root) {
+
+		bdi->debug_dir = debugfs_create_dir(name, bdi_debug_root);
+
+		if (bdi->debug_dir)
+			debugfs_create_file("stats", 0444, bdi->debug_dir, bdi,
+					    &bdi_debug_stats_fops);
+	}
 }
 
 static void bdi_debug_unregister(struct backing_dev_info *bdi)
 {
-	debugfs_remove(bdi->debug_stats);
-	debugfs_remove(bdi->debug_dir);
+	if (bdi->debug_dir)
+		debugfs_remove_recursive(bdi->debug_dir);
 }
 #else
 static inline void bdi_debug_init(void)
-- 
1.7.3.4

