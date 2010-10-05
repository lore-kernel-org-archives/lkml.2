Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab0JEJ0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 05:26:52 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:64579 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab0JEJ0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 05:26:51 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Oct 2010 05:26:51 EDT
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
        h.mitake@gmail.com, Dmitry Torokhov <dtor@mail.ru>,
        Vojtech Pavlik <vojtech@ucw.cz>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] lockdep: check the depth of subclass
Date: Tue,  5 Oct 2010 18:01:50 +0900
Message-Id: <1286269311-28336-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current look_up_lock_class() doesn't check the parameter "subclass".
This rarely rises problems because the main caller of this function,
register_lock_class(), checks it.
But register_lock_class() is not the only function which calls
look_up_lock_class(). lock_set_class() and its callees also call it.
And lock_set_class() doesn't check this parameter.

This will rise problems when the the value of subclass is larger
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

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Vojtech Pavlik <vojtech@ucw.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 drivers/input/mousedev.c |    2 +-
 kernel/lockdep.c         |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 1 deletions(-)

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
index 84baa71..c4c13ae 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -639,6 +639,21 @@ look_up_lock_class(struct lockdep_map *lock, unsigned int subclass)
 	}
 #endif
 
+	if (unlikely(subclass >= MAX_LOCKDEP_SUBCLASSES)) {
+		/*
+		 * This check should be done not only in __lock_acquire()
+		 * but also here. Because register_lock_class() is also called
+		 * by lock_set_class(). Callers of lock_set_class() can
+		 * pass invalid value as subclass.
+		 */
+
+		debug_locks_off();
+		printk(KERN_ERR "BUG: looking up invalid subclass: %u\n", subclass);
+		printk(KERN_ERR "turning off the locking correctness validator.\n");
+		dump_stack();
+		return NULL;
+	}
+
 	/*
 	 * Static locks do not have their class-keys yet - for them the key
 	 * is the lock object itself:
-- 
1.6.5.2

