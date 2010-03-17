Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab0CQQMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:12:25 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:36820 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab0CQQMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:12:20 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, containers@lists.linux-foundation.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [C/R v20][PATCH 04/96] eclone (4/11): Add target_pids parameter to alloc_pid()
Date: Wed, 17 Mar 2010 12:07:52 -0400
Message-Id: <1268842164-5590-5-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268842164-5590-4-git-send-email-orenl@cs.columbia.edu>
References: <1268842164-5590-1-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-2-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-3-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-4-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

This parameter is currently NULL, but will be used in a follow-on patch.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
---
 include/linux/pid.h |    2 +-
 kernel/fork.c       |    3 ++-
 kernel/pid.c        |    9 +++++++--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index 49f1c2f..914185d 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -119,7 +119,7 @@ extern struct pid *find_get_pid(int nr);
 extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
 int next_pidmap(struct pid_namespace *pid_ns, int last);
 
-extern struct pid *alloc_pid(struct pid_namespace *ns);
+extern struct pid *alloc_pid(struct pid_namespace *ns, pid_t *target_pids);
 extern void free_pid(struct pid *pid);
 
 /*
diff --git a/kernel/fork.c b/kernel/fork.c
index e9cf524..2e10cb8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -985,6 +985,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	int retval;
 	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
+	pid_t *target_pids = NULL;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1167,7 +1168,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_io;
 
 	if (pid != &init_struct_pid) {
-		pid = alloc_pid(p->nsproxy->pid_ns);
+		pid = alloc_pid(p->nsproxy->pid_ns, target_pids);
 		if (IS_ERR(pid)) {
 			retval = PTR_ERR(pid);
 			goto bad_fork_cleanup_io;
diff --git a/kernel/pid.c b/kernel/pid.c
index 1f15bb6..b0d7fc9 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -276,13 +276,14 @@ void free_pid(struct pid *pid)
 	call_rcu(&pid->rcu, delayed_put_pid);
 }
 
-struct pid *alloc_pid(struct pid_namespace *ns)
+struct pid *alloc_pid(struct pid_namespace *ns, pid_t *target_pids)
 {
 	struct pid *pid;
 	enum pid_type type;
 	int i, nr;
 	struct pid_namespace *tmp;
 	struct upid *upid;
+	pid_t tpid;
 
 	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
 	if (!pid) {
@@ -292,7 +293,11 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 
 	tmp = ns;
 	for (i = ns->level; i >= 0; i--) {
-		nr = alloc_pidmap(tmp);
+		tpid = 0;
+		if (target_pids)
+			tpid = target_pids[i];
+
+		nr = set_pidmap(tmp, tpid);
 		if (nr < 0)
 			goto out_free;
 
-- 
1.6.3.3

