Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab0ECAoJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 20:44:09 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51967 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab0ECAn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 20:43:59 -0400
Date: Sun, 2 May 2010 17:43:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: [GIT PULL] RCU fixes for 2.6.34 and changes for 2.6.35
Message-ID: <20100503004351.GA25163@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

Here are RCU fixes for 2.6.34 and changes for 2.6.35.

The following will pull only the 2.6.34 fixes, which are RCU-lockdep fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git urgent-to-mingo

The following will pull the 2.6.34 fixes plus the first installment of
2.6.35 changes:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git urgent-to-mingo

The changes include some fixes and cleanups from Lai Jiangshan,
application of debugobjects to detect RCU callback misbehavior and
abuse from Mathieu Desnoyers, and some TINY_RCU slimdowns and
RCU CPU stall-warning improvements from myself.  Arnd and I are still
working on the sparse-based RCU-pointer debug checks, and I hope to
have it ready soon.

The 2.6.35 changes depend on the 2.6.34 fixes.  If you would rather I use
some other organization, please let me know.  For example, I could merge
the 2.6.34 fixes on top of tip/core/rcu, then apply the 2.6.35 changes,
if that would work better.

							Thanx, Paul

------------------>
David Howells (2)
     KEYS: Fix an RCU warning
     KEYS: Fix an RCU warning in the reading of user keys

Lai Jiangshan (4)
     rcu: ignore offline CPUs in last non-dyntick-idle CPU check
     rcu: make dead code really dead
     rcu: move some code from macro to function
     rcu: v2: optionally leave lockdep enabled after RCU lockdep splat

Li Zefan (4)
     cgroup: Check task_lock in task_subsys_state()
     cgroup: Fix an RCU warning in alloc_css_id()
     cgroup: Fix an RCU warning in cgroup_path()
     sched: Fix an RCU warning in print_task()

Mathieu Desnoyers (6)
      Debugobjects transition check
      rcu: fix debugobjects rcu head init on stack in rcutree_plugin.h
      rcu head introduce rcu head init on stack
      rcu head remove init
      remove all rcu head initializations, except on_stack initializations
      tree/tiny rcu: Add debug RCU head objects (v5)

Paul E. McKenney (19)
     memcg: css_id() must be called under rcu_read_lock()
     rcu: disable CPU stall warnings upon panic
     rcu: enable CPU_STALL_VERBOSE by default
     rcu: Fix bogus CONFIG_PROVE_LOCKING in comments to reflect reality.
     rcu: fix now-bogus rcu_scheduler_active comments.
     rcu: improve RCU CPU stall-warning messages
     rcu: improve the RCU CPU-stall warning documentation
     rcu: make SRCU usable in modules
     rcu: permit discontiguous cpu_possible_mask CPU numbering
     rcu: print boot-time console messages if RCU configs out of ordinary
     rcu: RCU_FAST_NO_HZ must check RCU dyntick state
     rcu: refactor RCU's context-switch handling
     rcu: rename rcutiny rcu_ctrlblk to rcu_sched_ctrlblk
     rcu: shrink rcutiny by making synchronize_rcu_bh() be inline
     rcu: slim down rcutiny by removing rcu_scheduler_active and friends
     rcu: substitute set_need_resched for sending resched IPIs
     rcu: v2: reduce the number of spurious RCU_SOFTIRQ invocations
     vfs: fix RCU-lockdep false positive due to /proc access
     blk-cgroup: Fix RCU correctness warning in cfq_init_queue()


 Documentation/RCU/stallwarn.txt             |   94 +++++++++++---
 Documentation/RCU/trace.txt                 |   35 ++---
 arch/powerpc/mm/pgtable.c                   |    1 
 block/cfq-iosched.c                         |    3 
 block/genhd.c                               |    1 
 drivers/staging/batman-adv/hard-interface.c |    1 
 fs/file.c                                   |    3 
 fs/fs-writeback.c                           |   31 ++++
 fs/partitions/check.c                       |    1 
 include/linux/cgroup.h                      |    1 
 include/linux/debugobjects.h                |   11 +
 include/linux/fdtable.h                     |    3 
 include/linux/init_task.h                   |    1 
 include/linux/rcupdate.h                    |  105 ++++++++++++----
 include/linux/rcutiny.h                     |   29 ++++
 include/linux/rcutree.h                     |    6 
 include/linux/srcu.h                        |    6 
 kernel/cgroup.c                             |   16 +-
 kernel/cgroup_freezer.c                     |    5 
 kernel/lockdep.c                            |    2 
 kernel/rcupdate.c                           |  179 +++++++++++++++++++++++++---
 kernel/rcutiny.c                            |   37 +++--
 kernel/rcutiny_plugin.h                     |   39 ++++++
 kernel/rcutorture.c                         |    2 
 kernel/rcutree.c                            |  133 +++++++++++++++-----
 kernel/rcutree.h                            |    2 
 kernel/rcutree_plugin.h                     |   69 +++++++++-
 kernel/rcutree_trace.c                      |    4 
 kernel/sched.c                              |   12 +
 kernel/sched_debug.c                        |    2 
 kernel/softirq.c                            |    2 
 lib/Kconfig.debug                           |   20 ++-
 lib/debugobjects.c                          |   59 ++++++++-
 mm/backing-dev.c                            |    1 
 mm/memcontrol.c                             |   21 ++-
 mm/slob.c                                   |    1 
 security/keys/request_key.c                 |   13 +-
 security/keys/user_defined.c                |    3 
 security/selinux/avc.c                      |    1 
 security/selinux/netnode.c                  |    2 
 40 files changed, 773 insertions(+), 184 deletions(-)

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 1423d25..44c6dcc 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -3,35 +3,79 @@ Using RCU's CPU Stall Detector
 The CONFIG_RCU_CPU_STALL_DETECTOR kernel config parameter enables
 RCU's CPU stall detector, which detects conditions that unduly delay
 RCU grace periods.  The stall detector's idea of what constitutes
-"unduly delayed" is controlled by a pair of C preprocessor macros:
+"unduly delayed" is controlled by a set of C preprocessor macros:
 
 RCU_SECONDS_TILL_STALL_CHECK
 
 	This macro defines the period of time that RCU will wait from
 	the beginning of a grace period until it issues an RCU CPU
-	stall warning.	It is normally ten seconds.
+	stall warning.	This time period is normally ten seconds.
 
 RCU_SECONDS_TILL_STALL_RECHECK
 
 	This macro defines the period of time that RCU will wait after
-	issuing a stall warning until it issues another stall warning.
-	It is normally set to thirty seconds.
+	issuing a stall warning until it issues another stall warning
+	for the same stall.  This time period is normally set to thirty
+	seconds.
 
 RCU_STALL_RAT_DELAY
 
-	The CPU stall detector tries to make the offending CPU rat on itself,
-	as this often gives better-quality stack traces.  However, if
-	the offending CPU does not detect its own stall in the number
-	of jiffies specified by RCU_STALL_RAT_DELAY, then other CPUs will
-	complain.  This is normally set to two jiffies.
+	The CPU stall detector tries to make the offending CPU print its
+	own warnings, as this often gives better-quality stack traces.
+	However, if the offending CPU does not detect its own stall in
+	the number of jiffies specified by RCU_STALL_RAT_DELAY, then
+	some other CPU will complain.  This delay is normally set to
+	two jiffies.
 
-The following problems can result in an RCU CPU stall warning:
+When a CPU detects that it is stalling, it will print a message similar
+to the following:
+
+INFO: rcu_sched_state detected stall on CPU 5 (t=2500 jiffies)
+
+This message indicates that CPU 5 detected that it was causing a stall,
+and that the stall was affecting RCU-sched.  This message will normally be
+followed by a stack dump of the offending CPU.  On TREE_RCU kernel builds,
+RCU and RCU-sched are implemented by the same underlying mechanism,
+while on TREE_PREEMPT_RCU kernel builds, RCU is instead implemented
+by rcu_preempt_state.
+
+On the other hand, if the offending CPU fails to print out a stall-warning
+message quickly enough, some other CPU will print a message similar to
+the following:
+
+INFO: rcu_bh_state detected stalls on CPUs/tasks: { 3 5 } (detected by 2, 2502 jiffies)
+
+This message indicates that CPU 2 detected that CPUs 3 and 5 were both
+causing stalls, and that the stall was affecting RCU-bh.  This message
+will normally be followed by stack dumps for each CPU.  Please note that
+TREE_PREEMPT_RCU builds can be stalled by tasks as well as by CPUs,
+and that the tasks will be indicated by PID, for example, "P3421".
+It is even possible for a rcu_preempt_state stall to be caused by both
+CPUs -and- tasks, in which case the offending CPUs and tasks will all
+be called out in the list.
+
+Finally, if the grace period ends just as the stall warning starts
+printing, there will be a spurious stall-warning message:
+
+INFO: rcu_bh_state detected stalls on CPUs/tasks: { } (detected by 4, 2502 jiffies)
+
+This is rare, but does happen from time to time in real life.
+
+So your kernel printed an RCU CPU stall warning.  The next question is
+"What caused it?"  The following problems can result in RCU CPU stall
+warnings:
 
 o	A CPU looping in an RCU read-side critical section.
 	
-o	A CPU looping with interrupts disabled.
+o	A CPU looping with interrupts disabled.  This condition can
+	result in RCU-sched and RCU-bh stalls.
 
-o	A CPU looping with preemption disabled.
+o	A CPU looping with preemption disabled.  This condition can
+	result in RCU-sched stalls and, if ksoftirqd is in use, RCU-bh
+	stalls.
+
+o	A CPU looping with bottom halves disabled.  This condition can
+	result in RCU-sched and RCU-bh stalls.
 
 o	For !CONFIG_PREEMPT kernels, a CPU looping anywhere in the kernel
 	without invoking schedule().
