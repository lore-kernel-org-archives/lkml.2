Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab1HDUqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 16:46:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60826 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab1HDUqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 16:46:44 -0400
Date: Thu, 4 Aug 2011 22:45:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20110804204550.GA29523@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-urgent-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (4):
      lockdep: Fix trace_hardirqs_on_caller()
      lockdep: Fix up warning
      slab, lockdep: Annotate slab -> rcu -> debug_object -> slab
      slab, lockdep: Annotate the locks before using them

Shawn Bohrer (1):
      futex: Fix regression with read only mappings

Tejun Heo (1):
      lockdep: Clear whole lockdep_map on initialization


 kernel/futex.c   |   54 ++++++++++++++++++++++++-------
 kernel/lockdep.c |   37 ++++++++++-----------
 mm/slab.c        |   92 +++++++++++++++++++++++++++++++++++++++++------------
 3 files changed, 131 insertions(+), 52 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 0a30897..11cbe05 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -218,6 +218,8 @@ static void drop_futex_key_refs(union futex_key *key)
  * @uaddr:	virtual address of the futex
  * @fshared:	0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
  * @key:	address where result is stored.
+ * @rw:		mapping needs to be read/write (values: VERIFY_READ,
+ *              VERIFY_WRITE)
  *
  * Returns a negative error code or 0
  * The key words are stored in *key on success.
@@ -229,12 +231,12 @@ static void drop_futex_key_refs(union futex_key *key)
  * lock_page() might sleep, the caller should not hold a spinlock.
  */
 static int
-get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
+get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
 	struct page *page, *page_head;
-	int err;
+	int err, ro = 0;
 
 	/*
 	 * The futex address must be "naturally" aligned.
@@ -262,8 +264,18 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
 
 again:
 	err = get_user_pages_fast(address, 1, 1, &page);
+	/*
+	 * If write access is not required (eg. FUTEX_WAIT), try
+	 * and get read-only access.
+	 */
+	if (err == -EFAULT && rw == VERIFY_READ) {
+		err = get_user_pages_fast(address, 1, 0, &page);
+		ro = 1;
+	}
 	if (err < 0)
 		return err;
+	else
+		err = 0;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	page_head = page;
@@ -305,6 +317,13 @@ again:
 	if (!page_head->mapping) {
 		unlock_page(page_head);
 		put_page(page_head);
+		/*
+		* ZERO_PAGE pages don't have a mapping. Avoid a busy loop
+		* trying to find one. RW mapping would have COW'd (and thus
+		* have a mapping) so this page is RO and won't ever change.
+		*/
+		if ((page_head == ZERO_PAGE(address)))
+			return -EFAULT;
 		goto again;
 	}
 
@@ -316,6 +335,15 @@ again:
 	 * the object not the particular process.
 	 */
 	if (PageAnon(page_head)) {
+		/*
+		 * A RO anonymous page will never change and thus doesn't make
+		 * sense for futex operations.
+		 */
+		if (ro) {
+			err = -EFAULT;
+			goto out;
+		}
+
 		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
 		key->private.mm = mm;
 		key->private.address = address;
@@ -327,9 +355,10 @@ again:
 
 	get_futex_key_refs(key);
 
+out:
 	unlock_page(page_head);
 	put_page(page_head);
-	return 0;
+	return err;
 }
 
 static inline void put_futex_key(union futex_key *key)
@@ -940,7 +969,7 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 	if (!bitset)
 		return -EINVAL;
 
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key, VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -986,10 +1015,10 @@ futex_wake_op(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
 	int ret, op_ret;
 
 retry:
-	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1);
+	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1, VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
+	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out_put_key1;
 
@@ -1243,10 +1272,11 @@ retry:
 		pi_state = NULL;
 	}
 
-	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1);
+	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1, VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
+	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2,
+			    requeue_pi ? VERIFY_WRITE : VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out_put_key1;
 
@@ -1790,7 +1820,7 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
 	 * while the syscall executes.
 	 */
 retry:
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key, VERIFY_READ);
 	if (unlikely(ret != 0))
 		return ret;
 
