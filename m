Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab1COJeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:34:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412Ab1COJeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:34:02 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 01/15] GFS2: Use RCU for glock hash table
Date: Tue, 15 Mar 2011 09:11:31 +0000
Message-Id: <1300180305-5993-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
References: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has a number of advantages:

 - Reduces contention on the hash table lock
 - Makes the code smaller and simpler
 - Should speed up glock dumps when under load
 - Removes ref count changing in examine_bucket
 - No longer need hash chain lock in glock_put() in common case

There are some further changes which this enables and which
we may do in the future. One is to look at using SLAB_RCU,
and another is to look at using a per-cpu counter for the
per-sb glock counter, since that is touched twice in the
lifetime of each glock (but only used at umount time).

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 08a8beb..c75d499 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -26,6 +26,9 @@
 #include <linux/freezer.h>
 #include <linux/workqueue.h>
 #include <linux/jiffies.h>
+#include <linux/rcupdate.h>
+#include <linux/rculist_bl.h>
+#include <linux/bit_spinlock.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -41,10 +44,6 @@
 #define CREATE_TRACE_POINTS
 #include "trace_gfs2.h"
 
-struct gfs2_gl_hash_bucket {
-        struct hlist_head hb_list;
-};
-
 struct gfs2_glock_iter {
 	int hash;			/* hash bucket index         */
 	struct gfs2_sbd *sdp;		/* incore superblock         */
@@ -54,7 +53,6 @@ struct gfs2_glock_iter {
 
 typedef void (*glock_examiner) (struct gfs2_glock * gl);
 
-static int gfs2_dump_lockstate(struct gfs2_sbd *sdp);
 static int __dump_glock(struct seq_file *seq, const struct gfs2_glock *gl);
 #define GLOCK_BUG_ON(gl,x) do { if (unlikely(x)) { __dump_glock(NULL, gl); BUG(); } } while(0)
 static void do_xmote(struct gfs2_glock *gl, struct gfs2_holder *gh, unsigned int target);
@@ -70,57 +68,9 @@ static DEFINE_SPINLOCK(lru_lock);
 #define GFS2_GL_HASH_SIZE       (1 << GFS2_GL_HASH_SHIFT)
 #define GFS2_GL_HASH_MASK       (GFS2_GL_HASH_SIZE - 1)
 
-static struct gfs2_gl_hash_bucket gl_hash_table[GFS2_GL_HASH_SIZE];
+static struct hlist_bl_head gl_hash_table[GFS2_GL_HASH_SIZE];
 static struct dentry *gfs2_root;
 
-/*
- * Despite what you might think, the numbers below are not arbitrary :-)
- * They are taken from the ipv4 routing hash code, which is well tested
- * and thus should be nearly optimal. Later on we might tweek the numbers
- * but for now this should be fine.
- *
- * The reason for putting the locks in a separate array from the list heads
- * is that we can have fewer locks than list heads and save memory. We use
- * the same hash function for both, but with a different hash mask.
- */
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK) || \
-	defined(CONFIG_PROVE_LOCKING)
-
-#ifdef CONFIG_LOCKDEP
-# define GL_HASH_LOCK_SZ        256
-#else
-# if NR_CPUS >= 32
-#  define GL_HASH_LOCK_SZ       4096
-# elif NR_CPUS >= 16
-#  define GL_HASH_LOCK_SZ       2048
-# elif NR_CPUS >= 8
-#  define GL_HASH_LOCK_SZ       1024
-# elif NR_CPUS >= 4
-#  define GL_HASH_LOCK_SZ       512
-# else
-#  define GL_HASH_LOCK_SZ       256
-# endif
-#endif
-
-/* We never want more locks than chains */
-#if GFS2_GL_HASH_SIZE < GL_HASH_LOCK_SZ
-# undef GL_HASH_LOCK_SZ
-# define GL_HASH_LOCK_SZ GFS2_GL_HASH_SIZE
-#endif
-
-static rwlock_t gl_hash_locks[GL_HASH_LOCK_SZ];
-
-static inline rwlock_t *gl_lock_addr(unsigned int x)
-{
-	return &gl_hash_locks[x & (GL_HASH_LOCK_SZ-1)];
-}
-#else /* not SMP, so no spinlocks required */
-static inline rwlock_t *gl_lock_addr(unsigned int x)
-{
-	return NULL;
-}
-#endif
-
 /**
  * gl_hash() - Turn glock number into hash bucket number
  * @lock: The glock number
@@ -141,25 +91,30 @@ static unsigned int gl_hash(const struct gfs2_sbd *sdp,
 	return h;
 }
 
-/**
- * glock_free() - Perform a few checks and then release struct gfs2_glock
- * @gl: The glock to release
- *
- * Also calls lock module to release its internal structure for this glock.
- *
- */
+static inline void spin_lock_bucket(unsigned int hash)
+{
+	struct hlist_bl_head *bl = &gl_hash_table[hash];
+	bit_spin_lock(0, (unsigned long *)bl);
+}
+
+static inline void spin_unlock_bucket(unsigned int hash)
+{
+	struct hlist_bl_head *bl = &gl_hash_table[hash];
+	__bit_spin_unlock(0, (unsigned long *)bl);
+}
 
-static void glock_free(struct gfs2_glock *gl)
+void gfs2_glock_free(struct rcu_head *rcu)
 {
+	struct gfs2_glock *gl = container_of(rcu, struct gfs2_glock, gl_rcu);
 	struct gfs2_sbd *sdp = gl->gl_sbd;
-	struct address_space *mapping = gfs2_glock2aspace(gl);
-	struct kmem_cache *cachep = gfs2_glock_cachep;
 
-	GLOCK_BUG_ON(gl, mapping && mapping->nrpages);
-	trace_gfs2_glock_put(gl);
-	if (mapping)
-		cachep = gfs2_glock_aspace_cachep;
-	sdp->sd_lockstruct.ls_ops->lm_put_lock(cachep, gl);
+	if (gl->gl_ops->go_flags & GLOF_ASPACE)
+		kmem_cache_free(gfs2_glock_aspace_cachep, gl);
+	else
+		kmem_cache_free(gfs2_glock_cachep, gl);
+
+	if (atomic_dec_and_test(&sdp->sd_glock_disposal))
+		wake_up(&sdp->sd_glock_wait);
 }
 
 /**
@@ -185,34 +140,49 @@ static int demote_ok(const struct gfs2_glock *gl)
 {
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 
+	/* assert_spin_locked(&gl->gl_spin); */
+
 	if (gl->gl_state == LM_ST_UNLOCKED)
 		return 0;
-	if (!list_empty(&gl->gl_holders))
+	if (test_bit(GLF_LFLUSH, &gl->gl_flags))
+		return 0;
+	if ((gl->gl_name.ln_type != LM_TYPE_INODE) &&
+	    !list_empty(&gl->gl_holders))
 		return 0;
 	if (glops->go_demote_ok)
 		return glops->go_demote_ok(gl);
 	return 1;
 }
 