@@ -39,20 +83,24 @@ o	For !CONFIG_PREEMPT kernels, a CPU looping anywhere in the kernel
 o	A bug in the RCU implementation.
 
 o	A hardware failure.  This is quite unlikely, but has occurred
-	at least once in a former life.  A CPU failed in a running system,
+	at least once in real life.  A CPU failed in a running system,
 	becoming unresponsive, but not causing an immediate crash.
 	This resulted in a series of RCU CPU stall warnings, eventually
 	leading the realization that the CPU had failed.
 
-The RCU, RCU-sched, and RCU-bh implementations have CPU stall warning.
-SRCU does not do so directly, but its calls to synchronize_sched() will
-result in RCU-sched detecting any CPU stalls that might be occurring.
-
-To diagnose the cause of the stall, inspect the stack traces.  The offending
-function will usually be near the top of the stack.  If you have a series
-of stall warnings from a single extended stall, comparing the stack traces
-can often help determine where the stall is occurring, which will usually
-be in the function nearest the top of the stack that stays the same from
-trace to trace.
+The RCU, RCU-sched, and RCU-bh implementations have CPU stall
+warning.  SRCU does not have its own CPU stall warnings, but its
+calls to synchronize_sched() will result in RCU-sched detecting
+RCU-sched-related CPU stalls.  Please note that RCU only detects
+CPU stalls when there is a grace period in progress.  No grace period,
+no CPU stall warnings.
+
+To diagnose the cause of the stall, inspect the stack traces.
+The offending function will usually be near the top of the stack.
+If you have a series of stall warnings from a single extended stall,
+comparing the stack traces can often help determine where the stall
+is occurring, which will usually be in the function nearest the top of
+that portion of the stack which remains the same from trace to trace.
+If you can reliably trigger the stall, ftrace can be quite helpful.
 
 RCU bugs can often be debugged with the help of CONFIG_RCU_TRACE.
diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 8608fd8..efd8cc9 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -256,23 +256,23 @@ o	Each element of the form "1/1 0:127 ^0" represents one struct
 The output of "cat rcu/rcu_pending" looks as follows:
 
 rcu_sched:
-  0 np=255892 qsp=53936 cbr=0 cng=14417 gpc=10033 gps=24320 nf=6445 nn=146741
-  1 np=261224 qsp=54638 cbr=0 cng=25723 gpc=16310 gps=2849 nf=5912 nn=155792
-  2 np=237496 qsp=49664 cbr=0 cng=2762 gpc=45478 gps=1762 nf=1201 nn=136629
-  3 np=236249 qsp=48766 cbr=0 cng=286 gpc=48049 gps=1218 nf=207 nn=137723
-  4 np=221310 qsp=46850 cbr=0 cng=26 gpc=43161 gps=4634 nf=3529 nn=123110
-  5 np=237332 qsp=48449 cbr=0 cng=54 gpc=47920 gps=3252 nf=201 nn=137456
-  6 np=219995 qsp=46718 cbr=0 cng=50 gpc=42098 gps=6093 nf=4202 nn=120834
-  7 np=249893 qsp=49390 cbr=0 cng=72 gpc=38400 gps=17102 nf=41 nn=144888
+  0 np=255892 qsp=53936 rpq=85 cbr=0 cng=14417 gpc=10033 gps=24320 nf=6445 nn=146741
+  1 np=261224 qsp=54638 rpq=33 cbr=0 cng=25723 gpc=16310 gps=2849 nf=5912 nn=155792
+  2 np=237496 qsp=49664 rpq=23 cbr=0 cng=2762 gpc=45478 gps=1762 nf=1201 nn=136629
+  3 np=236249 qsp=48766 rpq=98 cbr=0 cng=286 gpc=48049 gps=1218 nf=207 nn=137723
+  4 np=221310 qsp=46850 rpq=7 cbr=0 cng=26 gpc=43161 gps=4634 nf=3529 nn=123110
+  5 np=237332 qsp=48449 rpq=9 cbr=0 cng=54 gpc=47920 gps=3252 nf=201 nn=137456
+  6 np=219995 qsp=46718 rpq=12 cbr=0 cng=50 gpc=42098 gps=6093 nf=4202 nn=120834
+  7 np=249893 qsp=49390 rpq=42 cbr=0 cng=72 gpc=38400 gps=17102 nf=41 nn=144888
 rcu_bh:
-  0 np=146741 qsp=1419 cbr=0 cng=6 gpc=0 gps=0 nf=2 nn=145314
-  1 np=155792 qsp=12597 cbr=0 cng=0 gpc=4 gps=8 nf=3 nn=143180
-  2 np=136629 qsp=18680 cbr=0 cng=0 gpc=7 gps=6 nf=0 nn=117936
-  3 np=137723 qsp=2843 cbr=0 cng=0 gpc=10 gps=7 nf=0 nn=134863
-  4 np=123110 qsp=12433 cbr=0 cng=0 gpc=4 gps=2 nf=0 nn=110671
-  5 np=137456 qsp=4210 cbr=0 cng=0 gpc=6 gps=5 nf=0 nn=133235
-  6 np=120834 qsp=9902 cbr=0 cng=0 gpc=6 gps=3 nf=2 nn=110921
-  7 np=144888 qsp=26336 cbr=0 cng=0 gpc=8 gps=2 nf=0 nn=118542
+  0 np=146741 qsp=1419 rpq=6 cbr=0 cng=6 gpc=0 gps=0 nf=2 nn=145314
+  1 np=155792 qsp=12597 rpq=3 cbr=0 cng=0 gpc=4 gps=8 nf=3 nn=143180
+  2 np=136629 qsp=18680 rpq=1 cbr=0 cng=0 gpc=7 gps=6 nf=0 nn=117936
+  3 np=137723 qsp=2843 rpq=0 cbr=0 cng=0 gpc=10 gps=7 nf=0 nn=134863
+  4 np=123110 qsp=12433 rpq=0 cbr=0 cng=0 gpc=4 gps=2 nf=0 nn=110671
+  5 np=137456 qsp=4210 rpq=1 cbr=0 cng=0 gpc=6 gps=5 nf=0 nn=133235
+  6 np=120834 qsp=9902 rpq=2 cbr=0 cng=0 gpc=6 gps=3 nf=2 nn=110921
+  7 np=144888 qsp=26336 rpq=0 cbr=0 cng=0 gpc=8 gps=2 nf=0 nn=118542
 
 As always, this is once again split into "rcu_sched" and "rcu_bh"
 portions, with CONFIG_TREE_PREEMPT_RCU kernels having an additional
@@ -284,6 +284,9 @@ o	"np" is the number of times that __rcu_pending() has been invoked
 o	"qsp" is the number of times that the RCU was waiting for a
 	quiescent state from this CPU.
 
+o	"rpq" is the number of times that the CPU had passed through
+	a quiescent state, but not yet reported it to RCU.
+
 o	"cbr" is the number of times that this CPU had RCU callbacks
 	that had passed through a grace period, and were thus ready
 	to be invoked.
diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
index ebc2f38..2c7e801 100644
--- a/arch/powerpc/mm/pgtable.c
+++ b/arch/powerpc/mm/pgtable.c
@@ -92,7 +92,6 @@ static void pte_free_rcu_callback(struct rcu_head *head)
 
 static void pte_free_submit(struct pte_freelist_batch *batch)
 {
-	INIT_RCU_HEAD(&batch->rcu);
 	call_rcu(&batch->rcu, pte_free_rcu_callback);
 }
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 838834b..702d006 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3694,8 +3694,10 @@ static void *cfq_init_queue(struct request_queue *q)
 	 * to make sure that cfq_put_cfqg() does not try to kfree root group
 	 */
 	atomic_set(&cfqg->ref, 1);
+	rcu_read_lock();
 	blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg, (void *)cfqd,
 					0);
+	rcu_read_unlock();
 #endif
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we
@@ -3741,7 +3743,6 @@ static void *cfq_init_queue(struct request_queue *q)
 	 * second, in order to have larger depth for async operations.
 	 */
 	cfqd->last_delayed_sync = jiffies - HZ;
-	INIT_RCU_HEAD(&cfqd->rcu);
 	return cfqd;
 }
 
diff --git a/block/genhd.c b/block/genhd.c
index d13ba76..27e85a2 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -987,7 +987,6 @@ int disk_expand_part_tbl(struct gendisk *disk, int partno)
 	if (!new_ptbl)
 		return -ENOMEM;
 
-	INIT_RCU_HEAD(&new_ptbl->rcu_head);
 	new_ptbl->len = target;
 
 	for (i = 0; i < len; i++)
diff --git a/drivers/staging/batman-adv/hard-interface.c b/drivers/staging/batman-adv/hard-interface.c
index befd488..96ea0e5 100644
--- a/drivers/staging/batman-adv/hard-interface.c
+++ b/drivers/staging/batman-adv/hard-interface.c
@@ -301,7 +301,6 @@ int hardif_add_interface(char *dev, int if_num)
 	batman_if->if_num = if_num;
 	batman_if->dev = dev;
 	batman_if->if_active = IF_INACTIVE;
-	INIT_RCU_HEAD(&batman_if->rcu);
 
 	printk(KERN_INFO "batman-adv:Adding interface: %s\n", dev);
 	avail_ifs++;
diff --git a/fs/file.c b/fs/file.c
index 34bb7f7..cccaead 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -178,7 +178,6 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	fdt->open_fds = (fd_set *)data;
 	data += nr / BITS_PER_BYTE;
 	fdt->close_on_exec = (fd_set *)data;
-	INIT_RCU_HEAD(&fdt->rcu);
 	fdt->next = NULL;
 
 	return fdt;
