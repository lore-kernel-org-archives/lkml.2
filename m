Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab2FLOXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:23:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab2FLOVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:21:01 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@suse.cz,
        Jan Kara <jack@suse.cz>, cluster-devel@redhat.com,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 20/27] gfs2: Convert to new freezing mechanism
Date: Tue, 12 Jun 2012 16:20:41 +0200
Message-Id: <1339510848-16992-21-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1339510848-16992-1-git-send-email-jack@suse.cz>
References: <1339510848-16992-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We update gfs2_page_mkwrite() to use new freeze protection and the transaction
code to use freeze protection while the transaction is running. That is needed
to stop iput() of unlinked file from modifying the filesystem. The rest is
handled by the generic code.

CC: cluster-devel@redhat.com
CC: Steven Whitehouse <swhiteho@redhat.com>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/gfs2/file.c  |   15 +++------------
 fs/gfs2/trans.c |    4 ++++
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 0795915..8ffeb03 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -370,11 +370,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	loff_t size;
 	int ret;
 
-	/* Wait if fs is frozen. This is racy so we check again later on
-	 * and retry if the fs has been frozen after the page lock has
-	 * been acquired
-	 */
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	sb_start_pagefault(inode->i_sb);
 
 	/* Update file times before taking page lock */
 	file_update_time(vma->vm_file);
@@ -458,14 +454,9 @@ out:
 	gfs2_holder_uninit(&gh);
 	if (ret == 0) {
 		set_page_dirty(page);
-		/* This check must be post dropping of transaction lock */
-		if (inode->i_sb->s_frozen == SB_UNFROZEN) {
-			wait_on_page_writeback(page);
-		} else {
-			ret = -EAGAIN;
-			unlock_page(page);
-		}
+		wait_on_page_writeback(page);
 	}
+	sb_end_pagefault(inode->i_sb);
 	return block_page_mkwrite_return(ret);
 }
 
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index ad3e2fb..adbd278 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -50,6 +50,7 @@ int gfs2_trans_begin(struct gfs2_sbd *sdp, unsigned int blocks,
 	if (revokes)
 		tr->tr_reserved += gfs2_struct2blk(sdp, revokes,
 						   sizeof(u64));
+	sb_start_intwrite(sdp->sd_vfs);
 	gfs2_holder_init(sdp->sd_trans_gl, LM_ST_SHARED, 0, &tr->tr_t_gh);
 
 	error = gfs2_glock_nq(&tr->tr_t_gh);
@@ -68,6 +69,7 @@ fail_gunlock:
 	gfs2_glock_dq(&tr->tr_t_gh);
 
 fail_holder_uninit:
+	sb_end_intwrite(sdp->sd_vfs);
 	gfs2_holder_uninit(&tr->tr_t_gh);
 	kfree(tr);
 
@@ -116,6 +118,7 @@ void gfs2_trans_end(struct gfs2_sbd *sdp)
 			gfs2_holder_uninit(&tr->tr_t_gh);
 			kfree(tr);
 		}
+		sb_end_intwrite(sdp->sd_vfs);
 		return;
 	}
 
@@ -136,6 +139,7 @@ void gfs2_trans_end(struct gfs2_sbd *sdp)
 
 	if (sdp->sd_vfs->s_flags & MS_SYNCHRONOUS)
 		gfs2_log_flush(sdp, NULL);
+	sb_end_intwrite(sdp->sd_vfs);
 }
 
 /**
-- 
1.7.1