+
 /**
- * gfs2_glock_schedule_for_reclaim - Add a glock to the reclaim list
+ * __gfs2_glock_schedule_for_reclaim - Add a glock to the reclaim list
  * @gl: the glock
  *
+ * If the glock is demotable, then we add it (or move it) to the end
+ * of the glock LRU list.
  */
 
-static void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl)
+static void __gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl)
 {
-	int may_reclaim;
-	may_reclaim = (demote_ok(gl) &&
-		       (atomic_read(&gl->gl_ref) == 1 ||
-			(gl->gl_name.ln_type == LM_TYPE_INODE &&
-			 atomic_read(&gl->gl_ref) <= 2)));
-	spin_lock(&lru_lock);
-	if (list_empty(&gl->gl_lru) && may_reclaim) {
+	if (demote_ok(gl)) {
+		spin_lock(&lru_lock);
+
+		if (!list_empty(&gl->gl_lru))
+			list_del_init(&gl->gl_lru);
+		else
+			atomic_inc(&lru_count);
+
 		list_add_tail(&gl->gl_lru, &lru_list);
-		atomic_inc(&lru_count);
+		spin_unlock(&lru_lock);
 	}
-	spin_unlock(&lru_lock);
+}
+
+void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl)
+{
+	spin_lock(&gl->gl_spin);
+	__gfs2_glock_schedule_for_reclaim(gl);
+	spin_unlock(&gl->gl_spin);
 }
 
 /**
@@ -227,7 +197,6 @@ void gfs2_glock_put_nolock(struct gfs2_glock *gl)
 {
 	if (atomic_dec_and_test(&gl->gl_ref))
 		GLOCK_BUG_ON(gl, 1);
-	gfs2_glock_schedule_for_reclaim(gl);
 }
 
 /**
@@ -236,30 +205,26 @@ void gfs2_glock_put_nolock(struct gfs2_glock *gl)
  *
  */
 