@@ -312,7 +311,6 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	new_fdt->close_on_exec = (fd_set *)&newf->close_on_exec_init;
 	new_fdt->open_fds = (fd_set *)&newf->open_fds_init;
 	new_fdt->fd = &newf->fd_array[0];
-	INIT_RCU_HEAD(&new_fdt->rcu);
 	new_fdt->next = NULL;
 
 	spin_lock(&oldf->file_lock);
@@ -430,7 +428,6 @@ struct files_struct init_files = {
 		.fd		= &init_files.fd_array[0],
 		.close_on_exec	= (fd_set *)&init_files.close_on_exec_init,
 		.open_fds	= (fd_set *)&init_files.open_fds_init,
-		.rcu		= RCU_HEAD_INIT,
 	},
 	.file_lock	= __SPIN_LOCK_UNLOCKED(init_task.file_lock),
 };
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 4b37f7c..ea38c65 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -75,12 +75,33 @@ static inline bool bdi_work_on_stack(struct bdi_work *work)
 	return test_bit(WS_ONSTACK_B, &work->state);
 }
 
-static inline void bdi_work_init(struct bdi_work *work,
-				 struct wb_writeback_args *args)
+static inline void __bdi_work_init(struct bdi_work *work,
+				   struct wb_writeback_args *args,
+				   int on_stack)
 {
-	INIT_RCU_HEAD(&work->rcu_head);
 	work->args = *args;
 	work->state = WS_USED;
+	if (on_stack) {
+		work->state |= WS_ONSTACK;
+		init_rcu_head_on_stack(&work->rcu_head);
+	}
+}
+
+static inline void bdi_work_init(struct bdi_work *work,
+				 struct wb_writeback_args *args)
+{
+	__bdi_work_init(work, args, false);
+}
+
+static inline void bdi_work_init_on_stack(struct bdi_work *work,
+					  struct wb_writeback_args *args)
+{
+	__bdi_work_init(work, args, true);
+}
+
+static inline void bdi_destroy_work_on_stack(struct bdi_work *work)
+{
+	destroy_rcu_head_on_stack(&work->rcu_head);
 }
 
 /**
@@ -233,11 +254,11 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
 	};
 	struct bdi_work work;
 
-	bdi_work_init(&work, &args);
-	work.state |= WS_ONSTACK;
+	bdi_work_init_on_stack(&work, &args);
 
 	bdi_queue_work(bdi, &work);
 	bdi_wait_on_work_clear(&work);
+	bdi_destroy_work_on_stack(&work);
 }
 
 /**
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index e238ab2..7444e6f 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -456,7 +456,6 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	}
 
 	/* everything is up and running, commence */
-	INIT_RCU_HEAD(&p->rcu_head);
 	rcu_assign_pointer(ptbl->part[partno], p);
 
 	/* suppress uevent if the disk supresses it */
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b8ad1ea..8f78073 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -530,6 +530,7 @@ static inline struct cgroup_subsys_state *task_subsys_state(
 {
 	return rcu_dereference_check(task->cgroups->subsys[subsys_id],
 				     rcu_read_lock_held() ||
+				     lockdep_is_held(&task->alloc_lock) ||
 				     cgroup_lock_is_held());
 }
 
diff --git a/include/linux/debugobjects.h b/include/linux/debugobjects.h
index 8c243aa..597692f 100644
--- a/include/linux/debugobjects.h
+++ b/include/linux/debugobjects.h
@@ -20,12 +20,14 @@ struct debug_obj_descr;
  * struct debug_obj - representaion of an tracked object
  * @node:	hlist node to link the object into the tracker list
  * @state:	tracked object state
+ * @astate:	current active state
  * @object:	pointer to the real object
  * @descr:	pointer to an object type specific debug description structure
  */
 struct debug_obj {
 	struct hlist_node	node;
 	enum debug_obj_state	state;
+	unsigned int		astate;
 	void			*object;
 	struct debug_obj_descr	*descr;
 };
@@ -60,6 +62,15 @@ extern void debug_object_deactivate(void *addr, struct debug_obj_descr *descr);
 extern void debug_object_destroy   (void *addr, struct debug_obj_descr *descr);
 extern void debug_object_free      (void *addr, struct debug_obj_descr *descr);
 
+/*
+ * Active state:
+ * - Set at 0 upon initialization.
+ * - Must return to 0 before deactivation.
+ */
+extern void
+debug_object_active_state(void *addr, struct debug_obj_descr *descr,
+			  unsigned int expect, unsigned int next);
+
 extern void debug_objects_early_init(void);
 extern void debug_objects_mem_init(void);
 #else
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 013dc52..d147461 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -61,7 +61,8 @@ struct files_struct {
 	(rcu_dereference_check((fdtfd), \
 			       rcu_read_lock_held() || \
 			       lockdep_is_held(&(files)->file_lock) || \
-			       atomic_read(&(files)->count) == 1))
+			       atomic_read(&(files)->count) == 1 || \
+			       rcu_my_thread_group_empty()))
 
 #define files_fdtable(files) \
 		(rcu_dereference_check_fdtable((files), (files)->fdt))
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index b1ed1cd..7996fc2 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -49,7 +49,6 @@ extern struct group_info init_groups;
 		{ .first = &init_task.pids[PIDTYPE_PGID].node },	\
 		{ .first = &init_task.pids[PIDTYPE_SID].node },		\
 	},								\
