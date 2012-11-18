Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2KRTC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 14:02:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431Ab2KRTC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 14:02:56 -0500
Date: Sun, 18 Nov 2012 20:03:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Arapov <anton@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] percpu_rw_semaphore: add the lockdep annotations
Message-ID: <20121118190321.GA9684@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121118190257.GA9660@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the lockdep annotations. Not only this can help to find the
potential problems, we do not want the false warnings if, say,
the task takes two different percpu_rw_semaphore's for reading.
IOW, at least ->rw_sem should not use a single class.

This patch exposes this internal lock to lockdep so that it
represents the whole percpu_rw_semaphore. This way we do not
need to add another "fake" ->lockdep_map and lock_class_key.
More importantly, this also makes the output from lockdep much
more understandable if it finds the problem.

In short, with this patch from lockdep pov percpu_down_read()
and percpu_up_read() acquire/release ->rw_sem for reading, this
matches the actual semantics. This abuses __up_read() but I hope
this is fine and in fact I'd like to have down_read_no_lockdep()
as well, percpu_down_read_recursive_readers() will need it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/percpu-rwsem.h |   10 +++++++++-
 lib/percpu-rwsem.c           |   21 +++++++++++++++++----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
index d2146a4..3e88c9a 100644
--- a/include/linux/percpu-rwsem.h
+++ b/include/linux/percpu-rwsem.h
@@ -5,6 +5,7 @@
 #include <linux/rwsem.h>
 #include <linux/percpu.h>
 #include <linux/wait.h>
+#include <linux/lockdep.h>
 
 struct percpu_rw_semaphore {
 	unsigned int __percpu	*fast_read_ctr;
@@ -20,7 +21,14 @@ extern void percpu_up_read(struct percpu_rw_semaphore *);
 extern void percpu_down_write(struct percpu_rw_semaphore *);
 extern void percpu_up_write(struct percpu_rw_semaphore *);
 
-extern int percpu_init_rwsem(struct percpu_rw_semaphore *);
+extern int __percpu_init_rwsem(struct percpu_rw_semaphore *,
+				const char *, struct lock_class_key *);
 extern void percpu_free_rwsem(struct percpu_rw_semaphore *);
 
+#define percpu_init_rwsem(brw)	\
+({								\
+	static struct lock_class_key rwsem_key;			\
+	__percpu_init_rwsem(brw, #brw, &rwsem_key);		\
+})
+
 #endif
diff --git a/lib/percpu-rwsem.c b/lib/percpu-rwsem.c
index e5a146e..ba2708f 100644
--- a/lib/percpu-rwsem.c
+++ b/lib/percpu-rwsem.c
@@ -2,18 +2,21 @@
 #include <linux/rwsem.h>
 #include <linux/percpu.h>
 #include <linux/wait.h>
+#include <linux/lockdep.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/errno.h>
 
-int percpu_init_rwsem(struct percpu_rw_semaphore *brw)
+int __percpu_init_rwsem(struct percpu_rw_semaphore *brw,
+			const char *name, struct lock_class_key *rwsem_key)
 {
 	brw->fast_read_ctr = alloc_percpu(int);
 	if (unlikely(!brw->fast_read_ctr))
 		return -ENOMEM;
 
-	init_rwsem(&brw->rw_sem);
+	/* ->rw_sem represents the whole percpu_rw_semaphore for lockdep */
+	__init_rwsem(&brw->rw_sem, name, rwsem_key);
 	atomic_set(&brw->write_ctr, 0);
 	atomic_set(&brw->slow_read_ctr, 0);
 	init_waitqueue_head(&brw->write_waitq);
@@ -66,19 +69,29 @@ static bool update_fast_ctr(struct percpu_rw_semaphore *brw, unsigned int val)
 /*
  * Like the normal down_read() this is not recursive, the writer can
  * come after the first percpu_down_read() and create the deadlock.
+ *
+ * Note: returns with lock_is_held(brw->rw_sem) == T for lockdep,
+ * percpu_up_read() does rwsem_release(). This pairs with the usage
+ * of ->rw_sem in percpu_down/up_write().
  */
 void percpu_down_read(struct percpu_rw_semaphore *brw)
 {
-	if (likely(update_fast_ctr(brw, +1)))
+	might_sleep();
+	if (likely(update_fast_ctr(brw, +1))) {
+		rwsem_acquire_read(&brw->rw_sem.dep_map, 0, 0, _RET_IP_);
 		return;
+	}
 
 	down_read(&brw->rw_sem);
 	atomic_inc(&brw->slow_read_ctr);
-	up_read(&brw->rw_sem);
+	/* avoid up_read()->rwsem_release() */
+	__up_read(&brw->rw_sem);
 }
 
 void percpu_up_read(struct percpu_rw_semaphore *brw)
 {
+	rwsem_release(&brw->rw_sem.dep_map, 1, _RET_IP_);
+
 	if (likely(update_fast_ctr(brw, -1)))
 		return;
 
-- 
1.5.5.1

