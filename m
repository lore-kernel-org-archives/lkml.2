Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813Ab1KJRQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:16:17 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:46598 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900Ab1KJRQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:16:15 -0500
Message-ID: <4EBC06DB.3090202@parallels.com>
Date: Thu, 10 Nov 2011 21:16:11 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: [PATCH 3/3] pids: Make it possible to clone tasks with given pids
References: <4EBC0696.9030103@parallels.com>
In-Reply-To: <4EBC0696.9030103@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When restoring a task (or a set of tasks) we need to recreate them
with exactly the same pid(s) as they had before. Thus we need the
ability to create a task with specified pid. The proposal is to reuse
the already free CLONE_STOPPED clone flag, introduce the new one
called CLONE_CHILD_USEPIDS and point to the desired pids with the
child_tidptr.

The child_tidptr points to an array of pids for current namespace and
its ancestors. When 0 is met in this array the pid number for the
corresponding namespace is generated, rather than set.

For security reasons after a regular clone/fork is done in a namespace
further cloning with predefined pid is not allowed.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>

---
 include/linux/pid.h   |    2 +-
 include/linux/sched.h |    3 +--
 kernel/fork.c         |    4 +++-
 kernel/pid.c          |   39 +++++++++++++++++++++++++++++++++++++--
 4 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index b152d44..95aa618 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -119,7 +119,7 @@ extern struct pid *find_get_pid(int nr);
 extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
 int next_pidmap(struct pid_namespace *pid_ns, unsigned int last);
 
-extern struct pid *alloc_pid(struct pid_namespace *ns);
+extern struct pid *alloc_pid(struct pid_namespace *ns, int __user *want_pids);
 extern void free_pid(struct pid *pid);
 
 /*
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 41d0237..5472c4e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -21,8 +21,7 @@
 #define CLONE_DETACHED		0x00400000	/* Unused, ignored */
 #define CLONE_UNTRACED		0x00800000	/* set if the tracing process can't force CLONE_PTRACE on this clone */
 #define CLONE_CHILD_SETTID	0x01000000	/* set the TID in the child */
-/* 0x02000000 was previously the unused CLONE_STOPPED (Start in stopped state)
-   and is now available for re-use. */
+#define CLONE_CHILD_USEPIDS	0x02000000	/* use the pids given by user */
 #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
 #define CLONE_NEWIPC		0x08000000	/* New ipcs */
 #define CLONE_NEWUSER		0x10000000	/* New user namespace */
diff --git a/kernel/fork.c b/kernel/fork.c
index 45a5f54..26c67ff 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1253,7 +1253,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_io;
 
 	if (pid != &init_struct_pid) {
-		pid = alloc_pid(p->nsproxy->pid_ns);
+		pid = alloc_pid(p->nsproxy->pid_ns,
+				(clone_flags & CLONE_CHILD_USEPIDS) ?
+					child_tidptr : NULL);
 		if (IS_ERR(pid)) {
 			retval = PTR_ERR(pid);
 			goto bad_fork_cleanup_io;
diff --git a/kernel/pid.c b/kernel/pid.c
index 700dda3..fb6f74f 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -224,6 +224,27 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 	return -ENOMEM;
 }
 
+static int set_pidmap(struct pid_namespace *pid_ns, int pid)
+{
+	int offset;
+	struct pidmap *map;
+
+	offset = pid & BITS_PER_PAGE_MASK;
+	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
+
+	if (unlikely(!map->page))
+		if (alloc_pidmap_page(map))
+			return -ENOMEM;
+
+	if (pid_ns->last_pid != 0)
+		return -EPERM;
+
+	if (test_and_set_bit(offset, map->page))
+		return -EBUSY;
+
+	return pid;
+}
+
 int next_pidmap(struct pid_namespace *pid_ns, unsigned int last)
 {
 	int offset;
@@ -284,7 +305,7 @@ void free_pid(struct pid *pid)
 	call_rcu(&pid->rcu, delayed_put_pid);
 }
 
-struct pid *alloc_pid(struct pid_namespace *ns)
+struct pid *alloc_pid(struct pid_namespace *ns, int __user *want_pids)
 {
 	struct pid *pid;
 	enum pid_type type;
@@ -298,7 +319,21 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 
 	tmp = ns;
 	for (i = ns->level; i >= 0; i--) {
-		nr = alloc_pidmap(tmp);
+		nr = 0;
+		if (unlikely(want_pids != NULL)) {
+			if (get_user(nr, want_pids)) {
+				nr = -EFAULT;
+				goto out_free;
+			}
+
+			if (nr != 0) {
+				want_pids++;
+				nr = set_pidmap(tmp, nr);
+			} else
+				want_pids = NULL; /* optimize above */
+		}
+		if (nr == 0)
+			nr = alloc_pidmap(tmp);
 		if (nr < 0)
 			goto out_free;
 
-- 
1.5.5.6
