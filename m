Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1DQJ7E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 05:59:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab1DQJ6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 05:58:07 -0400
Message-Id: <20110417095507.123045423@chello.nl>
User-Agent: quilt/0.48-1
Date: Sun, 17 Apr 2011 11:45:09 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 4/7] lockdep: Seperate lock ids for read/write acquires
References: <20110417094505.865828233@chello.nl>
Content-Disposition: inline; filename=gautham_r_shenoy-lockdep-seperate_lock_ids_for_read_write.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gautham R Shenoy <ego@in.ibm.com>

In order to support recursive read locks we need to support the
previously mentioned lock state conflict matrix:

 Conflicting_states(WRITE):             RECURSIVE_READ | READ | WRITE
 Conflicting_states(READ):                               READ | WRITE
 Conflicting_states(RECURSIVE_READ):                            WRITE

Since this introduces asymmetry between recursive read and write, we
need to split the lock dependency chains such that we can traverse
WRITE chains without observing RECURSIVE_READ|READ chains.

Previously we didn't distinguish between the read/write acquire of a
particular lock, thus we get the same key's for two different chains
involving the same locks in the same dependency order, but in
different read/write states.

For example:

	lock(A) ---> Rlock(B)
	lock(A) ---> Wlock(B)

Will overlap and produce a single chain. This is fine for the
symmetric conflict states of exlusive locks (trivial, WRITE exludes
WRITE) and fair read/write locks (note that both READ and WRITE
exclude each other), but is not sufficient for the reader preferenced
read/write lock since the recursive read state does not exclude
itself. 

The implementation is straight forward since the key of a dependency
chain is obtained from the keys of the locks involved in the
dependency chains. The keys of the locks are defined as their
lock_class id's.

By changing this to distinguishing between the read/write acquires of
a lock by defining the lock's key as follows:

	class_id + is_read_lock(lock) * MAX_LOCKDEP_KEYS

We gain the proposed split and thus for the purpose of chain key
calculation a lock's key can be in the range 1 to 2*MAX_LOCKDEP_KEYS-1.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h |   14 ++++++++++++++
 kernel/lockdep.c        |   19 +++++++++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -186,6 +186,7 @@ struct lock_chain {
 };
 
 #define MAX_LOCKDEP_KEYS_BITS		13
+
 /*
  * Subtract one because we offset hlock->class_idx by 1 in order
  * to make 0 mean no class. This avoids overflowing the class_idx
@@ -193,6 +194,19 @@ struct lock_chain {
  */
 #define MAX_LOCKDEP_KEYS		((1UL << MAX_LOCKDEP_KEYS_BITS) - 1)
 
+/*
+ * A lock's class id is used to calculate the chain-key. Since we need to
+ * differentiate between the chains which contain the read acquire of
+ * a lock from the chains having write acquire of the same lock,
+ * we offset the class_idx by MAX_LOCKDEP_KEYS if it is a read acquire.
+ *
+ * Thus the the lock's key during a chain-key calculation can be in the range
+ * 1 to 2 * MAX_LOCKDEP_KEYS - 1.
+ *
+ * LOCKDEP_CHAIN_KEY_BITS holds the number of bits required to
+ * represent this range.
+ */
+#define LOCKDEP_CHAIN_KEY_BITS	(MAX_LOCKDEP_KEYS_BITS + 1)
 struct held_lock {
 	/*
 	 * One-way hash of the dependency chain up to this point. We
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -303,8 +303,8 @@ static struct list_head chainhash_table[
  * unique.
  */
 #define iterate_chain_key(key1, key2) \
-	(((key1) << MAX_LOCKDEP_KEYS_BITS) ^ \
-	((key1) >> (64-MAX_LOCKDEP_KEYS_BITS)) ^ \
+	(((key1) << LOCKDEP_CHAIN_KEY_BITS) ^ \
+	((key1) >> (64 - LOCKDEP_CHAIN_KEY_BITS)) ^ \
 	(key2))
 
 void lockdep_off(void)
@@ -1988,6 +1988,9 @@ static void check_chain_key(struct task_
 		if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
 			return;
 
+		if (is_read(hlock->rw_state))
+			id += MAX_LOCKDEP_KEYS;
+
 		if (prev_hlock && (prev_hlock->irq_context !=
 							hlock->irq_context))
 			chain_key = 0;
@@ -2815,6 +2818,18 @@ static int __lock_acquire(struct lockdep
 	if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
 		return 0;
 
+	/*
+	 * Factor in the read/write state in the chain key calculation.
+	 *
+	 * Two chains containing lock dependencies in the same order can
+	 * still differ due to their read/write state
+	 * eg: lock(A)->Rlock(B) is different from lock(A)->Wlock(B)
+	 *
+	 * Hence distinguish between such chains.
+	 */
+	if (is_read(rw_state))
+		id += MAX_LOCKDEP_KEYS;
+
 	chain_key = curr->curr_chain_key;
 	if (!depth) {
 		if (DEBUG_LOCKS_WARN_ON(chain_key != 0))


