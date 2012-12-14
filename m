Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab2LNStR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:49:17 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:37184 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756687Ab2LNStO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:49:14 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilya Zykov <ilya@ilyx.ru>, Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 11/11] tty: Halt both ldiscs concurrently
Date: Fri, 14 Dec 2012 13:22:50 -0500
Message-Id: <1355509370-5883-12-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pty driver does not obtain an ldisc reference to the linked
tty when writing. When the ldiscs are sequentially halted, it
is possible for one ldisc to be halted, and before the second
ldisc can be halted, a concurrent write schedules buffer work on
the first ldisc. This can lead to an access-after-free error when
the scheduled buffer work starts on the closed ldisc.

Prevent subsequent use after halt by performing each stage
of the halt alternately the tty pair.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 19e088a..a6d3078 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -527,37 +527,53 @@ static int tty_ldisc_wait_idle(struct tty_struct *tty, long timeout)
 /**
  *	tty_ldisc_halt		-	shut down the line discipline
  *	@tty: tty device
+ *	@o_tty: paired pty device (can be NULL)
  *	@pending: returns true if work was scheduled when cancelled
  *		  (can be set to NULL)
+ *	@o_pending: returns true if work was scheduled when cancelled
+ *		    (can be set to NULL)
  *	@timeout: # of jiffies to wait for ldisc refs to be released
  *
- *	Shut down the line discipline and work queue for this tty device.
- *	The TTY_LDISC flag being cleared ensures no further references can
- *	be obtained while the delayed work queue halt ensures that no more
- *	data is fed to the ldisc.
+ *	Shut down the line discipline and work queue for this tty device and
+ *	its paired pty (if exists). Clearing the TTY_LDISC flag ensures
+ *	no further references can be obtained while the work queue halt
+ *	ensures that no more data is fed to the ldisc.
  *
  *	Furthermore, guarantee that existing ldisc references have been
  *	released, which in turn, guarantees that no future buffer work
  *	can be rescheduled.
  *
- *	You need to do a 'flush_scheduled_work()' (outside the ldisc_mutex)
+ *	You need to do a 'tty_ldisc_flush_works()' (outside the ldisc_mutex)
  *	in order to make sure any currently executing ldisc work is also
  *	flushed.
  */
 
-static int tty_ldisc_halt(struct tty_struct *tty, int *pending, long timeout)
+static int tty_ldisc_halt(struct tty_struct *tty, struct tty_struct *o_tty,
+			  int *pending, int *o_pending, long timeout)
 {
-	int scheduled, retval;
+	int scheduled, o_scheduled, retval;
 
 	clear_bit(TTY_LDISC, &tty->flags);
+	if (o_tty)
+		clear_bit(TTY_LDISC, &o_tty->flags);
+
 	retval = tty_ldisc_wait_idle(tty, timeout);
+	if (!retval && o_tty)
+		retval = tty_ldisc_wait_idle(o_tty, timeout);
 	if (retval)
 		return retval;
 
 	scheduled = cancel_work_sync(&tty->port->buf.work);
 	set_bit(TTY_LDISC_HALTED, &tty->flags);
+	if (o_tty) {
+		o_scheduled = cancel_work_sync(&o_tty->port->buf.work);
+		set_bit(TTY_LDISC_HALTED, &o_tty->flags);
+	}
+
 	if (pending)
 		*pending = scheduled;
+	if (o_tty && o_pending)
+		*o_pending = o_scheduled;
 	return 0;
 }
 
@@ -700,9 +716,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	 *	parallel to the change and re-referencing the tty.
 	 */
 
-	retval = tty_ldisc_halt(tty, &work, 5 * HZ);
-	if (o_tty)
-		tty_ldisc_halt(o_tty, &o_work, 0);
+	retval = tty_ldisc_halt(tty, o_tty, &work, &o_work, 5 * HZ);
 
 	/*
 	 * Wait for ->hangup_work and ->buf.work handlers to terminate.
@@ -964,12 +978,10 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	 */
 
 	tty_lock_pair(tty, o_tty);
-	tty_ldisc_halt(tty, NULL, MAX_SCHEDULE_TIMEOUT);
+	tty_ldisc_halt(tty, o_tty, NULL, NULL, MAX_SCHEDULE_TIMEOUT);
 	tty_ldisc_flush_works(tty);
-	if (o_tty) {
-		tty_ldisc_halt(o_tty, NULL, MAX_SCHEDULE_TIMEOUT);
+	if (o_tty)
 		tty_ldisc_flush_works(o_tty);
-	}
 
 	/* This will need doing differently if we need to lock */
 	tty_ldisc_kill(tty);
-- 
1.8.0.1

