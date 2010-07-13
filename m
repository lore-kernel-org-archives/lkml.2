Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab0GMUVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 16:21:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab0GMUVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 16:21:13 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] inotify: allow users to request not to recieve events on
	unlinked children
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk
Date: Tue, 13 Jul 2010 16:21:11 -0400
Message-ID: <20100713202111.2155.21700.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An inotify watch on a directory will send events for children even if those
children have been unlinked.  This patch add a new inotify flag IN_EXCL_UNLINK
which allows a watch to specificy they don't care about unlinked children.
This should fix performance problems seen by tasks which add a watch to
/tmp and then are overrun with events when other processes are reading and
writing to unlinked files they created in /tmp.

https://bugzilla.kernel.org/show_bug.cgi?id=16296

Requested-by: Matthias Clasen <mclasen@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inotify/inotify_fsnotify.c |    9 +++++++++
 fs/notify/inotify/inotify_user.c     |    2 +-
 include/linux/fsnotify_backend.h     |    1 +
 include/linux/inotify.h              |    1 +
 4 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 388a150..9d332e7 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -22,6 +22,7 @@
  * General Public License for more details.
  */
 
+#include <linux/dcache.h> /* d_unlinked */
 #include <linux/fs.h> /* struct inode */
 #include <linux/fsnotify_backend.h>
 #include <linux/inotify.h>
@@ -157,6 +158,14 @@ static bool inotify_should_send_event(struct fsnotify_group *group, struct inode
 	mask = (mask & ~FS_EVENT_ON_CHILD);
 	send = (fsn_mark->mask & mask);
 
+	if (send && (fsn_mark->mask & FS_EXCL_UNLINK) &&
+	    (data_type == FSNOTIFY_EVENT_PATH)) {
+		struct path *path  = data;
+
+		if (d_unlinked(path->dentry))
+			send = false;
+	}
+
 	/* find took a reference */
 	fsnotify_put_mark(fsn_mark);
 
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index f381daf..dfc80f7 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -97,7 +97,7 @@ static inline __u32 inotify_arg_to_mask(u32 arg)
 	mask = (FS_IN_IGNORED | FS_EVENT_ON_CHILD | FS_UNMOUNT);
 
 	/* mask off the flags used to open the fd */
-	mask |= (arg & (IN_ALL_EVENTS | IN_ONESHOT));
+	mask |= (arg & (IN_ALL_EVENTS | IN_ONESHOT | IN_EXCL_UNLINK));
 
 	return mask;
 }
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index b0d00fd..b06023a 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -44,6 +44,7 @@
 #define FS_OPEN_PERM		0x00010000	/* open event in an permission hook */
 #define FS_ACCESS_PERM		0x00020000	/* access event in a permissions hook */
 
+#define FS_EXCL_UNLINK		0x04000000	/* do not send events if object is unlinked */
 #define FS_IN_ISDIR		0x40000000	/* event occurred against dir */
 #define FS_IN_ONESHOT		0x80000000	/* only send event once */
 
diff --git a/include/linux/inotify.h b/include/linux/inotify.h
index 94d209a..b74f2ef 100644
--- a/include/linux/inotify.h
+++ b/include/linux/inotify.h
@@ -51,6 +51,7 @@ struct inotify_event {
 /* special flags */
 #define IN_ONLYDIR		0x01000000	/* only watch the path if it is a directory */
 #define IN_DONT_FOLLOW		0x02000000	/* don't follow a sym link */
+#define IN_EXCL_UNLINK		0x04000000	/* exclude events on unlinked objects */
 #define IN_MASK_ADD		0x20000000	/* add to the mask of an already existing watch */
 #define IN_ISDIR		0x40000000	/* event occurred against dir */
 #define IN_ONESHOT		0x80000000	/* only send event once */

