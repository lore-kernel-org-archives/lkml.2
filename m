Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab2JPW37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:29:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63115 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab2JPW3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:29:00 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, oleg@redhat.com
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/7] cgroup_freezer: don't stall transition to FROZEN for PF_NOFREEZE or PF_FREEZER_SKIP tasks
Date: Tue, 16 Oct 2012 15:28:43 -0700
Message-Id: <1350426526-14254-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1350426526-14254-1-git-send-email-tj@kernel.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_freezer doesn't transition from FREEZING to FROZEN if the
cgroup contains PF_NOFREEZE tasks or tasks sleeping with
PF_FREEZER_SKIP set.

Only kernel tasks can be non-freezable (PF_NOFREEZE) and there's
nothing cgroup_freezer or userland can do about or to it.  It's
pointless to stall the transition for PF_NOFREEZE tasks.

PF_FREEZER_SKIP indicates that the task can be skipped when
determining whether frozen state is reached.  A task with
PF_FREEZER_SKIP is guaranteed to perform try_to_freeze() after it
wakes up and can be considered frozen much like stopped or traced
tasks.  Note that a vfork parent uses PF_FREEZER_SKIP while waiting
for the child.

This updates update_if_frozen() such that it only considers freezable
tasks and treats %true freezer_should_skip() tasks as frozen.

This allows cgroups w/ kthreads and vfork parents successfully reach
FROZEN state.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/cgroup_freezer.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 05d5218..557f367 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -214,10 +214,18 @@ static void update_if_frozen(struct cgroup *cgroup,
 
 	cgroup_iter_start(cgroup, &it);
 	while ((task = cgroup_iter_next(cgroup, &it))) {
-		ntotal++;
-		if (freezing(task) && (frozen(task) ||
-				       task_is_stopped_or_traced(task)))
-			nfrozen++;
+		if (freezing(task)) {
+			ntotal++;
+			/*
+			 * freezer_should_skip() indicates that the task
+			 * should be skipped when determining freezing
+			 * completion.  Consider it frozen in addition to
+			 * the usual frozen condition.
+			 */
+			if (frozen(task) || task_is_stopped_or_traced(task) ||
+			    freezer_should_skip(task))
+				nfrozen++;
+		}
 	}
 
 	if (old_state == CGROUP_THAWED) {
-- 
1.7.7.3

