Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab2K1Vuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:50:52 -0500
Received: from mail-ea0-f202.google.com ([209.85.215.202]:50816 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658Ab2K1Vuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:50:50 -0500
From: Greg Thelen <gthelen@google.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH 2/2] cgroup: list_del_init() on removed events
Date: Wed, 28 Nov 2012 13:50:45 -0800
Message-Id: <1354139445-6685-2-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1354139445-6685-1-git-send-email-gthelen@google.com>
References: <1354139445-6685-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_del_init() rather than list_del() to remove events from
cgrp->event_list.  No functional change.  This is just defensive
coding.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 kernel/cgroup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a0d75bb..44c319d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3766,7 +3766,7 @@ static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
 	if (flags & POLLHUP) {
 		__remove_wait_queue(event->wqh, &event->wait);
 		spin_lock(&cgrp->event_list_lock);
-		list_del(&event->list);
+		list_del_init(&event->list);
 		spin_unlock(&cgrp->event_list_lock);
 		/*
 		 * We are in atomic context, but cgroup_event_remove() may
@@ -4340,7 +4340,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	list_splice_init(&cgrp->event_list, &tmp_list);
 	spin_unlock(&cgrp->event_list_lock);
 	list_for_each_entry_safe(event, tmp, &tmp_list, list) {
-		list_del(&event->list);
+		list_del_init(&event->list);
 		remove_wait_queue(event->wqh, &event->wait);
 		eventfd_signal(event->eventfd, 1);
 		schedule_work(&event->remove);
-- 
1.7.7.3

