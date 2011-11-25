Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab1KYKPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 05:15:19 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:12935 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab1KYKPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 05:15:17 -0500
Message-ID: <4ECF6AA0.80006@parallels.com>
Date: Fri, 25 Nov 2011 14:14:56 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Pedro Alves <pedro@codesourcery.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with	given
 pids
References: <4EC4F2FB.408@parallels.com> <201111221204.39235.pedro@codesourcery.com> <20111122153326.GD322@google.com> <201111231620.45440.pedro@codesourcery.com> <20111123162417.GE25780@google.com> <4ECD3946.1030503@parallels.com> <4ECD542C.7010705@parallels.com> <20111124173121.GA23260@redhat.com>
In-Reply-To: <20111124173121.GA23260@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 09:31 PM, Oleg Nesterov wrote:
> On 11/24, Pavel Emelyanov wrote:
>>
>> Hm... Started testing this stuff and thought about Pedro's wish to use this
>> in gdb one more time :(
>>
>> The thing is, that we (in checkpoint/restore) are going to use this sysctl
>> when creating a pid namespace from scratch, thus having full control over
>> all the forks happening in this namespace.
>>
>> But when it comes to the ability for gdb to create a task with a given pid in
>> a _living_ namespace this solution simply won't work! It doesn't guarantee,
>> that after setting the last_pid via sysctl this last_pid stays the same at
>> the time we do call fork()/clone(). Because there are other tasks that can call
>> fork themselves ignoring any lask_pid locking we can play with.
> 
> Sure. ->last_pid is a hint, nothing more.
> 
> But nothing can work reliably on the running system. Even if we can't
> race with another fork(), the required pid_nr can be already in use.
> 
> Oleg.

OK, here's another proposal that seem to suit all of us:

1. me wants to clone tasks with pids set
2. Pedro wants to fork task with not changing pids and w/o root perms
3. Oleg and Tejun want to have little intrusion into fork() path

The proposal is to implement the PR_RESERVE_PID prctl which allocates and puts a
pid on the current. The subsequent fork() uses this pid, this pid survives and keeps
its bit in the pidmap after detach. The 2nd fork() after the 1st task death thus
can reuse the same pid again. This basic thing doesn't require root perms at all
and safe against pid reuse problems. When requesting for pid reservation task may
specify a pid number it wants to have, but this requires root perms (CAP_SYS_ADMIN).

Pedro, I suppose this will work for your checkpoint feature in gdb, am I right?

Few comments about intrusion:

 * the common path - if (pid != &init_struct_pid) - on fork is just modified
 * we have -1 argument to copy_process
 * one more field on struct pid is OK, since it size doesn't change (32 bit level is
   anyway not required, it's OK to reduce on down to 16 bits)
 * no clone flags extension
 * no new locking - the reserved pid manipulations happen under tasklist_lock and
   existing common paths do not require more of it
 * yes, we have +1 member on task_struct :(

Current API problems:

 * Only one fork() with pid at a time. Next call to PR_RESERVE_PID will kill the
   previous reservation (don't know how to fix)
 * No way to fork() an init of a pid sub-namespace with desired pid in current
   (can be fixed for a flag for PR_RESERVE_PID saying that we need a pid for a
    namespace of a next level)
 * No way to grab existing pid for reserve (can be fixed, if someone wants this)

Oleg, Tejun, do you agree with such an approach?

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>

---

diff --git a/include/linux/pid.h b/include/linux/pid.h
index b152d44..b87a4ac 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -57,13 +57,16 @@ struct upid {
 struct pid
 {
 	atomic_t count;
-	unsigned int level;
+	unsigned short flags;
+	unsigned short level;
 	/* lists of tasks that use this pid */
 	struct hlist_head tasks[PIDTYPE_MAX];
 	struct rcu_head rcu;
 	struct upid numbers[1];
 };
 
+#define PID_RESERVED	0x1
+
 extern struct pid init_struct_pid;
 
 struct pid_link
@@ -72,6 +75,11 @@ struct pid_link
 	struct pid *pid;
 };
 
+int reserve_pid(int nr);
+void __unreserve_pid(struct task_struct *p);
+void unreserve_pid(void);
+int pid_attached(struct pid *pid);
+
 static inline struct pid *get_pid(struct pid *pid)
 {
 	if (pid)
@@ -119,7 +127,7 @@ extern struct pid *find_get_pid(int nr);
 extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
 int next_pidmap(struct pid_namespace *pid_ns, unsigned int last);
 
-extern struct pid *alloc_pid(struct pid_namespace *ns);
+extern struct pid *alloc_pid(struct pid_namespace *ns, int want_pid);
 extern void free_pid(struct pid *pid);
 
 /*
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index a3baeb2..6cc443c 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -102,4 +102,7 @@
 
 #define PR_MCE_KILL_GET 34
 
+#define PR_RESERVE_PID		35
+#define PR_UNRESERVE_PID	36
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 68daf4f..a991b03 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1336,6 +1336,7 @@ struct task_struct {
 	struct pid_link pids[PIDTYPE_MAX];
 	struct list_head thread_group;
 
+	struct pid *rsv_pid;
 	struct completion *vfork_done;		/* for vfork() */
 	int __user *set_child_tid;		/* CLONE_CHILD_SETTID */
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
diff --git a/kernel/exit.c b/kernel/exit.c
index d0b7d98..ae028f8 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -177,6 +177,8 @@ repeat:
 	proc_flush_task(p);
 
 	write_lock_irq(&tasklist_lock);
+	if (p->rsv_pid)
+		__unreserve_pid(p);
 	ptrace_release_task(p);
 	__exit_signal(p);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index ba0d172..088d8fc 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -297,6 +297,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	tsk->btrace_seq = 0;
 #endif
 	tsk->splice_pipe = NULL;
+	tsk->rsv_pid = NULL;
 
 	account_kernel_stack(ti, 1);
 
@@ -1049,11 +1050,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 					struct pt_regs *regs,
 					unsigned long stack_size,
 					int __user *child_tidptr,
-					struct pid *pid,
 					int trace)
 {
 	int retval;
 	struct task_struct *p;
+	struct pid *pid = current->rsv_pid;
 	int cgroup_callbacks_done = 0;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
@@ -1249,9 +1250,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (retval)
 		goto bad_fork_cleanup_io;
 
-	if (pid != &init_struct_pid) {
+	if (pid == NULL || pid_attached(pid)) {
 		retval = -ENOMEM;
-		pid = alloc_pid(p->nsproxy->pid_ns);
+		pid = alloc_pid(p->nsproxy->pid_ns, 0);
 		if (!pid)
 			goto bad_fork_cleanup_io;
 	}
@@ -1383,7 +1384,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	return p;
 
 bad_fork_free_pid:
-	if (pid != &init_struct_pid)
+	if (pid != current->rsv_pid)
 		free_pid(pid);
 bad_fork_cleanup_io:
 	if (p->io_context)
@@ -1447,8 +1448,8 @@ struct task_struct * __cpuinit fork_idle(int cpu)
 	struct task_struct *task;
 	struct pt_regs regs;
 
-	task = copy_process(CLONE_VM, 0, idle_regs(&regs), 0, NULL,
-			    &init_struct_pid, 0);
+	current->rsv_pid = &init_struct_pid;
+	task = copy_process(CLONE_VM, 0, idle_regs(&regs), 0, NULL, 0);
 	if (!IS_ERR(task)) {
 		init_idle_pids(task->pids);
 		init_idle(task, cpu);
@@ -1508,7 +1509,7 @@ long do_fork(unsigned long clone_flags,
 	}
 
 	p = copy_process(clone_flags, stack_start, regs, stack_size,
-			 child_tidptr, NULL, trace);
+			 child_tidptr, trace);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
diff --git a/kernel/pid.c b/kernel/pid.c
index fa5f722..86e7c6d 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -159,6 +159,26 @@ static void set_last_pid(struct pid_namespace *pid_ns, int base, int pid)
 	} while ((prev != last_write) && (pid_before(base, last_write, pid)));
 }
 
+static int alloc_pidmap_page(struct pidmap *map)
+{
+	if (unlikely(!map->page)) {
+		void *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
+		/*
+		 * Free the page if someone raced with us
+		 * installing it:
+		 */
+		spin_lock_irq(&pidmap_lock);
+		if (!map->page) {
+			map->page = page;
+			page = NULL;
+		}
+		spin_unlock_irq(&pidmap_lock);
+		kfree(page);
+	}
+
+	return map->page != NULL;
+}
+
 static int alloc_pidmap(struct pid_namespace *pid_ns)
 {
 	int i, offset, max_scan, pid, last = pid_ns->last_pid;
@@ -176,22 +196,9 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 	 */
 	max_scan = DIV_ROUND_UP(pid_max, BITS_PER_PAGE) - !offset;
 	for (i = 0; i <= max_scan; ++i) {
-		if (unlikely(!map->page)) {
-			void *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
-			/*
-			 * Free the page if someone raced with us
-			 * installing it:
-			 */
-			spin_lock_irq(&pidmap_lock);
-			if (!map->page) {
-				map->page = page;
-				page = NULL;
-			}
-			spin_unlock_irq(&pidmap_lock);
-			kfree(page);
-			if (unlikely(!map->page))
-				break;
-		}
+		if (!alloc_pidmap_page(map))
+			break;
+
 		if (likely(atomic_read(&map->nr_free))) {
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
@@ -217,6 +224,23 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 	return -1;
 }
 
+static int set_pidmap(struct pid_namespace *pid_ns, int pid)
+{
+	int offset;
+	struct pidmap *map;
+
+	offset = pid & BITS_PER_PAGE_MASK;
+	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
+	if (!alloc_pidmap_page(map))
+		return -1;
+
+	if (test_and_set_bit(offset, map->page))
+		return -1;
+
+	set_last_pid(pid_ns, pid_ns->last_pid, pid);
+	return pid;
+}
+
 int next_pidmap(struct pid_namespace *pid_ns, unsigned int last)
 {
 	int offset;
@@ -277,7 +301,7 @@ void free_pid(struct pid *pid)
 	call_rcu(&pid->rcu, delayed_put_pid);
 }
 
-struct pid *alloc_pid(struct pid_namespace *ns)
+struct pid *alloc_pid(struct pid_namespace *ns, int want_pid)
 {
 	struct pid *pid;
 	enum pid_type type;
@@ -291,7 +315,11 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 
 	tmp = ns;
 	for (i = ns->level; i >= 0; i--) {
-		nr = alloc_pidmap(tmp);
+		if (want_pid) {
+			nr = set_pidmap(tmp, want_pid);
+			want_pid = 0;
+		} else
+			nr = alloc_pidmap(tmp);
 		if (nr < 0)
 			goto out_free;
 
@@ -301,6 +329,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 	}
 
 	get_pid_ns(ns);
+	pid->flags = 0;
 	pid->level = ns->level;
 	atomic_set(&pid->count, 1);
 	for (type = 0; type < PIDTYPE_MAX; ++type)
@@ -359,12 +388,22 @@ void attach_pid(struct task_struct *task, enum pid_type type,
 	hlist_add_head_rcu(&link->node, &pid->tasks[type]);
 }
 
+int pid_attached(struct pid *pid)
+{
+	int tmp;
+
+	for (tmp = PIDTYPE_MAX; --tmp >= 0; )
+		if (!hlist_empty(&pid->tasks[tmp]))
+			return 1;
+
+	return 0;
+}
+
 static void __change_pid(struct task_struct *task, enum pid_type type,
 			struct pid *new)
 {
 	struct pid_link *link;
 	struct pid *pid;
-	int tmp;
 
 	link = &task->pids[type];
 	pid = link->pid;
@@ -372,11 +411,11 @@ static void __change_pid(struct task_struct *task, enum pid_type type,
 	hlist_del_rcu(&link->node);
 	link->pid = new;
 
-	for (tmp = PIDTYPE_MAX; --tmp >= 0; )
-		if (!hlist_empty(&pid->tasks[tmp]))
-			return;
+	if (pid_attached(pid))
+		return;
 
-	free_pid(pid);
+	if (!(pid->flags & PID_RESERVED))
+		free_pid(pid);
 }
 
 void detach_pid(struct task_struct *task, enum pid_type type)
@@ -534,6 +573,48 @@ struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
 	return pid;
 }
 
+static void do_unreserve_pid(struct pid *pid)
+{
+	pid->flags &= ~PID_RESERVED;
+	if (!pid_attached(pid))
+		free_pid(pid);
+}
+
+int reserve_pid(int nr)
+{
+	struct task_struct *me = current;
+	struct pid *pid;
+
+	if (nr != 0 && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	pid = alloc_pid(me->nsproxy->pid_ns, nr);
+	if (pid == NULL)
+		return -ENOMEM;
+
+	write_lock_irq(&tasklist_lock);
+	if (me->rsv_pid)
+		do_unreserve_pid(me->rsv_pid);
+	pid->flags |= PID_RESERVED;
+	me->rsv_pid = pid;
+	write_unlock_irq(&tasklist_lock);
+
+	return pid_nr_ns(pid, me->nsproxy->pid_ns);
+}
+
+void __unreserve_pid(struct task_struct *tsk)
+{
+	do_unreserve_pid(tsk->rsv_pid);
+	tsk->rsv_pid = NULL;
+}
+
+void unreserve_pid(void)
+{
+	write_lock_irq(&tasklist_lock);
+	__unreserve_pid(current);
+	write_unlock_irq(&tasklist_lock);
+}
+
 /*
  * The pid hash table is scaled according to the amount of memory in the
  * machine.  From a minimum of 16 slots up to 4096 slots at one gigabyte or
diff --git a/kernel/sys.c b/kernel/sys.c
index 481611f..8886672 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1841,6 +1841,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_RESERVE_PID:
+			error = reserve_pid(arg2);
+			break;
+		case PR_UNRESERVE_PID:
+			unreserve_pid();
+			break;
 		default:
 			error = -EINVAL;
 			break;
