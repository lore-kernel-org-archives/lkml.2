Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab1ASQqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:46:18 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:56224 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754713Ab1ASQqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:46:10 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+slitNb/msGgtQtyiy7jaAKI6kpi4a2YtvNgRfwl
	AjyMViYg6SN0Sd
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 07/14] fsnotify: handle number of marks and group ref counting independently from each other
Date: Wed, 19 Jan 2011 17:42:10 +0100
Message-Id: <1295455337-20219-8-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With that patch ref counting of a group and its number of marks are handled
independently.
A group starts with a num_marks value of 0 instead of 1 and it does not depend
any longer on the number of marks wheather a group is finally destroyed.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/group.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/notify/group.c b/fs/notify/group.c
index 0dcf497..a407bac 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -54,10 +54,7 @@ static void fsnotify_destroy_group(struct fsnotify_group *group)
 {
 	/* clear all inode marks for this group */
 	fsnotify_clear_marks_by_group(group);
-
-	/* past the point of no return, matches the initial value of 1 */
-	if (atomic_dec_and_test(&group->num_marks))
-		fsnotify_final_destroy_group(group);
+	fsnotify_final_destroy_group(group);
 }
 
 /*
@@ -82,11 +79,7 @@ struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops)
 
 	/* set to 0 when there a no external references to this group */
 	atomic_set(&group->refcnt, 1);
-	/*
-	 * hits 0 when there are no external references AND no marks for
-	 * this group
-	 */
-	atomic_set(&group->num_marks, 1);
+	atomic_set(&group->num_marks, 0);
 
 	mutex_init(&group->mutex);
 	mutex_init(&group->notification_mutex);
-- 
1.5.6.5

