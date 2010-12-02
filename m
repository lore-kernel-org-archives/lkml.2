Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab0LBKDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 05:03:54 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:59187 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752902Ab0LBKDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 05:03:53 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1/pQYp50svpfYaV9svWslHQPlXK02dlbW9aIKUVXi
	oTvLi+EbUl+HNx
Date: Thu, 2 Dec 2010 11:01:48 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/6] fsnotify: introduce new group mutex
Message-ID: <20101202100148.GB5196@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch intoduces a group specific mutex that is used to synchronize all 
group related data/tasks for which no dedicated lock exists yet. 

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/group.c                |    1 +
 include/linux/fsnotify_backend.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

Please apply this against commit 9f71741c75e5206e1fea72ddf2adf5661105444d of
branch 'origin/for-next' from git.infradead.org/users/eparis/notify.git

 Eric, as you can see i chose to introduce a new mutex instead of using the 
 notification_mutex since you may be right with you concerns about performance.
 I guess its ok since its what you preferred.

diff --git a/fs/notify/group.c b/fs/notify/group.c
index d309f38..cc341d3 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -90,6 +90,7 @@ struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops)
 	 */
 	atomic_set(&group->num_marks, 1);
 
+	mutex_init(&group->mutex);
 	mutex_init(&group->notification_mutex);
 	INIT_LIST_HEAD(&group->notification_list);
 	init_waitqueue_head(&group->notification_waitq);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index add1351..6a3c660 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -125,6 +125,7 @@ struct fsnotify_group {
 
 	const struct fsnotify_ops *ops;	/* how this group handles things */
 
+	struct mutex mutex;
 	/* needed to send notification to userspace */
 	struct mutex notification_mutex;	/* protect the notification_list */
 	struct list_head notification_list;	/* list of event_holder this group needs to send to userspace */
-- 
1.5.6.5

