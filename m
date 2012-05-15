Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab2EOODt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:03:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26535 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab2EOODr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:03:47 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5jdMkCm7lUEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=SpDfwWfMeJeNvvMP5nEA:9 a=nRRxmxZCcI2phbT_aGcA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337090625.14207.304.camel@gandalf.stny.rr.com>
Subject: [RFC][PATCH RT] rwsem_rt: Another (more sane) approach to mulit
 reader rt locks
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Tue, 15 May 2012 10:03:45 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RT patch has been having lots of trouble lately with large machines
and applications running lots of threads. This usually boils down to a
bottle neck of a single lock: the mm->mmap_sem.

The mmap_sem is a rwsem, which can sleep, but it also can be taken with
a read/write lock, where a read lock can be taken by several tasks at
the same time and the write lock can be only taken by a single task.

But due to priority inheritance, having multiple readers makes the code
much more complex, thus the -rt patch converts all rwsems into a single
mutex, where readers may nest (the same task may grab the same rwsem for
read multiple times), but only one task may hold the rwsem at any given
time (for read or write).

When we have lots of threads, the rwsem may be taken often, either for
memory allocation or filling in page faults. This becomes a bottle neck
for threads as only one thread at a time may grab the mmap_sem (which is
shared by all threads of a process).

Previous attempts of adding multiple readers became too complex and was
error prone. This approach takes on a much more simpler technique, one
that is actually used by per cpu locks.

The idea here is to have an rwsem create a rt_mutex for each CPU.
Actually, it creates a rwsem for each CPU that can only be acquired by
one task at a time. This allows for readers on separate CPUs to take
only the per cpu lock. When a writer needs to take a lock, it must grab
all CPU locks before continuing.

This approach does nothing special with the rt_mutex or priority
inheritance code. That stays the same, and works normally (thus less
error prone). The trick here is that when a reader takes a rwsem for
read, it must disable migration, that way it can unlock the rwsem
without needing any special searches (which lock did it take?).

I've tested this a bit, and so far it works well. I haven't found a nice
way to initialize the locks, so I'm using the silly initialize_rwsem()
at all places that acquire the lock. But we can work on this later.

Also, I don't use per_cpu sections for the locks, which means we have
cache line collisions, but a normal (mainline) rwsem has that as well.

These are all room for improvement (and why this is just an RFC patch).

I'll see if I can get some numbers to see how this fixes the issues with
multi threads on big boxes.

Thoughts?

-- Steve

Not-yet-signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/rwsem_rt.h b/include/linux/rwsem_rt.h
index 802c690..cd0c812 100644
--- a/include/linux/rwsem_rt.h
+++ b/include/linux/rwsem_rt.h
@@ -18,7 +18,7 @@
 
 #include <linux/rtmutex.h>
 