@@ -1941,7 +1971,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags, int detect,
 	}
 
 retry:
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2060,7 +2090,7 @@ retry:
 	if ((uval & FUTEX_TID_MASK) != vpid)
 		return -EPERM;
 
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2249,7 +2279,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	debug_rt_mutex_init_waiter(&rt_waiter);
 	rt_waiter.task = NULL;
 
-	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
+	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out;
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 3956f51..8c24294 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2468,7 +2468,7 @@ mark_held_locks(struct task_struct *curr, enum mark_type mark)
 
 		BUG_ON(usage_bit >= LOCK_USAGE_STATES);
 
-		if (hlock_class(hlock)->key == &__lockdep_no_validate__)
+		if (hlock_class(hlock)->key == __lockdep_no_validate__.subkeys)
 			continue;
 
 		if (!mark_lock(curr, hlock, usage_bit))
@@ -2485,23 +2485,9 @@ static void __trace_hardirqs_on_caller(unsigned long ip)
 {
 	struct task_struct *curr = current;
 
-	if (DEBUG_LOCKS_WARN_ON(unlikely(early_boot_irqs_disabled)))
-		return;
-
-	if (unlikely(curr->hardirqs_enabled)) {
-		/*
-		 * Neither irq nor preemption are disabled here
-		 * so this is racy by nature but losing one hit
-		 * in a stat is not a big deal.
-		 */
-		__debug_atomic_inc(redundant_hardirqs_on);
-		return;
-	}
 	/* we'll do an OFF -> ON transition: */
 	curr->hardirqs_enabled = 1;
 
-	if (DEBUG_LOCKS_WARN_ON(current->hardirq_context))
-		return;
 	/*
 	 * We are going to turn hardirqs on, so set the
 	 * usage bit for all held locks:
@@ -2529,9 +2515,25 @@ void trace_hardirqs_on_caller(unsigned long ip)
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
 
+	if (unlikely(current->hardirqs_enabled)) {
+		/*
+		 * Neither irq nor preemption are disabled here
+		 * so this is racy by nature but losing one hit
+		 * in a stat is not a big deal.
+		 */
+		__debug_atomic_inc(redundant_hardirqs_on);
+		return;
+	}
+
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return;
 
+	if (DEBUG_LOCKS_WARN_ON(unlikely(early_boot_irqs_disabled)))
+		return;
+
+	if (DEBUG_LOCKS_WARN_ON(current->hardirq_context))
+		return;
+
 	current->lockdep_recursion = 1;
 	__trace_hardirqs_on_caller(ip);
 	current->lockdep_recursion = 0;
