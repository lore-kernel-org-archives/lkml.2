Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab2LYIYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 03:24:53 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:53876 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab2LYIYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 03:24:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>
References: <87d2y2elbi.fsf@xmission.com> <871ueiel9d.fsf@xmission.com>
	<20121222165438.GA19680@redhat.com>
Date: Tue, 25 Dec 2012 00:24:40 -0800
In-Reply-To: <20121222165438.GA19680@redhat.com> (Oleg Nesterov's message of
	"Sat, 22 Dec 2012 17:54:38 +0100")
Message-ID: <87licm7d4n.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+4FzeXbMFeYdJ1XCIJVGxfkSTHloexNZs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3793]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: [PATCH review 2/3 take 2] pidns: Stop pid allocation when init dies
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Oleg pointed out that in a pid namespace the sequence.
- pid 1 becomes a zombie
- setns(thepidns), fork,...
- reaping pid 1.
- The injected processes exiting.

Can lead to processes attempting access their child reaper and
instead following a stale pointer.

That waitpid for init can return before all of the processes in
the pid namespace have exited is also unfortunate.

Avoid these problems by disabling the allocation of new pids in a pid
namespace when init dies, instead of when the last process in a pid
namespace is reaped.

Pointed-out-by:  Oleg Nesterov <oleg@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/pid.h           |    1 +
 include/linux/pid_namespace.h |    4 +++-
 kernel/pid.c                  |   15 ++++++++++++---
 kernel/pid_namespace.c        |    4 ++++
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index b152d44..2381c97 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -121,6 +121,7 @@ int next_pidmap(struct pid_namespace *pid_ns, unsigned int last);
 
 extern struct pid *alloc_pid(struct pid_namespace *ns);
 extern void free_pid(struct pid *pid);
+extern void disable_pid_allocation(struct pid_namespace *ns);
 
 /*
  * ns_of_pid() returns the pid namespace in which the specified pid was
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index bf28599..215e5e3 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -21,7 +21,7 @@ struct pid_namespace {
 	struct kref kref;
 	struct pidmap pidmap[PIDMAP_ENTRIES];
 	int last_pid;
-	int nr_hashed;
+	unsigned int nr_hashed;
 	struct task_struct *child_reaper;
 	struct kmem_cache *pid_cachep;
 	unsigned int level;
@@ -42,6 +42,8 @@ struct pid_namespace {
 
 extern struct pid_namespace init_pid_ns;
 
+#define PIDNS_HASH_ADDING (1U << 31)
+
 #ifdef CONFIG_PID_NS
 static inline struct pid_namespace *get_pid_ns(struct pid_namespace *ns)
 {
diff --git a/kernel/pid.c b/kernel/pid.c
index 36aa02f..de9af60 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -270,7 +270,6 @@ void free_pid(struct pid *pid)
 			wake_up_process(ns->child_reaper);
 			break;
 		case 0:
-			ns->nr_hashed = -1;
 			schedule_work(&ns->proc_work);
 			break;
 		}
@@ -319,7 +318,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 
 	upid = pid->numbers + ns->level;
 	spin_lock_irq(&pidmap_lock);
-	if (ns->nr_hashed < 0)
+	if (!(ns->nr_hashed & PIDNS_HASH_ADDING))
 		goto out_unlock;
 	for ( ; upid >= pid->numbers; --upid) {
 		hlist_add_head_rcu(&upid->pid_chain,
@@ -342,6 +341,13 @@ out_free:
 	goto out;
 }
 
+void disable_pid_allocation(struct pid_namespace *ns)
+{
+	spin_lock_irq(&pidmap_lock);
+	ns->nr_hashed &= ~PIDNS_HASH_ADDING;
+	spin_unlock_irq(&pidmap_lock);
+}
+
 struct pid *find_pid_ns(int nr, struct pid_namespace *ns)
 {
 	struct hlist_node *elem;
@@ -573,6 +579,9 @@ void __init pidhash_init(void)
 
 void __init pidmap_init(void)
 {
+	/* Veryify no one has done anything silly */
+	BUILD_BUG_ON(PID_MAX_LIMIT >= PIDNS_HASH_ADDING);
+
 	/* bump default and minimum pid_max based on number of cpus */
 	pid_max = min(pid_max_max, max_t(int, pid_max,
 				PIDS_PER_CPU_DEFAULT * num_possible_cpus()));
@@ -584,7 +593,7 @@ void __init pidmap_init(void)
 	/* Reserve PID 0. We never call free_pidmap(0) */
 	set_bit(0, init_pid_ns.pidmap[0].page);
 	atomic_dec(&init_pid_ns.pidmap[0].nr_free);
-	init_pid_ns.nr_hashed = 1;
+	init_pid_ns.nr_hashed = PIDNS_HASH_ADDING;
 
 	init_pid_ns.pid_cachep = KMEM_CACHE(pid,
 			SLAB_HWCACHE_ALIGN | SLAB_PANIC);
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index fdbd0cd..c1c3dc1 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -115,6 +115,7 @@ static struct pid_namespace *create_pid_namespace(struct user_namespace *user_ns
 	ns->level = level;
 	ns->parent = get_pid_ns(parent_pid_ns);
 	ns->user_ns = get_user_ns(user_ns);
+	ns->nr_hashed = PIDNS_HASH_ADDING;
 	INIT_WORK(&ns->proc_work, proc_cleanup_work);
 
 	set_bit(0, ns->pidmap[0].page);
@@ -181,6 +182,9 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	int rc;
 	struct task_struct *task, *me = current;
 
+	/* Don't allow any more processes into the pid namespace */
+	disable_pid_allocation(pid_ns);
+
 	/* Ignore SIGCHLD causing any terminated children to autoreap */
 	spin_lock_irq(&me->sighand->siglock);
 	me->sighand->action[SIGCHLD - 1].sa.sa_handler = SIG_IGN;
-- 
1.7.5.4

