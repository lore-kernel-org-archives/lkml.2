Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab1CCInZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:43:25 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:35864 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab1CCInY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:43:24 -0500
Message-ID: <4D6F53B5.5090105@parallels.com>
Date: Thu, 03 Mar 2011 11:39:17 +0300
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] pidns: Make pid_max per namespace
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rationale:

On x86_64 with big ram people running containers set pid_max on host to 
large values to be able to launch more containers. At the same time 
containers running 32-bit software experience problems with large pids - ps
calls readdir/stat on proc entries and inode's i_ino happen to be too big 
for the 32-bit API.

Thus, the ability to limit the pid value inside container is required.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>

---

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 38d1032..248220d 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -20,6 +20,7 @@ struct pid_namespace {
 	struct kref kref;
 	struct pidmap pidmap[PIDMAP_ENTRIES];
 	int last_pid;
+	int pid_max;
 	struct task_struct *child_reaper;
 	struct kmem_cache *pid_cachep;
 	unsigned int level;
diff --git a/kernel/pid.c b/kernel/pid.c
index 39b65b6..aafc285 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -43,12 +43,10 @@ static struct hlist_head *pid_hash;
 static unsigned int pidhash_shift = 4;
 struct pid init_struct_pid = INIT_STRUCT_PID;
 
-int pid_max = PID_MAX_DEFAULT;
-
 #define RESERVED_PIDS		300
 
-int pid_max_min = RESERVED_PIDS + 1;
-int pid_max_max = PID_MAX_LIMIT;
+static int pid_max_min = RESERVED_PIDS + 1;
+static int pid_max_max = PID_MAX_LIMIT;
 
 #define BITS_PER_PAGE		(PAGE_SIZE*8)
 #define BITS_PER_PAGE_MASK	(BITS_PER_PAGE-1)
@@ -161,7 +159,7 @@ static void set_last_pid(struct pid_namespace *pid_ns, int base, int pid)
 
 static int alloc_pidmap(struct pid_namespace *pid_ns)
 {
-	int i, offset, max_scan, pid, last = pid_ns->last_pid;
+	int i, offset, max_scan, pid, last = pid_ns->last_pid, pid_max = pid_ns->pid_max;
 	struct pidmap *map;
 
 	pid = last + 1;
@@ -546,14 +544,40 @@ void __init pidhash_init(void)
 		INIT_HLIST_HEAD(&pid_hash[i]);
 }
 
+static int proc_dointvec_pidmax(struct ctl_table *table, int write,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table tmp;
+
+	tmp = *table;
+	tmp.data = &current->nsproxy->pid_ns->pid_max;
+
+	return proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+}
+
+static struct ctl_table pid_ctl_table[] = {
+	{
+		.procname	= "pid_max",
+		.data		= &init_pid_ns.pid_max,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_pidmax,
+		.extra1		= &pid_max_min,
+		.extra2		= &pid_max_max,
+	},
+	{ }
+};
+
+static struct ctl_path pid_kern_path[] = { { .procname = "kernel" }, { } };
+
 void __init pidmap_init(void)
 {
 	/* bump default and minimum pid_max based on number of cpus */
-	pid_max = min(pid_max_max, max_t(int, pid_max,
+	init_pid_ns.pid_max = min(pid_max_max, max_t(int, PID_MAX_DEFAULT,
 				PIDS_PER_CPU_DEFAULT * num_possible_cpus()));
 	pid_max_min = max_t(int, pid_max_min,
 				PIDS_PER_CPU_MIN * num_possible_cpus());
-	pr_info("pid_max: default: %u minimum: %u\n", pid_max, pid_max_min);
+	pr_info("pid_max: default: %u minimum: %u\n", init_pid_ns.pid_max, pid_max_min);
 
 	init_pid_ns.pidmap[0].page = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	/* Reserve PID 0. We never call free_pidmap(0) */
@@ -562,4 +586,5 @@ void __init pidmap_init(void)
 
 	init_pid_ns.pid_cachep = KMEM_CACHE(pid,
 			SLAB_HWCACHE_ALIGN | SLAB_PANIC);
+	register_sysctl_paths(pid_kern_path, pid_ctl_table);
 }
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index a5aff94..93d594e 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -89,6 +89,7 @@ static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_p
 	kref_init(&ns->kref);
 	ns->level = level;
 	ns->parent = get_pid_ns(parent_pid_ns);
+	ns->pid_max = parent_pid_ns->pid_max;
 
 	set_bit(0, ns->pidmap[0].page);
 	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0f1bd83..0f94054 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -93,9 +93,7 @@ extern int core_uses_pid;
 extern int suid_dumpable;
 extern char core_pattern[];
 extern unsigned int core_pipe_limit;
-extern int pid_max;
 extern int min_free_kbytes;
-extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
@@ -653,15 +651,6 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 	{
-		.procname	= "pid_max",
-		.data		= &pid_max,
-		.maxlen		= sizeof (int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &pid_max_min,
-		.extra2		= &pid_max_max,
-	},
-	{
 		.procname	= "panic_on_oops",
 		.data		= &panic_on_oops,
 		.maxlen		= sizeof(int),
