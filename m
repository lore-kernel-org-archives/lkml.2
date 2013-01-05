Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3AEAfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 19:35:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab3AEAfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 19:35:05 -0500
Date: Sat, 5 Jan 2013 01:34:55 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/2] lockdep, rwsem: provide down_write_nest_lock()
In-Reply-To: <alpine.LNX.2.00.1301041317150.9143@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1301050134420.2946@pobox.suse.cz>
References: <alpine.LNX.2.00.1301041317150.9143@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

down_write_nest_lock() provides means to annotate locking scenario where 
an outter lock is guaranteed to serialize the order nested locks are being 
acquired.

This is an analogy to already existing mutex_lock_nest_lock() and
spin_lock_nest_lock().

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 include/linux/lockdep.h |    3 +++
 include/linux/rwsem.h   |    9 +++++++++
 kernel/rwsem.c          |   10 ++++++++++
 3 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 00e4637..2bca44b 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -524,14 +524,17 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
 #  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
 #  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 2, NULL, i)
 # else
 #  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, n, i)
 #  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 1, NULL, i)
 # endif
 # define rwsem_release(l, n, i)			lock_release(l, n, i)
 #else
 # define rwsem_acquire(l, s, t, i)		do { } while (0)
+# define rwsem_acquire_nest(l, s, t, n, i)	do { } while (0)
 # define rwsem_acquire_read(l, s, t, i)		do { } while (0)
 # define rwsem_release(l, n, i)			do { } while (0)
 #endif
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 54bd7cd..413cc11 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -125,8 +125,17 @@ extern void downgrade_write(struct rw_semaphore *sem);
  */
 extern void down_read_nested(struct rw_semaphore *sem, int subclass);
 extern void down_write_nested(struct rw_semaphore *sem, int subclass);
+extern void _down_write_nest_lock(struct rw_semaphore *sem, struct lockdep_map *nest_lock);
+
+# define down_write_nest_lock(sem, nest_lock)			\
+do {								\
+	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);	\
+	_down_write_nest_lock(sem, &(nest_lock)->dep_map);	\
+} while (0);
+
 #else
 # define down_read_nested(sem, subclass)		down_read(sem)
+# define down_write_nest_lock(sem, nest_lock)	down_read(sem)
 # define down_write_nested(sem, subclass)	down_write(sem)
 #endif
 
diff --git a/kernel/rwsem.c b/kernel/rwsem.c
index 6850f53..b3c6c3f 100644
--- a/kernel/rwsem.c
+++ b/kernel/rwsem.c
@@ -116,6 +116,16 @@ void down_read_nested(struct rw_semaphore *sem, int subclass)
 
 EXPORT_SYMBOL(down_read_nested);
 
+void _down_write_nest_lock(struct rw_semaphore *sem, struct lockdep_map *nest)
+{
+	might_sleep();
+	rwsem_acquire_nest(&sem->dep_map, 0, 0, nest, _RET_IP_);
+
+	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+}
+
+EXPORT_SYMBOL(_down_write_nest_lock);
+
 void down_write_nested(struct rw_semaphore *sem, int subclass)
 {
 	might_sleep();
-- 
Jiri Kosina
SUSE Labs
