Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934276Ab0EUQyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:54:38 -0400
Received: from kroah.org ([198.145.64.141]:39098 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934231Ab0EUQyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:19 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/38] lockdep: Add novalidate class for dev->mutex conversion
Date: Fri, 21 May 2010 09:53:41 -0700
Message-Id: <1274460848-11377-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

The conversion of device->sem to device->mutex resulted in lockdep
warnings. Create a novalidate class for now until the driver folks
come up with separate classes. That way we have at least the basic
mutex debugging coverage.

Add a checkpatch error so the usage is reserved for device->mutex.

[ tglx: checkpatch and compile fix for LOCKDEP=n ]

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c     |    1 +
 include/linux/lockdep.h |    8 ++++++++
 kernel/lockdep.c        |    5 +++++
 scripts/checkpatch.pl   |   11 +++++++++++
 4 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index cf507a7..4c5be85 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -559,6 +559,7 @@ void device_initialize(struct device *dev)
 	kobject_init(&dev->kobj, &device_ktype);
 	INIT_LIST_HEAD(&dev->dma_pools);
 	mutex_init(&dev->mutex);
+	lockdep_set_novalidate_class(&dev->mutex);
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
 	device_pm_init(dev);
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index a03977a..06aed83 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -44,6 +44,8 @@ struct lock_class_key {
 	struct lockdep_subclass_key	subkeys[MAX_LOCKDEP_SUBCLASSES];
 };
 
+extern struct lock_class_key __lockdep_no_validate__;
+
 #define LOCKSTAT_POINTS		4
 
 /*
@@ -270,6 +272,9 @@ extern void lockdep_init_map(struct lockdep_map *lock, const char *name,
 #define lockdep_set_subclass(lock, sub)	\
 		lockdep_init_map(&(lock)->dep_map, #lock, \
 				 (lock)->dep_map.key, sub)
+
+#define lockdep_set_novalidate_class(lock) \
+	lockdep_set_class(lock, &__lockdep_no_validate__)
 /*
  * Compare locking classes
  */
@@ -354,6 +359,9 @@ static inline void lockdep_on(void)
 #define lockdep_set_class_and_subclass(lock, key, sub) \
 		do { (void)(key); } while (0)
 #define lockdep_set_subclass(lock, sub)		do { } while (0)
+
+#define lockdep_set_novalidate_class(lock) do { } while (0)
+
 /*
  * We don't define lockdep_match_class() and lockdep_match_key() for !LOCKDEP
  * case since the result is not well defined and the caller should rather
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index ec21304..5428679 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2711,6 +2711,8 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 }
 EXPORT_SYMBOL_GPL(lockdep_init_map);
 
+struct lock_class_key __lockdep_no_validate__;
+
 /*
  * This gets called for every mutex_lock*()/spin_lock*() operation.
  * We maintain the dependency maps and validate the locking attempt:
@@ -2745,6 +2747,9 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		return 0;
 	}
 
+	if (lock->key == &__lockdep_no_validate__)
+		check = 1;
+
 	if (!subclass)
 		class = lock->class_cache;
 	/*
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a4d7434..f2bbea9 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2656,6 +2656,7 @@ sub process {
 # check for semaphores used as mutexes
 		if ($line =~ /^.\s*init_MUTEX_LOCKED\s*\(/) {
 			WARN("consider using a completion\n" . $herecurr);
+
 		}
 # recommend strict_strto* over simple_strto*
 		if ($line =~ /\bsimple_(strto.*?)\s*\(/) {
@@ -2740,6 +2741,16 @@ sub process {
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
-- 
1.7.0.3

