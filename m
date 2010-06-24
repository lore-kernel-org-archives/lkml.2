Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab0FXD0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:26:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629Ab0FXDPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:55 -0400
Message-Id: <20100624030732.402670838@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:54 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: [patch 42/52] fs: icache per-cpu last_ino allocator
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-last_ino-percpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>

new_inode() dirties a contended cache line to get increasing inode numbers.

Solve this problem by providing to each cpu a per_cpu variable, feeded by the
shared last_ino, but once every 1024 allocations.

This reduce contention on the shared last_ino, and give same spreading ino
numbers than before.  (same wraparound after 2^32 allocations)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/inode.c |   42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -664,6 +664,40 @@ __inode_add_to_lists(struct super_block
 	}
 }
 
+#ifdef CONFIG_SMP
+/*
+ * Each cpu owns a range of 1024 numbers.
+ * 'shared_last_ino' is dirtied only once out of 1024 allocations,
+ * to renew the exhausted range.
+ *
+ * On a 32bit, non LFS stat() call, glibc will generate an EOVERFLOW
+ * error if st_ino won't fit in target struct field. Use 32bit counter
+ * here to attempt to avoid that.
+ */
+static DEFINE_PER_CPU(int, last_ino);
+static atomic_t shared_last_ino;
+
+static int last_ino_get(void)
+{
+	int *p = &get_cpu_var(last_ino);
+	int res = *p;
+
+	if (unlikely((res & 1023) == 0))
+		res = atomic_add_return(1024, &shared_last_ino) - 1024;
+
+	*p = ++res;
+	put_cpu_var(last_ino);
+	return res;
+}
+#else
+static int last_ino_get(void)
+{
+	static int last_ino;
+
+	return ++last_ino;
+}
+#endif
+
 /**
  * inode_add_to_lists - add a new inode to relevant lists
  * @sb: superblock inode belongs to
@@ -700,19 +734,13 @@ EXPORT_SYMBOL_GPL(inode_add_to_lists);
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
 		/* XXX: init as locked for speedup */
 		spin_lock(&inode->i_lock);
-		inode->i_ino = atomic_inc_return(&last_ino);
+		inode->i_ino = last_ino_get();
 		inode->i_state = 0;
 		__inode_add_to_lists(sb, NULL, inode);
 		spin_unlock(&inode->i_lock);


