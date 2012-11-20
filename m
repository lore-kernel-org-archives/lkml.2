Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab2KTJXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:23:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab2KTJXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:23:44 -0500
From: Lukas Czerner <lczerner@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com,
        akpm@linux-foundation.org, Lukas Czerner <lczerner@redhat.com>,
        Neil Brown <neilb@suse.de>, David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] wait: add wait_event_lock_irq() interface
Date: Tue, 20 Nov 2012 10:23:04 +0100
Message-Id: <1353403385-735-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New wait_event_lock_irq{,cmd} macros added. This commit moves the
private wait_event_lock_irq() macro from MD to regular wait includes,
introduces new macro wait_event_lock_irq_cmd() instead of using the old
method with omitting cmd parameter which is ugly and makes a use of new
macros in the MD.

The use of new interface is when one have a special lock to protect data
structures used in the condition, or one also needs to invoke "cmd"
before putting it to sleep.

Both new macros are expected to be called with the lock taken. The lock
is released before sleep and reacquired afterwards. We will leave the
macro with the lock held.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: Neil Brown <neilb@suse.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 drivers/md/md.c      |    2 +-
 drivers/md/md.h      |   26 -----------------
 drivers/md/raid1.c   |   15 ++++-----
 drivers/md/raid10.c  |   15 ++++-----
 drivers/md/raid5.c   |   12 +++----
 include/linux/wait.h |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 96 insertions(+), 50 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9ab768a..7e513a3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -452,7 +452,7 @@ void md_flush_request(struct mddev *mddev, struct bio *bio)
 	spin_lock_irq(&mddev->write_lock);
 	wait_event_lock_irq(mddev->sb_wait,
 			    !mddev->flush_bio,
-			    mddev->write_lock, /*nothing*/);
+			    mddev->write_lock);
 	mddev->flush_bio = bio;
 	spin_unlock_irq(&mddev->write_lock);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index af443ab..1e2fc3d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -551,32 +551,6 @@ struct md_thread {
 
 #define THREAD_WAKEUP  0
 
-#define __wait_event_lock_irq(wq, condition, lock, cmd) 		\
-do {									\
-	wait_queue_t __wait;						\
-	init_waitqueue_entry(&__wait, current);				\
-									\
-	add_wait_queue(&wq, &__wait);					\
-	for (;;) {							\
-		set_current_state(TASK_UNINTERRUPTIBLE);		\
-		if (condition)						\
-			break;						\
-		spin_unlock_irq(&lock);					\
-		cmd;							\
-		schedule();						\
-		spin_lock_irq(&lock);					\
-	}								\
-	current->state = TASK_RUNNING;					\
-	remove_wait_queue(&wq, &__wait);				\
-} while (0)
-
-#define wait_event_lock_irq(wq, condition, lock, cmd) 			\
-do {									\
-	if (condition)	 						\
-		break;							\
-	__wait_event_lock_irq(wq, condition, lock, cmd);		\
-} while (0)
-
 static inline void safe_put_page(struct page *p)
 {
 	if (p) put_page(p);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 636bae0..f264a62 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -822,7 +822,7 @@ static void raise_barrier(struct r1conf *conf)
 
 	/* Wait until no block IO is waiting */
 	wait_event_lock_irq(conf->wait_barrier, !conf->nr_waiting,
-			    conf->resync_lock, );
+			    conf->resync_lock);
 
 	/* block any new IO from starting */
 	conf->barrier++;
@@ -830,7 +830,7 @@ static void raise_barrier(struct r1conf *conf)
 	/* Now wait for all pending IO to complete */
 	wait_event_lock_irq(conf->wait_barrier,
 			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
-			    conf->resync_lock, );
+			    conf->resync_lock);
 
 	spin_unlock_irq(&conf->resync_lock);
 }
@@ -864,8 +864,7 @@ static void wait_barrier(struct r1conf *conf)
 				    (conf->nr_pending &&
 				     current->bio_list &&
 				     !bio_list_empty(current->bio_list)),
-				    conf->resync_lock,
-			);
+				    conf->resync_lock);
 		conf->nr_waiting--;
 	}
 	conf->nr_pending++;
@@ -898,10 +897,10 @@ static void freeze_array(struct r1conf *conf)
 	spin_lock_irq(&conf->resync_lock);
 	conf->barrier++;
 	conf->nr_waiting++;
-	wait_event_lock_irq(conf->wait_barrier,
-			    conf->nr_pending == conf->nr_queued+1,
-			    conf->resync_lock,
-			    flush_pending_writes(conf));
+	wait_event_lock_irq_cmd(conf->wait_barrier,
+				conf->nr_pending == conf->nr_queued+1,
+				conf->resync_lock,
+				flush_pending_writes(conf));
 	spin_unlock_irq(&conf->resync_lock);
 }
 static void unfreeze_array(struct r1conf *conf)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d1295af..2530403 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -952,7 +952,7 @@ static void raise_barrier(struct r10conf *conf, int force)
 
 	/* Wait until no block IO is waiting (unless 'force') */
 	wait_event_lock_irq(conf->wait_barrier, force || !conf->nr_waiting,
-			    conf->resync_lock, );
+			    conf->resync_lock);
 
 	/* block any new IO from starting */
 	conf->barrier++;
@@ -960,7 +960,7 @@ static void raise_barrier(struct r10conf *conf, int force)
 	/* Now wait for all pending IO to complete */
 	wait_event_lock_irq(conf->wait_barrier,
 			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
-			    conf->resync_lock, );
+			    conf->resync_lock);
 
 	spin_unlock_irq(&conf->resync_lock);
 }