-int gfs2_glock_put(struct gfs2_glock *gl)
+void gfs2_glock_put(struct gfs2_glock *gl)
 {
-	int rv = 0;
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+	struct address_space *mapping = gfs2_glock2aspace(gl);
 
-	write_lock(gl_lock_addr(gl->gl_hash));
-	if (atomic_dec_and_lock(&gl->gl_ref, &lru_lock)) {
-		hlist_del(&gl->gl_list);
+	if (atomic_dec_and_test(&gl->gl_ref)) {
+		spin_lock_bucket(gl->gl_hash);
+		hlist_bl_del_rcu(&gl->gl_list);
+		spin_unlock_bucket(gl->gl_hash);
+		spin_lock(&lru_lock);
 		if (!list_empty(&gl->gl_lru)) {
 			list_del_init(&gl->gl_lru);
 			atomic_dec(&lru_count);
 		}
 		spin_unlock(&lru_lock);
-		write_unlock(gl_lock_addr(gl->gl_hash));
 		GLOCK_BUG_ON(gl, !list_empty(&gl->gl_holders));
-		glock_free(gl);
-		rv = 1;
-		goto out;
+		GLOCK_BUG_ON(gl, mapping && mapping->nrpages);
+		trace_gfs2_glock_put(gl);
+		sdp->sd_lockstruct.ls_ops->lm_put_lock(gl);
 	}
-	spin_lock(&gl->gl_spin);
-	gfs2_glock_schedule_for_reclaim(gl);
-	spin_unlock(&gl->gl_spin);
-	write_unlock(gl_lock_addr(gl->gl_hash));
-out:
-	return rv;
 }
 
 /**
@@ -275,17 +240,15 @@ static struct gfs2_glock *search_bucket(unsigned int hash,
 					const struct lm_lockname *name)
 {
 	struct gfs2_glock *gl;
-	struct hlist_node *h;
+	struct hlist_bl_node *h;
 
-	hlist_for_each_entry(gl, h, &gl_hash_table[hash].hb_list, gl_list) {
+	hlist_bl_for_each_entry_rcu(gl, h, &gl_hash_table[hash], gl_list) {
 		if (!lm_name_equal(&gl->gl_name, name))
 			continue;
 		if (gl->gl_sbd != sdp)
 			continue;
-
-		atomic_inc(&gl->gl_ref);
-
-		return gl;
+		if (atomic_inc_not_zero(&gl->gl_ref))
+			return gl;
 	}
 
 	return NULL;
@@ -743,10 +706,11 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	struct gfs2_glock *gl, *tmp;
 	unsigned int hash = gl_hash(sdp, &name);
 	struct address_space *mapping;
+	struct kmem_cache *cachep;
 
-	read_lock(gl_lock_addr(hash));
+	rcu_read_lock();
 	gl = search_bucket(hash, sdp, &name);
-	read_unlock(gl_lock_addr(hash));
+	rcu_read_unlock();
 
 	*glp = gl;
 	if (gl)
@@ -755,9 +719,10 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 		return -ENOENT;
 
 	if (glops->go_flags & GLOF_ASPACE)
-		gl = kmem_cache_alloc(gfs2_glock_aspace_cachep, GFP_KERNEL);
+		cachep = gfs2_glock_aspace_cachep;
 	else
-		gl = kmem_cache_alloc(gfs2_glock_cachep, GFP_KERNEL);
+		cachep = gfs2_glock_cachep;
+	gl = kmem_cache_alloc(cachep, GFP_KERNEL);
 	if (!gl)
 		return -ENOMEM;
 
@@ -790,15 +755,15 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 		mapping->writeback_index = 0;
 	}
 
-	write_lock(gl_lock_addr(hash));
+	spin_lock_bucket(hash);
 	tmp = search_bucket(hash, sdp, &name);
 	if (tmp) {
-		write_unlock(gl_lock_addr(hash));
-		glock_free(gl);
+		spin_unlock_bucket(hash);
+		kmem_cache_free(cachep, gl);
 		gl = tmp;
 	} else {
-		hlist_add_head(&gl->gl_list, &gl_hash_table[hash].hb_list);
-		write_unlock(gl_lock_addr(hash));
+		hlist_bl_add_head_rcu(&gl->gl_list, &gl_hash_table[hash]);
+		spin_unlock_bucket(hash);
 	}
 
 	*glp = gl;
@@ -1113,6 +1078,7 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 		    !test_bit(GLF_DEMOTE, &gl->gl_flags))
 			fast_path = 1;
 	}
+	__gfs2_glock_schedule_for_reclaim(gl);
 	trace_gfs2_glock_queue(gh, 0);
 	spin_unlock(&gl->gl_spin);
 	if (likely(fast_path))
@@ -1440,42 +1406,30 @@ static struct shrinker glock_shrinker = {
  * @sdp: the filesystem
  * @bucket: the bucket
  *
- * Returns: 1 if the bucket has entries
  */
 
-static int examine_bucket(glock_examiner examiner, struct gfs2_sbd *sdp,
+static void examine_bucket(glock_examiner examiner, const struct gfs2_sbd *sdp,
 			  unsigned int hash)
 {
-	struct gfs2_glock *gl, *prev = NULL;
-	int has_entries = 0;
-	struct hlist_head *head = &gl_hash_table[hash].hb_list;
+	struct gfs2_glock *gl;
+	struct hlist_bl_head *head = &gl_hash_table[hash];
+	struct hlist_bl_node *pos;
 
-	read_lock(gl_lock_addr(hash));
-	/* Can't use hlist_for_each_entry - don't want prefetch here */
-	if (hlist_empty(head))
-		goto out;
-	gl = list_entry(head->first, struct gfs2_glock, gl_list);
-	while(1) {
-		if (!sdp || gl->gl_sbd == sdp) {
-			gfs2_glock_hold(gl);
-			read_unlock(gl_lock_addr(hash));
-			if (prev)
-				gfs2_glock_put(prev);
-			prev = gl;
+	rcu_read_lock();
+	hlist_bl_for_each_entry_rcu(gl, pos, head, gl_list) {
+		if ((gl->gl_sbd == sdp) && atomic_read(&gl->gl_ref))
 			examiner(gl);
-			has_entries = 1;
-			read_lock(gl_lock_addr(hash));
-		}
-		if (gl->gl_list.next == NULL)
-			break;
-		gl = list_entry(gl->gl_list.next, struct gfs2_glock, gl_list);
 	}
-out:
-	read_unlock(gl_lock_addr(hash));
-	if (prev)
-		gfs2_glock_put(prev);
+	rcu_read_unlock();
 	cond_resched();
-	return has_entries;
+}
+
+static void glock_hash_walk(glock_examiner examiner, const struct gfs2_sbd *sdp)
+{
+	unsigned x;
+
+	for (x = 0; x < GFS2_GL_HASH_SIZE; x++)
+		examine_bucket(examiner, sdp, x);
 }
 
 
@@ -1529,10 +1483,21 @@ static void clear_glock(struct gfs2_glock *gl)
 
 void gfs2_glock_thaw(struct gfs2_sbd *sdp)
 {
-	unsigned x;
+	glock_hash_walk(thaw_glock, sdp);
+}
 
-	for (x = 0; x < GFS2_GL_HASH_SIZE; x++)
-		examine_bucket(thaw_glock, sdp, x);
+static int dump_glock(struct seq_file *seq, struct gfs2_glock *gl)
+{
+	int ret;
+	spin_lock(&gl->gl_spin);
+	ret = __dump_glock(seq, gl);
+	spin_unlock(&gl->gl_spin);
+	return ret;
+}
+
+static void dump_glock_func(struct gfs2_glock *gl)
+{
+	dump_glock(NULL, gl);
 }
 
 /**
@@ -1545,13 +1510,10 @@ void gfs2_glock_thaw(struct gfs2_sbd *sdp)
 
 void gfs2_gl_hash_clear(struct gfs2_sbd *sdp)
 {
-	unsigned int x;
-
-	for (x = 0; x < GFS2_GL_HASH_SIZE; x++)
-		examine_bucket(clear_glock, sdp, x);
+	glock_hash_walk(clear_glock, sdp);
 	flush_workqueue(glock_workqueue);
 	wait_event(sdp->sd_glock_wait, atomic_read(&sdp->sd_glock_disposal) == 0);
-	gfs2_dump_lockstate(sdp);
+	glock_hash_walk(dump_glock_func, sdp);
 }
 
 void gfs2_glock_finish_truncate(struct gfs2_inode *ip)
@@ -1717,66 +1679,15 @@ out:
 	return error;
 }
 
-static int dump_glock(struct seq_file *seq, struct gfs2_glock *gl)
-{
-	int ret;
-	spin_lock(&gl->gl_spin);
-	ret = __dump_glock(seq, gl);
-	spin_unlock(&gl->gl_spin);
-	return ret;
-}
-
-/**
- * gfs2_dump_lockstate - print out the current lockstate
- * @sdp: the filesystem
- * @ub: the buffer to copy the information into
- *
- * If @ub is NULL, dump the lockstate to the console.
- *
- */
-
-static int gfs2_dump_lockstate(struct gfs2_sbd *sdp)
-{
-	struct gfs2_glock *gl;
-	struct hlist_node *h;
-	unsigned int x;
-	int error = 0;
-
-	for (x = 0; x < GFS2_GL_HASH_SIZE; x++) {
-
-		read_lock(gl_lock_addr(x));
-
-		hlist_for_each_entry(gl, h, &gl_hash_table[x].hb_list, gl_list) {
-			if (gl->gl_sbd != sdp)
-				continue;
-
-			error = dump_glock(NULL, gl);
-			if (error)
-				break;
-		}
-
-		read_unlock(gl_lock_addr(x));
-
-		if (error)
-			break;
-	}
-
 
-	return error;
-}
 
 
 int __init gfs2_glock_init(void)
 {
 	unsigned i;
 	for(i = 0; i < GFS2_GL_HASH_SIZE; i++) {
-		INIT_HLIST_HEAD(&gl_hash_table[i].hb_list);
-	}
-#ifdef GL_HASH_LOCK_SZ
-	for(i = 0; i < GL_HASH_LOCK_SZ; i++) {
-		rwlock_init(&gl_hash_locks[i]);
+		INIT_HLIST_BL_HEAD(&gl_hash_table[i]);
 	}
-#endif
 
 	glock_workqueue = alloc_workqueue("glock_workqueue", WQ_MEM_RECLAIM |
 					  WQ_HIGHPRI | WQ_FREEZEABLE, 0);
@@ -1802,62 +1713,54 @@ void gfs2_glock_exit(void)
 	destroy_workqueue(gfs2_delete_workqueue);
 }
 
+static inline struct gfs2_glock *glock_hash_chain(unsigned hash)
+{
+	return hlist_bl_entry(hlist_bl_first_rcu(&gl_hash_table[hash]),
+			      struct gfs2_glock, gl_list);
+}
+
+static inline struct gfs2_glock *glock_hash_next(struct gfs2_glock *gl)
+{
+	return hlist_bl_entry(rcu_dereference_raw(gl->gl_list.next),
+			      struct gfs2_glock, gl_list);
+}
+
 static int gfs2_glock_iter_next(struct gfs2_glock_iter *gi)
 {
 	struct gfs2_glock *gl;
 
-restart:
-	read_lock(gl_lock_addr(gi->hash));
-	gl = gi->gl;
-	if (gl) {
-		gi->gl = hlist_entry(gl->gl_list.next,
-				     struct gfs2_glock, gl_list);
-	} else {
-		gi->gl = hlist_entry(gl_hash_table[gi->hash].hb_list.first,
-				     struct gfs2_glock, gl_list);
-	}
-	if (gi->gl)
-		gfs2_glock_hold(gi->gl);
-	read_unlock(gl_lock_addr(gi->hash));
-	if (gl)
-		gfs2_glock_put(gl);
-	while (gi->gl == NULL) {
-		gi->hash++;
-		if (gi->hash >= GFS2_GL_HASH_SIZE)
-			return 1;
-		read_lock(gl_lock_addr(gi->hash));
-		gi->gl = hlist_entry(gl_hash_table[gi->hash].hb_list.first,
-				     struct gfs2_glock, gl_list);
-		if (gi->gl)
-			gfs2_glock_hold(gi->gl);
-		read_unlock(gl_lock_addr(gi->hash));
-	}
-
-	if (gi->sdp != gi->gl->gl_sbd)
-		goto restart;
+	do {
+		gl = gi->gl;
+		if (gl) {
+			gi->gl = glock_hash_next(gl);
+		} else {
+			gi->gl = glock_hash_chain(gi->hash);
+		}
+		while (gi->gl == NULL) {
+			gi->hash++;
+			if (gi->hash >= GFS2_GL_HASH_SIZE) {
+				rcu_read_unlock();
+				return 1;
+			}
+			gi->gl = glock_hash_chain(gi->hash);
+		}
+	/* Skip entries for other sb and dead entries */
+	} while (gi->sdp != gi->gl->gl_sbd || atomic_read(&gi->gl->gl_ref) == 0);
 
 	return 0;
 }
 
-static void gfs2_glock_iter_free(struct gfs2_glock_iter *gi)
-{
-	if (gi->gl)
-		gfs2_glock_put(gi->gl);
-	gi->gl = NULL;
-}
-
 static void *gfs2_glock_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct gfs2_glock_iter *gi = seq->private;
 	loff_t n = *pos;
 
 	gi->hash = 0;
+	rcu_read_lock();
 
 	do {
-		if (gfs2_glock_iter_next(gi)) {
-			gfs2_glock_iter_free(gi);
+		if (gfs2_glock_iter_next(gi))
 			return NULL;
-		}
 	} while (n--);
 
 	return gi->gl;
@@ -1870,10 +1773,8 @@ static void *gfs2_glock_seq_next(struct seq_file *seq, void *iter_ptr,
 
 	(*pos)++;
 
-	if (gfs2_glock_iter_next(gi)) {
-		gfs2_glock_iter_free(gi);
+	if (gfs2_glock_iter_next(gi))
 		return NULL;
-	}
 
 	return gi->gl;
 }
@@ -1881,7 +1782,10 @@ static void *gfs2_glock_seq_next(struct seq_file *seq, void *iter_ptr,
 static void gfs2_glock_seq_stop(struct seq_file *seq, void *iter_ptr)
 {
 	struct gfs2_glock_iter *gi = seq->private;
-	gfs2_glock_iter_free(gi);
+
+	if (gi->gl)
+		rcu_read_unlock();
+	gi->gl = NULL;
 }
 
 static int gfs2_glock_seq_show(struct seq_file *seq, void *iter_ptr)
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 691851c..afa8bfe 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -118,7 +118,7 @@ struct lm_lockops {
 	int (*lm_mount) (struct gfs2_sbd *sdp, const char *fsname);
  	void (*lm_unmount) (struct gfs2_sbd *sdp);
 	void (*lm_withdraw) (struct gfs2_sbd *sdp);
-	void (*lm_put_lock) (struct kmem_cache *cachep, struct gfs2_glock *gl);
+	void (*lm_put_lock) (struct gfs2_glock *gl);
 	int (*lm_lock) (struct gfs2_glock *gl, unsigned int req_state,
 			unsigned int flags);
 	void (*lm_cancel) (struct gfs2_glock *gl);
@@ -174,7 +174,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp,
 		   int create, struct gfs2_glock **glp);
 void gfs2_glock_hold(struct gfs2_glock *gl);
 void gfs2_glock_put_nolock(struct gfs2_glock *gl);
-int gfs2_glock_put(struct gfs2_glock *gl);
+void gfs2_glock_put(struct gfs2_glock *gl);
 void gfs2_holder_init(struct gfs2_glock *gl, unsigned int state, unsigned flags,
 		      struct gfs2_holder *gh);
 void gfs2_holder_reinit(unsigned int state, unsigned flags,
@@ -223,25 +223,22 @@ static inline int gfs2_glock_nq_init(struct gfs2_glock *gl,
 	return error;
 }
 
-/*  Lock Value Block functions  */
-
-int gfs2_lvb_hold(struct gfs2_glock *gl);
-void gfs2_lvb_unhold(struct gfs2_glock *gl);
-
-void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state);
-void gfs2_glock_complete(struct gfs2_glock *gl, int ret);
-void gfs2_reclaim_glock(struct gfs2_sbd *sdp);
-void gfs2_gl_hash_clear(struct gfs2_sbd *sdp);
-void gfs2_glock_finish_truncate(struct gfs2_inode *ip);
-void gfs2_glock_thaw(struct gfs2_sbd *sdp);
-
-int __init gfs2_glock_init(void);
-void gfs2_glock_exit(void);
-
-int gfs2_create_debugfs_file(struct gfs2_sbd *sdp);
-void gfs2_delete_debugfs_file(struct gfs2_sbd *sdp);
-int gfs2_register_debugfs(void);
-void gfs2_unregister_debugfs(void);
+extern void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state);
+extern void gfs2_glock_complete(struct gfs2_glock *gl, int ret);
+extern void gfs2_reclaim_glock(struct gfs2_sbd *sdp);
+extern void gfs2_gl_hash_clear(struct gfs2_sbd *sdp);
+extern void gfs2_glock_finish_truncate(struct gfs2_inode *ip);
+extern void gfs2_glock_thaw(struct gfs2_sbd *sdp);
+extern void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl);
+extern void gfs2_glock_free(struct rcu_head *rcu);
+
+extern int __init gfs2_glock_init(void);
+extern void gfs2_glock_exit(void);
+
+extern int gfs2_create_debugfs_file(struct gfs2_sbd *sdp);
+extern void gfs2_delete_debugfs_file(struct gfs2_sbd *sdp);
+extern int gfs2_register_debugfs(void);
+extern void gfs2_unregister_debugfs(void);
 
 extern const struct lm_lockops gfs2_dlm_ops;
 
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 263561b..ac5fac9 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -206,8 +206,17 @@ static void inode_go_inval(struct gfs2_glock *gl, int flags)
 static int inode_go_demote_ok(const struct gfs2_glock *gl)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
+	struct gfs2_holder *gh;
+
 	if (sdp->sd_jindex == gl->gl_object || sdp->sd_rindex == gl->gl_object)
 		return 0;
+
+	if (!list_empty(&gl->gl_holders)) {
+		gh = list_entry(gl->gl_holders.next, struct gfs2_holder, gh_list);
+		if (gh->gh_list.next != &gl->gl_holders)
+			return 0;
+	}
+
 	return 1;
 }
 
@@ -272,19 +281,6 @@ static int inode_go_dump(struct seq_file *seq, const struct gfs2_glock *gl)
 }
 
 /**
- * rgrp_go_demote_ok - Check to see if it's ok to unlock a RG's glock
- * @gl: the glock
- *
- * Returns: 1 if it's ok
- */
-
-static int rgrp_go_demote_ok(const struct gfs2_glock *gl)
-{
-	const struct address_space *mapping = (const struct address_space *)(gl + 1);
-	return !mapping->nrpages;
-}
-
-/**
  * rgrp_go_lock - operation done after an rgrp lock is locked by
  *    a first holder on this node.
  * @gl: the glock
@@ -410,7 +406,6 @@ const struct gfs2_glock_operations gfs2_inode_glops = {
 const struct gfs2_glock_operations gfs2_rgrp_glops = {
 	.go_xmote_th = rgrp_go_sync,
 	.go_inval = rgrp_go_inval,
-	.go_demote_ok = rgrp_go_demote_ok,
 	.go_lock = rgrp_go_lock,
 	.go_unlock = rgrp_go_unlock,
 	.go_dump = gfs2_rgrp_dump,
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index a79790c..720c1e6 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -15,6 +15,8 @@
 #include <linux/workqueue.h>
 #include <linux/dlm.h>
 #include <linux/buffer_head.h>
+#include <linux/rcupdate.h>
+#include <linux/rculist_bl.h>
 
 #define DIO_WAIT	0x00000010
 #define DIO_METADATA	0x00000020
@@ -201,7 +203,7 @@ enum {
 };
 
 struct gfs2_glock {
-	struct hlist_node gl_list;
+	struct hlist_bl_node gl_list;
 	unsigned long gl_flags;		/* GLF_... */
 	struct lm_lockname gl_name;
 	atomic_t gl_ref;
