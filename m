Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291Ab1LQH7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 02:59:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62527 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1LQH7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 02:59:32 -0500
Date: Fri, 16 Dec 2011 23:59:24 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <rdunlap@xenotime.net>, Naveen Yadav <yad.naveen@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] rtth: advance to userspace-rcu-0.6.7
In-Reply-To: <alpine.LSU.2.00.1112162347440.1981@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1112162357510.1981@eggly.anvils>
References: <alpine.LSU.2.00.1112162347440.1981@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up to here I've been building rtth with userspace-rcu-0.5.4,
since 0.6 introduces a conflicting declaration of struct rcu_head:
rtth has its own little implementation of call_rcu(), with the
comment /* switch to urcu implementation when it is merged. */

userspace-rcu-0.6 (available since June) implements call_rcu() where
0.5 did not, so remove rtth's rcupdate.c and conflicting declarations,
converting to rely on userspace-rcu-0.6.7 for call_rcu().

And now the nr_allocated count of radix_tree_nodes does go down to zero.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 Makefile         |    2 -
 linux.c          |    2 -
 linux/rcupdate.h |   15 -------
 main.c           |    3 +
 rcupdate.c       |   86 ---------------------------------------------
 regression1.c    |    4 +-
 6 files changed, 6 insertions(+), 106 deletions(-)

--- rtth4/Makefile	2011-01-24 22:12:10.000000000 -0800
+++ rtth5/Makefile	2011-12-16 18:44:06.623896843 -0800
@@ -2,7 +2,7 @@
 CFLAGS += -I. -g -Wall -D_LGPL_SOURCE
 LDFLAGS += -lpthread -lurcu
 TARGETS = main
-OFILES = main.o rcupdate.o radix-tree.o linux.o test.o tag_check.o regression1.o regression2.o
+OFILES = main.o radix-tree.o linux.o test.o tag_check.o regression1.o regression2.o
 
 targets: $(TARGETS)
 
--- rtth4/linux/rcupdate.h	2010-11-10 16:35:29.000000000 -0800
+++ rtth5/linux/rcupdate.h	2011-12-16 18:44:06.623896843 -0800
@@ -3,21 +3,6 @@
 
 #include <urcu.h>
 
-void rcupdate_init(void);
-void rcupdate_thread_init(void);
-void rcupdate_thread_exit(void);
-
-/**
- * struct rcu_head - callback structure for use with RCU
- * @next: next update requests in a list
- * @func: actual update function to call after the grace period.
- */
-struct rcu_head {
-        struct rcu_head *next;
-        void (*func)(struct rcu_head *head);
-};
-
 #define rcu_dereference_raw(p) rcu_dereference(p)
-void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *head));
 
 #endif
--- rtth4/linux.c	2011-12-16 18:44:05.587897075 -0800
+++ rtth5/linux.c	2011-12-16 18:44:05.587897075 -0800
@@ -6,7 +6,7 @@
 
 #include <linux/mempool.h>
 #include <linux/slab.h>
-#include <urcu/uatomic_arch.h>
+#include <urcu/uatomic.h>
 
 int nr_allocated;
 
--- rtth4/main.c	2011-12-16 18:44:05.587897075 -0800
+++ rtth5/main.c	2011-12-16 18:44:06.623896843 -0800
@@ -256,7 +256,7 @@ static void single_thread_tests(void)
 
 int main()
 {
-	rcupdate_init();
+	rcu_register_thread();
 	radix_tree_init();
 
 	regression1_test();
@@ -265,6 +265,7 @@ int main()
 
 	sleep(1);
 	printf("after sleep(1): %d allocated\n", nr_allocated);
+	rcu_unregister_thread();
 
 	exit(0);
 }
--- rtth4/rcupdate.c	2010-11-10 16:35:48.000000000 -0800
+++ rtth5/rcupdate.c	1969-12-31 16:00:00.000000000 -0800
@@ -1,86 +0,0 @@
-#include <linux/rcupdate.h>
-#include <pthread.h>
-#include <stdio.h>
-#include <assert.h>
-
-static pthread_mutex_t rculock = PTHREAD_MUTEX_INITIALIZER;
-static struct rcu_head *rcuhead_global = NULL;
-static __thread int nr_rcuhead = 0;
-static __thread struct rcu_head *rcuhead = NULL;
-static __thread struct rcu_head *rcutail = NULL;
-
-static pthread_cond_t rcu_worker_cond = PTHREAD_COND_INITIALIZER;
-
-/* switch to urcu implementation when it is merged. */
-void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *head))
-{
-	head->func = func;
-	head->next = rcuhead;
-	rcuhead = head;
-	if (!rcutail)
-		rcutail = head;
-	nr_rcuhead++;
-	if (nr_rcuhead >= 1000) {
-		int signal = 0;
-
-		pthread_mutex_lock(&rculock);
-		if (!rcuhead_global)
-			signal = 1;
-		rcutail->next = rcuhead_global;
-		rcuhead_global = head;
-		pthread_mutex_unlock(&rculock);
-
-		nr_rcuhead = 0;
-		rcuhead = NULL;
-		rcutail = NULL;
-
-		if (signal) {
-			pthread_cond_signal(&rcu_worker_cond);
-		}
-	}
-}
-
-static void *rcu_worker(void *arg)
-{
-	struct rcu_head *r;
-
-	rcupdate_thread_init();
-
-	while (1) {
-		pthread_mutex_lock(&rculock);
-		while (!rcuhead_global) {
-			pthread_cond_wait(&rcu_worker_cond, &rculock);
-		}
-		r = rcuhead_global;
-		rcuhead_global = NULL;
-
-		pthread_mutex_unlock(&rculock);
-
-		synchronize_rcu();
-
-		while (r) {
-			struct rcu_head *tmp = r->next;
-			r->func(r);
-			r = tmp;
-		}
-	}
-
-	rcupdate_thread_exit();
-
-	return NULL;
-}
-
-static pthread_t worker_thread;
-void rcupdate_init(void)
-{
-	pthread_create(&worker_thread, NULL, rcu_worker, NULL);
-}
-
-void rcupdate_thread_init(void)
-{
-	rcu_register_thread();
-}
-void rcupdate_thread_exit(void)
-{
-	rcu_unregister_thread();
-}
--- rtth4/regression1.c	2011-12-16 18:44:04.551896997 -0800
+++ rtth5/regression1.c	2011-12-16 18:44:06.627896873 -0800
@@ -135,7 +135,7 @@ static pthread_barrier_t worker_barrier;
 
 static void *regression1_fn(void *arg)
 {
-	rcupdate_thread_init();
+	rcu_register_thread();
 
 	if (pthread_barrier_wait(&worker_barrier) ==
 			PTHREAD_BARRIER_SERIAL_THREAD) {
@@ -180,7 +180,7 @@ static void *regression1_fn(void *arg)
 		}
 	}
 
-	rcupdate_thread_exit();
+	rcu_unregister_thread();
 
 	return NULL;
 }
