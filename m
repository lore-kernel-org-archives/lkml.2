Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab0JVQK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:10:58 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55145 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617Ab0JVQK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:10:57 -0400
To: viro@ZenIV.linux.org.uk
CC: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <E1P9Gh4-00054y-EA@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Fri, 22 Oct 2010 14:25:58 +0200)
Subject: Re: [PATCH 7/9] vfs: protect remounting superblock read-only
References: <20101005103108.288743609@szeredi.hu>
 <20101005103144.051231469@szeredi.hu> <20101022064627.GA21607@ZenIV.linux.org.uk> <E1P9Gh4-00054y-EA@pomaz-ex.szeredi.hu>
Message-Id: <E1P9KCY-0005YO-4i@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 22 Oct 2010 18:10:42 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010, Miklos Szeredi wrote:
> >   Or, more subtle, tries to
> > update atime on some opened struct file on that sb.
> 
> Hmm, load_nls() will apparently do that.  Drat.
> 
> Plan B: remount all vfsmounts read-only before ->remount_fs() but
> remember which ones were read-write and restore on failure.  Will
> result in ugly transient write failures if remount_fs() fails, but I
> don't think anybody would care in practice.

And it's actually a pretty simple change.  Here's the incremental
patch to "vfs: protect remounting superblock read-only", with "vfs:
allow mnt_want_write() to sleep" reverted.

The full, updated patch with follow.

Thanks,
Miklos



Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2010-10-22 16:24:41.000000000 +0200
+++ linux-2.6/fs/namespace.c	2010-10-22 16:17:59.000000000 +0200
@@ -435,11 +435,17 @@ int sb_prepare_remount_readonly(struct s
 			}
 		}
 	}
+	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
+		if (mnt->mnt_flags & MNT_WRITE_HOLD) {
+			if (!err) {
+				mnt->mnt_flags |= MNT_READONLY | MNT_WAS_WRITE;
+				smp_wmb();
+			}
+			mnt->mnt_flags &= ~MNT_WRITE_HOLD;
+		}
+	}
 	br_write_unlock(vfsmount_lock);
 
-	if (err)
-		sb_cancel_remount_readonly(sb);
-
 	return err;
 }
 
@@ -449,12 +455,11 @@ void sb_cancel_remount_readonly(struct s
 
 	br_write_lock(vfsmount_lock);
 	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
-		if (mnt->mnt_flags & MNT_WRITE_HOLD)
-			mnt->mnt_flags &= ~MNT_WRITE_HOLD;
+		if (mnt->mnt_flags & MNT_WAS_WRITE)
+			mnt->mnt_flags &= ~(MNT_WAS_WRITE | MNT_READONLY);
 	}
 
 	br_write_unlock(vfsmount_lock);
-	wake_up_all(&sb->s_wait_remount_readonly);
 }
 
 void sb_finish_remount_readonly(struct super_block *sb)
@@ -463,15 +468,11 @@ void sb_finish_remount_readonly(struct s
 
 	br_write_lock(vfsmount_lock);
 	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
-		if (!(mnt->mnt_flags & MNT_READONLY)) {
-			mnt->mnt_flags |= MNT_READONLY;
-			smp_wmb();
-			mnt->mnt_flags &= ~MNT_WRITE_HOLD;
-		}
+		if (mnt->mnt_flags & MNT_WAS_WRITE)
+			mnt->mnt_flags &= ~MNT_WAS_WRITE;
 	}
 	sb->s_flags |= MS_RDONLY;
 	br_write_unlock(vfsmount_lock);
-	wake_up_all(&sb->s_wait_remount_readonly);
 }
 
 void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
Index: linux-2.6/include/linux/mount.h
===================================================================
--- linux-2.6.orig/include/linux/mount.h	2010-10-22 16:02:14.000000000 +0200
+++ linux-2.6/include/linux/mount.h	2010-10-22 16:20:26.000000000 +0200
@@ -30,6 +30,7 @@ struct mnt_namespace;
 
 #define MNT_SHRINKABLE	0x100
 #define MNT_WRITE_HOLD	0x200
+#define MNT_WAS_WRITE	0x400   /* used by remount to remember write mounts */
 
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
