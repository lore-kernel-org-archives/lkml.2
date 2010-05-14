Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab0ENHYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 03:24:47 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:46930 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757654Ab0ENHYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 03:24:44 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 4/5] superblock: add filesystem shrinker operations
Date: Fri, 14 May 2010 17:24:22 +1000
Message-Id: <1273821863-29524-5-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273821863-29524-1-git-send-email-david@fromorbit.com>
References: <1273821863-29524-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now we have a per-superblock shrinker implementation, we can add a
filesystem specific callout to it to allow filesystem internal
caches to be shrunk by the superblock shrinker.

Rather than perpetuate the multipurpose shrinker callback API (i.e.
nr_to_scan == 0 meaning "tell me how many objects freeable in the
cache), two operations will be added. The first will return the
number of objects that are freeable, the second is the actual
shrinker call.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/super.c         |   43 +++++++++++++++++++++++++++++++------------
 include/linux/fs.h |   11 +++++++++++
 2 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 339b590..e98292e 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -48,7 +48,8 @@ DEFINE_SPINLOCK(sb_lock);
 static int prune_super(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
 {
 	struct super_block *sb;
-	int count;
+	int	fs_objects = 0;
+	int	total_objects;
 
 	sb = container_of(shrink, struct super_block, s_shrink);
 
@@ -71,22 +72,40 @@ static int prune_super(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
 		return -1;
 	}
 
-	if (nr_to_scan) {
-		/* proportion the scan between the two cacheѕ */
-		int total;
-
-		total = sb->s_nr_dentry_unused + sb->s_nr_inodes_unused + 1;
-		count = (nr_to_scan * sb->s_nr_dentry_unused) / total;
+	if (sb->s_op && sb->s_op->nr_cached_objects)
+		fs_objects = sb->s_op->nr_cached_objects(sb);
 
-		/* prune dcache first as icache is pinned by it */
-		prune_dcache_sb(sb, count);
-		prune_icache_sb(sb, nr_to_scan - count);
+	total_objects = sb->s_nr_dentry_unused +
+			sb->s_nr_inodes_unused + fs_objects + 1;
+	if (nr_to_scan) {
+		int	dentries;
+		int	inodes;
+
+		/* proportion the scan between the cacheѕ */
+		dentries = (nr_to_scan * sb->s_nr_dentry_unused) /
+							total_objects;
+		inodes = (nr_to_scan * sb->s_nr_inodes_unused) /
+							total_objects;
+		if (fs_objects)
+			fs_objects = (nr_to_scan * fs_objects) /
+							total_objects;
+		/*
+		 * prune the dcache first as the icache is pinned by it, then
+		 * prune the icache, followed by the filesystem specific caches
+		 */
+		prune_dcache_sb(sb, dentries);
+		prune_icache_sb(sb, inodes);
+		if (sb->s_op && sb->s_op->free_cached_objects) {
+			sb->s_op->free_cached_objects(sb, fs_objects);
+			fs_objects = sb->s_op->nr_cached_objects(sb);
+		}
+		total_objects = sb->s_nr_dentry_unused +
+				sb->s_nr_inodes_unused + fs_objects;
 	}
 
-	count = ((sb->s_nr_dentry_unused + sb->s_nr_inodes_unused) / 100)
-						* sysctl_vfs_cache_pressure;
+	total_objects = (total_objects / 100) * sysctl_vfs_cache_pressure;
 	up_read(&sb->s_umount);
-	return count;
+	return total_objects;
 }
 
 /**
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6ba3739..ef2e9e2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1591,6 +1591,17 @@ struct super_operations {
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
+
+	/*
+	 * memory shrinker operations.
+	 * ->nr_cached_objects() should return the number of freeable cached
+	 * objects the filesystem holds.
+	 * ->free_cache_objects() should attempt to free the number of cached
+	 * objects indicated. It should return how many objects it attempted to
+	 * free.
+	 */
+	int (*nr_cached_objects)(struct super_block *);
+	int (*free_cached_objects)(struct super_block *, int);
 };
 
 /*
-- 
1.5.6.5

