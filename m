Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab0LJRtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:49:51 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45322 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752499Ab0LJRtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:49:50 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+PEwoDS+qPw4Lkd15gIkXXBI307nBM4kuy44leaJ
	tH0AE/SiTD7ntr
Date: Fri, 10 Dec 2010 18:47:33 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2] fanotify: remove obsolete check for overflow event in
	create_fd()
Message-ID: <20101210174733.GC32555@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In create_fd() we check if mount and dentry of the passed event are NULL.
This cant happen any more since we dont call this function for the overflow
event any longer. So we can remove this check.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/fanotify/fanotify_user.c |   35 +++++++++++++++--------------------
 1 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index e108960..0dce0d4 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -82,28 +82,23 @@ static int create_fd(struct fsnotify_group *group, struct fsnotify_event *event)
 	 */
 	dentry = dget(event->path.dentry);
 	mnt = mntget(event->path.mnt);
-	/* it's possible this event was an overflow event.  in that case dentry and mnt
-	 * are NULL;  That's fine, just don't call dentry open */
-	if (dentry && mnt) {
-		flags = group->fanotify_data.f_flags;
+
+	flags = group->fanotify_data.f_flags;
+	new_file = dentry_open(dentry, mnt, flags, current_cred());
+	/*
+	 * Attempt fallback to read-only access if writable was not possible
+	 * in order to at least provide something to the listener.
+	 */
+	if (IS_ERR(new_file) && group->fanotify_data.readonly_fallback) {
+		/* dentry_open() put our refs, so get them again... */
+		dentry = dget(event->path.dentry);
+		mnt = mntget(event->path.mnt);
+
+		flags &= ~O_ACCMODE;
+		flags |= O_RDONLY;
 		new_file = dentry_open(dentry, mnt, flags, current_cred());
-		/*
-		 * Attempt fallback to read-only access if writable was not possible
-		 * in order to at least provide something to the listener.
-		 */
-		if (IS_ERR(new_file) && group->fanotify_data.readonly_fallback) {
-			/* dentry_open() put our refs, so get them again... */
-			dentry = dget(event->path.dentry);
-			mnt = mntget(event->path.mnt);
-
-			flags &= ~O_ACCMODE;
-			flags |= O_RDONLY;
-			new_file = dentry_open(dentry, mnt, flags,
-					       current_cred());
-		}
-	} else {
-		new_file = ERR_PTR(-EOVERFLOW);
 	}
+
 	if (IS_ERR(new_file)) {
 		/*
 		 * we still send an event even if we can't open the file.  this
-- 
1.5.6.5

