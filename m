Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab1BKPIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:08:07 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:60670 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756937Ab1BKPIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:08:05 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+85ZJppMe88Th101th4HyeAKrO43F48sp+iQE0Q1
	IvaMRvF3cfb9AR
Date: Fri, 11 Feb 2011 16:04:20 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] inotify: fix race when adding a new watch
Message-ID: <20110211150420.GB14459@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In inotify_new_watch() the number of watches for a group is compared against
the max number of allowed watches and increased afterwards.
The check and incrementation is not done atomically, so it is possible for
multiple concurrent threads to pass the check and increment the number of
marks above the allowed max.
This patch uses a groups mark_lock to ensure that both check and incrementation
are done atomic.
With this lock held it is also not longer necessary to check for an already existing 
mark after inotify_new_watch() has returned, since mark lookup and addition are also
synchronized now.

Signed-off-by: Lino Sanfilippo <LinoSanfilppo@gmx.de>
---
This patch depends on the the patch series
"fsnotify: use a groups mark_mutex to synchronize access to its mark list" sent 
earlier this day.

 fs/notify/inotify/inotify_user.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 1637820..8e8b236 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -656,7 +656,8 @@ static int inotify_new_watch(struct fsnotify_group *group,
 		goto out_err;
 
 	/* we are on the idr, now get on the inode */
-	ret = fsnotify_add_mark(&tmp_i_mark->fsn_mark, group, inode, NULL, 0);
+	ret = fsnotify_add_mark_locked(&tmp_i_mark->fsn_mark, group, inode,
+				       NULL, 0);
 	if (ret) {
 		/* we failed to get on the inode, get off the idr */
 		inotify_remove_from_idr(group, tmp_i_mark);
@@ -680,19 +681,13 @@ static int inotify_update_watch(struct fsnotify_group *group, struct inode *inod
 {
 	int ret = 0;
 
-retry:
+	mutex_lock(&group->mark_mutex);
 	/* try to update and existing watch with the new arg */
 	ret = inotify_update_existing_watch(group, inode, arg);
 	/* no mark present, try to add a new one */
 	if (ret == -ENOENT)
 		ret = inotify_new_watch(group, inode, arg);
-	/*
-	 * inotify_new_watch could race with another thread which did an
-	 * inotify_new_watch between the update_existing and the add watch
-	 * here, go back and try to update an existing mark again.
-	 */
-	if (ret == -EEXIST)
-		goto retry;
+	mutex_unlock(&group->mark_mutex);
 
 	return ret;
 }
-- 
1.5.6.5

