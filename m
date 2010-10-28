Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761588Ab0J1VeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:34:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab0J1VdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:33:11 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 16/20] fanotify: ignore events on directories unless
	specifically requested
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:33:07 -0400
Message-ID: <20101028213307.24810.10460.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify has a very limited number of events it sends on directories.  The
usefulness of these events is yet to be seen and still we send them.  This
is particularly painful for mount marks where one might receive many of
these useless events.  As such this patch will drop events on IS_DIR()
inodes unless they were explictly requested with FAN_ON_DIR.

This means that a mark on a directory without FAN_EVENT_ON_CHILD or
FAN_ON_DIR is meaningless and will result in no events ever (although it
will still be allowed since detecting it is hard)

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify.c      |    5 +++++
 fs/notify/fanotify/fanotify_user.c |   12 ++++++++++++
 include/linux/fanotify.h           |   10 ++++++++--
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 8d98e1f..b04f88e 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -131,6 +131,7 @@ static int fanotify_handle_event(struct fsnotify_group *group,
 	BUILD_BUG_ON(FAN_Q_OVERFLOW != FS_Q_OVERFLOW);
 	BUILD_BUG_ON(FAN_OPEN_PERM != FS_OPEN_PERM);
 	BUILD_BUG_ON(FAN_ACCESS_PERM != FS_ACCESS_PERM);
+	BUILD_BUG_ON(FAN_ONDIR != FS_ISDIR);
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
@@ -195,6 +196,10 @@ static bool fanotify_should_send_event(struct fsnotify_group *group,
 		BUG();
 	}
 
+	if (S_ISDIR(path->dentry->d_inode->i_mode) &&
+	    (marks_ignored_mask & FS_ISDIR))
+		return false;
+
 	if (event_mask & marks_mask & ~marks_ignored_mask)
 		return true;
 
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index a7d9369..ff1a908 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -570,6 +570,12 @@ static __u32 fanotify_mark_add_to_mask(struct fsnotify_mark *fsn_mark,
 		if (flags & FAN_MARK_IGNORED_SURV_MODIFY)
 			fsn_mark->flags |= FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY;
 	}
+
+	if (!(flags & FAN_MARK_ONDIR)) {
+		__u32 tmask = fsn_mark->ignored_mask | FAN_ONDIR;
+		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
+	}
+
 	spin_unlock(&fsn_mark->lock);
 
 	return mask & ~oldmask;
@@ -766,6 +772,12 @@ SYSCALL_DEFINE(fanotify_mark)(int fanotify_fd, unsigned int flags,
 	default:
 		return -EINVAL;
 	}
+
+	if (mask & FAN_ONDIR) {
+		flags |= FAN_MARK_ONDIR;
+		mask &= ~FAN_ONDIR;
+	}
+
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	if (mask & ~(FAN_ALL_EVENTS | FAN_ALL_PERM_EVENTS | FAN_EVENT_ON_CHILD))
 #else
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 7592a36..5e0400a 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -10,13 +10,15 @@
 #define FAN_CLOSE_NOWRITE	0x00000010	/* Writtable file closed */
 #define FAN_OPEN		0x00000020	/* File was opened */
 
-#define FAN_EVENT_ON_CHILD	0x08000000	/* interested in child events */
-
 #define FAN_Q_OVERFLOW		0x00004000	/* Event queued overflowed */
 
 #define FAN_OPEN_PERM		0x00010000	/* File open in perm check */
 #define FAN_ACCESS_PERM		0x00020000	/* File accessed in perm check */
 
+#define FAN_ONDIR		0x40000000	/* event occurred against dir */
+
+#define FAN_EVENT_ON_CHILD	0x08000000	/* interested in child events */
+
 /* helper events */
 #define FAN_CLOSE		(FAN_CLOSE_WRITE | FAN_CLOSE_NOWRITE) /* close */
 
@@ -47,6 +49,10 @@
 #define FAN_MARK_IGNORED_MASK	0x00000020
 #define FAN_MARK_IGNORED_SURV_MODIFY	0x00000040
 #define FAN_MARK_FLUSH		0x00000080
+#ifdef __KERNEL__
+/* not valid from userspace, only kernel internal */
+#define FAN_MARK_ONDIR		0x00000100
+#endif
 
 #define FAN_ALL_MARK_FLAGS	(FAN_MARK_ADD |\
 				 FAN_MARK_REMOVE |\

