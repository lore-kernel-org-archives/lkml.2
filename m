Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1JQHcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 03:32:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51607 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab1JQHcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 03:32:01 -0400
Message-ID: <4E9BDA43.6060406@cn.fujitsu.com>
Date: Mon, 17 Oct 2011 15:33:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ben Blum <bblum@andrew.cmu.edu>, Frederic Weisbecker <fweisbec@redhat.com>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cgroups: don't cache common ancestor in task counter subsys
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-17 15:30:13,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-17 15:30:13,
	Serialize complete at 2011-10-17 15:30:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To reproduce the bug:

  # mount -t cgroup -o tasks xxx /cgroup
  # mkdir /cgroup/tmp
  # echo PID > /cgroup/tmp/cgroups.proc (PID has child threads)
  # echo PID > /cgroup/tasks
  # ecoh PID > /cgroup/tmp/cgroups.proc
  (oops!)

the call graph is:

	for_each_thread()
	    can_attach_task();

	for_each_thead()
	    attach_task();

but not:

	for_each_thread() {
	    can_attach_task();
	    attach_task();
	}

So common_ancestor used in attach_task() is always the value calculated
in the last can_attach_task() call.

To fix it, instead of caching, we always calculate the value every time
we want to use it.

Reported-by: Ben Blum <bblum@andrew.cmu.edu>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/cgroups/cgroups.txt |    3 ++-
 include/linux/cgroup.h            |    2 +-
 kernel/cgroup.c                   |    7 ++++---
 kernel/cgroup_task_counter.c      |   24 +++++++++++++++++-------
 4 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 3bc1dc9..f9e51a8 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -623,7 +623,8 @@ function, so that the subsystem can implement a rollback. If not, not necessary.
 This will be called only about subsystems whose can_attach() operation have
 succeeded.
 
-void cancel_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+void cancel_attach_task(struct cgroup *cgrp, struct cgroup *oldcgrp,
+			struct task_struct *tsk)
 (cgroup_mutex held by caller)
 
 As cancel_attach, but for operations that must be cancelled once per
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 9c8151e..e4659c4 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -475,7 +475,7 @@ struct cgroup_subsys {
 			       struct task_struct *tsk);
 	void (*cancel_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			      struct task_struct *tsk);
-	void (*cancel_attach_task)(struct cgroup *cgrp,
+	void (*cancel_attach_task)(struct cgroup *cgrp, struct cgroup *oldcgrp,
 				   struct task_struct *tsk);
 	void (*pre_attach)(struct cgroup *cgrp);
 	void (*attach_task)(struct cgroup *cgrp, struct cgroup *old_cgrp,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 018df9d..91abc9b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1885,7 +1885,7 @@ out:
 				break;
 
 			if (ss->cancel_attach_task)
-				ss->cancel_attach_task(cgrp, tsk);
+				ss->cancel_attach_task(cgrp, oldcgrp, tsk);
 			if (ss->cancel_attach)
 				ss->cancel_attach(ss, cgrp, tsk);
 		}
@@ -2151,7 +2151,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 			}
 		} else if (retval == -ESRCH) {
 			if (ss->cancel_attach_task)
-				ss->cancel_attach_task(cgrp, tsk);
+				ss->cancel_attach_task(cgrp, oldcgrp, tsk);
 		} else {
 			BUG_ON(1);
 		}
@@ -2191,7 +2191,8 @@ out_cancel_attach:
 					tsk = flex_array_get_ptr(group, i);
 					if (tsk == failed_task)
 						break;
-					ss->cancel_attach_task(cgrp, tsk);
+					ss->cancel_attach_task(cgrp, oldcgrp,
+							       tsk);
 				}
 			}
 
diff --git a/kernel/cgroup_task_counter.c b/kernel/cgroup_task_counter.c
index 2374905..a647174 100644
--- a/kernel/cgroup_task_counter.c
+++ b/kernel/cgroup_task_counter.c
@@ -94,11 +94,14 @@ static void task_counter_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
 		res_counter_uncharge(cgroup_task_res_counter(old_cgrp), 1);
 }
 
-/*
- * Protected amongst can_attach_task/attach_task/cancel_attach_task by
- * cgroup mutex
- */
-static struct res_counter *common_ancestor;
+static struct res_counter *find_common_ancestor(struct cgroup *cgrp,
+						struct cgroup *old_cgrp)
+{
+	struct res_counter *res = cgroup_task_res_counter(cgrp);
+	struct res_counter *old_res = cgroup_task_res_counter(old_cgrp);
+
+	return res_counter_common_ancestor(res, old_res);
+}
 
 /*
  * This does more than just probing the ability to attach to the dest cgroup.
@@ -112,7 +115,7 @@ static int task_counter_can_attach_task(struct cgroup *cgrp,
 					struct task_struct *tsk)
 {
 	struct res_counter *res = cgroup_task_res_counter(cgrp);
-	struct res_counter *old_res = cgroup_task_res_counter(old_cgrp);
+	struct res_counter *common_ancestor;
 	int err;
 
 	/*
@@ -123,7 +126,7 @@ static int task_counter_can_attach_task(struct cgroup *cgrp,
 	 * in the ancestor and spuriously fail due to the temporary
 	 * charge.
 	 */
-	common_ancestor = res_counter_common_ancestor(res, old_res);
+	common_ancestor = find_common_ancestor(cgrp, old_cgrp);
 
 	/*
 	 * If cgrp is the root then res is NULL, however in this case
@@ -138,8 +141,12 @@ static int task_counter_can_attach_task(struct cgroup *cgrp,
 
 /* Uncharge the dest cgroup that we charged in task_counter_can_attach_task() */
 static void task_counter_cancel_attach_task(struct cgroup *cgrp,
+					    struct cgroup *oldcgrp,
 					    struct task_struct *tsk)
 {
+	struct res_counter *common_ancestor;
+
+	common_ancestor = find_common_ancestor(cgrp, oldcgrp);
 	res_counter_uncharge_until(cgroup_task_res_counter(cgrp),
 				   common_ancestor, 1);
 }
@@ -155,6 +162,9 @@ static void task_counter_attach_task(struct cgroup *cgrp,
 				     struct cgroup *old_cgrp,
 				     struct task_struct *tsk)
 {
+	struct res_counter *common_ancestor;
+
+	common_ancestor = find_common_ancestor(cgrp, old_cgrp);
 	res_counter_uncharge_until(cgroup_task_res_counter(old_cgrp),
 				   common_ancestor, 1);
 }
-- 
1.7.3.1
