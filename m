Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab0IGOfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:35:09 -0400
Received: from www.tglx.de ([62.245.132.106]:43980 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297Ab0IGOeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:34:19 -0400
Message-Id: <20100907125057.562399240@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:34:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: [patch 30/30] semaphore: Remove mutex emulation
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=sema-remove-mutex-hack.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Semaphores used as mutexes have been deprecated for years. Now that
all users are either converted to real semaphores or to mutexes remove
the cruft.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/semaphore.h |    6 ------
 scripts/checkpatch.pl     |    8 ++------
 2 files changed, 2 insertions(+), 12 deletions(-)

Index: linux-2.6/include/linux/semaphore.h
===================================================================
--- linux-2.6.orig/include/linux/semaphore.h
+++ linux-2.6/include/linux/semaphore.h
@@ -29,9 +29,6 @@ struct semaphore {
 #define DEFINE_SEMAPHORE(name)	\
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
 
-#define DECLARE_MUTEX(name)	\
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
-
 static inline void sema_init(struct semaphore *sem, int val)
 {
 	static struct lock_class_key __key;
@@ -39,9 +36,6 @@ static inline void sema_init(struct sema
 	lockdep_init_map(&sem->lock.dep_map, "semaphore->lock", &__key, 0);
 }
 
-#define init_MUTEX(sem)		sema_init(sem, 1)
-#define init_MUTEX_LOCKED(sem)	sema_init(sem, 0)
-
 extern void down(struct semaphore *sem);
 extern int __must_check down_interruptible(struct semaphore *sem);
 extern int __must_check down_killable(struct semaphore *sem);
Index: linux-2.6/scripts/checkpatch.pl
===================================================================
--- linux-2.6.orig/scripts/checkpatch.pl
+++ linux-2.6/scripts/checkpatch.pl
@@ -2701,12 +2701,8 @@ sub process {
 			WARN("__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
 		}
 
-# check for semaphores used as mutexes
-		if ($line =~ /^.\s*(DECLARE_MUTEX|init_MUTEX)\s*\(/) {
-			WARN("mutexes are preferred for single holder semaphores\n" . $herecurr);
-		}
-# check for semaphores used as mutexes
-		if ($line =~ /^.\s*init_MUTEX_LOCKED\s*\(/) {
+# check for semaphores initialized locked
+		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
 			WARN("consider using a completion\n" . $herecurr);
 
 		}