-struct rw_semaphore {
+struct __rw_semaphore {
 	struct rt_mutex		lock;
 	int			read_depth;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -26,22 +26,40 @@ struct rw_semaphore {
 #endif
 };
 
+struct rw_semaphore {
+	int			initialized;
+	struct __rw_semaphore	lock[NR_CPUS];
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	const char		*name;
+	struct lock_class_key	__key[NR_CPUS];
+#endif
+};
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#define __RWSEM_INITIALIZER(_name) \
+	{ .name = _name }
+#else
 #define __RWSEM_INITIALIZER(name) \
-	{ .lock = __RT_MUTEX_INITIALIZER(name.lock), \
-	  RW_DEP_MAP_INIT(name) }
+	{  }
+
+#endif
 
 #define DECLARE_RWSEM(lockname) \
 	struct rw_semaphore lockname = __RWSEM_INITIALIZER(lockname)
 
-extern void  __rt_rwsem_init(struct rw_semaphore *rwsem, char *name,
+extern void  __rt_rwsem_init(struct __rw_semaphore *rwsem, char *name,
 				     struct lock_class_key *key);
 
-# define rt_init_rwsem(sem)				\
-do {							\
-	static struct lock_class_key __key;		\
-							\
-	rt_mutex_init(&(sem)->lock);			\
-	__rt_rwsem_init((sem), #sem, &__key);		\
+# define rt_init_rwsem(sem)						\
+do {									\
+	static struct lock_class_key __key[NR_CPUS];			\
+	int ____i;							\
+									\
+	for (____i = 0; ____i < NR_CPUS; ____i++) {			\
+		rt_mutex_init(&((sem)->lock[____i]).lock);		\
+		__rt_rwsem_init(&((sem)->lock[____i]), #sem, &__key[____i]); \
+	}								\
+	(sem)->initialized = 1;						\
 } while (0)
 
 extern void  rt_down_write(struct rw_semaphore *rwsem);
@@ -55,7 +73,11 @@ extern void  rt_up_write(struct rw_semaphore *rwsem);
 extern void  rt_downgrade_write(struct rw_semaphore *rwsem);
 
 #define init_rwsem(sem)		rt_init_rwsem(sem)
-#define rwsem_is_locked(s)	rt_mutex_is_locked(&(s)->lock)
+/*
+ * Use raw_smp_processor_id(), as readlocks use migrate disable,
+ * and write locks lock all of them (we don't care which one we test.
+ */
+#define rwsem_is_locked(s)	rt_mutex_is_locked(&(s)->lock[raw_smp_processor_id()].lock)
 
 static inline void down_read(struct rw_semaphore *sem)
 {
diff --git a/kernel/rt.c b/kernel/rt.c
index 092d6b3..f8dab27 100644
--- a/kernel/rt.c
+++ b/kernel/rt.c
@@ -306,18 +306,52 @@ EXPORT_SYMBOL(__rt_rwlock_init);
  * rw_semaphores
  */
 
+static void __initialize_rwsem(struct rw_semaphore *rwsem)
+{
+	int i;
+
+	/* TODO add spinlock here? */
+	rwsem->initialized = 1;
+
+	for (i = 0; i < NR_CPUS; i++) {
+		rt_mutex_init(&rwsem->lock[i].lock);
+		__rt_rwsem_init(&rwsem->lock[i],
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+				rwsem->name, &rwsem->key[i]
+#else
+				"", 0
+#endif
+			);
+	}
+}
+
+#define initialize_rwsem(rwsem)				\
+	do {						\
+		if (unlikely(!rwsem->initialized))	\
+			__initialize_rwsem(rwsem);	\
+	} while (0)
+
 void  rt_up_write(struct rw_semaphore *rwsem)
 {
-	rwsem_release(&rwsem->dep_map, 1, _RET_IP_);
-	rt_mutex_unlock(&rwsem->lock);
+	int i;
+
+	for_each_possible_cpu(i) {
+		rwsem_release(&rwsem->lock[i].dep_map, 1, _RET_IP_);
+		rt_mutex_unlock(&rwsem->lock[i].lock);
+	}
 }
 EXPORT_SYMBOL(rt_up_write);
 
 void  rt_up_read(struct rw_semaphore *rwsem)
 {
-	rwsem_release(&rwsem->dep_map, 1, _RET_IP_);
-	if (--rwsem->read_depth == 0)
-		rt_mutex_unlock(&rwsem->lock);
+	int cpu;
+
+	cpu = smp_processor_id();
+	rwsem_release(&rwsem->lock[cpu].dep_map, 1, _RET_IP_);
+	if (--rwsem->lock[cpu].read_depth == 0) {
+		rt_mutex_unlock(&rwsem->lock[cpu].lock);
+		migrate_enable();
+	}
 }
 EXPORT_SYMBOL(rt_up_read);
 
@@ -327,67 +361,112 @@ EXPORT_SYMBOL(rt_up_read);
  */
 void  rt_downgrade_write(struct rw_semaphore *rwsem)
 {
-	BUG_ON(rt_mutex_owner(&rwsem->lock) != current);
-	rwsem->read_depth = 1;
+	int cpu;
+	int i;
+
+	migrate_disable();
+	cpu = smp_processor_id();
+	for_each_possible_cpu(i) {
+		if (cpu == i) {
+			BUG_ON(rt_mutex_owner(&rwsem->lock[i].lock) != current);
+			rwsem->lock[i].read_depth = 1;
+		} else {
+			rwsem_release(&rwsem->lock[i].dep_map, 1, _RET_IP_);
+			rt_mutex_unlock(&rwsem->lock[i].lock);
+		}
+	}
 }
 EXPORT_SYMBOL(rt_downgrade_write);
 
 int  rt_down_write_trylock(struct rw_semaphore *rwsem)
 {
-	int ret = rt_mutex_trylock(&rwsem->lock);
+	int ret;
+	int i;
 
-	if (ret)
-		rwsem_acquire(&rwsem->dep_map, 0, 1, _RET_IP_);
-	return ret;
+	initialize_rwsem(rwsem);
+
+	for_each_possible_cpu(i) {
+		ret = rt_mutex_trylock(&rwsem->lock[i].lock);
+		if (ret)
+			rwsem_acquire(&rwsem->lock[i].dep_map, 0, 1, _RET_IP_);
+		else
+			goto release;
+	}
+	return 1;
+ release:
+	while (--i >= 0) {
+		rwsem_release(&rwsem->lock[i].dep_map, 1, _RET_IP_);
+		rt_mutex_unlock(&rwsem->lock[i].lock);
+	}
+	return 0;
 }
 EXPORT_SYMBOL(rt_down_write_trylock);
 
 void  rt_down_write(struct rw_semaphore *rwsem)
 {
-	rwsem_acquire(&rwsem->dep_map, 0, 0, _RET_IP_);
-	rt_mutex_lock(&rwsem->lock);
+	int i;
+	initialize_rwsem(rwsem);
+	for_each_possible_cpu(i) {
+		rwsem_acquire(&rwsem->lock[i].dep_map, 0, 0, _RET_IP_);
+		rt_mutex_lock(&rwsem->lock[i].lock);
+	}
 }
 EXPORT_SYMBOL(rt_down_write);
 
 void  rt_down_write_nested(struct rw_semaphore *rwsem, int subclass)
 {
-	rwsem_acquire(&rwsem->dep_map, subclass, 0, _RET_IP_);
-	rt_mutex_lock(&rwsem->lock);
+	int i;
+
+	initialize_rwsem(rwsem);
+	for_each_possible_cpu(i) {
+		rwsem_acquire(&rwsem->lock[i].dep_map, subclass, 0, _RET_IP_);
+		rt_mutex_lock(&rwsem->lock[i].lock);
+	}
 }
 EXPORT_SYMBOL(rt_down_write_nested);
 
 int  rt_down_read_trylock(struct rw_semaphore *rwsem)
 {
-	struct rt_mutex *lock = &rwsem->lock;
+	struct rt_mutex *lock;
 	int ret = 1;
+	int cpu;
 
+	initialize_rwsem(rwsem);
+	migrate_disable();
+	cpu = smp_processor_id();
+	lock = &rwsem->lock[cpu].lock;
 	/*
 	 * recursive read locks succeed when current owns the rwsem,
 	 * but not when read_depth == 0 which means that the rwsem is
 	 * write locked.
 	 */
 	if (rt_mutex_owner(lock) != current)
-		ret = rt_mutex_trylock(&rwsem->lock);
-	else if (!rwsem->read_depth)
+		ret = rt_mutex_trylock(lock);
+	else if (!rwsem->lock[cpu].read_depth)
 		ret = 0;
 
 	if (ret) {
-		rwsem->read_depth++;
-		rwsem_acquire(&rwsem->dep_map, 0, 1, _RET_IP_);
-	}
+		rwsem->lock[cpu].read_depth++;
+		rwsem_acquire(&rwsem->lock[cpu].dep_map, 0, 1, _RET_IP_);
+	} else
+		migrate_enable();
 	return ret;
 }
 EXPORT_SYMBOL(rt_down_read_trylock);
 
 static void __rt_down_read(struct rw_semaphore *rwsem, int subclass)
 {
-	struct rt_mutex *lock = &rwsem->lock;
+	struct rt_mutex *lock;
+	int cpu;
 
-	rwsem_acquire_read(&rwsem->dep_map, subclass, 0, _RET_IP_);
+	migrate_disable();
+	cpu = smp_processor_id();
+	lock = &rwsem->lock[cpu].lock;
+	rwsem_acquire_read(&rwsem->lock[cpu].dep_map, subclass, 0, _RET_IP_);
 
 	if (rt_mutex_owner(lock) != current)
-		rt_mutex_lock(&rwsem->lock);
-	rwsem->read_depth++;
+		rt_mutex_lock(lock);
+	rwsem->lock[cpu].read_depth++;
 }
 
 void  rt_down_read(struct rw_semaphore *rwsem)
@@ -402,7 +481,7 @@ void  rt_down_read_nested(struct rw_semaphore *rwsem, int subclass)
 }
 EXPORT_SYMBOL(rt_down_read_nested);
 
-void  __rt_rwsem_init(struct rw_semaphore *rwsem, char *name,
+void  __rt_rwsem_init(struct __rw_semaphore *rwsem, char *name,
 			      struct lock_class_key *key)
 {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC


