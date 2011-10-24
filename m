Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab1JXMse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:48:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308Ab1JXMr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:59 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>, Nick Piggin <npiggin@kernel.dk>
Subject: [PATCH 18/24] GFS2: Clean up ->page_mkwrite
Date: Mon, 24 Oct 2011 13:48:32 +0100
Message-Id: <1319460518-9046-19-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch brings gfs2's ->page_mkwrite uptodate with respect to the
expectations set by the VM. Also added is a check to wait if the fs
is frozen, before we attempt to get a glock. This will only work on
the node which initiates the freeze, but thats ok since the transaction
lock will still provide the expected barrier on other nodes.

The major change here is that we return a locked page now, except when
we don't return a page at all (error cases). This removes the race
which required rechecking the page after it was returned.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Nick Piggin <npiggin@kernel.dk>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 3b65f67..aa3a4dd 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -366,8 +366,15 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	unsigned int data_blocks, ind_blocks, rblocks;
 	struct gfs2_holder gh;
 	struct gfs2_alloc *al;
+	loff_t size;
 	int ret;
 
+	/* Wait if fs is frozen. This is racy so we check again later on
+	 * and retry if the fs has been frozen after the page lock has
+	 * been acquired
+	 */
+	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
 	ret = gfs2_glock_nq(&gh);
 	if (ret)
@@ -376,8 +383,15 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	set_bit(GLF_DIRTY, &ip->i_gl->gl_flags);
 	set_bit(GIF_SW_PAGED, &ip->i_flags);
 
-	if (!gfs2_write_alloc_required(ip, pos, PAGE_CACHE_SIZE))
+	if (!gfs2_write_alloc_required(ip, pos, PAGE_CACHE_SIZE)) {
+		lock_page(page);
+		if (!PageUptodate(page) || page->mapping != inode->i_mapping) {
+			ret = -EAGAIN;
+			unlock_page(page);
+		}
 		goto out_unlock;
+	}
+
 	ret = -ENOMEM;
 	al = gfs2_alloc_get(ip);
 	if (al == NULL)
@@ -405,21 +419,29 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 	lock_page(page);
 	ret = -EINVAL;
-	last_index = ip->i_inode.i_size >> PAGE_CACHE_SHIFT;
-	if (page->index > last_index)
-		goto out_unlock_page;
+	size = i_size_read(inode);
+	last_index = (size - 1) >> PAGE_CACHE_SHIFT;
+	/* Check page index against inode size */
+	if (size == 0 || (page->index > last_index))
+		goto out_trans_end;
+
+	ret = -EAGAIN;
+	/* If truncated, we must retry the operation, we may have raced
+	 * with the glock demotion code.
+	 */
+	if (!PageUptodate(page) || page->mapping != inode->i_mapping)
+		goto out_trans_end;
+
+	/* Unstuff, if required, and allocate backing blocks for page */
 	ret = 0;
-	if (!PageUptodate(page) || page->mapping != ip->i_inode.i_mapping)
-		goto out_unlock_page;
-	if (gfs2_is_stuffed(ip)) {
+	if (gfs2_is_stuffed(ip))
 		ret = gfs2_unstuff_dinode(ip, page);
-		if (ret)
-			goto out_unlock_page;
-	}
-	ret = gfs2_allocate_page_backing(page);
+	if (ret == 0)
+		ret = gfs2_allocate_page_backing(page);
 
-out_unlock_page:
-	unlock_page(page);
+out_trans_end:
+	if (ret)
+		unlock_page(page);
 	gfs2_trans_end(sdp);
 out_trans_fail:
 	gfs2_inplace_release(ip);
@@ -431,11 +453,17 @@ out_unlock:
 	gfs2_glock_dq(&gh);
 out:
 	gfs2_holder_uninit(&gh);
-	if (ret == -ENOMEM)
-		ret = VM_FAULT_OOM;
-	else if (ret)
-		ret = VM_FAULT_SIGBUS;
-	return ret;
+	if (ret == 0) {
+		set_page_dirty(page);
+		/* This check must be post dropping of transaction lock */
+		if (inode->i_sb->s_frozen == SB_UNFROZEN) {
+			wait_on_page_writeback(page);
+		} else {
+			ret = -EAGAIN;
+			unlock_page(page);
+		}
+	}
+	return block_page_mkwrite_return(ret);
 }
 
 static const struct vm_operations_struct gfs2_vm_ops = {
-- 
1.7.4.4