-	.rcu		= RCU_HEAD_INIT,				\
 	.level		= 0,						\
 	.numbers	= { {						\
 		.nr		= 0,					\
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 07db2fe..2f9e56c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -40,6 +40,7 @@
 #include <linux/seqlock.h>
 #include <linux/lockdep.h>
 #include <linux/completion.h>
+#include <linux/debugobjects.h>
 
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable; /* for sysctl */
@@ -56,8 +57,6 @@ struct rcu_head {
 };
 
 /* Exported common interfaces */
-extern void synchronize_rcu_bh(void);
-extern void synchronize_sched(void);
 extern void rcu_barrier(void);
 extern void rcu_barrier_bh(void);
 extern void rcu_barrier_sched(void);
@@ -66,8 +65,6 @@ extern int sched_expedited_torture_stats(char *page);
 
 /* Internal to kernel */
 extern void rcu_init(void);
-extern int rcu_scheduler_active;
-extern void rcu_scheduler_starting(void);
 
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
@@ -77,11 +74,24 @@ extern void rcu_scheduler_starting(void);
 #error "Unknown RCU implementation specified to kernel configuration"
 #endif
 
-#define RCU_HEAD_INIT	{ .next = NULL, .func = NULL }
-#define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
-#define INIT_RCU_HEAD(ptr) do { \
-       (ptr)->next = NULL; (ptr)->func = NULL; \
-} while (0)
+/*
+ * init_rcu_head_on_stack()/destroy_rcu_head_on_stack() are needed for dynamic
+ * initialization and destruction of rcu_head on the stack. rcu_head structures
+ * allocated dynamically in the heap or defined statically don't need any
+ * initialization.
+ */
+#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+extern void init_rcu_head_on_stack(struct rcu_head *head);
+extern void destroy_rcu_head_on_stack(struct rcu_head *head);
+#else /* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+static inline void init_rcu_head_on_stack(struct rcu_head *head)
+{
+}
+
+static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
+{
+}
+#endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
@@ -106,12 +116,13 @@ extern int debug_lockdep_rcu_enabled(void);
 /**
  * rcu_read_lock_held - might we be in RCU read-side critical section?
  *
- * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in
- * an RCU read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
+ * If CONFIG_DEBUG_LOCK_ALLOC is selected, returns nonzero iff in an RCU
+ * read-side critical section.  In absence of CONFIG_DEBUG_LOCK_ALLOC,
  * this assumes we are in an RCU read-side critical section unless it can
  * prove otherwise.
  *
- * Check rcu_scheduler_active to prevent false positives during boot.
+ * Check debug_lockdep_rcu_enabled() to prevent false positives during boot
+ * and while lockdep is disabled.
  */
 static inline int rcu_read_lock_held(void)
 {
@@ -129,13 +140,15 @@ extern int rcu_read_lock_bh_held(void);
 /**
  * rcu_read_lock_sched_held - might we be in RCU-sched read-side critical section?
  *
- * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in an
- * RCU-sched read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
- * this assumes we are in an RCU-sched read-side critical section unless it
- * can prove otherwise.  Note that disabling of preemption (including
- * disabling irqs) counts as an RCU-sched read-side critical section.
+ * If CONFIG_DEBUG_LOCK_ALLOC is selected, returns nonzero iff in an
+ * RCU-sched read-side critical section.  In absence of
+ * CONFIG_DEBUG_LOCK_ALLOC, this assumes we are in an RCU-sched read-side
+ * critical section unless it can prove otherwise.  Note that disabling
+ * of preemption (including disabling irqs) counts as an RCU-sched
+ * read-side critical section.
  *
- * Check rcu_scheduler_active to prevent false positives during boot.
+ * Check debug_lockdep_rcu_enabled() to prevent false positives during boot
+ * and while lockdep is disabled.
  */
 #ifdef CONFIG_PREEMPT
 static inline int rcu_read_lock_sched_held(void)
@@ -177,7 +190,7 @@ static inline int rcu_read_lock_bh_held(void)
 #ifdef CONFIG_PREEMPT
 static inline int rcu_read_lock_sched_held(void)
 {
-	return !rcu_scheduler_active || preempt_count() != 0 || irqs_disabled();
+	return preempt_count() != 0 || irqs_disabled();
 }
 #else /* #ifdef CONFIG_PREEMPT */
 static inline int rcu_read_lock_sched_held(void)
@@ -190,6 +203,17 @@ static inline int rcu_read_lock_sched_held(void)
 
 #ifdef CONFIG_PROVE_RCU
 
+extern int rcu_my_thread_group_empty(void);
+
+#define __do_rcu_dereference_check(c)					\
+	do {								\
+		static bool __warned;					\
+		if (debug_lockdep_rcu_enabled() && !__warned && !(c)) {	\
+			__warned = true;				\
+			lockdep_rcu_dereference(__FILE__, __LINE__);	\
+		}							\
+	} while (0)
+
 /**
  * rcu_dereference_check - rcu_dereference with debug checking
  * @p: The pointer to read, prior to dereferencing
@@ -219,8 +243,7 @@ static inline int rcu_read_lock_sched_held(void)
  */
 #define rcu_dereference_check(p, c) \
 	({ \
-		if (debug_lockdep_rcu_enabled() && !(c)) \
-			lockdep_rcu_dereference(__FILE__, __LINE__); \
+		__do_rcu_dereference_check(c); \
 		rcu_dereference_raw(p); \
 	})
 
@@ -237,8 +260,7 @@ static inline int rcu_read_lock_sched_held(void)
  */
 #define rcu_dereference_protected(p, c) \
 	({ \
-		if (debug_lockdep_rcu_enabled() && !(c)) \
-			lockdep_rcu_dereference(__FILE__, __LINE__); \
+		__do_rcu_dereference_check(c); \
 		(p); \
 	})
 
@@ -501,4 +523,41 @@ extern void call_rcu(struct rcu_head *head,
 extern void call_rcu_bh(struct rcu_head *head,
 			void (*func)(struct rcu_head *head));
 
+/*
+ * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
+ * by call_rcu() and rcu callback execution, and are therefore not part of the
+ * RCU API. Leaving in rcupdate.h because they are used by all RCU flavors.
+ */
+
+#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+# define STATE_RCU_HEAD_READY	0
+# define STATE_RCU_HEAD_QUEUED	1
+
+extern struct debug_obj_descr rcuhead_debug_descr;
+
+static inline void debug_rcu_head_queue(struct rcu_head *head)
+{
+	debug_object_activate(head, &rcuhead_debug_descr);
+	debug_object_active_state(head, &rcuhead_debug_descr,
+				  STATE_RCU_HEAD_READY,
+				  STATE_RCU_HEAD_QUEUED);
+}
+
+static inline void debug_rcu_head_unqueue(struct rcu_head *head)
+{
+	debug_object_active_state(head, &rcuhead_debug_descr,
+				  STATE_RCU_HEAD_QUEUED,
+				  STATE_RCU_HEAD_READY);
+	debug_object_deactivate(head, &rcuhead_debug_descr);
+}
+#else	/* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+static inline void debug_rcu_head_queue(struct rcu_head *head)
+{
+}
+
+static inline void debug_rcu_head_unqueue(struct rcu_head *head)
+{
+}
+#endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index a519587..14e5a76 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -29,6 +29,10 @@
 
 void rcu_sched_qs(int cpu);
 void rcu_bh_qs(int cpu);
+static inline void rcu_note_context_switch(int cpu)
+{
+	rcu_sched_qs(cpu);
+}
 
 #define __rcu_read_lock()	preempt_disable()
 #define __rcu_read_unlock()	preempt_enable()
@@ -74,7 +78,17 @@ static inline void rcu_sched_force_quiescent_state(void)
 {
 }
 
-#define synchronize_rcu synchronize_sched
+extern void synchronize_sched(void);
+
+static inline void synchronize_rcu(void)
+{
+	synchronize_sched();
+}
+
+static inline void synchronize_rcu_bh(void)
+{
+	synchronize_sched();
+}
 
 static inline void synchronize_rcu_expedited(void)
 {
@@ -114,4 +128,17 @@ static inline int rcu_preempt_depth(void)
 	return 0;
 }
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+extern int rcu_scheduler_active __read_mostly;
+extern void rcu_scheduler_starting(void);
+
+#else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
+static inline void rcu_scheduler_starting(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 #endif /* __LINUX_RCUTINY_H */
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 42cc3a0..4828205 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -34,6 +34,7 @@ struct notifier_block;
 
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
+extern void rcu_note_context_switch(int cpu);
 extern int rcu_needs_cpu(int cpu);
 extern int rcu_expedited_torture_stats(char *page);
 
@@ -86,6 +87,8 @@ static inline void __rcu_read_unlock_bh(void)
 
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));
+extern void synchronize_rcu_bh(void);
+extern void synchronize_sched(void);
 extern void synchronize_rcu_expedited(void);
 
 static inline void synchronize_rcu_bh_expedited(void)
@@ -120,4 +123,7 @@ static inline int rcu_blocking_is_gp(void)
 	return num_online_cpus() == 1;
 }
 
+extern void rcu_scheduler_starting(void);
+extern int rcu_scheduler_active __read_mostly;
+
 #endif /* __LINUX_RCUTREE_H */
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 4d5ecb2..4d5d2f5 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -27,6 +27,8 @@
 #ifndef _LINUX_SRCU_H
 #define _LINUX_SRCU_H
 
+#include <linux/mutex.h>
+
 struct srcu_struct_array {
 	int c[2];
 };
@@ -84,8 +86,8 @@ long srcu_batches_completed(struct srcu_struct *sp);
 /**
  * srcu_read_lock_held - might we be in SRCU read-side critical section?
  *
- * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in
- * an SRCU read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
+ * If CONFIG_DEBUG_LOCK_ALLOC is selected, returns nonzero iff in an SRCU
+ * read-side critical section.  In absence of CONFIG_DEBUG_LOCK_ALLOC,
  * this assumes we are in an SRCU read-side critical section unless it can
  * prove otherwise.
  */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e2769e1..3a53c77 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1646,7 +1646,9 @@ static inline struct cftype *__d_cft(struct dentry *dentry)
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 {
 	char *start;
-	struct dentry *dentry = rcu_dereference(cgrp->dentry);
+	struct dentry *dentry = rcu_dereference_check(cgrp->dentry,
+						      rcu_read_lock_held() ||
+						      cgroup_lock_is_held());
 
 	if (!dentry || cgrp == dummytop) {
 		/*
@@ -1662,13 +1664,17 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 	*--start = '\0';
 	for (;;) {
 		int len = dentry->d_name.len;
+
 		if ((start -= len) < buf)
 			return -ENAMETOOLONG;
-		memcpy(start, cgrp->dentry->d_name.name, len);
+		memcpy(start, dentry->d_name.name, len);
 		cgrp = cgrp->parent;
 		if (!cgrp)
 			break;
-		dentry = rcu_dereference(cgrp->dentry);
+
+		dentry = rcu_dereference_check(cgrp->dentry,
+					       rcu_read_lock_held() ||
+					       cgroup_lock_is_held());
 		if (!cgrp->parent)
 			continue;
 		if (--start < buf)
@@ -4555,13 +4561,13 @@ static int alloc_css_id(struct cgroup_subsys *ss, struct cgroup *parent,
 {
 	int subsys_id, i, depth = 0;
 	struct cgroup_subsys_state *parent_css, *child_css;
-	struct css_id *child_id, *parent_id = NULL;
+	struct css_id *child_id, *parent_id;
 
 	subsys_id = ss->subsys_id;
 	parent_css = parent->subsys[subsys_id];
 	child_css = child->subsys[subsys_id];
-	depth = css_depth(parent_css) + 1;
 	parent_id = parent_css->id;
+	depth = parent_id->depth;
 
 	child_id = get_new_cssid(ss, depth);
 	if (IS_ERR(child_id))
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index da5e139..e5c0244 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -205,9 +205,12 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 	 * No lock is needed, since the task isn't on tasklist yet,
 	 * so it can't be moved to another cgroup, which means the
 	 * freezer won't be removed and will be valid during this
-	 * function call.
+	 * function call.  Nevertheless, apply RCU read-side critical
+	 * section to suppress RCU lockdep false positives.
 	 */
+	rcu_read_lock();
 	freezer = task_freezer(task);
+	rcu_read_unlock();
 
 	/*
 	 * The root cgroup is non-freezable, so we can skip the
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 2594e1c..73747b7 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3801,8 +3801,10 @@ void lockdep_rcu_dereference(const char *file, const int line)
 {
 	struct task_struct *curr = current;
 
+#ifndef CONFIG_PROVE_RCU_REPEATEDLY
 	if (!debug_locks_off())
 		return;
+#endif /* #ifdef CONFIG_PROVE_RCU_REPEATEDLY */
 	printk("\n===================================================\n");
 	printk(  "[ INFO: suspicious rcu_dereference_check() usage. ]\n");
 	printk(  "---------------------------------------------------\n");
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 03a7ea1..be12514 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -44,7 +44,6 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
-#include <linux/kernel_stat.h>
 #include <linux/hardirq.h>
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -64,9 +63,6 @@ struct lockdep_map rcu_sched_lock_map =
 EXPORT_SYMBOL_GPL(rcu_sched_lock_map);
 #endif
 
-int rcu_scheduler_active __read_mostly;
-EXPORT_SYMBOL_GPL(rcu_scheduler_active);
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 int debug_lockdep_rcu_enabled(void)
@@ -97,21 +93,6 @@ EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 /*
- * This function is invoked towards the end of the scheduler's initialization
- * process.  Before this is called, the idle task might contain
- * RCU read-side critical sections (during which time, this idle
- * task is booting the system).  After this function is called, the
- * idle tasks are prohibited from containing RCU read-side critical
- * sections.
- */
-void rcu_scheduler_starting(void)
-{
-	WARN_ON(num_online_cpus() != 1);
-	WARN_ON(nr_context_switches() > 0);
-	rcu_scheduler_active = 1;
-}
-
-/*
  * Awaken the corresponding synchronize_rcu() instance now that a
  * grace period has elapsed.
  */
@@ -122,3 +103,163 @@ void wakeme_after_rcu(struct rcu_head  *head)
 	rcu = container_of(head, struct rcu_synchronize, head);
 	complete(&rcu->completion);
 }
+
+#ifdef CONFIG_PROVE_RCU
+/*
+ * wrapper function to avoid #include problems.
+ */
+int rcu_my_thread_group_empty(void)
+{
+	return thread_group_empty(current);
+}
+EXPORT_SYMBOL_GPL(rcu_my_thread_group_empty);
+#endif /* #ifdef CONFIG_PROVE_RCU */
+
+#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+static inline void debug_init_rcu_head(struct rcu_head *head)
+{
+	debug_object_init(head, &rcuhead_debug_descr);
+}
+
+static inline void debug_rcu_head_free(struct rcu_head *head)
+{
+	debug_object_free(head, &rcuhead_debug_descr);
+}
+
+/*
+ * fixup_init is called when:
+ * - an active object is initialized
+ */
+static int rcuhead_fixup_init(void *addr, enum debug_obj_state state)
+{
+	struct rcu_head *head = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		/*
+		 * Ensure that queued callbacks are all executed.
+		 * If we detect that we are nested in a RCU read-side critical
+		 * section, we should simply fail, otherwise we would deadlock.
+		 */
+#ifndef CONFIG_PREEMPT
+		WARN_ON(1);
+		return 0;
+#else
+		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
+		    irqs_disabled()) {
+			WARN_ON(1);
+			return 0;
+		}
+		rcu_barrier();
+		rcu_barrier_sched();
+		rcu_barrier_bh();
+		debug_object_init(head, &rcuhead_debug_descr);
+		return 1;
+#endif
+	default:
+		return 0;
+	}
+}
+
+/*
+ * fixup_activate is called when:
+ * - an active object is activated
+ * - an unknown object is activated (might be a statically initialized object)
+ * Activation is performed internally by call_rcu().
+ */
+static int rcuhead_fixup_activate(void *addr, enum debug_obj_state state)
+{
+	struct rcu_head *head = addr;
+
+	switch (state) {
+
+	case ODEBUG_STATE_NOTAVAILABLE:
+		/*
+		 * This is not really a fixup. We just make sure that it is
+		 * tracked in the object tracker.
+		 */
+		debug_object_init(head, &rcuhead_debug_descr);
+		debug_object_activate(head, &rcuhead_debug_descr);
+		return 0;
+
+	case ODEBUG_STATE_ACTIVE:
+		/*
+		 * Ensure that queued callbacks are all executed.
+		 * If we detect that we are nested in a RCU read-side critical
+		 * section, we should simply fail, otherwise we would deadlock.
+		 */
+#ifndef CONFIG_PREEMPT
+		WARN_ON(1);
+		return 0;
+#else
+		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
+		    irqs_disabled()) {
+			WARN_ON(1);
+			return 0;
+		}
+		rcu_barrier();
+		rcu_barrier_sched();
+		rcu_barrier_bh();
+		debug_object_activate(head, &rcuhead_debug_descr);
+		return 1;
+#endif
+	default:
+		return 0;
+	}
+}
+
+/*
+ * fixup_free is called when:
+ * - an active object is freed
+ */
+static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
+{
+	struct rcu_head *head = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		/*
+		 * Ensure that queued callbacks are all executed.
+		 * If we detect that we are nested in a RCU read-side critical
+		 * section, we should simply fail, otherwise we would deadlock.
+		 */
+#ifndef CONFIG_PREEMPT
+		WARN_ON(1);
+		return 0;
+#else
+		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
+		    irqs_disabled()) {
+			WARN_ON(1);
+			return 0;
+		}
+		rcu_barrier();
+		rcu_barrier_sched();
+		rcu_barrier_bh();
+		debug_object_free(head, &rcuhead_debug_descr);
+		return 1;
+#endif
+	default:
+		return 0;
+	}
+}
+
+void init_rcu_head_on_stack(struct rcu_head *head)
+{
+	debug_object_init_on_stack(head, &rcuhead_debug_descr);
+}
+EXPORT_SYMBOL_GPL(init_rcu_head_on_stack);
+
+void destroy_rcu_head_on_stack(struct rcu_head *head)
+{
+	debug_object_free(head, &rcuhead_debug_descr);
+}
+EXPORT_SYMBOL_GPL(destroy_rcu_head_on_stack);
+
+struct debug_obj_descr rcuhead_debug_descr = {
+	.name = "rcu_head",
+	.fixup_init = rcuhead_fixup_init,
+	.fixup_activate = rcuhead_fixup_activate,
+	.fixup_free = rcuhead_fixup_free,
+};
+EXPORT_SYMBOL_GPL(rcuhead_debug_descr);
+#endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 9f6d9ff..196ec02 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -44,9 +44,9 @@ struct rcu_ctrlblk {
 };
 
 /* Definition for rcupdate control block. */
