Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0JPIPP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 04:15:15 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:51650 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753759Ab0JPIPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 04:15:09 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/19] fs: introduce a per-cpu last_ino allocator
Date: Sat, 16 Oct 2010 19:14:08 +1100
Message-Id: <1287216853-17634-15-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287216853-17634-1-git-send-email-david@fromorbit.com>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

new_inode() dirties a contended cache line to get increasing
inode numbers. This limits performance on workloads that cause
significant parallel inode allocation.

Solve this problem by using a per_cpu variable fed by the shared
last_ino in batches of 1024 allocations.  This reduces contention on
the shared last_ino, and give same spreading ino numbers than before
(i.e. same wraparound after 2^32 allocations).

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/inode.c |   45 ++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 1ac9a61..05852a1 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -850,6 +850,43 @@ void inode_add_to_lists(struct super_block *sb, struct inode *inode)
 }
 EXPORT_SYMBOL_GPL(inode_add_to_lists);
 
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
+#define LAST_INO_BATCH 1024
+static DEFINE_PER_CPU(unsigned int, last_ino);
+
+static unsigned int get_next_ino(void)
+{
+	unsigned int *p = &get_cpu_var(last_ino);
+	unsigned int res = *p;
+
+#ifdef CONFIG_SMP
+	if (unlikely((res & (LAST_INO_BATCH-1)) == 0)) {
+		static atomic_t shared_last_ino;
+		int next = atomic_add_return(LAST_INO_BATCH, &shared_last_ino);
+
+		res = next - LAST_INO_BATCH;
+	}
+#endif
+
+	*p = ++res;
+	put_cpu_var(last_ino);
+	return res;
+}
+
 /**
  *	new_inode 	- obtain an inode
  *	@sb: superblock
@@ -864,12 +901,6 @@ EXPORT_SYMBOL_GPL(inode_add_to_lists);
  */
 struct inode *new_inode(struct super_block *sb)
 {
-	/*
-	 * On a 32bit, non LFS stat() call, glibc will generate an EOVERFLOW
-	 * error if st_ino won't fit in target struct field. Use 32bit counter
-	 * here to attempt to avoid that.
-	 */
-	static unsigned int last_ino;
 	struct inode *inode;
 
 	spin_lock_prefetch(&inode_lock);
@@ -882,7 +913,7 @@ struct inode *new_inode(struct super_block *sb)
 		 * set the inode state before we make the inode accessible to
 		 * the outside world.
 		 */
-		inode->i_ino = ++last_ino;
+		inode->i_ino = get_next_ino();
 		inode->i_state = 0;
 		__inode_add_to_lists(sb, NULL, inode);
 		spin_unlock(&inode_lock);
-- 
1.7.1

