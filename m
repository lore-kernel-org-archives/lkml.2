Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab0JUMs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 08:48:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35963 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643Ab0JUMs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 08:48:57 -0400
Date: Thu, 21 Oct 2010 14:48:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] locking changes for v2.6.37
Message-ID: <20101021124848.GA32566@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-locking-for-linus

 Thanks,

	Ingo

------------------>
Hitoshi Mitake (2):
      lockdep: Add improved subclass caching
      lockdep: Check the depth of subclass

John Kacur (2):
      lockdep: Remove __debug_show_held_locks
      lockup detector: Fix grammar by adding a missing "to" in the comments

Lin Ming (1):
      lockup_detector: Make callback function static

Thomas Gleixner (15):
      input: Misc/hp_sdc_rtc: semaphore cleanup
      input: Serio/hil_mlc: semaphore cleanup
      input: Serio/hp_sdc: semaphore cleanup
      net: 3c527: semaphore cleanup
      hamradio: 6pack: semaphore cleanup
      hamradio: Mkiss: semaphore cleanup
      net: Ppp_async: semaphore cleanup
      net: Wan/cosa.c: Convert "mutex" to semaphore
      irda: Semaphore cleanup
      parport: Semaphore cleanup
      drivers/macintosh/adb: Do not claim that the semaphore is a mutex
      printk: Make console_sem a semaphore not a pseudo mutex
      arm: Bcmring: semaphore cleanup
      hfs: Convert tree_lock to mutex
      affs: Use sema_init instead of init_MUTEX


 arch/arm/mach-bcmring/dma.c     |    4 +-
 drivers/input/misc/hp_sdc_rtc.c |    4 +-
 drivers/input/serio/hil_mlc.c   |    6 ++--
 drivers/input/serio/hp_sdc.c    |    4 +-
 drivers/macintosh/adb.c         |    2 +-
 drivers/net/3c527.c             |    2 +-
 drivers/net/hamradio/6pack.c    |    2 +-
 drivers/net/hamradio/mkiss.c    |    2 +-
 drivers/net/irda/sir_dev.c      |    2 +-
 drivers/net/ppp_async.c         |    2 +-
 drivers/net/wan/cosa.c          |    2 +-
 drivers/parport/share.c         |    2 +-
 fs/affs/super.c                 |    4 +-
 fs/hfs/bfind.c                  |    4 +-
 fs/hfs/btree.c                  |    2 +-
 fs/hfs/btree.h                  |    2 +-
 include/linux/debug_locks.h     |    5 ----
 include/linux/lockdep.h         |   13 +++++++++-
 kernel/hung_task.c              |    4 +-
 kernel/lockdep.c                |   51 ++++++++++++++++++++++----------------
 kernel/printk.c                 |    4 +-
 kernel/watchdog.c               |    2 +-
 22 files changed, 69 insertions(+), 56 deletions(-)

diff --git a/arch/arm/mach-bcmring/dma.c b/arch/arm/mach-bcmring/dma.c
index 29c0a91..77eb35c 100644
--- a/arch/arm/mach-bcmring/dma.c
+++ b/arch/arm/mach-bcmring/dma.c
@@ -691,7 +691,7 @@ int dma_init(void)
 
 	memset(&gDMA, 0, sizeof(gDMA));
 
-	init_MUTEX_LOCKED(&gDMA.lock);
+	sema_init(&gDMA.lock, 0);
 	init_waitqueue_head(&gDMA.freeChannelQ);
 
 	/* Initialize the Hardware */
@@ -1574,7 +1574,7 @@ int dma_init_mem_map(DMA_MemMap_t *memMap)
 {
 	memset(memMap, 0, sizeof(*memMap));
 
-	init_MUTEX(&memMap->lock);
+	sema_init(&memMap->lock, 1);
 
 	return 0;
 }
diff --git a/drivers/input/misc/hp_sdc_rtc.c b/drivers/input/misc/hp_sdc_rtc.c
index c190664..7e2c12a 100644
--- a/drivers/input/misc/hp_sdc_rtc.c
+++ b/drivers/input/misc/hp_sdc_rtc.c
@@ -104,7 +104,7 @@ static int hp_sdc_rtc_do_read_bbrtc (struct rtc_time *rtctm)
 	t.endidx =		91;
 	t.seq =			tseq;
 	t.act.semaphore =	&tsem;
