Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab0JMIbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 04:31:45 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62436 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab0JMIbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 04:31:43 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
        h.mitake@gmail.com, Dmitry Torokhov <dtor@mail.ru>,
        Vojtech Pavlik <vojtech@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2] lockdep: check the depth of subclass
Date: Wed, 13 Oct 2010 17:30:26 +0900
Message-Id: <1286958626-986-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <4CB56A43.9040706@dcl.info.waseda.ac.jp>
References: <4CB56A43.9040706@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current look_up_lock_class() doesn't check the parameter "subclass".
This rarely rises problems because the main caller of this function,
register_lock_class(), checks it.
But register_lock_class() is not the only function which calls
look_up_lock_class(). lock_set_class() and its callees also call it.
And lock_set_class() doesn't check this parameter.

This will rise problems when the the value of subclass is larger than
MAX_LOCKDEP_SUBCLASSES. Because the address (used as the key of class)
caliculated with too large subclass has a possibility to point
another key in different lock_class_key.
Of course this problem depends on the memory layout and
occurs with really low possibility.

And mousedev_create() calles lockdep_set_subclass() and
sets class of mousedev->mutex as MOUSEDEV_MIX(== 31).
And if my understanding is correct,
this subclass doesn't have to be MOUSEDEV_MIX,
so I modified this value to SINGLE_DEPTH_NESTING.

v2: Based on Peter Zijlstra's advice, I removed the
checking of the subclass value from __lock_acquire().
Because this is already a redundant thing.

# If you need devided version for mousedev.c and lockdep.c,
# feel free to tell me.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Vojtech Pavlik <vojtech@ucw.cz>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 drivers/input/mousedev.c |    2 +-
 kernel/lockdep.c         |   18 ++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index d528a2d..9897334 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -866,7 +866,7 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
 	spin_lock_init(&mousedev->client_lock);
 	mutex_init(&mousedev->mutex);
 	lockdep_set_subclass(&mousedev->mutex,
-			     minor == MOUSEDEV_MIX ? MOUSEDEV_MIX : 0);
+			     minor == MOUSEDEV_MIX ? SINGLE_DEPTH_NESTING : 0);
 	init_waitqueue_head(&mousedev->wait);
 
 	if (minor == MOUSEDEV_MIX)
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 84baa71..553d410 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -639,6 +639,16 @@ look_up_lock_class(struct lockdep_map *lock, unsigned int subclass)
 	}
 #endif
 
+	if (unlikely(subclass >= MAX_LOCKDEP_SUBCLASSES)) {
+		debug_locks_off();
+		printk(KERN_ERR
+			"BUG: looking up invalid subclass: %u\n", subclass);
+		printk(KERN_ERR
+			"turning off the locking correctness validator.\n");
+		dump_stack();
+		return NULL;
+	}
+
 	/*
 	 * Static locks do not have their class-keys yet - for them the key
 	 * is the lock object itself:
@@ -2739,14 +2749,6 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return 0;
 
-	if (unlikely(subclass >= MAX_LOCKDEP_SUBCLASSES)) {
-		debug_locks_off();
-		printk("BUG: MAX_LOCKDEP_SUBCLASSES too low!\n");
-		printk("turning off the locking correctness validator.\n");
-		dump_stack();
-		return 0;
-	}
-
 	if (lock->key == &__lockdep_no_validate__)
 		check = 1;
 
-- 
1.6.5.2

