Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977Ab0EVCjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 22:39:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26979 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab0EVCjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 22:39:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:date:message-id:user-agent:mime-version:
	content-type:content-transfer-encoding:x-system-of-record;
	b=xGRNzbaIhPru5K5zOPCiYhek5cMJo7Wa2o+X74hfPddKpaVfVMGfI0ksDq+fmhe3g
	79j8iKnf8A9q+mCgsWDfA==
Subject: [PATCH] Introduce a config option that introduces a bias in favour of
	writers in rwlocks
To: peterz@infradead.org, akpm@linux-foundation.org, mingo@infradead.org,
       linux-kernel@vger.kernel.org
From: Salman <sqazi@google.com>
Date: Fri, 21 May 2010 19:38:46 -0700
Message-ID: <20100522023744.16767.81170.stgit@bumblebee1.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If one or more readers are holding the lock, and one or more writers
are contending for it, then do not admit any new readers.  However,
if a writer is holding a lock, then let readers contend for it at
equal footing with the writers.

This fixes a pathological case (see the code below), where the
tasklist_lock is continuously held by the readers, and the writers starve.

The change does not introduce any unexpected test failures in the locking
self-test.  Furthermore, it makes the original problem go away.  In
particular, after the change, the following code can run without
causing a lockup:

void *thread_code(void *args)
{
	int j;
	int pid2;
	for (j = 0; j < 1000; j++) {
		pid2 = fork();
		if (pid2 == 0)
			while(1) { sleep(1000); }
	}

	while (1) {
		int status;
		if (waitpid(-1, &status, WNOHANG)) {
			printf("! %d\n", errno);
		}

	}
	exit(0);

}

/*
 * non-blocking waitpids in tight loop, with many children to go through,
 * done on multiple thread, so that they can "pass the torch" to eachother
 * and eliminate the window that a writer has to get in.
 *
 * This maximizes the holding of the tasklist_lock in read mode, starving
 * any attempts to take the lock in the write mode.
 */
int main(int argc, char **argv)
{
	int i;
	pthread_attr_t attr;
	pthread_t threads[NUM_CPUS];
	for (i = 0; i < NUM_CPUS; i++) {
		assert(!pthread_attr_init(&attr));
		assert(!pthread_create(&threads[i], &attr, thread_code));
	}
	while(1) { sleep(1000);}
	return 0;
}

Signed-off-by: "Salman Qazi" <sqazi@google.com>
---
 arch/x86/include/asm/spinlock.h       |   29 ++++++++++++++++++++++++++++-
 arch/x86/include/asm/spinlock_types.h |    9 ++++++++-
 lib/Kconfig                           |   11 +++++++++++
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 3089f70..e05045b 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -234,7 +234,11 @@ static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
  */
 static inline int arch_read_can_lock(arch_rwlock_t *lock)
 {
+#ifdef CONFIG_RWLOCK_WRBIAS
+	return ((int)(lock)->lock > 0) && (!(lock)->writers_contending);
+#else
 	return (int)(lock)->lock > 0;
+#endif
 }
 
 /**
@@ -248,7 +252,15 @@ static inline int arch_write_can_lock(arch_rwlock_t *lock)
 
 static inline void arch_read_lock(arch_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX " subl $1,(%0)\n\t"
+	asm volatile(
+#ifdef CONFIG_RWLOCK_WRBIAS
+		     "cmpl $0, (%0)\n\t"
+		     "jbe 3f\n\t"
+		     "2: pause\n\t"
+		     "cmpl $0, 0x04(%0)\n\t"
+		     "jne 2b\n\t"
+#endif
+		     "3 :" LOCK_PREFIX " subl $1,(%0)\n\t"
 		     "jns 1f\n"
 		     "call __read_lock_failed\n\t"
 		     "1:\n"
@@ -259,7 +271,13 @@ static inline void arch_write_lock(arch_rwlock_t *rw)
 {
 	asm volatile(LOCK_PREFIX " subl %1,(%0)\n\t"
 		     "jz 1f\n"
+#ifdef CONFIG_RWLOCK_WRBIAS
+		     LOCK_PREFIX " incl 0x04(%0)\n\t"
+#endif
 		     "call __write_lock_failed\n\t"
+#ifdef CONFIG_RWLOCK_WRBIAS
+		     LOCK_PREFIX " decl 0x04(%0)\n\t"
+#endif
 		     "1:\n"
 		     ::LOCK_PTR_REG (rw), "i" (RW_LOCK_BIAS) : "memory");
 }
@@ -268,6 +286,15 @@ static inline int arch_read_trylock(arch_rwlock_t *lock)
 {
 	atomic_t *count = (atomic_t *)lock;
 
+#ifdef CONFIG_RWLOCK_WRBIAS
+
+	/* If there are writers contending but a writer doesn't have the lock
+	 * then we shouldn't take it.
+	 */
+	if ((lock->writers_contending) && (atomic_read(count) > 0))
+		return 0;
+#endif
+
 	if (atomic_dec_return(count) >= 0)
 		return 1;
 	atomic_inc(count);
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index dcb48b2..22908be 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -13,8 +13,15 @@ typedef struct arch_spinlock {
 
 typedef struct {
 	unsigned int lock;
+#ifdef CONFIG_RWLOCK_WRBIAS
+	unsigned int writers_contending;
+#endif
 } arch_rwlock_t;
 
-#define __ARCH_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
+#ifdef CONFIG_RWLOCK_WRBIAS
+ #define __ARCH_RW_LOCK_UNLOCKED                { RW_LOCK_BIAS, 0 }
+#else
+ #define __ARCH_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
+#endif
 
 #endif /* _ASM_X86_SPINLOCK_TYPES_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index 170d8ca..ca1cf79 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -210,4 +210,15 @@ config GENERIC_ATOMIC64
 config LRU_CACHE
 	tristate
 
+config RWLOCK_WRBIAS
+	boolean
+	help
+	  Introduce a config option that introduces a bias in favour of writers
+	  in the readers-writer lock as follows:
+	  if one or more readers are holding the lock, and one or more writers
+	  are contending for it, then do not admit any new readers.  However,
+	  if a writer is holding a lock, then let readers contend for it at
+	  equal footing with the writers.
+	default y
+
 endmenu