@@ -993,8 +993,7 @@ static void wait_barrier(struct r10conf *conf)
 				    (conf->nr_pending &&
 				     current->bio_list &&
 				     !bio_list_empty(current->bio_list)),
-				    conf->resync_lock,
-			);
+				    conf->resync_lock);
 		conf->nr_waiting--;
 	}
 	conf->nr_pending++;
@@ -1027,10 +1026,10 @@ static void freeze_array(struct r10conf *conf)
 	spin_lock_irq(&conf->resync_lock);
 	conf->barrier++;
 	conf->nr_waiting++;
-	wait_event_lock_irq(conf->wait_barrier,
-			    conf->nr_pending == conf->nr_queued+1,
-			    conf->resync_lock,
-			    flush_pending_writes(conf));
+	wait_event_lock_irq_cmd(conf->wait_barrier,
+				conf->nr_pending == conf->nr_queued+1,
+				conf->resync_lock,
+				flush_pending_writes(conf));
 
 	spin_unlock_irq(&conf->resync_lock);
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c5439dc..2bf617d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -466,7 +466,7 @@ get_active_stripe(struct r5conf *conf, sector_t sector,
 	do {
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    conf->quiesce == 0 || noquiesce,
-				    conf->device_lock, /* nothing */);
+				    conf->device_lock);
 		sh = __find_stripe(conf, sector, conf->generation - previous);
 		if (!sh) {
 			if (!conf->inactive_blocked)
@@ -480,8 +480,7 @@ get_active_stripe(struct r5conf *conf, sector_t sector,
 						    (atomic_read(&conf->active_stripes)
 						     < (conf->max_nr_stripes *3/4)
 						     || !conf->inactive_blocked),
-						    conf->device_lock,
-						    );
+						    conf->device_lock);
 				conf->inactive_blocked = 0;
 			} else
 				init_stripe(sh, sector, previous);
@@ -1646,8 +1645,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		spin_lock_irq(&conf->device_lock);
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    !list_empty(&conf->inactive_list),
-				    conf->device_lock,
-				    );
+				    conf->device_lock);
 		osh = get_free_stripe(conf);
 		spin_unlock_irq(&conf->device_lock);
 		atomic_set(&nsh->count, 1);
@@ -4000,7 +3998,7 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 		spin_lock_irq(&conf->device_lock);
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    conf->quiesce == 0,
-				    conf->device_lock, /* nothing */);
+				    conf->device_lock);
 		atomic_inc(&conf->active_aligned_reads);
 		spin_unlock_irq(&conf->device_lock);
 
@@ -6088,7 +6086,7 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    atomic_read(&conf->active_stripes) == 0 &&
 				    atomic_read(&conf->active_aligned_reads) == 0,
-				    conf->device_lock, /* nothing */);
+				    conf->device_lock);
 		conf->quiesce = 1;
 		spin_unlock_irq(&conf->device_lock);
 		/* allow reshape to continue */
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 168dfe1..96ed02a 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -550,6 +550,82 @@ do {									\
 	__ret;								\
 })
 
+#define __wait_event_lock_irq(wq, condition, lock, cmd) 		\
+do {									\
+	wait_queue_t __wait;						\
+	init_waitqueue_entry(&__wait, current);				\
+									\
+	add_wait_queue(&wq, &__wait);					\
+	for (;;) {							\
+		set_current_state(TASK_UNINTERRUPTIBLE);		\
+		if (condition)						\
+			break;						\
+		spin_unlock_irq(&lock);					\
+		cmd;							\
+		schedule();						\
+		spin_lock_irq(&lock);					\
+	}								\
+	current->state = TASK_RUNNING;					\
+	remove_wait_queue(&wq, &__wait);				\
+} while (0)
+
+/**
+ * wait_event_lock_irq_cmd - sleep until a condition gets true. The
+ * 			     condition is checked under the lock. This
+ * 			     is expected to be called with the lock
+ * 			     taken.
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @lock: a locked lock, which will be released before cmd and schedule()
+ * 	  and reacquired afterwards.
+ * @cmd: a command which is invoked outside the critical section before
+ *       sleep
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * This is supposed to be called with holding the lock. The lock is
+ * dropped before invoking the cmd and going to sleep and reacquired
+ * afterwards.
+ */
+#define wait_event_lock_irq_cmd(wq, condition, lock, cmd) 		\
+do {									\
+	if (condition)	 						\
+		break;							\
+	__wait_event_lock_irq(wq, condition, lock, cmd);		\
+} while (0)
+
+/**
+ * wait_event_lock_irq - sleep until a condition gets true. The
+ * 			 condition is checked under the lock. This
+ * 			 is expected to be called with the lock
+ * 			 taken.
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @lock: a locked lock, which will be released before schedule()
+ * 	  and reacquired afterwards.
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * This is supposed to be called with holding the lock. The lock is
+ * dropped before going to sleep and reacquired afterwards.
+ */
+#define wait_event_lock_irq(wq, condition, lock) 			\
+do {									\
+	if (condition)	 						\
+		break;							\
+	__wait_event_lock_irq(wq, condition, lock, );			\
+} while (0)
+
 /*
  * These are the old interfaces to sleep waiting for an event.
  * They are racy.  DO NOT use them, use the wait_event* interfaces above.
-- 
1.7.7.6

