Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0J3KQy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 06:16:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:44026 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab0J3KQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 06:16:52 -0400
Date: Sat, 30 Oct 2010 10:16:39 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, hch@infradead.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, hch@infradead.org
In-Reply-To: <20100907125057.562399240@linutronix.de>
References: <20100907125057.562399240@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] semaphore: Remove mutex emulation
Message-ID: <tip-4882720b267b7b1d1b0ce08334b205f0329d4615@git.kernel.org>
Git-Commit-ID: 4882720b267b7b1d1b0ce08334b205f0329d4615
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 30 Oct 2010 10:16:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4882720b267b7b1d1b0ce08334b205f0329d4615
Gitweb:     http://git.kernel.org/tip/4882720b267b7b1d1b0ce08334b205f0329d4615
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Sep 2010 14:34:01 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 30 Oct 2010 12:12:50 +0200

semaphore: Remove mutex emulation

Semaphores used as mutexes have been deprecated for years. Now that
all users are either converted to real semaphores or to mutexes remove
the cruft.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
LKML-Reference: <20100907125057.562399240@linutronix.de>

---
 include/linux/semaphore.h |    6 ------
 scripts/checkpatch.pl     |    8 ++------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
index 5310d27..39fa049 100644
--- a/include/linux/semaphore.h
+++ b/include/linux/semaphore.h
@@ -29,9 +29,6 @@ struct semaphore {
 #define DEFINE_SEMAPHORE(name)	\
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
 
-#define DECLARE_MUTEX(name)	\
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
-
 static inline void sema_init(struct semaphore *sem, int val)
 {
 	static struct lock_class_key __key;
@@ -39,9 +36,6 @@ static inline void sema_init(struct semaphore *sem, int val)
 	lockdep_init_map(&sem->lock.dep_map, "semaphore->lock", &__key, 0);
 }
 
-#define init_MUTEX(sem)		sema_init(sem, 1)
-#define init_MUTEX_LOCKED(sem)	sema_init(sem, 0)
-
 extern void down(struct semaphore *sem);
 extern int __must_check down_interruptible(struct semaphore *sem);
 extern int __must_check down_killable(struct semaphore *sem);
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 90b54d4..e3c7fc0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2794,12 +2794,8 @@ sub process {
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
