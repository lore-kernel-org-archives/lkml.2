Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab0LJRqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:46:49 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:40671 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754795Ab0LJRqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:46:48 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+uIeE26ASu6bhrpwnSTsWyZfmCZFs+BaUyU5n0N1
	E0Gf39wzjZR+1D
Date: Fri, 10 Dec 2010 18:44:29 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: tvrtko.ursulin@sophos.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/2] fanotify: fix broken ref count in create_fd()
Message-ID: <20101210174429.GB32555@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In create_fd(), before we fallback to open a file read-only we should grab dentry
and mount refs again, since they have been put by the former failed call to dentry_open().

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/fanotify/fanotify_user.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

 Please apply this against commit 26552d4aa4117cd3ea8cbe13ebf317da652e6bfd of
 branch 'origin/for-next' from git.infradead.org/users/eparis/notify.git

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 2d4925b..e108960 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -92,6 +92,10 @@ static int create_fd(struct fsnotify_group *group, struct fsnotify_event *event)
 		 * in order to at least provide something to the listener.
 		 */
 		if (IS_ERR(new_file) && group->fanotify_data.readonly_fallback) {
+			/* dentry_open() put our refs, so get them again... */
+			dentry = dget(event->path.dentry);
+			mnt = mntget(event->path.mnt);
+
 			flags &= ~O_ACCMODE;
 			flags |= O_RDONLY;
 			new_file = dentry_open(dentry, mnt, flags,
-- 
1.5.6.5

