Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1KPVu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 16:50:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab1KPVuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 16:50:55 -0500
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        Tomasz Buchert <tomasz.buchert@inria.fr>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <htejun@gmail.com>
Subject: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks
Date: Wed, 16 Nov 2011 22:50:34 +0100
Message-Id: <1321480234-29241-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2d3cbf8b (cgroup_freezer: update_freezer_state() does incorrect state
transitions) removed is_task_frozen_enough and replaced it with a simple
frozen call. This, however, breaks freezing for a group with stopped tasks
because those cannot be frozen and so the group remains in CGROUP_FREEZING
state (update_if_frozen doesn't count stopped tasks) and never reaches
CGROUP_FROZEN.

Let's add is_task_frozen_enough back and use it at the original locations
(update_if_frozen and try_to_freeze_cgroup). Semantically we consider
stopped tasks as frozen enough so we should consider both cases when
testing frozen tasks.

Testcase:
mkdir /dev/freezer
mount -t cgroup -o freezer none /dev/freezer
mkdir /dev/freezer/foo
sleep 1h &
pid=$!
kill -STOP $pid
echo $pid > /dev/freezer/foo/tasks
echo FROZEN > /dev/freezer/foo/freezer.state
while true
do
        cat /dev/freezer/foo/freezer.state
        [ "`cat /dev/freezer/foo/freezer.state`" = "FROZEN" ] && break
        sleep 1
done
echo OK

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Tomasz Buchert <tomasz.buchert@inria.fr>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>
---
 kernel/cgroup_freezer.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 5e828a2..4d073dc 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -153,6 +153,13 @@ static void freezer_destroy(struct cgroup_subsys *ss,
 	kfree(cgroup_freezer(cgroup));
 }
 
+/* Task is frozen or will freeze immediately when next it gets woken */
+static bool is_task_frozen_enough(struct task_struct *task)
+{
+	return frozen(task) ||
+		(task_is_stopped_or_traced(task) && freezing(task));
+}
+
 /*
  * The call to cgroup_lock() in the freezer.state write method prevents
  * a write to that file racing against an attach, and hence the
@@ -231,7 +238,7 @@ static void update_if_frozen(struct cgroup *cgroup,
 	cgroup_iter_start(cgroup, &it);
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		ntotal++;
-		if (frozen(task))
+		if (is_task_frozen_enough(task))
 			nfrozen++;
 	}
 
@@ -284,7 +291,7 @@ static int try_to_freeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		if (!freeze_task(task, true))
 			continue;
-		if (frozen(task))
+		if (is_task_frozen_enough(task))
 			continue;
 		if (!freezing(task) && !freezer_should_skip(task))
 			num_cant_freeze_now++;
-- 
1.7.7.1