@@ -2872,10 +2874,7 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 void lockdep_init_map(struct lockdep_map *lock, const char *name,
 		      struct lock_class_key *key, int subclass)
 {
-	int i;
-
-	for (i = 0; i < NR_LOCKDEP_CACHING_CLASSES; i++)
-		lock->class_cache[i] = NULL;
+	memset(lock, 0, sizeof(*lock));
 
 #ifdef CONFIG_LOCK_STAT
 	lock->cpu = raw_smp_processor_id();
diff --git a/mm/slab.c b/mm/slab.c
index 9594740..6d90a09 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -622,6 +622,51 @@ int slab_is_available(void)
 static struct lock_class_key on_slab_l3_key;
 static struct lock_class_key on_slab_alc_key;
 
+static struct lock_class_key debugobj_l3_key;
+static struct lock_class_key debugobj_alc_key;
+
+static void slab_set_lock_classes(struct kmem_cache *cachep,
+		struct lock_class_key *l3_key, struct lock_class_key *alc_key,
+		int q)
+{
+	struct array_cache **alc;
+	struct kmem_list3 *l3;
+	int r;
+
+	l3 = cachep->nodelists[q];
+	if (!l3)
+		return;
+
+	lockdep_set_class(&l3->list_lock, l3_key);
+	alc = l3->alien;
+	/*
+	 * FIXME: This check for BAD_ALIEN_MAGIC
+	 * should go away when common slab code is taught to
+	 * work even without alien caches.
+	 * Currently, non NUMA code returns BAD_ALIEN_MAGIC
+	 * for alloc_alien_cache,
+	 */
+	if (!alc || (unsigned long)alc == BAD_ALIEN_MAGIC)
+		return;
+	for_each_node(r) {
+		if (alc[r])
+			lockdep_set_class(&alc[r]->lock, alc_key);
+	}
+}
+
+static void slab_set_debugobj_lock_classes_node(struct kmem_cache *cachep, int node)
+{
+	slab_set_lock_classes(cachep, &debugobj_l3_key, &debugobj_alc_key, node);
+}
+
+static void slab_set_debugobj_lock_classes(struct kmem_cache *cachep)
+{
+	int node;
+
+	for_each_online_node(node)
+		slab_set_debugobj_lock_classes_node(cachep, node);
+}
+
 static void init_node_lock_keys(int q)
 {
 	struct cache_sizes *s = malloc_sizes;
@@ -630,29 +675,14 @@ static void init_node_lock_keys(int q)
 		return;
 
 	for (s = malloc_sizes; s->cs_size != ULONG_MAX; s++) {
-		struct array_cache **alc;
 		struct kmem_list3 *l3;
-		int r;
 
 		l3 = s->cs_cachep->nodelists[q];
 		if (!l3 || OFF_SLAB(s->cs_cachep))
 			continue;
-		lockdep_set_class(&l3->list_lock, &on_slab_l3_key);
-		alc = l3->alien;
-		/*
-		 * FIXME: This check for BAD_ALIEN_MAGIC
-		 * should go away when common slab code is taught to
-		 * work even without alien caches.
-		 * Currently, non NUMA code returns BAD_ALIEN_MAGIC
-		 * for alloc_alien_cache,
-		 */
-		if (!alc || (unsigned long)alc == BAD_ALIEN_MAGIC)
-			continue;
-		for_each_node(r) {
-			if (alc[r])
-				lockdep_set_class(&alc[r]->lock,
-					&on_slab_alc_key);
-		}
+
+		slab_set_lock_classes(s->cs_cachep, &on_slab_l3_key,
+				&on_slab_alc_key, q);
 	}
 }
 
@@ -671,6 +701,14 @@ static void init_node_lock_keys(int q)
 static inline void init_lock_keys(void)
 {
 }
+
+static void slab_set_debugobj_lock_classes_node(struct kmem_cache *cachep, int node)
+{
+}
+
+static void slab_set_debugobj_lock_classes(struct kmem_cache *cachep)
+{
+}
 #endif
 
 /*
@@ -1264,6 +1302,8 @@ static int __cpuinit cpuup_prepare(long cpu)
 		spin_unlock_irq(&l3->list_lock);
 		kfree(shared);
 		free_alien_cache(alien);
+		if (cachep->flags & SLAB_DEBUG_OBJECTS)
+			slab_set_debugobj_lock_classes_node(cachep, node);
 	}
 	init_node_lock_keys(node);
 
@@ -1626,6 +1666,9 @@ void __init kmem_cache_init_late(void)
 {
 	struct kmem_cache *cachep;
 
+	/* Annotate slab for lockdep -- annotate the malloc caches */
+	init_lock_keys();
+
 	/* 6) resize the head arrays to their final sizes */
 	mutex_lock(&cache_chain_mutex);
 	list_for_each_entry(cachep, &cache_chain, next)
@@ -1636,9 +1679,6 @@ void __init kmem_cache_init_late(void)
 	/* Done! */
 	g_cpucache_up = FULL;
 
-	/* Annotate slab for lockdep -- annotate the malloc caches */
-	init_lock_keys();
-
 	/*
 	 * Register a cpu startup notifier callback that initializes
 	 * cpu_cache_get for all new cpus
@@ -2426,6 +2466,16 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 		goto oops;
 	}
 
+	if (flags & SLAB_DEBUG_OBJECTS) {
+		/*
+		 * Would deadlock through slab_destroy()->call_rcu()->
+		 * debug_object_activate()->kmem_cache_alloc().
+		 */
+		WARN_ON_ONCE(flags & SLAB_DESTROY_BY_RCU);
+
+		slab_set_debugobj_lock_classes(cachep);
+	}
+
 	/* cache setup completed, link it into the list */
 	list_add(&cachep->next, &cache_chain);
 oops:
