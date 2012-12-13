Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab2LMOOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:14:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45071 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334Ab2LMOOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:14:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 217/241] GFS2: Don't call file_accessed() with a shared glock
Date: Thu, 13 Dec 2012 11:59:42 -0200
Message-Id: <1355407206-17100-218-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

commit 3d1626889a64bd5a661544d582036a0a02104a60 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/gfs2/file.c  |   12 +++++-------
 fs/gfs2/super.c |    3 ++-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 31b199f..a8a81d7 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -492,15 +492,13 @@ static int gfs2_mmap(struct file *file, struct vm_area_struct *vma)
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
 	vma->vm_flags |= VM_CAN_NONLINEAR;
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 713e621..12769a2 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -800,7 +800,8 @@ static void gfs2_dirty_inode(struct inode *inode, int flags)
 			return;
 		}
 		need_unlock = 1;
-	}
+	} else if (WARN_ON_ONCE(ip->i_gl->gl_state != LM_ST_EXCLUSIVE))
+		return;
 
 	if (current->journal_info == NULL) {
 		ret = gfs2_trans_begin(sdp, RES_DINODE, 0);
-- 
1.7.9.5

