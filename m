Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab2DKJPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:15:07 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:46542 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab2DKJPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:15:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 2/3] TTY: con3215, add tty_port
Date: Wed, 11 Apr 2012 11:14:58 +0200
Message-Id: <1334135699-30180-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1334135699-30180-1-git-send-email-jslaby@suse.cz>
References: <1334135699-30180-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And use flags from that. But first we have to get rid of duplicated
flag names. From now on, for the standard ones that are stored in
tty_port->flags, we use ASYNC_* ones.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/char/con3215.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 7e30f85..f7bc23b 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -20,6 +20,7 @@
 #include <linux/interrupt.h>
 #include <linux/err.h>
 #include <linux/reboot.h>
+#include <linux/serial.h> /* ASYNC_* flags */
 #include <linux/slab.h>
 #include <asm/ccwdev.h>
 #include <asm/cio.h>
@@ -44,14 +45,11 @@
 #define RAW3215_TIMEOUT	    HZ/10     /* time for delayed output */
 
 #define RAW3215_FIXED	    1	      /* 3215 console device is not be freed */
-#define RAW3215_ACTIVE	    2	      /* set if the device is in use */
 #define RAW3215_WORKING	    4	      /* set if a request is being worked on */
 #define RAW3215_THROTTLED   8	      /* set if reading is disabled */
 #define RAW3215_STOPPED	    16	      /* set if writing is disabled */
-#define RAW3215_CLOSING	    32	      /* set while in close process */
 #define RAW3215_TIMER_RUNS  64	      /* set if the output delay timer is on */
 #define RAW3215_FLUSHING    128	      /* set to flush buffer (no delay) */
-#define RAW3215_FROZEN	    256	      /* set if 3215 is frozen for suspend */
 
 #define TAB_STOP_SIZE	    8	      /* tab stop size */
 
