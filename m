Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab1FFEmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 00:42:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11704 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab1FFEmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 00:42:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=bL3P3tHQM3nOeddwRced5SdFGAiSJ7BuKYVwvC7kicF/xpYJLr7uOFlBqj4z+Ql6UO
         G2iORX4bzoFjkvpubQdg==
Date: Sun, 5 Jun 2011 21:42:39 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 14/14] tmpfs: no need to use i_lock
In-Reply-To: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
Message-ID: <alpine.LSU.2.00.1106052140580.17116@sister.anvils>
References: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36's 7e496299d4d2 to make tmpfs scalable with percpu_counter used
inode->i_lock in place of sbinfo->stat_lock around i_blocks updates;
but that was adverse to scalability, and unnecessary, since info->lock
is already held there in the fast paths.

Remove those uses of i_lock, and add info->lock in the three error
paths where it's then needed across shmem_free_blocks().  It's not
actually needed across shmem_unacct_blocks(), but they're so often
paired that it looks wrong to split them apart.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 mm/shmem.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- linux.orig/mm/shmem.c	2011-06-05 17:53:42.948796800 -0700
+++ linux/mm/shmem.c	2011-06-05 19:27:33.248715783 -0700
@@ -241,9 +241,7 @@ static void shmem_free_blocks(struct ino
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	if (sbinfo->max_blocks) {
 		percpu_counter_add(&sbinfo->used_blocks, -pages);
-		spin_lock(&inode->i_lock);
 		inode->i_blocks -= pages*BLOCKS_PER_PAGE;
-		spin_unlock(&inode->i_lock);
 	}
 }
 
@@ -432,9 +430,7 @@ static swp_entry_t *shmem_swp_alloc(stru
 						sbinfo->max_blocks - 1) >= 0)
 				return ERR_PTR(-ENOSPC);
 			percpu_counter_inc(&sbinfo->used_blocks);
-			spin_lock(&inode->i_lock);
 			inode->i_blocks += BLOCKS_PER_PAGE;
-			spin_unlock(&inode->i_lock);
 		}
 
 		spin_unlock(&info->lock);
@@ -1421,9 +1417,7 @@ repeat:
 			    shmem_acct_block(info->flags))
 				goto nospace;
 			percpu_counter_inc(&sbinfo->used_blocks);
-			spin_lock(&inode->i_lock);
 			inode->i_blocks += BLOCKS_PER_PAGE;
-			spin_unlock(&inode->i_lock);
 		} else if (shmem_acct_block(info->flags))
 			goto nospace;
 
@@ -1434,8 +1428,10 @@ repeat:
 				spin_unlock(&info->lock);
 				filepage = shmem_alloc_page(gfp, info, idx);
 				if (!filepage) {
+					spin_lock(&info->lock);
 					shmem_unacct_blocks(info->flags, 1);
 					shmem_free_blocks(inode, 1);
+					spin_unlock(&info->lock);
 					error = -ENOMEM;
 					goto failed;
 				}
@@ -1449,8 +1445,10 @@ repeat:
 					current->mm, GFP_KERNEL);
 				if (error) {
 					page_cache_release(filepage);
+					spin_lock(&info->lock);
 					shmem_unacct_blocks(info->flags, 1);
 					shmem_free_blocks(inode, 1);
+					spin_unlock(&info->lock);
 					filepage = NULL;
 					goto failed;
 				}
@@ -1480,10 +1478,10 @@ repeat:
 			 * be done automatically.
 			 */
 			if (ret) {
-				spin_unlock(&info->lock);
-				page_cache_release(filepage);
 				shmem_unacct_blocks(info->flags, 1);
 				shmem_free_blocks(inode, 1);
+				spin_unlock(&info->lock);
+				page_cache_release(filepage);
 				filepage = NULL;
 				if (error)
 					goto failed;
