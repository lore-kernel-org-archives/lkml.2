Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0ICHOC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:14:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:44469 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab0ICHN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:13:59 -0400
Date: Fri, 3 Sep 2010 07:13:31 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rusty@rustcorp.com.au, tglx@linutronix.de, randy.dunlap@oracle.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, tglx@linutronix.de, randy.dunlap@oracle.com,
        mingo@elte.hu
In-Reply-To: <20100902154816.6cc2f9ad.randy.dunlap@oracle.com>
References: <20100902154816.6cc2f9ad.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] mutex: Fix annotations to include it in kernel-locking docbook
Message-ID: <tip-ef5dc121d5a0bb1fa477c5395277259f07d318a3@git.kernel.org>
Git-Commit-ID: ef5dc121d5a0bb1fa477c5395277259f07d318a3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 07:13:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef5dc121d5a0bb1fa477c5395277259f07d318a3
Gitweb:     http://git.kernel.org/tip/ef5dc121d5a0bb1fa477c5395277259f07d318a3
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Thu, 2 Sep 2010 15:48:16 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Sep 2010 08:19:51 +0200

mutex: Fix annotations to include it in kernel-locking docbook

Fix kernel-doc notation in linux/mutex.h and kernel/mutex.c,
then add these 2 files to the kernel-locking docbook as the
Mutex API reference chapter.

Add one API function to mutex-design.txt and correct a typo in
that file.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <20100902154816.6cc2f9ad.randy.dunlap@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/DocBook/kernel-locking.tmpl |    6 ++++++
 Documentation/mutex-design.txt            |    3 ++-
 include/linux/mutex.h                     |    8 ++++++++
 kernel/mutex.c                            |   23 +++++++----------------
 4 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/Documentation/DocBook/kernel-locking.tmpl b/Documentation/DocBook/kernel-locking.tmpl
index 0b1a3f9..a0d479d 100644
--- a/Documentation/DocBook/kernel-locking.tmpl
+++ b/Documentation/DocBook/kernel-locking.tmpl
@@ -1961,6 +1961,12 @@ machines due to caching.
    </sect1>
   </chapter>
 
+  <chapter id="apiref">
+   <title>Mutex API reference</title>
+!Iinclude/linux/mutex.h
+!Ekernel/mutex.c
+  </chapter>
+
   <chapter id="references">
    <title>Further reading</title>
 
diff --git a/Documentation/mutex-design.txt b/Documentation/mutex-design.txt
index c91ccc0..38c10fd 100644
--- a/Documentation/mutex-design.txt
+++ b/Documentation/mutex-design.txt
@@ -9,7 +9,7 @@ firstly, there's nothing wrong with semaphores. But if the simpler
 mutex semantics are sufficient for your code, then there are a couple
 of advantages of mutexes:
 
- - 'struct mutex' is smaller on most architectures: .e.g on x86,
+ - 'struct mutex' is smaller on most architectures: E.g. on x86,
    'struct semaphore' is 20 bytes, 'struct mutex' is 16 bytes.
    A smaller structure size means less RAM footprint, and better
    CPU-cache utilization.
@@ -136,3 +136,4 @@ the APIs of 'struct mutex' have been streamlined:
  void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
  int  mutex_lock_interruptible_nested(struct mutex *lock,
                                       unsigned int subclass);
+ int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 878cab4..f363bc8 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -78,6 +78,14 @@ struct mutex_waiter {
 # include <linux/mutex-debug.h>
 #else
 # define __DEBUG_MUTEX_INITIALIZER(lockname)
+/**
+ * mutex_init - initialize the mutex
+ * @mutex: the mutex to be initialized
+ *
+ * Initialize the mutex to unlocked state.
+ *
+ * It is not allowed to initialize an already locked mutex.
+ */
 # define mutex_init(mutex) \
 do {							\
 	static struct lock_class_key __key;		\
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 4c0b7b3..200407c 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -36,15 +36,6 @@
 # include <asm/mutex.h>
 #endif
 
-/***
- * mutex_init - initialize the mutex
- * @lock: the mutex to be initialized
- * @key: the lock_class_key for the class; used by mutex lock debugging
- *
- * Initialize the mutex to unlocked state.
- *
- * It is not allowed to initialize an already locked mutex.
- */
 void
 __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 {
@@ -68,7 +59,7 @@ EXPORT_SYMBOL(__mutex_init);
 static __used noinline void __sched
 __mutex_lock_slowpath(atomic_t *lock_count);
 
-/***
+/**
  * mutex_lock - acquire the mutex
  * @lock: the mutex to be acquired
  *
@@ -105,7 +96,7 @@ EXPORT_SYMBOL(mutex_lock);
 
 static __used noinline void __sched __mutex_unlock_slowpath(atomic_t *lock_count);
 
-/***
+/**
  * mutex_unlock - release the mutex
  * @lock: the mutex to be released
  *
@@ -364,8 +355,8 @@ __mutex_lock_killable_slowpath(atomic_t *lock_count);
 static noinline int __sched
 __mutex_lock_interruptible_slowpath(atomic_t *lock_count);
 
-/***
- * mutex_lock_interruptible - acquire the mutex, interruptable
+/**
+ * mutex_lock_interruptible - acquire the mutex, interruptible
  * @lock: the mutex to be acquired
  *
  * Lock the mutex like mutex_lock(), and return 0 if the mutex has
@@ -456,15 +447,15 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
 	return prev == 1;
 }
 
-/***
- * mutex_trylock - try acquire the mutex, without waiting
+/**
+ * mutex_trylock - try to acquire the mutex, without waiting
  * @lock: the mutex to be acquired
  *
  * Try to acquire the mutex atomically. Returns 1 if the mutex
  * has been acquired successfully, and 0 on contention.
  *
  * NOTE: this function follows the spin_trylock() convention, so
- * it is negated to the down_trylock() return values! Be careful
+ * it is negated from the down_trylock() return values! Be careful
  * about this when converting semaphore users to mutexes.
  *
  * This function must not be used in interrupt context. The
