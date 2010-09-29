Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab0I2MVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:21:08 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:44274 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755634Ab0I2MTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:30 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/17] fs: inode per-cpu last_ino allocator
Date: Wed, 29 Sep 2010 22:18:47 +1000
Message-Id: <1285762729-17928-16-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>

last_ino was converted to an atomic variable to allow the inode_lock
to go away. However, contended atomics do not scale on large
machines, and new_inode() triggers excessive contention in such
situations.

Solve this problem by providing to each cpu a per_cpu variable,
feeded by the shared last_ino, but once every 1024 allocations.
This reduces contention on the shared last_ino, and give same
spreading ino numbers than before (i.e. same wraparound after 2^32
allocations).

[npiggin: some extra commenting and use of defines]

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |   50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index d279517..1388450 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -653,6 +653,48 @@ __inode_add_to_lists(struct super_block *sb, struct inode_hash_bucket *b,
 	}
 }
 
+#ifdef CONFIG_SMP
+#define LAST_INO_BATCH 1024
+/*
+ * Each cpu owns a range of LAST_INO_BATCH numbers.
+ * 'shared_last_ino' is dirtied only once out of LAST_INO_BATCH allocations,
+ * to renew the exhausted range.
+ *
+ * This does not significantly increase overflow rate because every CPU can
+ * consume at most LAST_INO_BATCH-1 unused inode numbers. So there is
+ * NR_CPUS*(LAST_INO_BATCH-1) wastage. At 4096 and 1024, this is ~0.1% of the
+ * 2^32 range, and is a worst-case. Even a 50% wastage would only increase
+ * overflow rate by 2x, which does not seem too significant.
+ *
+ * On a 32bit, non LFS stat() call, glibc will generate an EOVERFLOW
+ * error if st_ino won't fit in target struct field. Use 32bit counter
+ * here to attempt to avoid that.
+ */
+static DEFINE_PER_CPU(unsigned int, last_ino);
+static atomic_t shared_last_ino;
+
+static unsigned int last_ino_get(void)
+{
+	unsigned int *p = &get_cpu_var(last_ino);
+	unsigned int res = *p;
+
+	if (unlikely((res & (LAST_INO_BATCH-1)) == 0))
+		res = (unsigned int)atomic_add_return(LAST_INO_BATCH,
+				&shared_last_ino) - LAST_INO_BATCH;
+
+	*p = ++res;
+	put_cpu_var(last_ino);
+	return res;
+}
+#else
+static unsigned int last_ino_get(void)
+{
+	static unsigned int last_ino;
+
+	return ++last_ino;
+}
+#endif
+
 /**
  * inode_add_to_lists - add a new inode to relevant lists
  * @sb: superblock inode belongs to
@@ -690,19 +732,13 @@ EXPORT_SYMBOL_GPL(inode_add_to_lists);
  */
 struct inode *new_inode(struct super_block *sb)
 {
-	/*
-	 * On a 32bit, non LFS stat() call, glibc will generate an EOVERFLOW
-	 * error if st_ino won't fit in target struct field. Use 32bit counter
-	 * here to attempt to avoid that.
-	 */
-	static atomic_t last_ino = ATOMIC_INIT(0);
 	struct inode *inode;
 
 	inode = alloc_inode(sb);
 	if (inode) {
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
-		inode->i_ino = (unsigned int)atomic_inc_return(&last_ino);
+		inode->i_ino = last_ino_get();
 		inode->i_state = 0;
 		__inode_add_to_lists(sb, NULL, inode);
 		spin_unlock(&inode->i_lock);
-- 
1.7.1

