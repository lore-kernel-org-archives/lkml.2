Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab0CSAht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 20:37:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:45690 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab0CSAhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 20:37:48 -0400
Subject: [PATCH] lockdep: Add novalidate class for dev->mutex conversion
From: Peter Zijlstra <peterz@infradead.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: tglx <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Mar 2010 01:37:42 +0100
Message-ID: <1268959062.9440.467.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's a FWD of the patch Thomas send you, you might want to put the
first hunk into your dev->sem to mutex patch so that you can reverse
these two patches in order.

-------- Forwarded Message --------

Subject: lockdep: Add novalidate class for dev->mutex conversion
From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 18 Feb 2010 10:37:53 +0100

The conversion of device->sem to device->mutex resulted in lockdep
warnings. Create a novalidate class for now until the driver folks
come up with separate classes. That way we have at least the basic
mutex debugging coverage.

Add a checkpatch error so the usage is reserved for device->mutex.

[ tglx: checkpatch and compile fix for LOCKDEP=n ]

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/base/core.c     |    1 +
 include/linux/lockdep.h |    8 ++++++++
 kernel/lockdep.c        |    5 +++++
 scripts/checkpatch.pl   |   11 +++++++++++
 4 files changed, 25 insertions(+)

Index: linux-2.6-tip/drivers/base/core.c
===================================================================
--- linux-2.6-tip.orig/drivers/base/core.c
+++ linux-2.6-tip/drivers/base/core.c
@@ -565,6 +565,7 @@ void device_initialize(struct device *de
 	kobject_init(&dev->kobj, &device_ktype);
 	INIT_LIST_HEAD(&dev->dma_pools);
 	mutex_init(&dev->mutex);
+	lockdep_set_novalidate_class(&dev->mutex);
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
 	device_init_wakeup(dev, 0);
Index: linux-2.6-tip/include/linux/lockdep.h
===================================================================
--- linux-2.6-tip.orig/include/linux/lockdep.h
+++ linux-2.6-tip/include/linux/lockdep.h
@@ -40,6 +40,8 @@ struct lock_class_key {
 	struct lockdep_subclass_key	subkeys[MAX_LOCKDEP_SUBCLASSES];
 };
 
+extern struct lock_class_key __lockdep_no_validate__;
+
 #define LOCKSTAT_POINTS		4
 
 /*
@@ -266,6 +268,9 @@ extern void lockdep_init_map(struct lock
 #define lockdep_set_subclass(lock, sub)	\
 		lockdep_init_map(&(lock)->dep_map, #lock, \
 				 (lock)->dep_map.key, sub)
+
+#define lockdep_set_novalidate_class(lock) \
+	lockdep_set_class(lock, &__lockdep_no_validate__)
 /*
  * Compare locking classes
  */
@@ -350,6 +355,9 @@ static inline void lockdep_on(void)
 #define lockdep_set_class_and_subclass(lock, key, sub) \
 		do { (void)(key); } while (0)
 #define lockdep_set_subclass(lock, sub)		do { } while (0)
+
+#define lockdep_set_novalidate_class(lock) do { } while (0)
+
 /*
  * We don't define lockdep_match_class() and lockdep_match_key() for !LOCKDEP
  * case since the result is not well defined and the caller should rather
Index: linux-2.6-tip/kernel/lockdep.c
===================================================================
--- linux-2.6-tip.orig/kernel/lockdep.c
+++ linux-2.6-tip/kernel/lockdep.c
@@ -2716,6 +2716,8 @@ void lockdep_init_map(struct lockdep_map
 }
 EXPORT_SYMBOL_GPL(lockdep_init_map);
 
+struct lock_class_key __lockdep_no_validate__;
+
 /*
  * This gets called for every mutex_lock*()/spin_lock*() operation.
  * We maintain the dependency maps and validate the locking attempt:
@@ -2750,6 +2752,9 @@ static int __lock_acquire(struct lockdep
 		return 0;
 	}
 
+	if (lock->key == &__lockdep_no_validate__)
+		check = 1;
+
 	if (!subclass)
 		class = lock->class_cache;
 	/*
Index: linux-2.6-tip/scripts/checkpatch.pl
===================================================================
--- linux-2.6-tip.orig/scripts/checkpatch.pl
+++ linux-2.6-tip/scripts/checkpatch.pl
@@ -2625,6 +2625,7 @@ sub process {
 # check for semaphores used as mutexes
 		if ($line =~ /^.\s*init_MUTEX_LOCKED\s*\(/) {
 			WARN("consider using a completion\n" . $herecurr);
+
 		}
 # recommend strict_strto* over simple_strto*
 		if ($line =~ /\bsimple_(strto.*?)\s*\(/) {
@@ -2672,6 +2673,16 @@ sub process {
 				WARN("use of in_atomic() is incorrect outside core kernel code\n" . $herecurr);
 			}
 		}
+
+# check for lockdep_set_novalidate_class
+		if ($line =~ /^.\s*lockdep_set_novalidate_class\s*\(/ ||
+		    $line =~ /__lockdep_no_validate__\s*\)/ ) {
+			if ($realfile !~ m@^kernel/lockdep@ &&
+			    $realfile !~ m@^include/linux/lockdep@ &&
+			    $realfile !~ m@^drivers/base/core@) {
+				ERROR("lockdep_no_validate class is reserved for device->mutex.\n" . $herecurr);
+			}
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on


