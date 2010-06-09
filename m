Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab0FISyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:54:43 -0400
Received: from suva.vyatta.com ([76.74.103.44]:59654 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758200Ab0FISyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:54:22 -0400
X-Greylist: delayed 867 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2010 14:54:17 EDT
Message-Id: <20100609183626.205751245@vyatta.com>
User-Agent: quilt/0.48-1
Date: Wed, 09 Jun 2010 11:34:56 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] floppy: use wait_event_interruptible
References: <20100609183449.110905403@vyatta.com>
Content-Disposition: inline; filename=floppy-wait-event.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert wait loops to use wait_event_ macros.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/drivers/block/floppy.c	2010-06-09 11:34:11.326812498 -0700
+++ b/drivers/block/floppy.c	2010-06-09 11:34:12.416645239 -0700
@@ -514,8 +514,6 @@ static unsigned long fdc_busy;
 static DECLARE_WAIT_QUEUE_HEAD(fdc_wait);
 static DECLARE_WAIT_QUEUE_HEAD(command_done);
 
-#define NO_SIGNAL (!interruptible || !signal_pending(current))
-
 /* Errors during formatting are counted here. */
 static int format_errors;
 
@@ -858,36 +856,15 @@ static void set_fdc(int drive)
 }
 
 /* locks the driver */
-static int _lock_fdc(int drive, bool interruptible, int line)
+static int lock_fdc(int drive, bool interruptible)
 {
-	if (atomic_read(&usage_count) == 0) {
-		pr_err("Trying to lock fdc while usage count=0 at line %d\n",
-		       line);
+	if (WARN(atomic_read(&usage_count) == 0,
+		 "Trying to lock fdc while usage count=0\n"))
 		return -1;
-	}
 
-	if (test_and_set_bit(0, &fdc_busy)) {
-		DECLARE_WAITQUEUE(wait, current);
-		add_wait_queue(&fdc_wait, &wait);
-
-		for (;;) {
-			set_current_state(TASK_INTERRUPTIBLE);
-
-			if (!test_and_set_bit(0, &fdc_busy))
-				break;
-
-			schedule();
-
-			if (!NO_SIGNAL) {
-				remove_wait_queue(&fdc_wait, &wait);
-				return -EINTR;
-			}
-		}
+	if (wait_event_interruptible(fdc_wait, !test_and_set_bit(0, &fdc_busy)))
+		return -EINTR;
 
-		set_current_state(TASK_RUNNING);
-		remove_wait_queue(&fdc_wait, &wait);
-		flush_scheduled_work();
-	}
 	command_status = FD_COMMAND_NONE;
 
 	__reschedule_timeout(drive, "lock fdc");
@@ -895,9 +872,6 @@ static int _lock_fdc(int drive, bool int
 	return 0;
 }
 
-#define lock_fdc(drive, interruptible)			\
-	_lock_fdc(drive, interruptible, __LINE__)
-
 /* unlocks the driver */
 static void unlock_fdc(void)
 {
@@ -2015,25 +1989,10 @@ static int wait_til_done(void (*handler)
 
 	schedule_bh(handler);
 
-	if (command_status < 2 && NO_SIGNAL) {
-		DECLARE_WAITQUEUE(wait, current);
-
-		add_wait_queue(&command_done, &wait);
-		for (;;) {
-			set_current_state(interruptible ?
-					  TASK_INTERRUPTIBLE :
-					  TASK_UNINTERRUPTIBLE);
-
-			if (command_status >= 2 || !NO_SIGNAL)
-				break;
-
-			is_alive(__func__, "");
-			schedule();
-		}
-
-		set_current_state(TASK_RUNNING);
-		remove_wait_queue(&command_done, &wait);
-	}
+	if (interruptible)
+		wait_event_interruptible(command_done, command_status >= 2);
+	else
+		wait_event(command_done, command_status >= 2);
 
 	if (command_status < 2) {
 		cancel_activity();