-	init_MUTEX_LOCKED(&tsem);
+	sema_init(&tsem, 0);
 	
 	if (hp_sdc_enqueue_transaction(&t)) return -1;
 	
@@ -698,7 +698,7 @@ static int __init hp_sdc_rtc_init(void)
 		return -ENODEV;
 #endif
 
-	init_MUTEX(&i8042tregs);
+	sema_init(&i8042tregs, 1);
 
 	if ((ret = hp_sdc_request_timer_irq(&hp_sdc_rtc_isr)))
 		return ret;
diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c
index c92f4ed..e5624d8 100644
--- a/drivers/input/serio/hil_mlc.c
+++ b/drivers/input/serio/hil_mlc.c
@@ -915,15 +915,15 @@ int hil_mlc_register(hil_mlc *mlc)
 	mlc->ostarted = 0;
 
 	rwlock_init(&mlc->lock);
-	init_MUTEX(&mlc->osem);
+	sema_init(&mlc->osem, 1);
 
-	init_MUTEX(&mlc->isem);
+	sema_init(&mlc->isem, 1);
 	mlc->icount = -1;
 	mlc->imatch = 0;
 
 	mlc->opercnt = 0;
 
-	init_MUTEX_LOCKED(&(mlc->csem));
+	sema_init(&(mlc->csem), 0);
 
 	hil_mlc_clear_di_scratch(mlc);
 	hil_mlc_clear_di_map(mlc, 0);
diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index bcc2d30..8c0b51c 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -905,7 +905,7 @@ static int __init hp_sdc_init(void)
 	ts_sync[1]	= 0x0f;
 	ts_sync[2] = ts_sync[3]	= ts_sync[4] = ts_sync[5] = 0;
 	t_sync.act.semaphore = &s_sync;
-	init_MUTEX_LOCKED(&s_sync);
+	sema_init(&s_sync, 0);
 	hp_sdc_enqueue_transaction(&t_sync);
 	down(&s_sync); /* Wait for t_sync to complete */
 
@@ -1039,7 +1039,7 @@ static int __init hp_sdc_register(void)
 		return hp_sdc.dev_err;
 	}
 
-	init_MUTEX_LOCKED(&tq_init_sem);
+	sema_init(&tq_init_sem, 0);
 
 	tq_init.actidx		= 0;
 	tq_init.idx		= 1;
diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index 1c4ee6e..bf64e49 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -83,7 +83,7 @@ static struct adb_driver *adb_controller;
 BLOCKING_NOTIFIER_HEAD(adb_client_list);
 static int adb_got_sleep;
 static int adb_inited;
-static DECLARE_MUTEX(adb_probe_mutex);
+static DEFINE_SEMAPHORE(adb_probe_mutex);
 static int sleepy_trackpad;
 static int autopoll_devs;
 int __adb_probe_sync;
diff --git a/drivers/net/3c527.c b/drivers/net/3c527.c
index 70705d1..eca55c5 100644
--- a/drivers/net/3c527.c
+++ b/drivers/net/3c527.c
@@ -522,7 +522,7 @@ static int __init mc32_probe1(struct net_device *dev, int slot)
 	lp->tx_len 		= lp->exec_box->data[9];   /* Transmit list count */
 	lp->rx_len 		= lp->exec_box->data[11];  /* Receive list count */
 
-	init_MUTEX_LOCKED(&lp->cmd_mutex);
+	sema_init(&lp->cmd_mutex, 0);
 	init_completion(&lp->execution_cmd);
 	init_completion(&lp->xceiver_cmd);
 
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 4b52c76..3e5d0b6 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -608,7 +608,7 @@ static int sixpack_open(struct tty_struct *tty)
 
 	spin_lock_init(&sp->lock);
 	atomic_set(&sp->refcnt, 1);
-	init_MUTEX_LOCKED(&sp->dead_sem);
+	sema_init(&sp->dead_sem, 0);
 
 	/* !!! length of the buffers. MTU is IP MTU, not PACLEN!  */
 
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 66e88bd..4c62839 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -747,7 +747,7 @@ static int mkiss_open(struct tty_struct *tty)
 
 	spin_lock_init(&ax->buflock);
 	atomic_set(&ax->refcnt, 1);
-	init_MUTEX_LOCKED(&ax->dead_sem);
+	sema_init(&ax->dead_sem, 0);
 
 	ax->tty = tty;
 	tty->disc_data = ax;
