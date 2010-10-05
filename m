Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab0JEKc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:32:28 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56731 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932923Ab0JEKcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:32:25 -0400
Message-Id: <20101005103137.421669825@szeredi.hu>
References: <20101005103108.288743609@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 05 Oct 2010 12:31:11 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] vfs: fix per mount read-write
Content-Disposition: inline; filename=vfs-fix-bind-remount-read-write.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Don't allow remounting the vfsmount read-write if the superblock is
read-only.  Return -EROFS in this case.

Rename __mnt_unmake_readonly() to mnt_make_writable() to match
mnt_make_readonly().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2010-09-30 16:53:30.000000000 +0200
+++ linux-2.6/fs/namespace.c	2010-09-30 16:57:47.000000000 +0200
@@ -399,11 +399,18 @@ static int mnt_make_readonly(struct vfsm
 	return ret;
 }
 
-static void __mnt_unmake_readonly(struct vfsmount *mnt)
+static int mnt_make_writable(struct vfsmount *mnt)
 {
+	int err = 0;
+
 	br_write_lock(vfsmount_lock);
-	mnt->mnt_flags &= ~MNT_READONLY;
+	if (mnt->mnt_sb->s_flags & MS_RDONLY)
+		err = -EROFS;
+	else
+		mnt->mnt_flags &= ~MNT_READONLY;
 	br_write_unlock(vfsmount_lock);
+
+	return err;
 }
 
 void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
@@ -1600,7 +1607,7 @@ static int change_mount_flags(struct vfs
 	if (readonly_request)
 		error = mnt_make_readonly(mnt);
 	else
-		__mnt_unmake_readonly(mnt);
+		error = mnt_make_writable(mnt);
 	return error;
 }
 

-- 
