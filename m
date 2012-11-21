Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab2KUMjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:39:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:35215 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab2KUMjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:39:14 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH] tty: don't dead while flushing workqueue
Date: Wed, 21 Nov 2012 13:39:02 +0100
Message-Id: <1353501542-14707-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 89c8d91e31f2 ("tty: localise the lock") I see a dead lock
in one of my dummy_hcd + g_nokia test cases. The first run one was usually
okay, the second often resulted in a splat by lockdep and the third was
usually a dead lock.
Lockdep complained about tty->hangup_work and tty->legacy_mutex taken
both ways:
| ======================================================
| [ INFO: possible circular locking dependency detected ]
| 3.7.0-rc6+ #204 Not tainted
| -------------------------------------------------------
| kworker/2:1/35 is trying to acquire lock:
|  (&tty->legacy_mutex){+.+.+.}, at: [<c14051e6>] tty_lock_nested+0x36/0x80
|
| but task is already holding lock:
|  ((&tty->hangup_work)){+.+...}, at: [<c104f6e4>] process_one_work+0x124/0x5e0
|
| which lock already depends on the new lock.
|
| the existing dependency chain (in reverse order) is:
|
| -> #2 ((&tty->hangup_work)){+.+...}:
|        [<c107fe74>] lock_acquire+0x84/0x190
|        [<c104d82d>] flush_work+0x3d/0x240
|        [<c12e6986>] tty_ldisc_flush_works+0x16/0x30
|        [<c12e7861>] tty_ldisc_release+0x21/0x70
|        [<c12e0dfc>] tty_release+0x35c/0x470
|        [<c1105e28>] __fput+0xd8/0x270
|        [<c1105fcd>] ____fput+0xd/0x10
|        [<c1051dd9>] task_work_run+0xb9/0xf0
|        [<c1002a51>] do_notify_resume+0x51/0x80
|        [<c140550a>] work_notifysig+0x35/0x3b
|
| -> #1 (&tty->legacy_mutex/1){+.+...}:
|        [<c107fe74>] lock_acquire+0x84/0x190
|        [<c140276c>] mutex_lock_nested+0x6c/0x2f0
|        [<c14051e6>] tty_lock_nested+0x36/0x80
|        [<c1405279>] tty_lock_pair+0x29/0x70
|        [<c12e0bb8>] tty_release+0x118/0x470
|        [<c1105e28>] __fput+0xd8/0x270
|        [<c1105fcd>] ____fput+0xd/0x10
|        [<c1051dd9>] task_work_run+0xb9/0xf0
|        [<c1002a51>] do_notify_resume+0x51/0x80
|        [<c140550a>] work_notifysig+0x35/0x3b
|
| -> #0 (&tty->legacy_mutex){+.+.+.}:
|        [<c107f3c9>] __lock_acquire+0x1189/0x16a0
|        [<c107fe74>] lock_acquire+0x84/0x190
|        [<c140276c>] mutex_lock_nested+0x6c/0x2f0
|        [<c14051e6>] tty_lock_nested+0x36/0x80
|        [<c140523f>] tty_lock+0xf/0x20
|        [<c12df8e4>] __tty_hangup+0x54/0x410
|        [<c12dfcb2>] do_tty_hangup+0x12/0x20
|        [<c104f763>] process_one_work+0x1a3/0x5e0
|        [<c104fec9>] worker_thread+0x119/0x3a0
|        [<c1055084>] kthread+0x94/0xa0
|        [<c140ca37>] ret_from_kernel_thread+0x1b/0x28
|
|other info that might help us debug this:
|
|Chain exists of:
|  &tty->legacy_mutex --> &tty->legacy_mutex/1 --> (&tty->hangup_work)
|
| Possible unsafe locking scenario:
|
|       CPU0                    CPU1
|       ----                    ----
|  lock((&tty->hangup_work));
|                               lock(&tty->legacy_mutex/1);
|                               lock((&tty->hangup_work));
|  lock(&tty->legacy_mutex);
|
| *** DEADLOCK ***

Before the path mentioned tty_ldisc_release() look like this:

|	tty_ldisc_halt(tty);
|	tty_ldisc_flush_works(tty);
|	tty_lock();

As it can be seen, it first flushes the workqueue and then grabs the
tty_lock. Now we grab the lock first:

|	tty_lock_pair(tty, o_tty);
|	tty_ldisc_halt(tty);
|	tty_ldisc_flush_works(tty);

so lockdep's complaint seems valid.

The other user of tty_ldisc_flush_works() is tty_set_ldisc() and I tried
to mimnic its logic:
- grab tty lock
- grab ldisc_mutex lock
- release the tty lock
- call tty_ldisc_halt()
- release ldisc_mutex
- call tty_ldisc_flush_works()
The code under tty_ldisc_kill() was executed earlier with the tty lock
taken so it is taken again.

I don't see any problems in my testcase.

Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/tty_ldisc.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 0f2a2c5..fb76818 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -930,16 +930,21 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	 */
 
 	tty_lock_pair(tty, o_tty);
+	mutex_lock(&tty->ldisc_mutex);
+	tty_unlock_pair(tty, o_tty);
+
 	tty_ldisc_halt(tty);
-	tty_ldisc_flush_works(tty);
-	if (o_tty) {
+	if (o_tty)
 		tty_ldisc_halt(o_tty);
+	mutex_unlock(&tty->ldisc_mutex);
+
+	tty_ldisc_flush_works(tty);
+	if (o_tty)
 		tty_ldisc_flush_works(o_tty);
-	}
 
+	tty_lock_pair(tty, o_tty);
 	/* This will need doing differently if we need to lock */
 	tty_ldisc_kill(tty);
-
 	if (o_tty)
 		tty_ldisc_kill(o_tty);
 
-- 
1.7.10.4

