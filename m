Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab0LBKH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 05:07:28 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:49272 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751434Ab0LBKH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 05:07:27 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18F9+k1IIsF54MOgm26VUveD1tPoBNUdsMudZounC
	Y797AW4s375a8p
Date: Thu, 2 Dec 2010 11:05:22 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/6] dnotify: replace dnotify_mark_mutex with dnotify_group
	mutex
Message-ID: <20101202100522.GD5196@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since we introduced a new mutex for fsnotify groups we dont need an extra
dnotify_mark_mutex any more.
This patch replaces the dnotify_mark_mutex with the dnotify_group mutex.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/dnotify/dnotify.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 3344bdd..89ec7e0 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -31,7 +31,6 @@ int dir_notify_enable __read_mostly = 1;
 static struct kmem_cache *dnotify_struct_cache __read_mostly;
 static struct kmem_cache *dnotify_mark_cache __read_mostly;
 static struct fsnotify_group *dnotify_group __read_mostly;
-static DEFINE_MUTEX(dnotify_mark_mutex);
 
 /*
  * dnotify will attach one of these to each inode (i_fsnotify_marks) which
@@ -183,7 +182,7 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 		return;
 	dn_mark = container_of(fsn_mark, struct dnotify_mark, fsn_mark);
 
-	mutex_lock(&dnotify_mark_mutex);
+	mutex_lock(&dnotify_group->mutex);
 
 	spin_lock(&fsn_mark->lock);
 	prev = &dn_mark->dn;
@@ -199,11 +198,11 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 
 	spin_unlock(&fsn_mark->lock);
 
-	/* nothing else could have found us thanks to the dnotify_mark_mutex */
+	/* nothing else could have found us thanks to the dnotify_group mutex */
 	if (dn_mark->dn == NULL)
 		fsnotify_destroy_mark(fsn_mark);
 
-	mutex_unlock(&dnotify_mark_mutex);
+	mutex_unlock(&dnotify_group->mutex);
 
 	fsnotify_put_mark(fsn_mark);
 }
@@ -326,7 +325,7 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 	new_dn_mark->dn = NULL;
 
 	/* this is needed to prevent the fcntl/close race described below */
-	mutex_lock(&dnotify_mark_mutex);
+	mutex_lock(&dnotify_group->mutex);
 
 	/* add the new_fsn_mark or find an old one. */
 	fsn_mark = fsnotify_find_inode_mark(dnotify_group, inode);
@@ -348,8 +347,8 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 
 	/* if (f != filp) means that we lost a race and another task/thread
 	 * actually closed the fd we are still playing with before we grabbed
-	 * the dnotify_mark_mutex and fsn_mark->lock.  Since closing the fd is the
-	 * only time we clean up the marks we need to get our mark off
+	 * the dnotify_group mutex and fsn_mark->lock. Since closing the fd is
+	 * the only time we clean up the marks we need to get our mark off
 	 * the list. */
 	if (f != filp) {
 		/* if we added ourselves, shoot ourselves, it's possible that
@@ -387,7 +386,7 @@ out:
 	if (destroy)
 		fsnotify_destroy_mark(fsn_mark);
 
-	mutex_unlock(&dnotify_mark_mutex);
+	mutex_unlock(&dnotify_group->mutex);
 	fsnotify_put_mark(fsn_mark);
 out_err:
 	if (new_fsn_mark)
-- 
1.5.6.5

