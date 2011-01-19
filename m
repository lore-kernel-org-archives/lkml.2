Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab1ASQyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:54:17 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:49380 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752108Ab1ASQyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:54:16 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX19hXb40DTlhCZD0IrRnR7kmw6o44TY37BjjsqNMB8
	6TE6a/VtdJTUm2
Date: Wed, 19 Jan 2011 17:51:05 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 11/14] fsnotify: dont use a free_list to remove marks in
	clear_marks_by_group_flags()
Message-ID: <20110119165105.GB20335@lsanfilippo.unix.rd.tt.avira.com>
Reply-To: 1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dont use a to use a temporary "free_list" in clear_mark_by_group_flags() any more,
since it is now possible to remove a mark while a spinlock is held.  

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/mark.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 87d78b9..2827867 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -204,24 +204,16 @@ void fsnotify_clear_marks_by_group_flags(struct fsnotify_group *group,
 					 unsigned int flags)
 {
 	struct fsnotify_mark *lmark, *mark;
-	LIST_HEAD(free_list);
 
 	spin_lock(&group->mark_lock);
 	list_for_each_entry_safe(mark, lmark, &group->marks_list, g_list) {
-		if (mark->flags & flags) {
-			list_add(&mark->free_g_list, &free_list);
-			list_del_init(&mark->g_list);
-			fsnotify_get_mark(mark);
-		}
+		if (mark->flags & flags)
+			fsnotify_remove_mark_locked(mark);
 	}
 	spin_unlock(&group->mark_lock);
-
-	list_for_each_entry_safe(mark, lmark, &free_list, free_g_list) {
-		fsnotify_destroy_mark(mark);
-		fsnotify_put_mark(mark);
-	}
 }
 
+
 /*
  * Given a group, destroy all of the marks associated with that group.
  */
-- 
1.5.6.5

