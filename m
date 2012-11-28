Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab2K1UPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:15:50 -0500
Received: from mail-we0-f202.google.com ([74.125.82.202]:35743 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab2K1UPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:15:47 -0500
From: Greg Thelen <gthelen@google.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>,
        Aaron Durbin <adurbin@google.com>
Subject: [PATCH] cgroup: fix lockdep warning for event_control
Date: Wed, 28 Nov 2012 12:15:42 -0800
Message-Id: <1354133742-22175-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cgroup_event_wake() function is called with the wait queue head
locked and it takes cgrp->event_list_lock. However, in cgroup_rmdir()
remove_wait_queue() was being called after taking
cgrp->event_list_lock.  Correct the lock ordering by using a temporary
list to obtain the event list to remove from the wait queue.

Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Aaron Durbin <adurbin@google.com>
---
 kernel/cgroup.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ece60d4..c79a969 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4276,6 +4276,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	DEFINE_WAIT(wait);
 	struct cgroup_event *event, *tmp;
 	struct cgroup_subsys *ss;
+	struct list_head tmp_list;
 
 	lockdep_assert_held(&d->d_inode->i_mutex);
 	lockdep_assert_held(&cgroup_mutex);
@@ -4330,16 +4331,20 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	/*
 	 * Unregister events and notify userspace.
 	 * Notify userspace about cgroup removing only after rmdir of cgroup
-	 * directory to avoid race between userspace and kernelspace
+	 * directory to avoid race between userspace and kernelspace. Use
+	 * a temporary list to avoid a deadlock with cgroup_event_wake(). Since
+	 * cgroup_event_wake() is called with the wait queue head locked,
+	 * remove_wait_queue() cannot be called while holding event_list_lock.
 	 */
 	spin_lock(&cgrp->event_list_lock);
-	list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
+	list_replace_init(&cgrp->event_list, &tmp_list);
+	spin_unlock(&cgrp->event_list_lock);
+	list_for_each_entry_safe(event, tmp, &tmp_list, list) {
 		list_del(&event->list);
 		remove_wait_queue(event->wqh, &event->wait);
 		eventfd_signal(event->eventfd, 1);
 		schedule_work(&event->remove);
 	}
-	spin_unlock(&cgrp->event_list_lock);
 
 	return 0;
 }
-- 
1.7.7.3

