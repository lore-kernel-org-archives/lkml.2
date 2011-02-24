Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1BXMkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 07:40:43 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:57098 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754853Ab1BXMkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 07:40:40 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18XQv1p3WAXcrtA1i1ZkOOyJfysOtM0A4d1vprlDX
	7b40wHRq98VvNN
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH] inotify: dont skip removing mark from idr when creation of ignore event failed
Date: Thu, 24 Feb 2011 13:36:22 +0100
Message-Id: <1298550982-27080-1-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In inotify_ignored_and_remove_idr() dont skip removing a mark from the idr if
allocating an "ignored event" failed.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
The patch applies against commit ef9bf3b7144bee6ce1da5616015cabc8771206af of
branch 'origin/for-next' from git.infradead.org/users/eparis/notify.git

 fs/notify/inotify/inotify_user.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 4cd5d5d..3cda8a4 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -522,17 +522,17 @@ void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
 	struct fsnotify_event_private_data *fsn_event_priv;
 	int ret;
 
+	i_mark = container_of(fsn_mark, struct inotify_inode_mark, fsn_mark);
+
 	ignored_event = fsnotify_create_event(NULL, FS_IN_IGNORED, NULL,
 					      FSNOTIFY_EVENT_NONE, NULL, 0,
 					      GFP_NOFS);
 	if (!ignored_event)
-		return;
-
-	i_mark = container_of(fsn_mark, struct inotify_inode_mark, fsn_mark);
+		goto skip_send_ignore;
 
 	event_priv = kmem_cache_alloc(event_priv_cachep, GFP_NOFS);
 	if (unlikely(!event_priv))
-		goto skip_send_ignore;
+		goto skip_send_ignore2;
 
 	fsn_event_priv = &event_priv->fsnotify_event_priv_data;
 
@@ -548,11 +548,12 @@ void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
 		inotify_free_event_priv(fsn_event_priv);
 	}
 
-skip_send_ignore:
+skip_send_ignore2:
 
 	/* matches the reference taken when the event was created */
 	fsnotify_put_event(ignored_event);
 
+skip_send_ignore:
 	/* remove this mark from the idr */
 	inotify_remove_from_idr(group, i_mark);
 
-- 
1.7.1