@@ -234,6 +236,7 @@ struct gfs2_glock {
 	atomic_t gl_ail_count;
 	struct delayed_work gl_work;
 	struct work_struct gl_delete;
+	struct rcu_head gl_rcu;
 };
 
 #define GFS2_MIN_LVB_SIZE 32	/* Min size of LVB that gfs2 supports */
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 6e493ae..c80485c 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -22,7 +22,6 @@ static void gdlm_ast(void *arg)
 {
 	struct gfs2_glock *gl = arg;
 	unsigned ret = gl->gl_state;
-	struct gfs2_sbd *sdp = gl->gl_sbd;
 
 	BUG_ON(gl->gl_lksb.sb_flags & DLM_SBF_DEMOTED);
 
@@ -31,12 +30,7 @@ static void gdlm_ast(void *arg)
 
 	switch (gl->gl_lksb.sb_status) {
 	case -DLM_EUNLOCK: /* Unlocked, so glock can be freed */
-		if (gl->gl_ops->go_flags & GLOF_ASPACE)
-			kmem_cache_free(gfs2_glock_aspace_cachep, gl);
-		else
-			kmem_cache_free(gfs2_glock_cachep, gl);
-		if (atomic_dec_and_test(&sdp->sd_glock_disposal))
-			wake_up(&sdp->sd_glock_wait);
+		call_rcu(&gl->gl_rcu, gfs2_glock_free);
 		return;
 	case -DLM_ECANCEL: /* Cancel while getting lock */
 		ret |= LM_OUT_CANCELED;
@@ -164,16 +158,14 @@ static int gdlm_lock(struct gfs2_glock *gl, unsigned int req_state,
 			GDLM_STRNAME_BYTES - 1, 0, gdlm_ast, gl, gdlm_bast);
 }
 
-static void gdlm_put_lock(struct kmem_cache *cachep, struct gfs2_glock *gl)
+static void gdlm_put_lock(struct gfs2_glock *gl)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
 	int error;
 
 	if (gl->gl_lksb.sb_lkid == 0) {
-		kmem_cache_free(cachep, gl);
-		if (atomic_dec_and_test(&sdp->sd_glock_disposal))
-			wake_up(&sdp->sd_glock_wait);
+		call_rcu(&gl->gl_rcu, gfs2_glock_free);
 		return;
 	}
 
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index bf33f82..11a73ef 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -91,7 +91,8 @@ static void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
 	}
 	bd->bd_ail = ai;
 	list_add(&bd->bd_ail_st_list, &ai->ai_ail1_list);
