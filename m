Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784Ab0JSD7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:59:16 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:35868 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933687Ab0JSD7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:59:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSoUAag
Message-Id: <20101019034657.793803593@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:38 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [patch 22/35] fs: icache per-cpu last_ino allocator
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-last_ino-percpu-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

new_inode() dirties a contended cache line to get increasing
inode numbers.

Solve this problem by providing to each cpu a per_cpu variable,
feeded by the shared last_ino, but once every 1024 allocations.
This reduces contention on the shared last_ino, and give same
spreading ino numbers than before (i.e. same wraparound after 2^32
allocations).

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/inode.c |   47 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 7 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:24.000000000 +1100
@@ -754,6 +754,45 @@
 }
 EXPORT_SYMBOL_GPL(inode_add_to_lists);
 
+#define LAST_INO_BATCH 1024
+
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
+
+static unsigned int get_next_ino(void)
+{
+	unsigned int res;
+
+	get_cpu();
+	res = __this_cpu_read(last_ino);
+#ifdef CONFIG_SMP
+	if (unlikely((res & (LAST_INO_BATCH - 1)) == 0)) {
+		static atomic_t shared_last_ino;
+		int next = atomic_add_return(LAST_INO_BATCH, &shared_last_ino);
+
+		res = next - LAST_INO_BATCH;
+	}
+#endif
+	res++;
+	__this_cpu_write(last_ino, res);
+	put_cpu();
+	return res;
+}
+
 /**
  *	new_inode 	- obtain an inode
  *	@sb: superblock
@@ -768,18 +807,12 @@
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
 		spin_lock(&inode->i_lock);
-		inode->i_ino = (unsigned int)atomic_inc_return(&last_ino);
+		inode->i_ino = get_next_ino();
 		inode->i_state = 0;
 		__inode_add_to_lists(sb, NULL, inode);
 		spin_unlock(&inode->i_lock);


