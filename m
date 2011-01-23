Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab1AWPRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:17:49 -0500
Received: from www.tglx.de ([62.245.132.106]:58733 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab1AWPRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:17:46 -0500
Message-Id: <20110123143837.697467914@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 23 Jan 2011 15:17:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 9/9] locking: Remove deprecated lock initializers
References: <20110123143631.392446736@linutronix.de>
Content-Disposition: inline;
	filename=locking-remove-deprecated-lock-initializers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last users are gone. Remove the leftovers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/spinlocks.txt    |   24 +-----------------------
 include/linux/rwlock_types.h   |    8 --------
 include/linux/spinlock_types.h |    8 --------
 scripts/checkpatch.pl          |    5 -----
 4 files changed, 1 insertion(+), 44 deletions(-)

Index: linux-2.6/Documentation/spinlocks.txt
===================================================================
--- linux-2.6.orig/Documentation/spinlocks.txt
+++ linux-2.6/Documentation/spinlocks.txt
@@ -86,7 +86,7 @@ to change the variables it has to get an
 
 The routines look the same as above:
 
-   rwlock_t xxx_lock = RW_LOCK_UNLOCKED;
+   rwlock_t xxx_lock = __RW_LOCK_UNLOCKED(xxx_lock);
 
 	unsigned long flags;
 
@@ -196,25 +196,3 @@ appropriate:
 
 For static initialization, use DEFINE_SPINLOCK() / DEFINE_RWLOCK() or
 __SPIN_LOCK_UNLOCKED() / __RW_LOCK_UNLOCKED() as appropriate.
-
-SPIN_LOCK_UNLOCKED and RW_LOCK_UNLOCKED are deprecated.  These interfere
-with lockdep state tracking.
-
-Most of the time, you can simply turn:
-	static spinlock_t xxx_lock = SPIN_LOCK_UNLOCKED;
-into:
-	static DEFINE_SPINLOCK(xxx_lock);
-
-Static structure member variables go from:
-
-	struct foo bar {
-		.lock	=	SPIN_LOCK_UNLOCKED;
-	};
-
-to:
-
-	struct foo bar {
-		.lock	=	__SPIN_LOCK_UNLOCKED(bar.lock);
-	};
-
-Declaration of static rw_locks undergo a similar transformation.
Index: linux-2.6/include/linux/rwlock_types.h
===================================================================
--- linux-2.6.orig/include/linux/rwlock_types.h
+++ linux-2.6/include/linux/rwlock_types.h
@@ -43,14 +43,6 @@ typedef struct {
 				RW_DEP_MAP_INIT(lockname) }
 #endif
 
-/*
- * RW_LOCK_UNLOCKED defeat lockdep state tracking and is hence
- * deprecated.
- *
- * Please use DEFINE_RWLOCK() or __RW_LOCK_UNLOCKED() as appropriate.
- */
-#define RW_LOCK_UNLOCKED	__RW_LOCK_UNLOCKED(old_style_rw_init)
-
 #define DEFINE_RWLOCK(x)	rwlock_t x = __RW_LOCK_UNLOCKED(x)
 
 #endif /* __LINUX_RWLOCK_TYPES_H */
Index: linux-2.6/include/linux/spinlock_types.h
===================================================================
--- linux-2.6.orig/include/linux/spinlock_types.h
+++ linux-2.6/include/linux/spinlock_types.h
@@ -81,14 +81,6 @@ typedef struct spinlock {
 #define __SPIN_LOCK_UNLOCKED(lockname) \
 	(spinlock_t ) __SPIN_LOCK_INITIALIZER(lockname)
 
-/*
- * SPIN_LOCK_UNLOCKED defeats lockdep state tracking and is hence
- * deprecated.
- * Please use DEFINE_SPINLOCK() or __SPIN_LOCK_UNLOCKED() as
- * appropriate.
- */
-#define SPIN_LOCK_UNLOCKED	__SPIN_LOCK_UNLOCKED(old_style_spin_init)
-
 #define DEFINE_SPINLOCK(x)	spinlock_t x = __SPIN_LOCK_UNLOCKED(x)
 
 #include <linux/rwlock_types.h>
Index: linux-2.6/scripts/checkpatch.pl
===================================================================
--- linux-2.6.orig/scripts/checkpatch.pl
+++ linux-2.6/scripts/checkpatch.pl
@@ -2654,11 +2654,6 @@ sub process {
 			WARN("Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n" . $herecurr);
 		}
 
-# SPIN_LOCK_UNLOCKED & RW_LOCK_UNLOCKED are deprecated
-		if ($line =~ /\b(SPIN_LOCK_UNLOCKED|RW_LOCK_UNLOCKED)/) {
-			ERROR("Use of $1 is deprecated: see Documentation/spinlocks.txt\n" . $herecurr);
-		}
-
 # warn about #if 0
 		if ($line =~ /^.\s*\#\s*if\s+0\b/) {
 			CHK("if this code is redundant consider removing it\n" .


