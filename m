Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab2LDHIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 02:08:54 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:59565 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750980Ab2LDHIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:08:52 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 2/9] tty: Add diagnostic for halted line discipline
Date: Tue,  4 Dec 2012 02:07:38 -0500
Message-Id: <1354604865-10278-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
References: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flip buffer work must not be scheduled after the line discipline
has been halted; issue warning.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c      |  6 ++++++
 drivers/tty/tty_buffer.c |  3 +++
 drivers/tty/tty_ldisc.c  | 45 +++++++++++++++++++++++++--------------------
 include/linux/tty.h      |  1 +
 4 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 19083ef..3f704a9 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -152,6 +152,12 @@ static void n_tty_set_room(struct tty_struct *tty)
 	if (left && !old_left) {
 		WARN_RATELIMIT(tty->port->itty == NULL,
 				"scheduling with invalid itty\n");
+		/* see if ldisc has been killed - if so, this means that
+		 * even though the ldisc has been halted and ->buf.work
+		 * cancelled, ->buf.work is about to be rescheduled
+		 */
+		WARN_RATELIMIT(test_bit(TTY_LDISC_HALTED, &tty->flags),
+			       "scheduling buffer work for halted ldisc\n");
 		schedule_work(&tty->port->buf.work);
 	}
 }
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index cc9cbcf..d8d6f77 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -520,6 +520,9 @@ void tty_flip_buffer_push(struct tty_struct *tty)
 	struct tty_bufhead *buf = &tty->port->buf;
 	unsigned long flags;
 
+	WARN_RATELIMIT(test_bit(TTY_LDISC_HALTED, &tty->flags),
+		       "scheduling buffer work for halted ldisc\n");
+
 	spin_lock_irqsave(&buf->lock, flags);
 	if (buf->tail != NULL)
 		buf->tail->commit = buf->tail->used;
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index c578229..f986bb0 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -373,6 +373,7 @@ static inline void tty_ldisc_put(struct tty_ldisc *ld)
 
 void tty_ldisc_enable(struct tty_struct *tty)
 {
+	clear_bit(TTY_LDISC_HALTED, &tty->flags);
 	set_bit(TTY_LDISC, &tty->flags);
 	clear_bit(TTY_LDISC_CHANGING, &tty->flags);
 	wake_up(&tty_ldisc_wait);
@@ -496,26 +497,6 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
 }
 
 /**
- *	tty_ldisc_halt		-	shut down the line discipline
- *	@tty: tty device
- *
- *	Shut down the line discipline and work queue for this tty device.
- *	The TTY_LDISC flag being cleared ensures no further references can
- *	be obtained while the delayed work queue halt ensures that no more
- *	data is fed to the ldisc.
- *
- *	You need to do a 'flush_scheduled_work()' (outside the ldisc_mutex)
- *	in order to make sure any currently executing ldisc work is also
- *	flushed.
- */
-
-static int tty_ldisc_halt(struct tty_struct *tty)
-{
-	clear_bit(TTY_LDISC, &tty->flags);
-	return cancel_work_sync(&tty->port->buf.work);
-}
-
-/**
  *	tty_ldisc_flush_works	-	flush all works of a tty
  *	@tty: tty device to flush works for
  *
@@ -545,6 +526,29 @@ static int tty_ldisc_wait_idle(struct tty_struct *tty, long timeout)
 }
 
 /**
+ *	tty_ldisc_halt		-	shut down the line discipline
+ *	@tty: tty device
+ *
+ *	Shut down the line discipline and work queue for this tty device.
+ *	The TTY_LDISC flag being cleared ensures no further references can
+ *	be obtained while the delayed work queue halt ensures that no more
+ *	data is fed to the ldisc.
+ *
+ *	You need to do a 'flush_scheduled_work()' (outside the ldisc_mutex)
+ *	in order to make sure any currently executing ldisc work is also
+ *	flushed.
+ */
+
+static int tty_ldisc_halt(struct tty_struct *tty)
+{
+	int scheduled;
+	clear_bit(TTY_LDISC, &tty->flags);
+	scheduled = cancel_work_sync(&tty->port->buf.work);
+	set_bit(TTY_LDISC_HALTED, &tty->flags);
+	return scheduled;
+}
+
+/**
  *	tty_set_ldisc		-	set line discipline
  *	@tty: the terminal to set
  *	@ldisc: the line discipline
@@ -818,6 +822,7 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	clear_bit(TTY_LDISC, &tty->flags);
 	tty_unlock(tty);
 	cancel_work_sync(&tty->port->buf.work);
+	set_bit(TTY_LDISC_HALTED, &tty->flags);
 	mutex_unlock(&tty->ldisc_mutex);
 retry:
 	tty_lock(tty);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 8db1b56..e6b968d 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -314,6 +314,7 @@ struct tty_file_private {
 #define TTY_NO_WRITE_SPLIT 	17	/* Preserve write boundaries to driver */
 #define TTY_HUPPED 		18	/* Post driver->hangup() */
 #define TTY_HUPPING 		21	/* ->hangup() in progress */
+#define TTY_LDISC_HALTED	22	/* Line discipline is halted */
 
 #define TTY_WRITE_FLUSH(tty) tty_write_flush((tty))
 
-- 
1.8.0

