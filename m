Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab2KGKmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:42:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab2KGKmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:42:06 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 6/7] GFS2: Don't call file_accessed() with a shared glock
Date: Wed,  7 Nov 2012 10:15:58 +0000
Message-Id: <1352283359-3314-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1352283359-3314-1-git-send-email-swhiteho@redhat.com>
References: <1352283359-3314-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

file_accessed() was being called by gfs2_mmap() with a shared glock. If it
needed to update the atime, it was crashing because it dirtied the inode in
gfs2_dirty_inode() without holding an exclusive lock. gfs2_dirty_inode()
checked if the caller was already holding a glock, but it didn't make sure that
the glock was in the exclusive state. Now, instead of calling file_accessed()
while holding the shared lock in gfs2_mmap(), file_accessed() is called after
grabbing and releasing the glock to update the inode.  If file_accessed() needs
to update the atime, it will grab an exclusive lock in gfs2_dirty_inode().

gfs2_dirty_inode() now also checks to make sure that if the calling process has
already locked the glock, it has an exclusive lock.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 377a68d..e056b4c 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -516,15 +516,13 @@ static int gfs2_mmap(struct file *file, struct vm_area_struct *vma)
 		struct gfs2_holder i_gh;
 		int error;
 
-		gfs2_holder_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
-		error = gfs2_glock_nq(&i_gh);
-		if (error == 0) {
-			file_accessed(file);
-			gfs2_glock_dq(&i_gh);
-		}
-		gfs2_holder_uninit(&i_gh);
+		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY,
+					   &i_gh);
 		if (error)
 			return error;
+		/* grab lock to update inode */
+		gfs2_glock_dq_uninit(&i_gh);
+		file_accessed(file);
 	}
 	vma->vm_ops = &gfs2_vm_ops;
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index bc73726..d648867 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -810,7 +810,8 @@ static void gfs2_dirty_inode(struct inode *inode, int flags)
 			return;
 		}
 		need_unlock = 1;
-	}
+	} else if (WARN_ON_ONCE(ip->i_gl->gl_state != LM_ST_EXCLUSIVE))
+		return;
 
 	if (current->journal_info == NULL) {
 		ret = gfs2_trans_begin(sdp, RES_DINODE, 0);
-- 
1.7.4

