Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1BNTQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:16:38 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:46957 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1BNTQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:16:33 -0500
From: Daniel Lezcano <daniel.lezcano@free.fr>
To: akpm@linux-foundation.org
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, ebiederm@xmission.com
Subject: [PATCH 1/3] pid: Remove the child_reaper special case in init/main.c
Date: Mon, 14 Feb 2011 20:16:01 +0100
Message-Id: <1297710963-19843-2-git-send-email-daniel.lezcano@free.fr>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297710963-19843-1-git-send-email-daniel.lezcano@free.fr>
References: <1297710963-19843-1-git-send-email-daniel.lezcano@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

It turns out that the existing assignment in copy_process of
the child_reaper can handle the initial assignment of child_reaper
we just need to generalize the test in kernel/fork.c

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
---
 include/linux/pid.h |   11 +++++++++++
 init/main.c         |    9 ---------
 kernel/fork.c       |    2 +-
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index 49f1c2f..efceda0 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -141,6 +141,17 @@ static inline struct pid_namespace *ns_of_pid(struct pid *pid)
 }
 
 /*
+ * is_child_reaper returns true if the pid is the init process
+ * of the current namespace. As this one could be checked before
+ * pid_ns->child_reaper is assigned in copy_process, we check
+ * with the pid number.
+ */
+static inline bool is_child_reaper(struct pid *pid)
+{
+	return pid->numbers[pid->level].nr == 1;
+}
+
+/*
  * the helpers to get the pid's id seen from different namespaces
  *
  * pid_nr()    : global id, i.e. the id seen from the init namespace;
diff --git a/init/main.c b/init/main.c
index 33c37c3..793ebfd 100644
--- a/init/main.c
+++ b/init/main.c
@@ -875,15 +875,6 @@ static int __init kernel_init(void * unused)
 	 * init can run on any cpu.
 	 */
 	set_cpus_allowed_ptr(current, cpu_all_mask);
-	/*
-	 * Tell the world that we're going to be the grim
-	 * reaper of innocent orphaned children.
-	 *
-	 * We don't want people to have to make incorrect
-	 * assumptions about where in the task array this
-	 * can be found.
-	 */
-	init_pid_ns.child_reaper = current;
 
 	cad_pid = task_pid(current);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 25e4291..c9f0784 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1289,7 +1289,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		tracehook_finish_clone(p, clone_flags, trace);
 
 		if (thread_group_leader(p)) {
-			if (clone_flags & CLONE_NEWPID)
+			if (is_child_reaper(pid))
 				p->nsproxy->pid_ns->child_reaper = p;
 
 			p->signal->leader_pid = pid;
-- 
1.7.1

