Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959Ab0JEKd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:33:26 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56706 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932869Ab0JEKby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:31:54 -0400
Message-Id: <20101005103140.601636569@szeredi.hu>
References: <20101005103108.288743609@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 05 Oct 2010 12:31:13 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] vfs: allow mnt_want_write() to sleep
Content-Disposition: inline; filename=vfs-sleeping-mnt_want_write.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Allow mnt_want_write() to sleep.

This is necessary to enable holding off write requests for the
duration of ->remount_fs(), which may sleep.

A quick audit didn't turn up any callers from atomic context.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c     |   11 +++++++----
 fs/super.c         |    1 +
 include/linux/fs.h |    5 +++++
 3 files changed, 13 insertions(+), 4 deletions(-)

Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2010-10-04 12:15:17.000000000 +0200
+++ linux-2.6/fs/namespace.c	2010-10-04 16:50:44.000000000 +0200
@@ -281,8 +281,12 @@ int mnt_want_write(struct vfsmount *mnt)
 	 * incremented count after it has set MNT_WRITE_HOLD.
 	 */
 	smp_mb();
-	while (mnt->mnt_flags & MNT_WRITE_HOLD)
-		cpu_relax();
+	if (unlikely(mnt->mnt_flags & MNT_WRITE_HOLD)) {
+		preempt_enable();
+		wait_event(mnt->mnt_sb->s_wait_remount_readonly,
+			   !(mnt->mnt_flags & MNT_WRITE_HOLD));
+		preempt_disable();
+	}
 	/*
 	 * After the slowpath clears MNT_WRITE_HOLD, mnt_is_readonly will
 	 * be set to match its requirements. So we must not load that until
@@ -292,9 +296,7 @@ int mnt_want_write(struct vfsmount *mnt)
 	if (__mnt_is_readonly(mnt)) {
 		dec_mnt_writers(mnt);
 		ret = -EROFS;
-		goto out;
 	}
-out:
 	preempt_enable();
 	return ret;
 }
@@ -395,6 +397,7 @@ static int mnt_make_readonly(struct vfsm
 	 */
 	smp_wmb();
 	mnt->mnt_flags &= ~MNT_WRITE_HOLD;
+	wake_up_all(&mnt->mnt_sb->s_wait_remount_readonly);
 	br_write_unlock(vfsmount_lock);
 	return ret;
 }
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c	2010-10-04 12:12:01.000000000 +0200
+++ linux-2.6/fs/super.c	2010-10-04 16:50:25.000000000 +0200
@@ -107,6 +107,7 @@ static struct super_block *alloc_super(s
 		mutex_init(&s->s_dquot.dqonoff_mutex);
 		init_rwsem(&s->s_dquot.dqptr_sem);
 		init_waitqueue_head(&s->s_wait_unfrozen);
+		init_waitqueue_head(&s->s_wait_remount_readonly);
 		s->s_maxbytes = MAX_NON_LFS;
 		s->s_op = &default_op;
 		s->s_time_gran = 1000000000;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-04 12:13:00.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2010-10-04 16:50:25.000000000 +0200
@@ -1385,6 +1385,11 @@ struct super_block {
 	 * generic_show_options()
 	 */
 	char *s_options;
+
+	/*
+	 * Wait queue for remouting read-only
+	 */
+	wait_queue_head_t s_wait_remount_readonly;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);

-- 
