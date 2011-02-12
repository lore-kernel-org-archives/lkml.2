Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab1BLRNq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:13:46 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65372 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab1BLRLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:11:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=wpXw5ZhLL7F4tPlFvXlbzc6gk/5vOjDbNrXxIctuYqsovR8DktDqflvEqq8Ao4yf5B
         WGVS5QYUR2ftp2KliZqA953ZQUntaiqExKa2vbH5DaosqBKthylRDI/REybGo2UQksZ4
         mdA9U3I/whiuJS8oUD22qAxK7dc7BT6e1FVdU=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 20/26] x86-64, NUMA: make numa_cleanup_meminfo() prettier
Date: Sat, 12 Feb 2011 18:10:57 +0100
Message-Id: <1297530663-26234-21-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297530663-26234-1-git-send-email-tj@kernel.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Factor out numa_remove_memblk_from().

* Hole detection doesn't need separate start/end.  Calculate start/end
  once.

* Relocate comment.

* Define iterators at the top and remove unnecessary prefix
  increments.

This prepares for further improvements to the function.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa_64.c |   36 +++++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 4f173a5..62ba1fd 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -230,6 +230,13 @@ int __init numa_add_memblk(int nid, u64 start, u64 end)
 	return 0;
 }
 
+static void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi)
+{
+	mi->nr_blks--;
+	memmove(&mi->blk[idx], &mi->blk[idx + 1],
+		(mi->nr_blks - idx) * sizeof(mi->blk[0]));
+}
+
 static __init void cutoff_node(int i, unsigned long start, unsigned long end)
 {
 	struct bootnode *nd = &numa_nodes[i];
@@ -294,25 +301,25 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 
 static int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 {
-	int i;
+	int i, j, k;
 
-	/*
-	 * Join together blocks on the same node, holes between
-	 * which don't overlap with memory on other nodes.
-	 */
-	for (i = 0; i < mi->nr_blks; ++i) {
+	for (i = 0; i < mi->nr_blks; i++) {
 		struct numa_memblk *bi = &mi->blk[i];
-		int j, k;
 
-		for (j = i + 1; j < mi->nr_blks; ++j) {
+		for (j = i + 1; j < mi->nr_blks; j++) {
 			struct numa_memblk *bj = &mi->blk[j];
 			unsigned long start, end;
 
+			/*
+			 * Join together blocks on the same node, holes
+			 * between which don't overlap with memory on other
+			 * nodes.
+			 */
 			if (bi->nid != bj->nid)
 				continue;
-			start = min(bi->end, bj->end);
-			end = max(bi->start, bj->start);
-			for (k = 0; k < mi->nr_blks; ++k) {
+			start = min(bi->start, bj->start);
+			end = max(bi->end, bj->end);
+			for (k = 0; k < mi->nr_blks; k++) {
 				struct numa_memblk *bk = &mi->blk[k];
 
 				if (bi->nid == bk->nid)
@@ -322,17 +329,12 @@ static int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 			}
 			if (k < mi->nr_blks)
 				continue;
-			start = min(bi->start, bj->start);
-			end = max(bi->end, bj->end);
 			printk(KERN_INFO "NUMA: Node %d [%Lx,%Lx) + [%Lx,%Lx) -> [%lx,%lx)\n",
 			       bi->nid, bi->start, bi->end, bj->start, bj->end,
 			       start, end);
 			bi->start = start;
 			bi->end = end;
-			k = --mi->nr_blks - j;
-			memmove(mi->blk + j, mi->blk + j + 1,
-				k * sizeof(mi->blk[0]));
-			--j;
+			numa_remove_memblk_from(j--, mi);
 		}
 	}
 
-- 
1.7.1