@@ -76,6 +74,7 @@ struct raw3215_req {
 } __attribute__ ((aligned(8)));
 
 struct raw3215_info {
+	struct tty_port port;
 	struct ccw_device *cdev;      /* device for tty driver */
 	spinlock_t *lock;	      /* pointer to irq lock */
 	int flags;		      /* state flags */
@@ -293,7 +292,7 @@ static void raw3215_timeout(unsigned long __data)
 	if (raw->flags & RAW3215_TIMER_RUNS) {
 		del_timer(&raw->timer);
 		raw->flags &= ~RAW3215_TIMER_RUNS;
-		if (!(raw->flags & RAW3215_FROZEN)) {
+		if (!(raw->port.flags & ASYNC_SUSPENDED)) {
 			raw3215_mk_write_req(raw);
 			raw3215_start_io(raw);
 		}
@@ -309,7 +308,8 @@ static void raw3215_timeout(unsigned long __data)
  */
 static inline void raw3215_try_io(struct raw3215_info *raw)
 {
-	if (!(raw->flags & RAW3215_ACTIVE) || (raw->flags & RAW3215_FROZEN))
+	if (!(raw->port.flags & ASYNC_INITIALIZED) ||
+			(raw->port.flags & ASYNC_SUSPENDED))
 		return;
 	if (raw->queued_read != NULL)
 		raw3215_start_io(raw);
@@ -484,7 +484,7 @@ static void raw3215_make_room(struct raw3215_info *raw, unsigned int length)
 		/* While console is frozen for suspend we have no other
 		 * choice but to drop message from the buffer to make
 		 * room for even more messages. */
-		if (raw->flags & RAW3215_FROZEN) {
+		if (raw->port.flags & ASYNC_SUSPENDED) {
 			raw3215_drop_line(raw);
 			continue;
 		}
@@ -606,10 +606,10 @@ static int raw3215_startup(struct raw3215_info *raw)
 {
 	unsigned long flags;
 
-	if (raw->flags & RAW3215_ACTIVE)
+	if (raw->port.flags & ASYNC_INITIALIZED)
 		return 0;
 	raw->line_pos = 0;
-	raw->flags |= RAW3215_ACTIVE;
+	raw->port.flags |= ASYNC_INITIALIZED;
 	spin_lock_irqsave(get_ccwdev_lock(raw->cdev), flags);
 	raw3215_try_io(raw);
 	spin_unlock_irqrestore(get_ccwdev_lock(raw->cdev), flags);
@@ -625,14 +625,15 @@ static void raw3215_shutdown(struct raw3215_info *raw)
 	DECLARE_WAITQUEUE(wait, current);
 	unsigned long flags;
 
-	if (!(raw->flags & RAW3215_ACTIVE) || (raw->flags & RAW3215_FIXED))
+	if (!(raw->port.flags & ASYNC_INITIALIZED) ||
+			(raw->flags & RAW3215_FIXED))
 		return;
 	/* Wait for outstanding requests, then free irq */
 	spin_lock_irqsave(get_ccwdev_lock(raw->cdev), flags);
 	if ((raw->flags & RAW3215_WORKING) ||
 	    raw->queued_write != NULL ||
 	    raw->queued_read != NULL) {
-		raw->flags |= RAW3215_CLOSING;
+		raw->port.flags |= ASYNC_CLOSING;
 		add_wait_queue(&raw->empty_wait, &wait);
 		set_current_state(TASK_INTERRUPTIBLE);
 		spin_unlock_irqrestore(get_ccwdev_lock(raw->cdev), flags);
@@ -640,7 +641,7 @@ static void raw3215_shutdown(struct raw3215_info *raw)
 		spin_lock_irqsave(get_ccwdev_lock(raw->cdev), flags);
 		remove_wait_queue(&raw->empty_wait, &wait);
 		set_current_state(TASK_RUNNING);
-		raw->flags &= ~(RAW3215_ACTIVE | RAW3215_CLOSING);
+		raw->port.flags &= ~(ASYNC_INITIALIZED | ASYNC_CLOSING);
 	}
 	spin_unlock_irqrestore(get_ccwdev_lock(raw->cdev), flags);
 }
@@ -663,6 +664,7 @@ static struct raw3215_info *raw3215_alloc_info(void)
 	setup_timer(&info->timer, raw3215_timeout, (unsigned long)info);
 	init_waitqueue_head(&info->empty_wait);
 	tasklet_init(&info->tlet, raw3215_wakeup, (unsigned long)info);
+	tty_port_init(&info->port);
 
 	return info;
 }
@@ -752,7 +754,7 @@ static int raw3215_pm_stop(struct ccw_device *cdev)
 	raw = dev_get_drvdata(&cdev->dev);
 	spin_lock_irqsave(get_ccwdev_lock(raw->cdev), flags);
 	raw3215_make_room(raw, RAW3215_BUFFER_SIZE);
-	raw->flags |= RAW3215_FROZEN;
+	raw->port.flags |= ASYNC_SUSPENDED;
 	spin_unlock_irqrestore(get_ccwdev_lock(raw->cdev), flags);
 	return 0;
 }
@@ -765,7 +767,7 @@ static int raw3215_pm_start(struct ccw_device *cdev)
 	/* Allow I/O again and flush output buffer. */
 	raw = dev_get_drvdata(&cdev->dev);
 	spin_lock_irqsave(get_ccwdev_lock(raw->cdev), flags);
-	raw->flags &= ~RAW3215_FROZEN;
+	raw->port.flags &= ~ASYNC_SUSPENDED;
 	raw->flags |= RAW3215_FLUSHING;
 	raw3215_try_io(raw);
 	raw->flags &= ~RAW3215_FLUSHING;
@@ -838,7 +840,7 @@ static void con3215_flush(void)
 	unsigned long flags;
 
 	raw = raw3215[0];  /* console 3215 is the first one */
-	if (raw->flags & RAW3215_FROZEN)
+	if (raw->port.flags & ASYNC_SUSPENDED)
 		/* The console is still frozen for suspend. */
 		if (ccw_device_force_console())
 			/* Forcing didn't work, no panic message .. */
-- 
1.7.9.2


