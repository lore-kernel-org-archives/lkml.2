Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab2KVVa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:30:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:49649 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab2KVSkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [ 63/83] GFS2: Dont call file_accessed() with a shared glock
Date: Wed, 21 Nov 2012 16:42:25 -0800
Message-Id: <20121122004219.499555479@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/file.c  |   12 +++++-------
 fs/gfs2/super.c |    3 ++-
 2 files changed, 7 insertions(+), 8 deletions(-)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -515,15 +515,13 @@ static int gfs2_mmap(struct file *file,
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
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -810,7 +810,8 @@ static void gfs2_dirty_inode(struct inod
 			return;
 		}
 		need_unlock = 1;
-	}
+	} else if (WARN_ON_ONCE(ip->i_gl->gl_state != LM_ST_EXCLUSIVE))
+		return;
 
 	if (current->journal_info == NULL) {
 		ret = gfs2_trans_begin(sdp, RES_DINODE, 0);


