Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965735Ab2EPUAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:00:52 -0400
Received: from relay3.sgi.com ([192.48.152.1]:59152 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965281Ab2EPUAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:00:49 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
To: Hugh Dickins <hughd@google.com>, Nick Piggin <npiggin@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] tmpfs not interleaving properly
Thread-Topic: [PATCH] tmpfs not interleaving properly
Thread-Index: Ac0znpEud/UKP154QuCbsU7dRS4hWw==
Date: Wed, 16 May 2012 20:00:39 +0000
Message-ID: <74F10842A85F514CA8D8C487E74474BB2C0429@P-EXMB1-DC21.corp.sgi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.162.233.143]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When tmpfs has the memory policy interleaved it always starts allocating at each file at node 0.
When there are many small files the lower nodes fill up disproportionately.
My proposed solution is to start a file at a randomly chosen node.

Cc: Christoph Lameter <cl@linux.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nathan T Zimmer <nzimmer@sgi.com>


diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h index 79ab255..38eda26 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -17,6 +17,7 @@ struct shmem_inode_info {
 		char		*symlink;	/* unswappable short symlink */
 	};
 	struct shared_policy	policy;		/* NUMA memory alloc policy */
+	int			node_offset;	/* bias for interleaved nodes */
 	struct list_head	swaplist;	/* chain of maybes on swap */
 	struct list_head	xattr_list;	/* list of shmem_xattr */
 	struct inode		vfs_inode;
diff --git a/mm/shmem.c b/mm/shmem.c
index f99ff3e..58ef512 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -819,7 +819,7 @@ static struct page *shmem_alloc_page(gfp_t gfp,
 
 	/* Create a pseudo vma that just contains the policy */
 	pvma.vm_start = 0;
-	pvma.vm_pgoff = index;
+	pvma.vm_pgoff = index + info->node_offset;
 	pvma.vm_ops = NULL;
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
 
@@ -1153,6 +1153,7 @@ static struct inode *shmem_get_inode(struct super_block *sb, const struct inode
 			inode->i_fop = &shmem_file_operations;
 			mpol_shared_policy_init(&info->policy,
 						 shmem_get_sbmpol(sbinfo));
+			info->node_offset = node_random(&node_online_map);
 			break;
 		case S_IFDIR:
 			inc_nlink(inode);