-	clear_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
+	if (test_and_clear_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags))
+		gfs2_glock_schedule_for_reclaim(bd->bd_gl);
 	trace_gfs2_pin(bd, 0);
 	gfs2_log_unlock(sdp);
 	unlock_buffer(bh);
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index ebef7ab..d850004 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -14,6 +14,8 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/gfs2_ondisk.h>
+#include <linux/rcupdate.h>
+#include <linux/rculist_bl.h>
 #include <asm/atomic.h>
 
 #include "gfs2.h"
@@ -45,7 +47,7 @@ static void gfs2_init_glock_once(void *foo)
 {
 	struct gfs2_glock *gl = foo;
 
-	INIT_HLIST_NODE(&gl->gl_list);
+	INIT_HLIST_BL_NODE(&gl->gl_list);
 	spin_lock_init(&gl->gl_spin);
 	INIT_LIST_HEAD(&gl->gl_holders);
 	INIT_LIST_HEAD(&gl->gl_lru);
@@ -198,6 +200,8 @@ static void __exit exit_gfs2_fs(void)
 	unregister_filesystem(&gfs2meta_fs_type);
 	destroy_workqueue(gfs_recovery_wq);
 
+	rcu_barrier();
+
 	kmem_cache_destroy(gfs2_quotad_cachep);
 	kmem_cache_destroy(gfs2_rgrpd_cachep);
 	kmem_cache_destroy(gfs2_bufdata_cachep);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 777927c..a39c103 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -928,12 +928,9 @@ static const match_table_t nolock_tokens = {
 	{ Opt_err, NULL },
 };
 
-static void nolock_put_lock(struct kmem_cache *cachep, struct gfs2_glock *gl)
+static void nolock_put_lock(struct gfs2_glock *gl)
 {
-	struct gfs2_sbd *sdp = gl->gl_sbd;
-	kmem_cache_free(cachep, gl);
-	if (atomic_dec_and_test(&sdp->sd_glock_disposal))
-		wake_up(&sdp->sd_glock_wait);
+	call_rcu(&gl->gl_rcu, gfs2_glock_free);
 }
 
 static const struct lm_lockops nolock_ops = {
-- 
1.7.4

