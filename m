Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab2LDHL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 02:11:26 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:38734 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751793Ab2LDHJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:09:00 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 4/9] tty: Refactor wait for ldisc refs out of tty_ldisc_hangup()
Date: Tue,  4 Dec 2012 02:07:40 -0500
Message-Id: <1354604865-10278-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
References: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor tty_ldisc_hangup() to extract standalone function,
tty_ldisc_hangup_wait_idle(), to wait for ldisc references
to be released.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 54 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index f986bb0..6c1d8aa 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -549,6 +549,41 @@ static int tty_ldisc_halt(struct tty_struct *tty)
 }
 
 /**
+ *	tty_ldisc_hangup_wait_idle - wait for the ldisc to become idle
+ *	@tty: tty to wait for
+ *
+ *	Wait for the line discipline to become idle. The discipline must
+ *	have been halted for this to guarantee it remains idle.
+ *
+ *	Caller must hold legacy and ->ldisc_mutex.
+ */
+static bool tty_ldisc_hangup_wait_idle(struct tty_struct *tty)
+{
+	while (tty->ldisc) {	/* Not yet closed */
+		if (atomic_read(&tty->ldisc->users) != 1) {
+			char cur_n[TASK_COMM_LEN], tty_n[64];
+			long timeout = 3 * HZ;
+			tty_unlock(tty);
+
+			while (tty_ldisc_wait_idle(tty, timeout) == -EBUSY) {
+				timeout = MAX_SCHEDULE_TIMEOUT;
+				printk_ratelimited(KERN_WARNING
+					"%s: waiting (%s) for %s took too long, but we keep waiting...\n",
+					__func__, get_task_comm(cur_n, current),
+					tty_name(tty, tty_n));
+			}
+			/* must reacquire both locks and preserve lock order */
+			mutex_unlock(&tty->ldisc_mutex);
+			tty_lock(tty);
+			mutex_lock(&tty->ldisc_mutex);
+			continue;
+		}
+		break;
+	}
+	return !!(tty->ldisc);
+}
+
+/**
  *	tty_set_ldisc		-	set line discipline
  *	@tty: the terminal to set
  *	@ldisc: the line discipline
@@ -824,7 +859,6 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	cancel_work_sync(&tty->port->buf.work);
 	set_bit(TTY_LDISC_HALTED, &tty->flags);
 	mutex_unlock(&tty->ldisc_mutex);
-retry:
 	tty_lock(tty);
 	mutex_lock(&tty->ldisc_mutex);
 
@@ -832,23 +866,7 @@ retry:
 	   reopen it. We could defer this to the next open but
 	   it means auditing a lot of other paths so this is
 	   a FIXME */
-	if (tty->ldisc) {	/* Not yet closed */
-		if (atomic_read(&tty->ldisc->users) != 1) {
-			char cur_n[TASK_COMM_LEN], tty_n[64];
-			long timeout = 3 * HZ;
-			tty_unlock(tty);
-
-			while (tty_ldisc_wait_idle(tty, timeout) == -EBUSY) {
-				timeout = MAX_SCHEDULE_TIMEOUT;
-				printk_ratelimited(KERN_WARNING
-					"%s: waiting (%s) for %s took too long, but we keep waiting...\n",
-					__func__, get_task_comm(cur_n, current),
-					tty_name(tty, tty_n));
-			}
-			mutex_unlock(&tty->ldisc_mutex);
-			goto retry;
-		}
-
+	if (tty_ldisc_hangup_wait_idle(tty)) {
 		if (reset == 0) {
 
 			if (!tty_ldisc_reinit(tty, tty->termios.c_line))
-- 
1.8.0