-static struct rcu_ctrlblk rcu_ctrlblk = {
-	.donetail	= &rcu_ctrlblk.rcucblist,
-	.curtail	= &rcu_ctrlblk.rcucblist,
+static struct rcu_ctrlblk rcu_sched_ctrlblk = {
+	.donetail	= &rcu_sched_ctrlblk.rcucblist,
+	.curtail	= &rcu_sched_ctrlblk.rcucblist,
 };
 
 static struct rcu_ctrlblk rcu_bh_ctrlblk = {
@@ -54,6 +54,11 @@ static struct rcu_ctrlblk rcu_bh_ctrlblk = {
 	.curtail	= &rcu_bh_ctrlblk.rcucblist,
 };
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+int rcu_scheduler_active __read_mostly;
+EXPORT_SYMBOL_GPL(rcu_scheduler_active);
+#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 #ifdef CONFIG_NO_HZ
 
 static long rcu_dynticks_nesting = 1;
@@ -108,7 +113,8 @@ static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
  */
 void rcu_sched_qs(int cpu)
 {
-	if (rcu_qsctr_help(&rcu_ctrlblk) + rcu_qsctr_help(&rcu_bh_ctrlblk))
+	if (rcu_qsctr_help(&rcu_sched_ctrlblk) +
+	    rcu_qsctr_help(&rcu_bh_ctrlblk))
 		raise_softirq(RCU_SOFTIRQ);
 }
 
@@ -163,6 +169,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 	while (list) {
 		next = list->next;
 		prefetch(next);
+		debug_rcu_head_unqueue(list);
 		list->func(list);
 		list = next;
 	}
@@ -173,7 +180,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
  */
 static void rcu_process_callbacks(struct softirq_action *unused)
 {
-	__rcu_process_callbacks(&rcu_ctrlblk);
+	__rcu_process_callbacks(&rcu_sched_ctrlblk);
 	__rcu_process_callbacks(&rcu_bh_ctrlblk);
 }
 
@@ -187,7 +194,8 @@ static void rcu_process_callbacks(struct softirq_action *unused)
  *
  * Cool, huh?  (Due to Josh Triplett.)
  *
- * But we want to make this a static inline later.
+ * But we want to make this a static inline later.  The cond_resched()
+ * currently makes this problematic.
  */
 void synchronize_sched(void)
 {
@@ -195,12 +203,6 @@ void synchronize_sched(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_sched);
 
-void synchronize_rcu_bh(void)
-{
-	synchronize_sched();
-}
-EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
-
 /*
  * Helper function for call_rcu() and call_rcu_bh().
  */
@@ -210,6 +212,7 @@ static void __call_rcu(struct rcu_head *head,
 {
 	unsigned long flags;
 
+	debug_rcu_head_queue(head);
 	head->func = func;
 	head->next = NULL;
 
@@ -226,7 +229,7 @@ static void __call_rcu(struct rcu_head *head,
  */
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 {
-	__call_rcu(head, func, &rcu_ctrlblk);
+	__call_rcu(head, func, &rcu_sched_ctrlblk);
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
@@ -244,11 +247,13 @@ void rcu_barrier(void)
 {
 	struct rcu_synchronize rcu;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier);
 
@@ -256,11 +261,13 @@ void rcu_barrier_bh(void)
 {
 	struct rcu_synchronize rcu;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu_bh(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_bh);
 
@@ -268,11 +275,13 @@ void rcu_barrier_sched(void)
 {
 	struct rcu_synchronize rcu;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu_sched(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_sched);
 
@@ -280,3 +289,5 @@ void __init rcu_init(void)
 {
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
+
+#include "rcutiny_plugin.h"
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
new file mode 100644
index 0000000..d223a92
--- /dev/null
+++ b/kernel/rcutiny_plugin.h
@@ -0,0 +1,39 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion (tree-based version)
+ * Internal non-public definitions that provide either classic
+ * or preemptable semantics.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2009
+ *
+ * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+ */
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+#include <linux/kernel_stat.h>
+
+/*
+ * During boot, we forgive RCU lockdep issues.  After this function is
+ * invoked, we start taking RCU lockdep issues seriously.
+ */
+void rcu_scheduler_starting(void)
+{
+	WARN_ON(nr_context_switches() > 0);
+	rcu_scheduler_active = 1;
+}
+
+#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 58df55b..077defb 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -464,9 +464,11 @@ static void rcu_bh_torture_synchronize(void)
 {
 	struct rcu_bh_torture_synchronize rcu;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	call_rcu_bh(&rcu.head, rcu_bh_torture_wakeme_after_cb);
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 
 static struct rcu_torture_ops rcu_bh_ops = {
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3ec8160..d5bc439 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -46,6 +46,7 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/time.h>
+#include <linux/kernel_stat.h>
 
 #include "rcutree.h"
 
@@ -53,8 +54,8 @@
 
 static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
 
-#define RCU_STATE_INITIALIZER(name) { \
-	.level = { &name.node[0] }, \
+#define RCU_STATE_INITIALIZER(structname) { \
+	.level = { &structname.node[0] }, \
 	.levelcnt = { \
 		NUM_RCU_LVL_0,  /* root of hierarchy. */ \
 		NUM_RCU_LVL_1, \
@@ -65,13 +66,14 @@ static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
 	.signaled = RCU_GP_IDLE, \
 	.gpnum = -300, \
 	.completed = -300, \
-	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&name.onofflock), \
+	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&structname.onofflock), \
 	.orphan_cbs_list = NULL, \
-	.orphan_cbs_tail = &name.orphan_cbs_list, \
+	.orphan_cbs_tail = &structname.orphan_cbs_list, \
 	.orphan_qlen = 0, \
-	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&name.fqslock), \
+	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&structname.fqslock), \
 	.n_force_qs = 0, \
 	.n_force_qs_ngp = 0, \
+	.name = #structname, \
 }
 
 struct rcu_state rcu_sched_state = RCU_STATE_INITIALIZER(rcu_sched_state);
@@ -80,6 +82,9 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
+int rcu_scheduler_active __read_mostly;
+EXPORT_SYMBOL_GPL(rcu_scheduler_active);
+
 /*
  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
  * permit this function to be invoked without holding the root rcu_node
@@ -97,25 +102,32 @@ static int rcu_gp_in_progress(struct rcu_state *rsp)
  */
 void rcu_sched_qs(int cpu)
 {
-	struct rcu_data *rdp;
+	struct rcu_data *rdp = &per_cpu(rcu_sched_data, cpu);
 
-	rdp = &per_cpu(rcu_sched_data, cpu);
 	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
 	rdp->passed_quiesc = 1;
-	rcu_preempt_note_context_switch(cpu);
 }
 
 void rcu_bh_qs(int cpu)
 {
-	struct rcu_data *rdp;
+	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
 
-	rdp = &per_cpu(rcu_bh_data, cpu);
 	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
 	rdp->passed_quiesc = 1;
 }
 
+/*
+ * Note a context switch.  This is a quiescent state for RCU-sched,
+ * and requires special handling for preemptible RCU.
+ */
+void rcu_note_context_switch(int cpu)
+{
+	rcu_sched_qs(cpu);
+	rcu_preempt_note_context_switch(cpu);
+}
+
 #ifdef CONFIG_NO_HZ
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks_nesting = 1,
@@ -438,6 +450,8 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
+int rcu_cpu_stall_panicking __read_mostly;
+
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
 	rsp->gp_start = jiffies;
@@ -470,7 +484,8 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 
 	/* OK, time to rat on our buddy... */
 
-	printk(KERN_ERR "INFO: RCU detected CPU stalls:");
+	printk(KERN_ERR "INFO: %s detected stalls on CPUs/tasks: {",
+	       rsp->name);
 	rcu_for_each_leaf_node(rsp, rnp) {
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rcu_print_task_stall(rnp);
@@ -481,7 +496,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 			if (rnp->qsmask & (1UL << cpu))
 				printk(" %d", rnp->grplo + cpu);
 	}
-	printk(" (detected by %d, t=%ld jiffies)\n",
+	printk("} (detected by %d, t=%ld jiffies)\n",
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
 	trigger_all_cpu_backtrace();
 
@@ -497,8 +512,8 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
-	printk(KERN_ERR "INFO: RCU detected CPU %d stall (t=%lu jiffies)\n",
-			smp_processor_id(), jiffies - rsp->gp_start);
+	printk(KERN_ERR "INFO: %s detected stall on CPU %d (t=%lu jiffies)\n",
+	       rsp->name, smp_processor_id(), jiffies - rsp->gp_start);
 	trigger_all_cpu_backtrace();
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
@@ -515,6 +530,8 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 	long delta;
 	struct rcu_node *rnp;
 
+	if (rcu_cpu_stall_panicking)
+		return;
 	delta = jiffies - rsp->jiffies_stall;
 	rnp = rdp->mynode;
 	if ((rnp->qsmask & rdp->grpmask) && delta >= 0) {
@@ -529,6 +546,21 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 }
 
+static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
+{
+	rcu_cpu_stall_panicking = 1;
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block rcu_panic_block = {
+	.notifier_call = rcu_panic,
+};
+
+static void __init check_cpu_stall_init(void)
+{
+	atomic_notifier_chain_register(&panic_notifier_list, &rcu_panic_block);
+}
+
 #else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
@@ -539,6 +571,10 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 }
 
+static void __init check_cpu_stall_init(void)
+{
+}
+
 #endif /* #else #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /*
@@ -1076,6 +1112,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	while (list) {
 		next = list->next;
 		prefetch(next);
+		debug_rcu_head_unqueue(list);
 		list->func(list);
 		list = next;
 		if (++count >= rdp->blimit)
@@ -1125,8 +1162,6 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
  */
 void rcu_check_callbacks(int cpu, int user)
 {
-	if (!rcu_pending(cpu))
-		return; /* if nothing for RCU to do. */
 	if (user ||
 	    (idle_cpu(cpu) && rcu_scheduler_active &&
 	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
@@ -1158,7 +1193,8 @@ void rcu_check_callbacks(int cpu, int user)
 		rcu_bh_qs(cpu);
 	}
 	rcu_preempt_check_callbacks(cpu);
-	raise_softirq(RCU_SOFTIRQ);
+	if (rcu_pending(cpu))
+		raise_softirq(RCU_SOFTIRQ);
 }
 
 #ifdef CONFIG_SMP
@@ -1236,11 +1272,11 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		break; /* grace period idle or initializing, ignore. */
 
 	case RCU_SAVE_DYNTICK:
-
-		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
 		if (RCU_SIGNAL_INIT != RCU_SAVE_DYNTICK)
 			break; /* So gcc recognizes the dead code. */
 
+		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
+
 		/* Record dyntick-idle state. */
 		force_qs_rnp(rsp, dyntick_save_progress_counter);
 		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
@@ -1353,6 +1389,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	unsigned long flags;
 	struct rcu_data *rdp;
 
+	debug_rcu_head_queue(head);
 	head->func = func;
 	head->next = NULL;
 
@@ -1449,11 +1486,13 @@ void synchronize_sched(void)
 	if (rcu_blocking_is_gp())
 		return;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu_sched(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(synchronize_sched);
 
@@ -1473,11 +1512,13 @@ void synchronize_rcu_bh(void)
 	if (rcu_blocking_is_gp())
 		return;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu_bh(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
@@ -1498,8 +1539,20 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	check_cpu_stall(rsp, rdp);
 
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
-	if (rdp->qs_pending) {
+	if (rdp->qs_pending && !rdp->passed_quiesc) {
+
+		/*
+		 * If force_quiescent_state() coming soon and this CPU
+		 * needs a quiescent state, and this is either RCU-sched
+		 * or RCU-bh, force a local reschedule.
+		 */
 		rdp->n_rp_qs_pending++;
+		if (!rdp->preemptable &&
+		    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs) - 1,
+				 jiffies))
+			set_need_resched();
+	} else if (rdp->qs_pending && rdp->passed_quiesc) {
+		rdp->n_rp_report_qs++;
 		return 1;
 	}
 
@@ -1767,6 +1820,21 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 }
 
 /*
+ * This function is invoked towards the end of the scheduler's initialization
+ * process.  Before this is called, the idle task might contain
+ * RCU read-side critical sections (during which time, this idle
+ * task is booting the system).  After this function is called, the
+ * idle tasks are prohibited from containing RCU read-side critical
+ * sections.  This function also enables RCU lockdep checking.
+ */
+void rcu_scheduler_starting(void)
+{
+	WARN_ON(num_online_cpus() != 1);
+	WARN_ON(nr_context_switches() > 0);
+	rcu_scheduler_active = 1;
+}
+
+/*
  * Compute the per-level fanout, either using the exact fanout specified
  * or balancing the tree, depending on CONFIG_RCU_FANOUT_EXACT.
  */
@@ -1849,6 +1917,14 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 			INIT_LIST_HEAD(&rnp->blocked_tasks[3]);
 		}
 	}
+
+	rnp = rsp->level[NUM_RCU_LVLS - 1];
+	for_each_possible_cpu(i) {
+		while (i > rnp->grphi)
+			rnp++;
+		rsp->rda[i]->mynode = rnp;
+		rcu_boot_init_percpu_data(i, rsp);
+	}
 }
 
 /*
@@ -1859,19 +1935,11 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 #define RCU_INIT_FLAVOR(rsp, rcu_data) \
 do { \
 	int i; \
-	int j; \
-	struct rcu_node *rnp; \
 	\
-	rcu_init_one(rsp); \
-	rnp = (rsp)->level[NUM_RCU_LVLS - 1]; \
-	j = 0; \
 	for_each_possible_cpu(i) { \
-		if (i > rnp[j].grphi) \
-			j++; \
-		per_cpu(rcu_data, i).mynode = &rnp[j]; \
 		(rsp)->rda[i] = &per_cpu(rcu_data, i); \
-		rcu_boot_init_percpu_data(i, rsp); \
 	} \
+	rcu_init_one(rsp); \
 } while (0)
 
 void __init rcu_init(void)
@@ -1879,12 +1947,6 @@ void __init rcu_init(void)
 	int cpu;
 
 	rcu_bootup_announce();
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-#if NUM_RCU_LVL_4 != 0
-	printk(KERN_INFO "Experimental four-level hierarchy is enabled.\n");
-#endif /* #if NUM_RCU_LVL_4 != 0 */
 	RCU_INIT_FLAVOR(&rcu_sched_state, rcu_sched_data);
 	RCU_INIT_FLAVOR(&rcu_bh_state, rcu_bh_data);
 	__rcu_init_preempt();
@@ -1898,6 +1960,7 @@ void __init rcu_init(void)
 	cpu_notifier(rcu_cpu_notify, 0);
 	for_each_online_cpu(cpu)
 		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
+	check_cpu_stall_init();
 }
 
 #include "rcutree_plugin.h"
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 4a525a3..14c040b 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -223,6 +223,7 @@ struct rcu_data {
 	/* 5) __rcu_pending() statistics. */
 	unsigned long n_rcu_pending;	/* rcu_pending() calls since boot. */
 	unsigned long n_rp_qs_pending;
+	unsigned long n_rp_report_qs;
 	unsigned long n_rp_cb_ready;
 	unsigned long n_rp_cpu_needs_gp;
 	unsigned long n_rp_gp_completed;
@@ -326,6 +327,7 @@ struct rcu_state {
 	unsigned long jiffies_stall;		/* Time at which to check */
 						/*  for CPU stalls. */
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+	char *name;				/* Name of structure. */
 };
 
 /* Return values for rcu_preempt_offline_tasks(). */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 79b53bd..92e5c9b 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -26,6 +26,45 @@
 
 #include <linux/delay.h>
 
+/*
+ * Check the RCU kernel configuration parameters and print informative
+ * messages about anything out of the ordinary.  If you like #ifdef, you
+ * will love this function.
+ */
+static void __init rcu_bootup_announce_oddness(void)
+{
+#ifdef CONFIG_RCU_TRACE
+	printk(KERN_INFO "\tRCU debugfs-based tracing is enabled.\n");
+#endif
+#if (defined(CONFIG_64BIT) && CONFIG_RCU_FANOUT != 64) || (!defined(CONFIG_64BIT) && CONFIG_RCU_FANOUT != 32)
+	printk(KERN_INFO "\tCONFIG_RCU_FANOUT set to non-default value of %d\n",
+	       CONFIG_RCU_FANOUT);
+#endif
+#ifdef CONFIG_RCU_FANOUT_EXACT
+	printk(KERN_INFO "\tHierarchical RCU autobalancing is disabled.\n");
+#endif
+#ifdef CONFIG_RCU_FAST_NO_HZ
+	printk(KERN_INFO
+	       "\tRCU dyntick-idle grace-period acceleration is enabled.\n");
+#endif
+#ifdef CONFIG_PROVE_RCU
+	printk(KERN_INFO "\tRCU lockdep checking is enabled.\n");
+#endif
+#ifdef CONFIG_RCU_TORTURE_TEST_RUNNABLE
+	printk(KERN_INFO "\tRCU torture testing starts during boot.\n");
+#endif
+#ifndef CONFIG_RCU_CPU_STALL_DETECTOR
+	printk(KERN_INFO
+	       "\tRCU-based detection of stalled CPUs is disabled.\n");
+#endif
+#ifndef CONFIG_RCU_CPU_STALL_VERBOSE
+	printk(KERN_INFO "\tVerbose stalled-CPUs detection is disabled.\n");
+#endif
+#if NUM_RCU_LVL_4 != 0
+	printk(KERN_INFO "\tExperimental four-level hierarchy is enabled.\n");
+#endif
+}
+
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
 struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt_state);
@@ -38,8 +77,8 @@ static int rcu_preempted_readers_exp(struct rcu_node *rnp);
  */
 static void __init rcu_bootup_announce(void)
 {
-	printk(KERN_INFO
-	       "Experimental preemptable hierarchical RCU implementation.\n");
+	printk(KERN_INFO "Preemptable hierarchical RCU implementation.\n");
+	rcu_bootup_announce_oddness();
 }
 
 /*
@@ -75,13 +114,19 @@ EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
  * that this just means that the task currently running on the CPU is
  * not in a quiescent state.  There might be any number of tasks blocked
  * while in an RCU read-side critical section.
+ *
+ * Unlike the other rcu_*_qs() functions, callers to this function
+ * must disable irqs in order to protect the assignment to
+ * ->rcu_read_unlock_special.
  */
 static void rcu_preempt_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
+
 	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
 	rdp->passed_quiesc = 1;
+	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
 }
 
 /*
@@ -144,9 +189,8 @@ static void rcu_preempt_note_context_switch(int cpu)
 	 * grace period, then the fact that the task has been enqueued
 	 * means that we continue to block the current grace period.
 	 */
-	rcu_preempt_qs(cpu);
 	local_irq_save(flags);
-	t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
+	rcu_preempt_qs(cpu);
 	local_irq_restore(flags);
 }
 
@@ -236,7 +280,6 @@ static void rcu_read_unlock_special(struct task_struct *t)
 	 */
 	special = t->rcu_read_unlock_special;
 	if (special & RCU_READ_UNLOCK_NEED_QS) {
-		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
 		rcu_preempt_qs(smp_processor_id());
 	}
 
@@ -473,7 +516,6 @@ static void rcu_preempt_check_callbacks(int cpu)
 	struct task_struct *t = current;
 
 	if (t->rcu_read_lock_nesting == 0) {
-		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
 		rcu_preempt_qs(cpu);
 		return;
 	}
@@ -515,11 +557,13 @@ void synchronize_rcu(void)
 	if (!rcu_scheduler_active)
 		return;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
@@ -754,6 +798,7 @@ void exit_rcu(void)
 static void __init rcu_bootup_announce(void)
 {
 	printk(KERN_INFO "Hierarchical RCU implementation.\n");
+	rcu_bootup_announce_oddness();
 }
 
 /*
@@ -1008,6 +1053,8 @@ static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
 int rcu_needs_cpu(int cpu)
 {
 	int c = 0;
+	int snap;
+	int snap_nmi;
 	int thatcpu;
 
 	/* Check for being in the holdoff period. */
@@ -1015,12 +1062,18 @@ int rcu_needs_cpu(int cpu)
 		return rcu_needs_cpu_quick_check(cpu);
 
 	/* Don't bother unless we are the last non-dyntick-idle CPU. */
-	for_each_cpu_not(thatcpu, nohz_cpu_mask)
-		if (thatcpu != cpu) {
+	for_each_online_cpu(thatcpu) {
+		if (thatcpu == cpu)
+			continue;
+		snap = per_cpu(rcu_dynticks, thatcpu)->dynticks;
+		snap_nmi = per_cpu(rcu_dynticks, thatcpu)->dynticks_nmi;
+		smp_mb(); /* Order sampling of snap with end of grace period. */
+		if (((snap & 0x1) != 0) || ((snap_nmi & 0x1) != 0)) {
 			per_cpu(rcu_dyntick_drain, cpu) = 0;
 			per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
 			return rcu_needs_cpu_quick_check(cpu);
 		}
+	}
 
 	/* Check and update the rcu_dyntick_drain sequencing. */
 	if (per_cpu(rcu_dyntick_drain, cpu) <= 0) {
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index d45db2e..36c95b4 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -241,11 +241,13 @@ static const struct file_operations rcugp_fops = {
 static void print_one_rcu_pending(struct seq_file *m, struct rcu_data *rdp)
 {
 	seq_printf(m, "%3d%cnp=%ld "
-		   "qsp=%ld cbr=%ld cng=%ld gpc=%ld gps=%ld nf=%ld nn=%ld\n",
+		   "qsp=%ld rpq=%ld cbr=%ld cng=%ld "
+		   "gpc=%ld gps=%ld nf=%ld nn=%ld\n",
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
 		   rdp->n_rcu_pending,
 		   rdp->n_rp_qs_pending,
+		   rdp->n_rp_report_qs,
 		   rdp->n_rp_cb_ready,
 		   rdp->n_rp_cpu_needs_gp,
 		   rdp->n_rp_gp_completed,
diff --git a/kernel/sched.c b/kernel/sched.c
index de0bd26..d8a213c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -323,6 +323,15 @@ static inline struct task_group *task_group(struct task_struct *p)
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
+	/*
+	 * Strictly speaking this rcu_read_lock() is not needed since the
+	 * task_group is tied to the cgroup, which in turn can never go away
+	 * as long as there are tasks attached to it.
+	 *
+	 * However since task_group() uses task_subsys_state() which is an
+	 * rcu_dereference() user, this quiets CONFIG_PROVE_RCU.
+	 */
+	rcu_read_lock();
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
 	p->se.parent = task_group(p)->se[cpu];
@@ -332,6 +341,7 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
 	p->rt.parent = task_group(p)->rt_se[cpu];
 #endif
+	rcu_read_unlock();
 }
 
 #else
@@ -3696,7 +3706,7 @@ need_resched:
 	preempt_disable();
 	cpu = smp_processor_id();
 	rq = cpu_rq(cpu);
-	rcu_sched_qs(cpu);
+	rcu_note_context_switch(cpu);
 	prev = rq->curr;
 	switch_count = &prev->nivcsw;
 
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 9b49db1..19be00b 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -114,7 +114,9 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 	{
 		char path[64];
 
+		rcu_read_lock();
 		cgroup_path(task_group(p)->css.cgroup, path, sizeof(path));
+		rcu_read_unlock();
 		SEQ_printf(m, " %s", path);
 	}
 #endif
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7c1a67e..0db913a 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -716,7 +716,7 @@ static int run_ksoftirqd(void * __bind_cpu)
 			preempt_enable_no_resched();
 			cond_resched();
 			preempt_disable();
-			rcu_sched_qs((long)__bind_cpu);
+			rcu_note_context_switch((long)__bind_cpu);
 		}
 		preempt_enable();
 		set_current_state(TASK_INTERRUPTIBLE);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 935248b..8689646 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -307,6 +307,12 @@ config DEBUG_OBJECTS_WORK
 	  work queue routines to track the life time of work objects and
 	  validate the work operations.
 
+config DEBUG_OBJECTS_RCU_HEAD
+	bool "Debug RCU callbacks objects"
+	depends on DEBUG_OBJECTS
+	help
+	  Enable this to turn on debugging of RCU list heads (call_rcu() usage).
+
 config DEBUG_OBJECTS_ENABLE_DEFAULT
 	int "debug_objects bootup default value (0-1)"
         range 0 1
@@ -512,6 +518,18 @@ config PROVE_RCU
 
 	 Say N if you are unsure.
 
+config PROVE_RCU_REPEATEDLY
+	bool "RCU debugging: don't disable PROVE_RCU on first splat"
+	depends on PROVE_RCU
+	default n
+	help
+	 By itself, PROVE_RCU will disable checking upon issuing the
+	 first warning (or "splat").  This feature prevents such
+	 disabling, allowing multiple RCU-lockdep warnings to be printed
+	 on a single reboot.
+
+	 Say N if you are unsure.
+
 config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
@@ -793,7 +811,7 @@ config RCU_CPU_STALL_DETECTOR
 config RCU_CPU_STALL_VERBOSE
 	bool "Print additional per-task information for RCU_CPU_STALL_DETECTOR"
 	depends on RCU_CPU_STALL_DETECTOR && TREE_PREEMPT_RCU
-	default n
+	default y
 	help
 	  This option causes RCU to printk detailed per-task information
 	  for any tasks that are stalling the current RCU grace period.
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index b862b30..076464f 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -141,6 +141,7 @@ alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
 		obj->object = addr;
 		obj->descr  = descr;
 		obj->state  = ODEBUG_STATE_NONE;
+		obj->astate = 0;
 		hlist_del(&obj->node);
 
 		hlist_add_head(&obj->node, &b->list);
@@ -252,8 +253,10 @@ static void debug_print_object(struct debug_obj *obj, char *msg)
 
 	if (limit < 5 && obj->descr != descr_test) {
 		limit++;
-		WARN(1, KERN_ERR "ODEBUG: %s %s object type: %s\n", msg,
-		       obj_states[obj->state], obj->descr->name);
+		WARN(1, KERN_ERR "ODEBUG: %s %s (active state %u) "
+				 "object type: %s\n",
+			msg, obj_states[obj->state], obj->astate,
+			obj->descr->name);
 	}
 	debug_objects_warnings++;
 }
@@ -447,7 +450,10 @@ void debug_object_deactivate(void *addr, struct debug_obj_descr *descr)
 		case ODEBUG_STATE_INIT:
 		case ODEBUG_STATE_INACTIVE:
 		case ODEBUG_STATE_ACTIVE:
-			obj->state = ODEBUG_STATE_INACTIVE;
+			if (!obj->astate)
+				obj->state = ODEBUG_STATE_INACTIVE;
+			else
+				debug_print_object(obj, "deactivate");
 			break;
 
 		case ODEBUG_STATE_DESTROYED:
@@ -553,6 +559,53 @@ out_unlock:
 	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
 
+/**
+ * debug_object_active_state - debug checks object usage state machine
+ * @addr:	address of the object
+ * @descr:	pointer to an object specific debug description structure
+ * @expect:	expected state
+ * @next:	state to move to if expected state is found
+ */
+void
+debug_object_active_state(void *addr, struct debug_obj_descr *descr,
+			  unsigned int expect, unsigned int next)
+{
+	struct debug_bucket *db;
+	struct debug_obj *obj;
+	unsigned long flags;
+
+	if (!debug_objects_enabled)
+		return;
+
+	db = get_bucket((unsigned long) addr);
+
+	raw_spin_lock_irqsave(&db->lock, flags);
+
+	obj = lookup_object(addr, db);
+	if (obj) {
+		switch (obj->state) {
+		case ODEBUG_STATE_ACTIVE:
+			if (obj->astate == expect)
+				obj->astate = next;
+			else
+				debug_print_object(obj, "active_state");
+			break;
+
+		default:
+			debug_print_object(obj, "active_state");
+			break;
+		}
+	} else {
+		struct debug_obj o = { .object = addr,
+				       .state = ODEBUG_STATE_NOTAVAILABLE,
+				       .descr = descr };
+
+		debug_print_object(&o, "active_state");
+	}
+
+	raw_spin_unlock_irqrestore(&db->lock, flags);
+}
+
 #ifdef CONFIG_DEBUG_OBJECTS_FREE
 static void __debug_check_no_obj_freed(const void *address, unsigned long size)
 {
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index f13e067..1bba4ae 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -656,7 +656,6 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = PROP_FRAC_BASE;
 	spin_lock_init(&bdi->wb_lock);
-	INIT_RCU_HEAD(&bdi->rcu_head);
 	INIT_LIST_HEAD(&bdi->bdi_list);
 	INIT_LIST_HEAD(&bdi->wb_list);
 	INIT_LIST_HEAD(&bdi->work_list);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f4ede99..e06490d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -811,10 +811,12 @@ int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
 	 * enabled in "curr" and "curr" is a child of "mem" in *cgroup*
 	 * hierarchy(even if use_hierarchy is disabled in "mem").
 	 */
+	rcu_read_lock();
 	if (mem->use_hierarchy)
 		ret = css_is_ancestor(&curr->css, &mem->css);
 	else
 		ret = (curr == mem);
+	rcu_read_unlock();
 	css_put(&curr->css);
 	return ret;
 }
@@ -2312,7 +2314,9 @@ mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
 
 	/* record memcg information */
 	if (do_swap_account && swapout && memcg) {
+		rcu_read_lock();
 		swap_cgroup_record(ent, css_id(&memcg->css));
+		rcu_read_unlock();
 		mem_cgroup_get(memcg);
 	}
 	if (swapout && memcg)
@@ -2369,8 +2373,10 @@ static int mem_cgroup_move_swap_account(swp_entry_t entry,
 {
 	unsigned short old_id, new_id;
 
+	rcu_read_lock();
 	old_id = css_id(&from->css);
 	new_id = css_id(&to->css);
+	rcu_read_unlock();
 
 	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
 		mem_cgroup_swap_statistics(from, false);
@@ -4038,11 +4044,16 @@ static int is_target_pte_for_mc(struct vm_area_struct *vma,
 			put_page(page);
 	}
 	/* throught */
-	if (ent.val && do_swap_account && !ret &&
-			css_id(&mc.from->css) == lookup_swap_cgroup(ent)) {
-		ret = MC_TARGET_SWAP;
-		if (target)
-			target->ent = ent;
+	if (ent.val && do_swap_account && !ret) {
+		unsigned short id;
+		rcu_read_lock();
+		id = css_id(&mc.from->css);
+		rcu_read_unlock();
+		if (id == lookup_swap_cgroup(ent)) {
+			ret = MC_TARGET_SWAP;
+			if (target)
+				target->ent = ent;
+		}
 	}
 	return ret;
 }
diff --git a/mm/slob.c b/mm/slob.c
index 837ebd6..6de238d 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -647,7 +647,6 @@ void kmem_cache_free(struct kmem_cache *c, void *b)
 	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
 		struct slob_rcu *slob_rcu;
 		slob_rcu = b + (c->size - sizeof(struct slob_rcu));
-		INIT_RCU_HEAD(&slob_rcu->head);
 		slob_rcu->size = c->size;
 		call_rcu(&slob_rcu->head, kmem_rcu_free);
 	} else {
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 03fe63e..ea97c31 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -68,7 +68,8 @@ static int call_sbin_request_key(struct key_construction *cons,
 {
 	const struct cred *cred = current_cred();
 	key_serial_t prkey, sskey;
-	struct key *key = cons->key, *authkey = cons->authkey, *keyring;
+	struct key *key = cons->key, *authkey = cons->authkey, *keyring,
+		*session;
 	char *argv[9], *envp[3], uid_str[12], gid_str[12];
 	char key_str[12], keyring_str[3][12];
 	char desc[20];
@@ -112,10 +113,12 @@ static int call_sbin_request_key(struct key_construction *cons,
 	if (cred->tgcred->process_keyring)
 		prkey = cred->tgcred->process_keyring->serial;
 
-	if (cred->tgcred->session_keyring)
-		sskey = rcu_dereference(cred->tgcred->session_keyring)->serial;
-	else
-		sskey = cred->user->session_keyring->serial;
+	rcu_read_lock();
+	session = rcu_dereference(cred->tgcred->session_keyring);
+	if (!session)
+		session = cred->user->session_keyring;
+	sskey = session->serial;
+	rcu_read_unlock();
 
 	sprintf(keyring_str[2], "%d", sskey);
 
diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index 7c687d5..e9aa079 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -199,7 +199,8 @@ long user_read(const struct key *key, char __user *buffer, size_t buflen)
 	struct user_key_payload *upayload;
 	long ret;
 
-	upayload = rcu_dereference(key->payload.data);
+	upayload = rcu_dereference_protected(
+		key->payload.data, rwsem_is_locked(&((struct key *)key)->sem));
 	ret = upayload->datalen;
 
 	/* we can return the data as is */
diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index 989fef8..bf4e3bc 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -288,7 +288,6 @@ static struct avc_node *avc_alloc_node(void)
 	if (!node)
 		goto out;
 
-	INIT_RCU_HEAD(&node->rhead);
 	INIT_HLIST_NODE(&node->list);
 	avc_cache_stats_incr(allocations);
 
diff --git a/security/selinux/netnode.c b/security/selinux/netnode.c
index dc92792..65ebfe9 100644
--- a/security/selinux/netnode.c
+++ b/security/selinux/netnode.c
@@ -183,8 +183,6 @@ static void sel_netnode_insert(struct sel_netnode *node)
 		BUG();
 	}
 
-	INIT_RCU_HEAD(&node->rcu);
-
 	/* we need to impose a limit on the growth of the hash table so check
 	 * this bucket to make sure it is within the specified bounds */
 	list_add_rcu(&node->list, &sel_netnode_hash[idx].list);
