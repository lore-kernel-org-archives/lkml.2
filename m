Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab2K1Vfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:35:45 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53082 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652Ab2K1Ve7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:34:59 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, mhocko@suse.cz, bsingharora@gmail.com,
        hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/13] cpuset: schedule hotplug propagation from cpuset_attach() if the cpuset is empty
Date: Wed, 28 Nov 2012 13:34:19 -0800
Message-Id: <1354138460-19286-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354138460-19286-1-git-send-email-tj@kernel.org>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuset is scheduled to be decoupled from cgroup_lock which will make
hotplug handling race with task migration.  cpus or mems will be
allowed to go offline between ->can_attach() and ->attach().  If
hotplug takes down all cpus or mems of a cpuset while attach is in
progress, ->attach() may end up putting tasks into an empty cpuset.

This patchset makes ->attach() schedule hotplug propagation if the
cpuset is empty after attaching is complete.  This will move the tasks
to the nearest ancestor which can execute and the end result would be
as if hotplug handling happened after the tasks finished attaching.

cpuset_write_resmask() now also flushes cpuset_propagate_hotplug_wq to
wait for propagations scheduled directly by cpuset_attach().

This currently doesn't make any functional difference as everything is
protected by cgroup_mutex but enables decoupling the locking.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cpuset.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 68a0906..79be3f0 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -266,6 +266,7 @@ static struct workqueue_struct *cpuset_propagate_hotplug_wq;
 
 static void cpuset_hotplug_workfn(struct work_struct *work);
 static void cpuset_propagate_hotplug_workfn(struct work_struct *work);
+static void schedule_cpuset_propagate_hotplug(struct cpuset *cs);
 
 static DECLARE_WORK(cpuset_hotplug_work, cpuset_hotplug_workfn);
 
@@ -1458,6 +1459,14 @@ static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 	}
 
 	cs->attach_in_progress--;
+
+	/*
+	 * We may have raced with CPU/memory hotunplug.  Trigger hotplug
+	 * propagation if @cs doesn't have any CPU or memory.  It will move
+	 * the newly added tasks to the nearest parent which can execute.
+	 */
+	if (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
+		schedule_cpuset_propagate_hotplug(cs);
 }
 
 /* The various types of files and directories in a cpuset file system */
@@ -1563,8 +1572,13 @@ static int cpuset_write_resmask(struct cgroup *cgrp, struct cftype *cft,
 	 * resources, wait for the previously scheduled operations before
 	 * proceeding, so that we don't end up keep removing tasks added
 	 * after execution capability is restored.
+	 *
+	 * Flushing cpuset_hotplug_work is enough to synchronize against
+	 * hotplug hanlding; however, cpuset_attach() may schedule
+	 * propagation work directly.  Flush the workqueue too.
 	 */
 	flush_work(&cpuset_hotplug_work);
+	flush_workqueue(cpuset_propagate_hotplug_wq);
 
 	if (!cgroup_lock_live_group(cgrp))
 		return -ENODEV;
-- 
1.7.11.7

