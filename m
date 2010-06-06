Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129Ab0FFO47 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:56:59 -0400
Received: from smtp.nokia.com ([192.100.122.233]:50188 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957Ab0FFOx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:27 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCHv5 04/16] VFS: add memory barrier to sb_mark_clean and sb_mark_dirty
Date: Sun,  6 Jun 2010 17:50:17 +0300
Message-Id: <1275835829-1478-5-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 06 Jun 2010 14:53:16.0912 (UTC) FILETIME=[FF1EBF00:01CB0587]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

The proper way for file-systems to synchronize the superblock
should be as follows:

1. when modifying the SB, first modify it, then mark it as dirty;
2. when synchronizing the SB, first mark as clean, then start
   synchronizing.

And to make ensure the order, we need memory barriers in 'sb_mark_clean()'
and 'sb_mark_dirty()'.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 include/linux/fs.h |   14 ++++++++++++++
 mm/backing-dev.c   |    5 +++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index ca1e993..3acaccf 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1783,10 +1783,24 @@ extern int get_sb_pseudo(struct file_system_type *, char *,
 	struct vfsmount *mnt);
 extern void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
 
+/*
+ * The SB clean/dirty state manipulations should be done as follows:
+ * 1. modification: first modify the SB-related data, then mark the SB as
+ *    dirty;
+ * 2. synchronization: first mark the SB as clean, then start synchronizing it.
+ *
+ * This order makes sure that races are harmless and we never end up in a
+ * situation when the SB is modified but is nevertheless marked as clean.
+ */
 void sb_mark_dirty(struct super_block *sb);
 static inline void sb_mark_clean(struct super_block *sb)
 {
 	sb->s_dirty = 0;
+	/*
+	 * Normally FSes first unset the sb->s_dirty flag, and then start
+	 * synchronizing the SB. The memory barrier ensures this order.
+	 */
+	smp_mb();
 }
 static inline int sb_is_dirty(struct super_block *sb)
 {
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index d751284..d861bd4 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -352,6 +352,11 @@ static void bdi_flush_io(struct backing_dev_info *bdi)
 
 void sb_mark_dirty(struct super_block *sb)
 {
+	/*
+	 * Normally FSes modify the SB, and then mark it as dirty. The memory
+	 * barrier ensures this order.
+	 */
+	smp_mb();
 	sb->s_dirty = 1;
 	/*
 	 * sb->s_dirty store must be visible to sync_supers before we load
-- 
1.7.0.1

