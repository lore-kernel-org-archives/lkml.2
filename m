Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070Ab0J1VdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:33:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761204Ab0J1Vcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:32:48 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 12/20] fanotify: allow userspace to override max marks
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:32:44 -0400
Message-ID: <20101028213244.24810.19075.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some fanotify groups, especially those like AV scanners, will need to place
lots of marks, particularly ignore marks.  Since ignore marks do not pin
inodes in cache and are cleared if the inode is removed from core (usually
under memory pressure) we expose an interface for listeners, with
CAP_SYS_ADMIN, to override the maximum number of marks and be allowed to
set and 'unlimited' number of marks.  Programs which make use of this
feature will be able to OOM a machine.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify_user.c |    9 ++++++++-
 include/linux/fanotify.h           |    4 +++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 1d33d7d..f921610 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -707,7 +707,14 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 		group->max_events = FANOTIFY_DEFAULT_MAX_EVENTS;
 	}
 
-	group->fanotify_data.max_marks = FANOTIFY_DEFAULT_MAX_MARKS;
+	if (flags & FAN_UNLIMITED_MARKS) {
+		fd = -EPERM;
+		if (!capable(CAP_SYS_ADMIN))
+			goto out_put_group;
+		group->fanotify_data.max_marks = UINT_MAX;
+	} else {
+		group->fanotify_data.max_marks = FANOTIFY_DEFAULT_MAX_MARKS;
+	}
 
 	fd = anon_inode_getfd("[fanotify]", &fanotify_fops, group, f_flags);
 	if (fd < 0)
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index e37f559..7592a36 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -32,9 +32,11 @@
 				 FAN_CLASS_PRE_CONTENT)
 
 #define FAN_UNLIMITED_QUEUE	0x00000010
+#define FAN_UNLIMITED_MARKS	0x00000020
 
 #define FAN_ALL_INIT_FLAGS	(FAN_CLOEXEC | FAN_NONBLOCK | \
-				 FAN_ALL_CLASS_BITS | FAN_UNLIMITED_QUEUE)
+				 FAN_ALL_CLASS_BITS | FAN_UNLIMITED_QUEUE |\
+				 FAN_UNLIMITED_MARKS)
 
 /* flags used for fanotify_modify_mark() */
 #define FAN_MARK_ADD		0x00000001

