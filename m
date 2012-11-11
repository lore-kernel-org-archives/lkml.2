Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab2KKS1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 13:27:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab2KKS1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 13:27:15 -0500
Date: Sun, 11 Nov 2012 19:27:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm]
	percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessari
	ly.fix
Message-ID: <20121111182744.GA25282@redhat.com>
References: <20121019192838.GM2518@linux.vnet.ibm.com> <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com> <20121030184800.GA16129@redhat.com> <20121031194135.GA504@redhat.com> <20121031194158.GB504@redhat.com> <CA+55aFx0yyke6V1+wgMPBN4QZ0w=YoV7yBRqp0uy6aGKbcmC5g@mail.gmail.com> <20121102180606.GA13255@redhat.com> <20121108134805.GA23870@redhat.com> <20121108134849.GB23870@redhat.com> <20121108120700.42d438f2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108120700.42d438f2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More include's and more comments, no changes in code.

To remind, once/if I am sure you agree with this patch I'll send 2 additional
and simple patches:

	1. lockdep annotations

	2. CONFIG_PERCPU_RWSEM

It seems that we can do much more improvements to a) speedup the writers and
b) make percpu_rw_semaphore more useful, but not right now.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 lib/percpu-rwsem.c |   35 +++++++++++++++++++++++++++++++++--
 1 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/lib/percpu-rwsem.c b/lib/percpu-rwsem.c
index 0e3bc0f..02bd157 100644
--- a/lib/percpu-rwsem.c
+++ b/lib/percpu-rwsem.c
@@ -1,6 +1,11 @@
+#include <linux/mutex.h>
+#include <linux/rwsem.h>
+#include <linux/percpu.h>
+#include <linux/wait.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
+#include <linux/errno.h>
 
 int percpu_init_rwsem(struct percpu_rw_semaphore *brw)
 {
@@ -21,6 +26,29 @@ void percpu_free_rwsem(struct percpu_rw_semaphore *brw)
 	brw->fast_read_ctr = NULL; /* catch use after free bugs */
 }
 
+/*
+ * This is the fast-path for down_read/up_read, it only needs to ensure
+ * there is no pending writer (!mutex_is_locked() check) and inc/dec the
+ * fast per-cpu counter. The writer uses synchronize_sched() to serialize
+ * with the preempt-disabled section below.
+ *
+ * The nontrivial part is that we should guarantee acquire/release semantics
+ * in case when
+ *
+ *	R_W: down_write() comes after up_read(), the writer should see all
+ *	     changes done by the reader
+ * or
+ *	W_R: down_read() comes after up_write(), the reader should see all
+ *	     changes done by the writer
+ *
+ * If this helper fails the callers rely on the normal rw_semaphore and
+ * atomic_dec_and_test(), so in this case we have the necessary barriers.
+ *
+ * But if it succeeds we do not have any barriers, mutex_is_locked() or
+ * __this_cpu_add() below can be reordered with any LOAD/STORE done by the
+ * reader inside the critical section. See the comments in down_write and
+ * up_write below.
+ */
 static bool update_fast_ctr(struct percpu_rw_semaphore *brw, unsigned int val)
 {
 	bool success = false;
@@ -98,6 +126,7 @@ void percpu_down_write(struct percpu_rw_semaphore *brw)
 	 *
 	 * 3. Ensures that if any reader has exited its critical section via
 	 *    fast-path, it executes a full memory barrier before we return.
+	 *    See R_W case in the comment above update_fast_ctr().
 	 */
 	synchronize_sched();
 
@@ -116,8 +145,10 @@ void percpu_up_write(struct percpu_rw_semaphore *brw)
 	/* allow the new readers, but only the slow-path */
 	up_write(&brw->rw_sem);
 
-	/* insert the barrier before the next fast-path in down_read */
+	/*
+	 * Insert the barrier before the next fast-path in down_read,
+	 * see W_R case in the comment above update_fast_ctr().
+	 */
 	synchronize_sched();
-
 	mutex_unlock(&brw->writer_mutex);
 }
-- 
1.5.5.1


