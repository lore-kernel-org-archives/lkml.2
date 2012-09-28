Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab2I1NDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:03:16 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52411 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab2I1NDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:03:10 -0400
X-Greylist: delayed 1237 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2012 09:03:09 EDT
Subject: [PATCH 5/5] reservation: Add lockdep annotation and selftests
To: jakob@vmware.com, thellstrom@vmware.com, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
        linux-media@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 28 Sep 2012 14:43:21 +0200
Message-ID: <20120928124321.14366.35302.stgit@patser.local>
In-Reply-To: <20120928124148.14366.21063.stgit@patser.local>
References: <20120928124148.14366.21063.stgit@patser.local>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

---

The self-tests will fail if the commit "lockdep: Check if nested
lock is actually held" from linux tip core/locking is not applied.
---
 drivers/base/reservation.c  |   46 +++++-
 include/linux/reservation.h |   29 +++-
 lib/Kconfig.debug           |    1 
 lib/locking-selftest.c      |  353 +++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 403 insertions(+), 26 deletions(-)

diff --git a/drivers/base/reservation.c b/drivers/base/reservation.c
index 93e2d9f..b8d4f4d 100644
--- a/drivers/base/reservation.c
+++ b/drivers/base/reservation.c
@@ -41,6 +41,18 @@
 atomic64_t reservation_counter = ATOMIC64_INIT(1);
 EXPORT_SYMBOL(reservation_counter);
 
+const char reservation_object_name[] = "reservation_object";
+EXPORT_SYMBOL(reservation_object_name);
+
+const char reservation_ticket_name[] = "reservation_ticket";
+EXPORT_SYMBOL(reservation_ticket_name);
+
+struct lock_class_key reservation_object_class;
+EXPORT_SYMBOL(reservation_object_class);
+
+struct lock_class_key reservation_ticket_class;
+EXPORT_SYMBOL(reservation_ticket_class);
+
 int
 object_reserve(struct reservation_object *obj, bool intr, bool no_wait,
 	       reservation_ticket_t *ticket)