diff --git a/drivers/net/irda/sir_dev.c b/drivers/net/irda/sir_dev.c
index 1b051da..51d7444 100644
--- a/drivers/net/irda/sir_dev.c
+++ b/drivers/net/irda/sir_dev.c
@@ -909,7 +909,7 @@ struct sir_dev * sirdev_get_instance(const struct sir_driver *drv, const char *n
 	dev->tx_skb = NULL;
 
 	spin_lock_init(&dev->tx_lock);
-	init_MUTEX(&dev->fsm.sem);
+	sema_init(&dev->fsm.sem, 1);
 
 	dev->drv = drv;
 	dev->netdev = ndev;
diff --git a/drivers/net/ppp_async.c b/drivers/net/ppp_async.c
index af50a53..78d70a6 100644
--- a/drivers/net/ppp_async.c
+++ b/drivers/net/ppp_async.c
@@ -184,7 +184,7 @@ ppp_asynctty_open(struct tty_struct *tty)
 	tasklet_init(&ap->tsk, ppp_async_process, (unsigned long) ap);
 
 	atomic_set(&ap->refcnt, 1);
-	init_MUTEX_LOCKED(&ap->dead_sem);
+	sema_init(&ap->dead_sem, 0);
 
 	ap->chan.private = ap;
 	ap->chan.ops = &async_ops;
diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 04c6cd4..10bafd5 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -575,7 +575,7 @@ static int cosa_probe(int base, int irq, int dma)
 
 		/* Initialize the chardev data structures */
 		mutex_init(&chan->rlock);
-		init_MUTEX(&chan->wsem);
+		sema_init(&chan->wsem, 1);
 
 		/* Register the network interface */
 		if (!(chan->netdev = alloc_hdlcdev(chan))) {
diff --git a/drivers/parport/share.c b/drivers/parport/share.c
index dffa5d4..a2d9d1e 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -306,7 +306,7 @@ struct parport *parport_register_port(unsigned long base, int irq, int dma,
 	spin_lock_init(&tmp->pardevice_lock);
 	tmp->ieee1284.mode = IEEE1284_MODE_COMPAT;
 	tmp->ieee1284.phase = IEEE1284_PH_FWD_IDLE;
-	init_MUTEX_LOCKED (&tmp->ieee1284.irq); /* actually a semaphore at 0 */
+	sema_init(&tmp->ieee1284.irq, 0);
 	tmp->spintime = parport_default_spintime;
 	atomic_set (&tmp->ref_count, 1);
 	INIT_LIST_HEAD(&tmp->full_list);
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 33c4e7e..9581ea9 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -109,8 +109,8 @@ static void init_once(void *foo)
 {
 	struct affs_inode_info *ei = (struct affs_inode_info *) foo;
 
-	init_MUTEX(&ei->i_link_lock);
-	init_MUTEX(&ei->i_ext_lock);
+	sema_init(&ei->i_link_lock, 1);
+	sema_init(&ei->i_ext_lock, 1);
 	inode_init_once(&ei->vfs_inode);
 }
 
diff --git a/fs/hfs/bfind.c b/fs/hfs/bfind.c
index 4129cdb..571abe9 100644
--- a/fs/hfs/bfind.c
+++ b/fs/hfs/bfind.c
@@ -23,7 +23,7 @@ int hfs_find_init(struct hfs_btree *tree, struct hfs_find_data *fd)
 	fd->search_key = ptr;
 	fd->key = ptr + tree->max_key_len + 2;
 	dprint(DBG_BNODE_REFS, "find_init: %d (%p)\n", tree->cnid, __builtin_return_address(0));
-	down(&tree->tree_lock);
+	mutex_lock(&tree->tree_lock);
 	return 0;
 }
 
@@ -32,7 +32,7 @@ void hfs_find_exit(struct hfs_find_data *fd)
 	hfs_bnode_put(fd->bnode);
 	kfree(fd->search_key);
 	dprint(DBG_BNODE_REFS, "find_exit: %d (%p)\n", fd->tree->cnid, __builtin_return_address(0));
-	up(&fd->tree->tree_lock);
+	mutex_unlock(&fd->tree->tree_lock);
 	fd->tree = NULL;
 }
 
diff --git a/fs/hfs/btree.c b/fs/hfs/btree.c
index 38a0a99..3ebc437 100644
--- a/fs/hfs/btree.c
+++ b/fs/hfs/btree.c
@@ -27,7 +27,7 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id, btree_keycmp ke
 	if (!tree)
 		return NULL;
 
-	init_MUTEX(&tree->tree_lock);
+	mutex_init(&tree->tree_lock);
 	spin_lock_init(&tree->hash_lock);
 	/* Set the correct compare function */
 	tree->sb = sb;
diff --git a/fs/hfs/btree.h b/fs/hfs/btree.h
index cc51905..2a1d712 100644
--- a/fs/hfs/btree.h
+++ b/fs/hfs/btree.h
@@ -33,7 +33,7 @@ struct hfs_btree {
 	unsigned int depth;
 
 	//unsigned int map1_size, map_size;
-	struct semaphore tree_lock;
+	struct mutex tree_lock;
 
 	unsigned int pages_per_bnode;
 	spinlock_t hash_lock;
diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index 29b3ce3..2833452 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -49,7 +49,6 @@ struct task_struct;
 
 #ifdef CONFIG_LOCKDEP
 extern void debug_show_all_locks(void);
-extern void __debug_show_held_locks(struct task_struct *task);
 extern void debug_show_held_locks(struct task_struct *task);
 extern void debug_check_no_locks_freed(const void *from, unsigned long len);
 extern void debug_check_no_locks_held(struct task_struct *task);
@@ -58,10 +57,6 @@ static inline void debug_show_all_locks(void)
 {
 }
 
-static inline void __debug_show_held_locks(struct task_struct *task)
-{
-}
-
 static inline void debug_show_held_locks(struct task_struct *task)
 {
 }
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 06aed83..2186a64 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -32,6 +32,17 @@ extern int lock_stat;
 #define MAX_LOCKDEP_SUBCLASSES		8UL
 
 /*
+ * NR_LOCKDEP_CACHING_CLASSES ... Number of classes
+ * cached in the instance of lockdep_map
+ *
+ * Currently main class (subclass == 0) and signle depth subclass
+ * are cached in lockdep_map. This optimization is mainly targeting
+ * on rq->lock. double_rq_lock() acquires this highly competitive with
+ * single depth.
+ */
+#define NR_LOCKDEP_CACHING_CLASSES	2
+
+/*
  * Lock-classes are keyed via unique addresses, by embedding the
  * lockclass-key into the kernel (or module) .data section. (For
  * static locks we use the lock address itself as the key.)
@@ -138,7 +149,7 @@ void clear_lock_stats(struct lock_class *class);
  */
 struct lockdep_map {
 	struct lock_class_key		*key;
-	struct lock_class		*class_cache;
+	struct lock_class		*class_cache[NR_LOCKDEP_CACHING_CLASSES];
 	const char			*name;
 #ifdef CONFIG_LOCK_STAT
 	int				cpu;
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 0c642d5..53ead17 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -98,7 +98,7 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
 	printk(KERN_ERR "\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
 			" disables this message.\n");
 	sched_show_task(t);
-	__debug_show_held_locks(t);
+	debug_show_held_locks(t);
 
 	touch_nmi_watchdog();
 
@@ -111,7 +111,7 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
  * periodically exit the critical section and enter a new one.
  *
  * For preemptible RCU it is sufficient to call rcu_read_unlock in order
- * exit the grace period. For classic RCU, a reschedule is required.
+ * to exit the grace period. For classic RCU, a reschedule is required.
  */
 static void rcu_lock_break(struct task_struct *g, struct task_struct *t)
 {
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index f2852a5..42ba65d 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -639,6 +639,16 @@ look_up_lock_class(struct lockdep_map *lock, unsigned int subclass)
 	}
 #endif
 
+	if (unlikely(subclass >= MAX_LOCKDEP_SUBCLASSES)) {
+		debug_locks_off();
+		printk(KERN_ERR
+			"BUG: looking up invalid subclass: %u\n", subclass);
+		printk(KERN_ERR
+			"turning off the locking correctness validator.\n");
+		dump_stack();
+		return NULL;
+	}
+
 	/*
 	 * Static locks do not have their class-keys yet - for them the key
 	 * is the lock object itself:
@@ -774,7 +784,9 @@ out_unlock_set:
 	raw_local_irq_restore(flags);
 
 	if (!subclass || force)
-		lock->class_cache = class;
+		lock->class_cache[0] = class;
+	else if (subclass < NR_LOCKDEP_CACHING_CLASSES)
+		lock->class_cache[subclass] = class;
 
 	if (DEBUG_LOCKS_WARN_ON(class->subclass != subclass))
 		return NULL;
@@ -2679,7 +2691,11 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 void lockdep_init_map(struct lockdep_map *lock, const char *name,
 		      struct lock_class_key *key, int subclass)
 {
-	lock->class_cache = NULL;
+	int i;
+
+	for (i = 0; i < NR_LOCKDEP_CACHING_CLASSES; i++)
+		lock->class_cache[i] = NULL;
+
 #ifdef CONFIG_LOCK_STAT
 	lock->cpu = raw_smp_processor_id();
 #endif
@@ -2739,21 +2755,13 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return 0;
 
-	if (unlikely(subclass >= MAX_LOCKDEP_SUBCLASSES)) {
-		debug_locks_off();
-		printk("BUG: MAX_LOCKDEP_SUBCLASSES too low!\n");
-		printk("turning off the locking correctness validator.\n");
-		dump_stack();
-		return 0;
-	}
-
 	if (lock->key == &__lockdep_no_validate__)
 		check = 1;
 
-	if (!subclass)
-		class = lock->class_cache;
+	if (subclass < NR_LOCKDEP_CACHING_CLASSES)
+		class = lock->class_cache[subclass];
 	/*
-	 * Not cached yet or subclass?
+	 * Not cached?
 	 */
 	if (unlikely(!class)) {
 		class = register_lock_class(lock, subclass, 0);
@@ -2918,7 +2926,7 @@ static int match_held_lock(struct held_lock *hlock, struct lockdep_map *lock)
 		return 1;
 
 	if (hlock->references) {
-		struct lock_class *class = lock->class_cache;
+		struct lock_class *class = lock->class_cache[0];
 
 		if (!class)
 			class = look_up_lock_class(lock, 0);
@@ -3559,7 +3567,12 @@ void lockdep_reset_lock(struct lockdep_map *lock)
 		if (list_empty(head))
 			continue;
 		list_for_each_entry_safe(class, next, head, hash_entry) {
-			if (unlikely(class == lock->class_cache)) {
+			int match = 0;
+
+			for (j = 0; j < NR_LOCKDEP_CACHING_CLASSES; j++)
+				match |= class == lock->class_cache[j];
+
+			if (unlikely(match)) {
 				if (debug_locks_off_graph_unlock())
 					WARN_ON(1);
 				goto out_restore;
@@ -3775,7 +3788,7 @@ EXPORT_SYMBOL_GPL(debug_show_all_locks);
  * Careful: only use this function if you are sure that
  * the task cannot run in parallel!
  */
-void __debug_show_held_locks(struct task_struct *task)
+void debug_show_held_locks(struct task_struct *task)
 {
 	if (unlikely(!debug_locks)) {
 		printk("INFO: lockdep is turned off.\n");
@@ -3783,12 +3796,6 @@ void __debug_show_held_locks(struct task_struct *task)
 	}
 	lockdep_print_held_locks(task);
 }
-EXPORT_SYMBOL_GPL(__debug_show_held_locks);
-
-void debug_show_held_locks(struct task_struct *task)
-{
-		__debug_show_held_locks(task);
-}
 EXPORT_SYMBOL_GPL(debug_show_held_locks);
 
 void lockdep_sys_exit(void)
diff --git a/kernel/printk.c b/kernel/printk.c
index 8fe465a..2531017 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -85,7 +85,7 @@ EXPORT_SYMBOL(oops_in_progress);
  * provides serialisation for access to the entire console
  * driver system.
  */
-static DECLARE_MUTEX(console_sem);
+static DEFINE_SEMAPHORE(console_sem);
 struct console *console_drivers;
 EXPORT_SYMBOL_GPL(console_drivers);
 
@@ -556,7 +556,7 @@ static void zap_locks(void)
 	/* If a crash is occurring, make sure we can't deadlock */
 	spin_lock_init(&logbuf_lock);
 	/* And make sure that we print immediately */
-	init_MUTEX(&console_sem);
+	sema_init(&console_sem, 1);
 }
 
 #if defined(CONFIG_PRINTK_TIME)
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 7f9c3c5..2feb287 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -209,7 +209,7 @@ static struct perf_event_attr wd_hw_attr = {
 };
 
 /* Callback function for perf event subsystem */
-void watchdog_overflow_callback(struct perf_event *event, int nmi,
+static void watchdog_overflow_callback(struct perf_event *event, int nmi,
 		 struct perf_sample_data *data,
 		 struct pt_regs *regs)
 {
4
