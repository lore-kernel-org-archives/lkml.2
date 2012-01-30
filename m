Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab2A3BNc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 20:13:32 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47353 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab2A3BN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 20:13:29 -0500
Date: Mon, 30 Jan 2012 05:13:23 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, San Mehat <san@google.com>,
        Colin Cross <ccross@android.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 1/3] procfs: Export next_tgid(), move it to kernel/pid.c
Message-ID: <20120130011323.GA30274@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'd like to use this function in the android low memory killer driver, so
let's export it.

Also, move next_tgid() to kernel/pid.c, so now it lives with the rest of
pid library functions and does not depend on procfs. Plus, we may now hide
find_ge_pid() from the global namespace.

While at it, also turn next_tgid()'s comments into kerneldoc format.

There should be no functional changes.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/proc/base.c      |   43 -------------------------------------------
 include/linux/pid.h |    9 ++++++++-
 kernel/pid.c        |   41 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 48 insertions(+), 45 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 5485a53..84b8625 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3324,49 +3324,6 @@ out:
 	return result;
 }
 
-/*
- * Find the first task with tgid >= tgid
- *
- */
-struct tgid_iter {
-	unsigned int tgid;
-	struct task_struct *task;
-};
-static struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter iter)
-{
-	struct pid *pid;
-
-	if (iter.task)
-		put_task_struct(iter.task);
-	rcu_read_lock();
-retry:
-	iter.task = NULL;
-	pid = find_ge_pid(iter.tgid, ns);
-	if (pid) {
-		iter.tgid = pid_nr_ns(pid, ns);
-		iter.task = pid_task(pid, PIDTYPE_PID);
-		/* What we to know is if the pid we have find is the
-		 * pid of a thread_group_leader.  Testing for task
-		 * being a thread_group_leader is the obvious thing
-		 * todo but there is a window when it fails, due to
-		 * the pid transfer logic in de_thread.
-		 *
-		 * So we perform the straight forward test of seeing
-		 * if the pid we have found is the pid of a thread
-		 * group leader, and don't worry if the task we have
-		 * found doesn't happen to be a thread group leader.
-		 * As we don't care in the case of readdir.
-		 */
-		if (!iter.task || !has_group_leader_pid(iter.task)) {
-			iter.tgid += 1;
-			goto retry;
-		}
-		get_task_struct(iter.task);
-	}
-	rcu_read_unlock();
-	return iter;
-}
-
 #define TGID_OFFSET (FIRST_PROCESS_ENTRY + ARRAY_SIZE(proc_base_stuff))
 
 static int proc_pid_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
diff --git a/include/linux/pid.h b/include/linux/pid.h
index b152d44..33e350b 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -116,7 +116,6 @@ extern struct pid *find_vpid(int nr);
  * Lookup a PID in the hash table, and return with it's count elevated.
  */
 extern struct pid *find_get_pid(int nr);
-extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
 int next_pidmap(struct pid_namespace *pid_ns, unsigned int last);
 
 extern struct pid *alloc_pid(struct pid_namespace *ns);
@@ -199,4 +198,12 @@ pid_t pid_vnr(struct pid *pid);
 		} while_each_thread(tg___, task);			\
 		task = tg___;						\
 	} while_each_pid_task(pid, type, task)
+
+struct tgid_iter {
+	unsigned int tgid;
+	struct task_struct *task;
+};
+
+struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter iter);
+
 #endif /* _LINUX_PID_H */
diff --git a/kernel/pid.c b/kernel/pid.c
index ce8e00d..34a52a6 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -522,7 +522,7 @@ EXPORT_SYMBOL_GPL(task_active_pid_ns);
  *
  * If there is a pid at nr this function is exactly the same as find_pid_ns.
  */
-struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
+static struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
 {
 	struct pid *pid;
 
@@ -536,6 +536,45 @@ struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
 	return pid;
 }
 
+/**
+ * next_tgid() - Find the first task with tgid >= tgid
+ * @ns: pointer to the pid namespace
+ * @iter: iterator
+ */
+struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter iter)
+{
+	struct pid *pid;
+
+	if (iter.task)
+		put_task_struct(iter.task);
+	rcu_read_lock();
+retry:
+	iter.task = NULL;
+	pid = find_ge_pid(iter.tgid, ns);
+	if (pid) {
+		iter.tgid = pid_nr_ns(pid, ns);
+		iter.task = pid_task(pid, PIDTYPE_PID);
+		/* What we to know is if the pid we have find is the
+		 * pid of a thread_group_leader.  Testing for task
+		 * being a thread_group_leader is the obvious thing
+		 * todo but there is a window when it fails, due to
+		 * the pid transfer logic in de_thread.
+		 *
+		 * So we perform the straight forward test of seeing
+		 * if the pid we have found is the pid of a thread
+		 * group leader, and don't worry if the task we have
+		 * found doesn't happen to be a thread group leader.
+		 */
+		if (!iter.task || !has_group_leader_pid(iter.task)) {
+			iter.tgid += 1;
+			goto retry;
+		}
+		get_task_struct(iter.task);
+	}
+	rcu_read_unlock();
+	return iter;
+}
+
 /*
  * The pid hash table is scaled according to the amount of memory in the
  * machine.  From a minimum of 16 slots up to 4096 slots at one gigabyte or
-- 
1.7.7

