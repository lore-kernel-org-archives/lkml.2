Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab1I3Ns5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:48:57 -0400
Received: from mx.kernel.net.pl ([217.73.31.3]:34090 "EHLO an2.kernel.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757119Ab1I3Nsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:48:55 -0400
From: Witold Krecicki <wpk@culm.net>
To: Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 3/6] cgroup: add 'root' parameter to cgroup_path function
Date: Fri, 30 Sep 2011 15:48:47 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
References: <1317382585-12172-1-git-send-email-wpk@culm.net> <1317382585-12172-4-git-send-email-wpk@culm.net>
In-Reply-To: <1317382585-12172-4-git-send-email-wpk@culm.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109301548.47947.wpk@culm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original patch was broken (showing incorrect cgroups inside the container), 
here goes the corrected version.



This patch adds 'root' parameter to 'cgroup_path' function. When it's
not NULL creating cgroup path will stop when current cgroup is 'root'.
A task contained in cgroup isolation root will see its cgroup in
/proc/$PID/cgroup with isolation root as top.

Signed-off-by: Witold Krecicki <wpk@culm.net>
---
 block/blk-cgroup.c     |    2 +-
 include/linux/cgroup.h |    3 ++-
 kernel/cgroup.c        |   21 +++++++++++++++------
 kernel/cpuset.c        |    2 +-
 kernel/sched_debug.c   |    2 +-
 mm/memcontrol.c        |    6 +++---
 6 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index b596e54..2dd96e7 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -491,7 +491,7 @@ void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 	blkg->plid = plid;
 	spin_unlock_irqrestore(&blkcg->lock, flags);
 	/* Need to take css reference ? */
-	cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path));
+	cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path), NULL);
 	blkg->dev = dev;
 }
 EXPORT_SYMBOL_GPL(blkiocg_add_blkio_group);
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 6965591..3b36554 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -436,7 +436,8 @@ int cgroup_add_files(struct cgroup *cgrp,
 
 int cgroup_is_removed(const struct cgroup *cgrp);
 
-int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
+int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen,
+		 const struct cgroup *root);
 
 int cgroup_task_count(const struct cgroup *cgrp);
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0177472..182c435 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1716,18 +1716,20 @@ static inline struct cftype *__d_cft(struct dentry 
*dentry)
  * @cgrp: the cgroup in question
  * @buf: the buffer to write the path into
  * @buflen: the length of the buffer
+ * @root: root cgroup for isolation
  *
  * Called with cgroup_mutex held or else with an RCU-protected cgroup
  * reference.  Writes path of cgroup into buf.  Returns 0 on success,
  * -errno on error.
  */
-int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
+int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen,
+		 const struct cgroup *root)
 {
 	char *start;
 	struct dentry *dentry = rcu_dereference_check(cgrp->dentry,
 						      cgroup_lock_is_held());
 
-	if (!dentry || cgrp == dummytop) {
+	if (!dentry || cgrp == dummytop || cgrp == root) {
 		/*
 		 * Inactive subsystems have no dentry for their root
 		 * cgroup
@@ -1748,7 +1750,12 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, 
int buflen)
 		cgrp = cgrp->parent;
 		if (!cgrp)
 			break;
-
+		if (cgrp == root) {
+			if (--start < buf)
+				return -ENAMETOOLONG;
+			*start = '/';
+			break;
+		}
 		dentry = rcu_dereference_check(cgrp->dentry,
 					       cgroup_lock_is_held());
 		if (!cgrp->parent)
@@ -4459,7 +4466,7 @@ static int proc_cgroup_show(struct seq_file *m, void *v)
 
 	for_each_active_root(root) {
 		struct cgroup_subsys *ss;
-		struct cgroup *cgrp;
+		struct cgroup *cgrp, *asking_cgrp, *isol_root_cgrp;
 		int count = 0;
 
 		seq_printf(m, "%d:", root->hierarchy_id);
@@ -4470,7 +4477,9 @@ static int proc_cgroup_show(struct seq_file *m, void *v)
 				   root->name);
 		seq_putc(m, ':');
 		cgrp = task_cgroup_from_root(tsk, root);
-		retval = cgroup_path(cgrp, buf, PAGE_SIZE);
+		asking_cgrp = task_cgroup_from_root(current, root);
+		isol_root_cgrp = cgroup_get_isolation_root(asking_cgrp);
+		retval = cgroup_path(cgrp, buf, PAGE_SIZE, isol_root_cgrp);
 		if (retval < 0)
 			goto out_unlock;
 		seq_puts(m, buf);
@@ -4790,7 +4799,7 @@ static void cgroup_release_agent(struct work_struct 
*work)
 		pathbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!pathbuf)
 			goto continue_free;
-		if (cgroup_path(cgrp, pathbuf, PAGE_SIZE) < 0)
+		if (cgroup_path(cgrp, pathbuf, PAGE_SIZE, NULL) < 0)
 			goto continue_free;
 		agentbuf = kstrdup(cgrp->root->release_agent_path, GFP_KERNEL);
 		if (!agentbuf)
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 10131fd..6206a5c 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2583,7 +2583,7 @@ static int proc_cpuset_show(struct seq_file *m, void 
*unused_v)
 	retval = -EINVAL;
 	cgroup_lock();
 	css = task_subsys_state(tsk, cpuset_subsys_id);
-	retval = cgroup_path(css->cgroup, buf, PAGE_SIZE);
+	retval = cgroup_path(css->cgroup, buf, PAGE_SIZE, NULL);
 	if (retval < 0)
 		goto out_unlock;
 	seq_puts(m, buf);
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index a6710a1..bdd8e9a 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -103,7 +103,7 @@ static char *task_group_path(struct task_group *tg)
 		group_path[0] = '\0';
 		return group_path;
 	}
-	cgroup_path(tg->css.cgroup, group_path, PATH_MAX);
+	cgroup_path(tg->css.cgroup, group_path, PATH_MAX, NULL);
 	return group_path;
 }
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3508777..6e5b35e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1388,7 +1388,7 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, 
struct task_struct *p)
 	mem_cgrp = memcg->css.cgroup;
 	task_cgrp = task_cgroup(p, mem_cgroup_subsys_id);
 
-	ret = cgroup_path(task_cgrp, memcg_name, PATH_MAX);
+	ret = cgroup_path(task_cgrp, memcg_name, PATH_MAX, NULL);
 	if (ret < 0) {
 		/*
 		 * Unfortunately, we are unable to convert to a useful name
@@ -1402,7 +1402,7 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, 
struct task_struct *p)
 	printk(KERN_INFO "Task in %s killed", memcg_name);
 
 	rcu_read_lock();
-	ret = cgroup_path(mem_cgrp, memcg_name, PATH_MAX);
+	ret = cgroup_path(mem_cgrp, memcg_name, PATH_MAX, NULL);
 	if (ret < 0) {
 		rcu_read_unlock();
 		goto done;
@@ -3390,7 +3390,7 @@ void mem_cgroup_print_bad_page(struct page *page)
 		if (path) {
 			rcu_read_lock();
 			ret = cgroup_path(pc->mem_cgroup->css.cgroup,
-							path, PATH_MAX);
+						path, PATH_MAX, NULL);
 			rcu_read_unlock();
 		}
 
-- 
1.7.4.1