@@ -49,6 +61,10 @@ object_reserve(struct reservation_object *obj, bool intr, bool no_wait,
 	u64 sequence = ticket ? ticket->seqno : 1;
 	u64 oldseq;
 
+	if (!no_wait)
+		mutex_acquire_nest(&obj->dep_map, 0, 0,
+				   ticket ? &ticket->dep_map : NULL, _RET_IP_);
+
 	while (unlikely(oldseq = atomic64_cmpxchg(&obj->reserved, 0, sequence))) {
 
 		/**
@@ -58,14 +74,18 @@ object_reserve(struct reservation_object *obj, bool intr, bool no_wait,
 			/**
 			 * We've already reserved this one.
 			 */
-			if (unlikely(sequence == oldseq))
-				return -EDEADLK;
+			if (unlikely(sequence == oldseq)) {
+				ret = -EDEADLK;
+				goto fail;
+			}
 			/**
 			 * Already reserved by a thread that will not back
 			 * off for us. We need to back off.
 			 */
-			if (unlikely(sequence - oldseq < (1ULL << 63)))
-				return -EAGAIN;
+			if (unlikely(sequence - oldseq < (1ULL << 63))) {
+				ret = -EAGAIN;
+				goto fail;
+			}
 		}
 
 		if (no_wait)
@@ -74,9 +94,12 @@ object_reserve(struct reservation_object *obj, bool intr, bool no_wait,
 		ret = object_wait_unreserved(obj, intr);
 
 		if (unlikely(ret))
-			return ret;
+			goto fail;
 	}
 
+	if (no_wait)
+		mutex_acquire(&obj->dep_map, 0, 1, _RET_IP_);
+
 	/**
 	 * Wake up waiters that may need to recheck for deadlock,
 	 * if we decreased the sequence number.
@@ -84,6 +107,11 @@ object_reserve(struct reservation_object *obj, bool intr, bool no_wait,
 	wake_up_all(&obj->event_queue);
 
 	return 0;
+
+fail:
+	if (!no_wait)
+		mutex_release(&obj->dep_map, 1, _RET_IP_);
+	return ret;
 }
 EXPORT_SYMBOL(object_reserve);
 
@@ -105,6 +133,14 @@ void
 object_unreserve(struct reservation_object *obj,
 		 reservation_ticket_t *ticket)
 {
+	mutex_release(&obj->dep_map, 1, _RET_IP_);
+
+	if (!object_is_reserved(obj)) {
+#ifndef CONFIG_DEBUG_LOCKING_API_SELFTESTS
+		WARN_ON(1);
+#endif
+		return;
+	}
 	smp_mb();
 	atomic64_set(&obj->reserved, 0);
 	wake_up_all(&obj->event_queue);
diff --git a/include/linux/reservation.h b/include/linux/reservation.h
index 93280af..6fa0cdb 100644
--- a/include/linux/reservation.h
+++ b/include/linux/reservation.h
@@ -44,6 +44,10 @@
 #include <linux/fence.h>
 
 extern atomic64_t reservation_counter;
+extern const char reservation_object_name[];
+extern struct lock_class_key reservation_object_class;
+extern const char reservation_ticket_name[];
+extern struct lock_class_key reservation_ticket_class;
 
 struct reservation_object {
 	wait_queue_head_t event_queue;
@@ -53,10 +57,17 @@ struct reservation_object {
 	u32 fence_shared_count;
 	struct fence *fence_excl;
 	struct fence *fence_shared[BUF_MAX_SHARED_FENCE];
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
 };
 
 typedef struct reservation_ticket {
 	u64 seqno;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
 } reservation_ticket_t;
 
 /**
@@ -73,11 +84,13 @@ struct reservation_entry {
 	unsigned long obj_shared;
 };
 
-
 static inline void
 __reservation_object_init(struct reservation_object *obj)
 {
 	init_waitqueue_head(&obj->event_queue);
+
+	lockdep_init_map(&obj->dep_map, reservation_object_name,
+			 &reservation_object_class, 0);
 }
 
 static inline void
@@ -110,6 +123,16 @@ reservation_object_fini(struct reservation_object *obj)
 static inline void
 reservation_ticket_init(struct reservation_ticket *t)
 {
+#ifdef CONFIG_LOCKDEP
+	/*
+	 * Make sure we are not reinitializing a held ticket:
+	 */
+
+	debug_check_no_locks_freed((void *)t, sizeof(*t));
+#endif
+	lockdep_init_map(&t->dep_map, reservation_ticket_name,
+			 &reservation_ticket_class, 0);
+	mutex_acquire(&t->dep_map, 0, 0, _RET_IP_);
 	do {
 		t->seqno = atomic64_inc_return(&reservation_counter);
 	} while (unlikely(t->seqno < 2));
@@ -125,7 +148,9 @@ reservation_ticket_init(struct reservation_ticket *t)
  */
 static inline void
 reservation_ticket_fini(struct reservation_ticket *t)
-{ }
+{
+	mutex_release(&t->dep_map, 1, _RET_IP_);
+}
 
 /**
  * reservation_entry_init - initialize and append a reservation_entry
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2403a63..3211730 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -700,6 +700,7 @@ config DEBUG_ATOMIC_SLEEP
 config DEBUG_LOCKING_API_SELFTESTS
 	bool "Locking API boot-time self-tests"
 	depends on DEBUG_KERNEL
+	select CONFIG_DMA_SHARED_BUFFER
 	help
 	  Say Y here if you want the kernel to run a short self-test during
 	  bootup. The self-test checks whether common types of locking bugs
diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 7aae0f2..fc4a45b 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -20,6 +20,7 @@
 #include <linux/interrupt.h>
 #include <linux/debug_locks.h>
 #include <linux/irqflags.h>
+#include <linux/reservation.h>
 
 /*
  * Change this to 1 if you want to see the failure printouts:
@@ -42,6 +43,7 @@ __setup("debug_locks_verbose=", setup_debug_locks_verbose);
 #define LOCKTYPE_RWLOCK	0x2
 #define LOCKTYPE_MUTEX	0x4
 #define LOCKTYPE_RWSEM	0x8
+#define LOCKTYPE_RESERVATION 0x10
 
 /*
  * Normal standalone locks, for the circular and irq-context
@@ -920,11 +922,17 @@ GENERATE_PERMUTATIONS_3_EVENTS(irq_read_recursion_soft)
 static void reset_locks(void)
 {
 	local_irq_disable();
+	lockdep_free_key_range(&reservation_object_class, 1);
+	lockdep_free_key_range(&reservation_ticket_class, 1);
+
 	I1(A); I1(B); I1(C); I1(D);
 	I1(X1); I1(X2); I1(Y1); I1(Y2); I1(Z1); I1(Z2);
 	lockdep_reset();
 	I2(A); I2(B); I2(C); I2(D);
 	init_shared_classes();
+
+	memset(&reservation_object_class, 0, sizeof reservation_object_class);
+	memset(&reservation_ticket_class, 0, sizeof reservation_ticket_class);
 	local_irq_enable();
 }
 
@@ -938,7 +946,6 @@ static int unexpected_testcase_failures;
 static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 {
 	unsigned long saved_preempt_count = preempt_count();
-	int expected_failure = 0;
 
 	WARN_ON(irqs_disabled());
 
@@ -946,26 +953,16 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 	/*
 	 * Filter out expected failures:
 	 */
+	if (debug_locks != expected) {
 #ifndef CONFIG_PROVE_LOCKING
-	if ((lockclass_mask & LOCKTYPE_SPIN) && debug_locks != expected)
-		expected_failure = 1;
-	if ((lockclass_mask & LOCKTYPE_RWLOCK) && debug_locks != expected)
-		expected_failure = 1;
-	if ((lockclass_mask & LOCKTYPE_MUTEX) && debug_locks != expected)
-		expected_failure = 1;
-	if ((lockclass_mask & LOCKTYPE_RWSEM) && debug_locks != expected)
-		expected_failure = 1;
+		expected_testcase_failures++;
+		printk("failed|");
+#else
+		unexpected_testcase_failures++;
+		printk("FAILED|");
+
+		dump_stack();
 #endif
-	if (debug_locks != expected) {
-		if (expected_failure) {
-			expected_testcase_failures++;
-			printk("failed|");
-		} else {
-			unexpected_testcase_failures++;
-
-			printk("FAILED|");
-			dump_stack();
-		}
 	} else {
 		testcase_successes++;
 		printk("  ok  |");
@@ -1108,6 +1105,322 @@ static inline void print_testname(const char *testname)
 	DO_TESTCASE_6IRW(desc, name, 312);			\
 	DO_TESTCASE_6IRW(desc, name, 321);
 
+static void reservation_test_fail_reserve(void)
+{
+	struct reservation_ticket t;
+	struct reservation_object o;
+
+	reservation_object_init(&o);
+	reservation_ticket_init(&t);
+	t.seqno++;
+
+	object_reserve(&o, false, false, &t);
+	/* No lockdep test, pure API */
+	WARN_ON(object_reserve(&o, false, true, &t) != -EDEADLK);
+	t.seqno--;
+	WARN_ON(object_reserve(&o, false, true, &t) != -EBUSY);
+	t.seqno += 2;
+	WARN_ON(object_reserve(&o, false, true, &t) != -EAGAIN);
+	object_unreserve(&o, NULL);
+
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_test_two_tickets(void)
+{
+	struct reservation_ticket t, t2;
+
+	reservation_ticket_init(&t);
+	reservation_ticket_init(&t2);
+
+	reservation_ticket_fini(&t2);
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_test_ticket_unreserve_twice(void)
+{
+	struct reservation_ticket t;
+
+	reservation_ticket_init(&t);
+	reservation_ticket_fini(&t);
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_test_object_unreserve_twice(void)
+{
+	struct reservation_object o;
+
+	reservation_object_init(&o);
+	object_reserve(&o, false, false, NULL);
+	object_unreserve(&o, NULL);
+	object_unreserve(&o, NULL);
+}
+
+static void reservation_test_fence_nest_unreserved(void)
+{
+	struct reservation_object o;
+
+	reservation_object_init(&o);
+
+	spin_lock_nest_lock(&lock_A, &o);
+	spin_unlock(&lock_A);
+}
+
+static void reservation_test_ticket_block(void)
+{
+	struct reservation_ticket t;
+	struct reservation_object o, o2;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+	reservation_ticket_init(&t);
+
+	object_reserve(&o, false, false, &t);
+	object_reserve(&o2, false, false, NULL);
+	object_unreserve(&o2, NULL);
+	object_unreserve(&o, &t);
+
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_test_ticket_try(void)
+{
+	struct reservation_ticket t;
+	struct reservation_object o, o2;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+	reservation_ticket_init(&t);
+
+	object_reserve(&o, false, false, &t);
+	object_reserve(&o2, false, true, NULL);
+	object_unreserve(&o2, NULL);
+	object_unreserve(&o, &t);
+
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_test_ticket_ticket(void)
+{
+	struct reservation_ticket t;
+	struct reservation_object o, o2;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+	reservation_ticket_init(&t);
+
+	object_reserve(&o, false, false, &t);
+	object_reserve(&o2, false, false, &t);
+	object_unreserve(&o2, &t);
+	object_unreserve(&o, &t);
+
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_test_try_block(void)
+{
+	struct reservation_object o, o2;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+
+	object_reserve(&o, false, true, NULL);
+	object_reserve(&o2, false, false, NULL);
+	object_unreserve(&o2, NULL);
+	object_unreserve(&o, NULL);
+}
+
+static void reservation_test_try_try(void)
+{
+	struct reservation_object o, o2;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+
+	object_reserve(&o, false, true, NULL);
+	object_reserve(&o2, false, true, NULL);
+	object_unreserve(&o2, NULL);
+	object_unreserve(&o, NULL);
+}
+
+static void reservation_test_try_ticket(void)
+{
+	struct reservation_ticket t;
+	struct reservation_object o, o2;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+
+	object_reserve(&o, false, true, NULL);
+	reservation_ticket_init(&t);
+
+	object_reserve(&o2, false, false, &t);
+	object_unreserve(&o2, &t);
+	object_unreserve(&o, NULL);
+
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_test_block_block(void)
+{
+	struct reservation_object o, o2;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+
+	object_reserve(&o, false, false, NULL);
+	object_reserve(&o2, false, false, NULL);
+	object_unreserve(&o2, NULL);
+	object_unreserve(&o, NULL);
+}
+
+static void reservation_test_block_try(void)
+{
+	struct reservation_object o, o2;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+
+	object_reserve(&o, false, false, NULL);
+	object_reserve(&o2, false, true, NULL);
+	object_unreserve(&o2, NULL);
+	object_unreserve(&o, NULL);
+}
+
+static void reservation_test_block_ticket(void)
+{
+	struct reservation_ticket t;
+	struct reservation_object o, o2;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+
+	object_reserve(&o, false, false, NULL);
+	reservation_ticket_init(&t);
+
+	object_reserve(&o2, false, false, &t);
+	object_unreserve(&o2, &t);
+	object_unreserve(&o, NULL);
+
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_test_fence_block(void)
+{
+	struct reservation_object o;
+
+	reservation_object_init(&o);
+	spin_lock(&lock_A);
+	spin_unlock(&lock_A);
+
+	object_reserve(&o, false, false, NULL);
+	spin_lock(&lock_A);
+	spin_unlock(&lock_A);
+	object_unreserve(&o, NULL);
+
+	spin_lock(&lock_A);
+	object_reserve(&o, false, false, NULL);
+	object_unreserve(&o, NULL);
+	spin_unlock(&lock_A);
+}
+
+static void reservation_test_fence_try(void)
+{
+	struct reservation_object o;
+
+	reservation_object_init(&o);
+	spin_lock(&lock_A);
+	spin_unlock(&lock_A);
+
+	object_reserve(&o, false, true, NULL);
+	spin_lock(&lock_A);
+	spin_unlock(&lock_A);
+	object_unreserve(&o, NULL);
+
+	spin_lock(&lock_A);
+	object_reserve(&o, false, true, NULL);
+	object_unreserve(&o, NULL);
+	spin_unlock(&lock_A);
+}
+
+static void reservation_test_fence_ticket(void)
+{
+	struct reservation_ticket t;
+	struct reservation_object o;
+
+	reservation_object_init(&o);
+	spin_lock(&lock_A);
+	spin_unlock(&lock_A);
+
+	reservation_ticket_init(&t);
+
+	object_reserve(&o, false, false, &t);
+	spin_lock(&lock_A);
+	spin_unlock(&lock_A);
+	object_unreserve(&o, &t);
+
+	spin_lock(&lock_A);
+	object_reserve(&o, false, false, &t);
+	object_unreserve(&o, &t);
+	spin_unlock(&lock_A);
+
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_tests(void)
+{
+	printk("  --------------------------------------------------------------------------\n");
+	printk("  | Reservation tests |\n");
+	printk("  ---------------------\n");
+
+	print_testname("reservation api failures");
+	dotest(reservation_test_fail_reserve, SUCCESS, LOCKTYPE_RESERVATION);
+	printk("\n");
+
+	print_testname("reserving two tickets");
+	dotest(reservation_test_two_tickets, FAILURE, LOCKTYPE_RESERVATION);
+	printk("\n");
+
+	print_testname("unreserve ticket twice");
+	dotest(reservation_test_ticket_unreserve_twice, FAILURE, LOCKTYPE_RESERVATION);
+	printk("\n");
+
+	print_testname("unreserve object twice");
+	dotest(reservation_test_object_unreserve_twice, FAILURE, LOCKTYPE_RESERVATION);
+	printk("\n");
+
+	print_testname("spinlock nest unreserved");
+	dotest(reservation_test_fence_nest_unreserved, FAILURE, LOCKTYPE_RESERVATION);
+	printk("\n");
+
+	printk("  -----------------------------------------------------\n");
+	printk("                                 |block | try  |ticket|\n");
+	printk("  -----------------------------------------------------\n");
+
+	print_testname("ticket");
+	dotest(reservation_test_ticket_block, FAILURE, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_ticket_try, SUCCESS, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_ticket_ticket, SUCCESS, LOCKTYPE_RESERVATION);
+	printk("\n");
+
+	print_testname("try");
+	dotest(reservation_test_try_block, FAILURE, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_try_try, SUCCESS, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_try_ticket, FAILURE, LOCKTYPE_RESERVATION);
+	printk("\n");
+
+	print_testname("block");
+	dotest(reservation_test_block_block, FAILURE, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_block_try, SUCCESS, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_block_ticket, FAILURE, LOCKTYPE_RESERVATION);
+	printk("\n");
+
+	print_testname("spinlock");
+	dotest(reservation_test_fence_block, FAILURE, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_fence_try, SUCCESS, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_fence_ticket, FAILURE, LOCKTYPE_RESERVATION);
+	printk("\n");
+}
 
 void locking_selftest(void)
 {
@@ -1188,6 +1501,8 @@ void locking_selftest(void)
 	DO_TESTCASE_6x2("irq read-recursion", irq_read_recursion);
 //	DO_TESTCASE_6x2B("irq read-recursion #2", irq_read_recursion2);
 
+	reservation_tests();
+
 	if (unexpected_testcase_failures) {
 		printk("-----------------------------------------------------------------\n");
 		debug_locks = 0;

