Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab0ELQIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 12:08:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756315Ab0ELQIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 12:08:01 -0400
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] inotify: race use after free/double free in inotify inode marks
Date: Wed, 12 May 2010 12:08:00 -0400
Message-Id: <1273680480-2550-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: root <root@tyan-gt24-04.rhts.eng.bos.redhat.com>

There is a race in the inotify add/rm watch code.  A task can find and
remove a mark which doesn't have all of it's references.  This can
result in a use after free/double free situation.

Task A					Task B
------------				-----------
inotify_new_watch()
 allocate a mark (refcnt == 1)
 add it to the idr
					inotify_rm_watch()
					 inotify_remove_from_idr()
					  fsnotify_put_mark()
					      refcnt hits 0, free
 take reference because we are on idr
 [at this point it is a use after free]
 [time goes on]
 refcnt may hit 0 again, double free

The fix is to take the reference BEFORE the object can be found in the
idr.

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 fs/notify/inotify/inotify_user.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 40da732..e46ca68 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -546,21 +546,24 @@ retry:
 	if (unlikely(!idr_pre_get(&group->inotify_data.idr, GFP_KERNEL)))
 		goto out_err;
 
+	/* we are putting the mark on the idr, take a reference */
+	fsnotify_get_mark(&tmp_ientry->fsn_entry);
+
 	spin_lock(&group->inotify_data.idr_lock);
 	ret = idr_get_new_above(&group->inotify_data.idr, &tmp_ientry->fsn_entry,
 				group->inotify_data.last_wd+1,
 				&tmp_ientry->wd);
 	spin_unlock(&group->inotify_data.idr_lock);
 	if (ret) {
+		/* we didn't get on the idr, drop the idr reference */
+		fsnotify_put_mark(&tmp_ientry->fsn_entry);
+
 		/* idr was out of memory allocate and try again */
 		if (ret == -EAGAIN)
 			goto retry;
 		goto out_err;
 	}
 
-	/* we put the mark on the idr, take a reference */
-	fsnotify_get_mark(&tmp_ientry->fsn_entry);
-
 	/* we are on the idr, now get on the inode */
 	ret = fsnotify_add_mark(&tmp_ientry->fsn_entry, group, inode);
 	if (ret) {
-- 
1.6.5.3

