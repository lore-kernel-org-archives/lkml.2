Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab0LBKKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 05:10:43 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:51448 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755850Ab0LBKKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 05:10:41 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1/MZrFW/0jMxp+i8qPcnKFMH7Fxuz2QgagtRTTlRX
	X1joVxeBegBZz3
Date: Thu, 2 Dec 2010 11:08:36 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/6] fanotify: dont set FAN_ONDIR implicitly
Message-ID: <20101202100836.GF5196@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently we set the FAN_ONDIR flag in a marks ignore_mask whenever the user
wants to add something to the mask of the mark but does not explicitly specifiy
FAN_ONDIR. We also never set that flag in a marks event mask.

The problem is that even if the user has specified FAN_ONDIR with a call to
fanotify_mark() it will be set ignored as soon as a subsequent call does not
specify this flag, which may not be what the user expected.
Furthermore it is hard to ever unset FAN_ONDIR once it is set in the ignore_mask 
so that a mark will very likely not be destroyed before its group is destroyed.

With this patch FAN_ONDIR is treated as every other flag, thus if specified it 
is set in a marks event maks and no longer implicitly set in the ignore_mask. 

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/fanotify/fanotify.c      |    2 +-
 fs/notify/fanotify/fanotify_user.c |   16 +++-------------
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index c2ba86a..72705f2 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -194,7 +194,7 @@ static bool fanotify_should_send_event(struct fsnotify_group *group,
 	}
 
 	if (S_ISDIR(path->dentry->d_inode->i_mode) &&
-	    (marks_ignored_mask & FS_ISDIR))
+	    !((marks_mask & ~marks_ignored_mask) & FS_ISDIR))
 		return false;
 
 	/*
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 6b9606a..acf8465 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -603,12 +603,6 @@ static __u32 fanotify_mark_add_to_mask(struct fsnotify_mark *fsn_mark,
 		if (flags & FAN_MARK_IGNORED_SURV_MODIFY)
 			fsn_mark->flags |= FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY;
 	}
-
-	if (!(flags & FAN_MARK_ONDIR)) {
-		__u32 tmask = fsn_mark->ignored_mask | FAN_ONDIR;
-		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
-	}
-
 	spin_unlock(&fsn_mark->lock);
 
 	return mask & ~oldmask;
@@ -832,15 +826,11 @@ SYSCALL_DEFINE(fanotify_mark)(int fanotify_fd, unsigned int flags,
 		return -EINVAL;
 	}
 
-	if (mask & FAN_ONDIR) {
-		flags |= FAN_MARK_ONDIR;
-		mask &= ~FAN_ONDIR;
-	}
-
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	if (mask & ~(FAN_ALL_EVENTS | FAN_ALL_PERM_EVENTS | FAN_EVENT_ON_CHILD))
+	if (mask & ~(FAN_ALL_EVENTS | FAN_ALL_PERM_EVENTS | FAN_ONDIR |
+		     FAN_EVENT_ON_CHILD))
 #else
-	if (mask & ~(FAN_ALL_EVENTS | FAN_EVENT_ON_CHILD))
+	if (mask & ~(FAN_ALL_EVENTS | FAN_ONDIR | FAN_EVENT_ON_CHILD))
 #endif
 		return -EINVAL;
 
-- 
1.5.6.5

