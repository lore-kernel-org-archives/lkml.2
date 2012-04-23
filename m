Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab2DWSu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:50:28 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:61263 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2DWSu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:50:27 -0400
From: Sasikanth V <sasikanth.v19@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasikanth V <sasikanth.v19@gmail.com>
Subject: [PATCH] mm:vmstat - Removed debug fs entries on failure of file creation and made extfrag_debug_root dentry local
Date: Tue, 24 Apr 2012 00:20:12 +0530
Message-Id: <1335207012-25133-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed debug fs files and directory on failure. Since no one using "extfrag_debug_root" dentry outside of function
extfrag_debug_init made it local to the function.

Signed-off-by: Sasikanth V <sasikanth.v19@gmail.com>
---
 mm/vmstat.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index f600557..ddae476 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1220,7 +1220,6 @@ module_init(setup_vmstat)
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_COMPACTION)
 #include <linux/debugfs.h>
 
-static struct dentry *extfrag_debug_root;
 
 /*
  * Return an index indicating how much of the available free memory is
@@ -1358,17 +1357,23 @@ static const struct file_operations extfrag_file_ops = {
 
 static int __init extfrag_debug_init(void)
 {
+	struct dentry *extfrag_debug_root;
+
 	extfrag_debug_root = debugfs_create_dir("extfrag", NULL);
 	if (!extfrag_debug_root)
 		return -ENOMEM;
 
 	if (!debugfs_create_file("unusable_index", 0444,
-			extfrag_debug_root, NULL, &unusable_file_ops))
+			extfrag_debug_root, NULL, &unusable_file_ops)) {
+		debugfs_remove (extfrag_debug_root);
 		return -ENOMEM;
+	}
 
 	if (!debugfs_create_file("extfrag_index", 0444,
-			extfrag_debug_root, NULL, &extfrag_file_ops))
+			extfrag_debug_root, NULL, &extfrag_file_ops)) {
+		debugfs_remove_recursive (extfrag_debug_root);
 		return -ENOMEM;
+	}
 
 	return 0;
 }
-- 
1.7.3.4

