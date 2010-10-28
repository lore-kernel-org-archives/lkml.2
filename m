Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835Ab0J1VcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:32:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760345Ab0J1Vb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:31:56 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 03/20] fanotify: implement fanotify listener ordering
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:31:51 -0400
Message-ID: <20101028213151.24810.60039.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fanotify listeners needs to be able to specify what types of operations
they are going to perform so they can be ordered appropriately between other
listeners doing other types of operations.  They need this to be able to make
sure that things like hierarchichal storage managers will get access to inodes
before processes which need the data.  This patch defines 3 possible uses
which groups must indicate in the fanotify_init() flags.

FAN_CLASS_PRE_CONTENT
FAN_CLASS_CONTENT
FAN_CLASS_NOTIF

Groups will receive notification in that order.  The order between 2 groups in
the same class is undeterministic.

FAN_CLASS_PRE_CONTENT is intended to be used by listeners which need access to
the inode before they are certain that the inode contains it's final data.  A
hierarchical storage manager should choose to use this class.

FAN_CLASS_CONTENT is intended to be used by listeners which need access to the
inode after it contains its intended contents.  This would be the appropriate
level for an AV solution or document control system.

FAN_CLASS_NOTIF is intended for normal async notification about access, much the
same as inotify and dnotify.  Syncronous permissions events are not permitted
at this class.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify_user.c |   25 ++++++++++++++++++++++++-
 include/linux/fanotify.h           |   11 ++++++++++-
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index bbcb98e..1c09e63 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -664,6 +664,20 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	init_waitqueue_head(&group->fanotify_data.access_waitq);
 	INIT_LIST_HEAD(&group->fanotify_data.access_list);
 #endif
+	switch (flags & FAN_ALL_CLASS_BITS) {
+	case FAN_CLASS_NOTIF:
+		group->priority = FS_PRIO_0;
+		break;
+	case FAN_CLASS_CONTENT:
+		group->priority = FS_PRIO_1;
+		break;
+	case FAN_CLASS_PRE_CONTENT:
+		group->priority = FS_PRIO_2;
+		break;
+	default:
+		fd = -EINVAL;
+		goto out_put_group;
+	}
 
 	fd = anon_inode_getfd("[fanotify]", &fanotify_fops, group, f_flags);
 	if (fd < 0)
@@ -719,6 +733,16 @@ SYSCALL_DEFINE(fanotify_mark)(int fanotify_fd, unsigned int flags,
 	ret = -EINVAL;
 	if (unlikely(filp->f_op != &fanotify_fops))
 		goto fput_and_out;
+	group = filp->private_data;
+
+	/*
+	 * group->priority == FS_PRIO_0 == FAN_CLASS_NOTIF.  These are not
+	 * allowed to set permissions events.
+	 */
+	ret = -EINVAL;
+	if (mask & FAN_ALL_PERM_EVENTS &&
+	    group->priority == FS_PRIO_0)
+		goto fput_and_out;
 
 	ret = fanotify_find_path(dfd, pathname, &path, flags);
 	if (ret)
@@ -729,7 +753,6 @@ SYSCALL_DEFINE(fanotify_mark)(int fanotify_fd, unsigned int flags,
 		inode = path.dentry->d_inode;
 	else
 		mnt = path.mnt;
-	group = filp->private_data;
 
 	/* create/update an inode mark */
 	switch (flags & (FAN_MARK_ADD | FAN_MARK_REMOVE | FAN_MARK_FLUSH)) {
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 63531a6..2c89ce7 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -25,7 +25,16 @@
 #define FAN_CLOEXEC		0x00000001
 #define FAN_NONBLOCK		0x00000002
 
-#define FAN_ALL_INIT_FLAGS	(FAN_CLOEXEC | FAN_NONBLOCK)
+/* These are NOT bitwise flags.  Both bits are used togther.  */
+#define FAN_CLASS_NOTIF		0x00000000
+#define FAN_CLASS_CONTENT	0x00000004
+#define FAN_CLASS_PRE_CONTENT	0x00000008
+
+#define FAN_ALL_CLASS_BITS	(FAN_CLASS_NOTIF | FAN_CLASS_CONTENT | \
+				 FAN_CLASS_PRE_CONTENT)
+
+#define FAN_ALL_INIT_FLAGS	(FAN_CLOEXEC | FAN_NONBLOCK | \
+				 FAN_ALL_CLASS_BITS)
 
 /* flags used for fanotify_modify_mark() */
 #define FAN_MARK_ADD		0x00000001

