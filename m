Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab2EaOjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:39:25 -0400
Received: from relay2.sgi.com ([192.48.179.30]:48222 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932072Ab2EaOjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:39:22 -0400
Date: Thu, 31 May 2012 09:39:17 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: hughd@google.com, npiggin@gmail.com, cl@linux.com, lee.schermerhorn@hp.com,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
        riel@redhat.com
Subject: [PATCH v2] tmpfs not interleaving properly
Message-ID: <20120531143916.GA16162@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When tmpfs has the memory policy interleaved it always starts allocating at each
file at node 0.  When there are many small files the lower nodes fill up
disproportionately.
This patch attempts to spread out node usage by starting files at nodes other
then 0.  I disturbed the addr parameter since alloc_pages_vma will only use it
when the policy is MPOL_INTERLEAVE.  Random was picked over using another
variable which would require some sort of contention management.

Cc: Christoph Lameter <cl@linux.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nathan T Zimmer <nzimmer@sgi.com>
---
 include/linux/shmem_fs.h |    1 +
 mm/shmem.c               |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index bef2cf0..cfe8a34 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -17,6 +17,7 @@ struct shmem_inode_info {
 		char		*symlink;	/* unswappable short symlink */
 	};
 	struct shared_policy	policy;		/* NUMA memory alloc policy */
+	unsigned long           node_offset;	/* bias for interleaved nodes */
 	struct list_head	swaplist;	/* chain of maybes on swap */
 	struct list_head	xattr_list;	/* list of shmem_xattr */
 	struct inode		vfs_inode;
diff --git a/mm/shmem.c b/mm/shmem.c
index d576b84..69a47fb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -929,7 +929,7 @@ static struct page *shmem_alloc_page(gfp_t gfp,
 	/*
 	 * alloc_page_vma() will drop the shared policy reference
 	 */
-	return alloc_page_vma(gfp, &pvma, 0);
+	return alloc_page_vma(gfp, &pvma, info->node_offset << PAGE_SHIFT );
 }
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
@@ -1357,6 +1357,7 @@ static struct inode *shmem_get_inode(struct super_block *sb, const struct inode
 			inode->i_fop = &shmem_file_operations;
 			mpol_shared_policy_init(&info->policy,
 						 shmem_get_sbmpol(sbinfo));
+			info->node_offset = node_random(&node_online_map);
 			break;
 		case S_IFDIR:
 			inc_nlink(inode);
-- 
1.6.0.2

