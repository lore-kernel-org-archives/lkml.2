Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab2LDHKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 02:10:11 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:52547 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751928Ab2LDHJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:09:12 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 7/9] tty: Strengthen no-subsequent-use guarantee of tty_ldisc_halt()
Date: Tue,  4 Dec 2012 02:07:43 -0500
Message-Id: <1354604865-10278-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
References: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for destructing and freeing the tty, the line discipline
must first be brought to an inactive state before it can be destructed.
This line discipline shutdown must:
 - disallow new users of the ldisc
 - wait for existing ldisc users to finish
 - only then, cancel/flush their pending/running work

Factor tty_ldisc_wait_idle() from tty_set_ldisc() and tty_ldisc_kill()
to ensure this shutdown order.

Failure to provide this guarantee can result in scheduled work
running after the tty has already been freed, as indicated in the
following log message:

[   88.331234] WARNING: at /home/peter/src/kernels/next/drivers/tty/tty_buffer.c:435 flush_to_ldisc+0x194/0x1d0()
[   88.334505] Hardware name: Bochs
[   88.335618] tty is bad=-1
[   88.335703] Modules linked in: netconsole configfs bnep rfcomm bluetooth ......
[   88.345272] Pid: 39, comm: kworker/1:1 Tainted: G        W    3.7.0-next-20121129+ttydebug-xeon #20121129+ttydebug
[   88.347736] Call Trace:
[   88.349024]  [<ffffffff81058aff>] warn_slowpath_common+0x7f/0xc0
[   88.350383]  [<ffffffff81058bf6>] warn_slowpath_fmt+0x46/0x50
[   88.351745]  [<ffffffff81432bd4>] flush_to_ldisc+0x194/0x1d0
[   88.353047]  [<ffffffff816f7fe1>] ? _raw_spin_unlock_irq+0x21/0x50
[   88.354190]  [<ffffffff8108a809>] ? finish_task_switch+0x49/0xe0
[   88.355436]  [<ffffffff81077ad1>] process_one_work+0x121/0x490
[   88.357674]  [<ffffffff81432a40>] ? __tty_buffer_flush+0x90/0x90
[   88.358954]  [<ffffffff81078c84>] worker_thread+0x164/0x3e0
[   88.360247]  [<ffffffff81078b20>] ? manage_workers+0x120/0x120
[   88.361282]  [<ffffffff8107e230>] kthread+0xc0/0xd0
[   88.362284]  [<ffffffff816f0000>] ? cmos_do_probe+0x2eb/0x3bf
[   88.363391]  [<ffffffff8107e170>] ? flush_kthread_worker+0xb0/0xb0
[   88.364797]  [<ffffffff816fff6c>] ret_from_fork+0x7c/0xb0
[   88.366087]  [<ffffffff8107e170>] ? flush_kthread_worker+0xb0/0xb0
[   88.367266] ---[ end trace 453a7c9f38fbfec0 ]---

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index c3dec37..9f4c7b0 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -528,24 +528,38 @@ static int tty_ldisc_wait_idle(struct tty_struct *tty, long timeout)
 /**
  *	tty_ldisc_halt		-	shut down the line discipline
  *	@tty: tty device
+ *	@pending: returns true if work was scheduled when cancelled
+ *		  (can be set to NULL)
+ *	@timeout: # of jiffies to wait for ldisc refs to be released
  *
  *	Shut down the line discipline and work queue for this tty device.
  *	The TTY_LDISC flag being cleared ensures no further references can
  *	be obtained while the delayed work queue halt ensures that no more
  *	data is fed to the ldisc.
  *
+ *	Furthermore, guarantee that existing ldisc references have been
+ *	released, which in turn, guarantees that no future buffer work
+ *	can be rescheduled.
+ *
  *	You need to do a 'flush_scheduled_work()' (outside the ldisc_mutex)
  *	in order to make sure any currently executing ldisc work is also
  *	flushed.
  */
 
-static int tty_ldisc_halt(struct tty_struct *tty)
+static int tty_ldisc_halt(struct tty_struct *tty, int *pending, long timeout)
 {
-	int scheduled;
+	int scheduled, retval;
+
 	clear_bit(TTY_LDISC, &tty->flags);
+	retval = tty_ldisc_wait_idle(tty, timeout);
+	if (retval)
+		return retval;
+
 	scheduled = cancel_work_sync(&tty->port->buf.work);
 	set_bit(TTY_LDISC_HALTED, &tty->flags);
-	return scheduled;
+	if (pending)
+		*pending = scheduled;
+	return 0;
 }
 
 /**
@@ -687,9 +701,9 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	 *	parallel to the change and re-referencing the tty.
 	 */
 
-	work = tty_ldisc_halt(tty);
+	retval = tty_ldisc_halt(tty, &work, 5 * HZ);
 	if (o_tty)
-		o_work = tty_ldisc_halt(o_tty);
+		tty_ldisc_halt(o_tty, &o_work, 0);
 
 	/*
 	 * Wait for ->hangup_work and ->buf.work handlers to terminate.
@@ -700,8 +714,6 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	tty_ldisc_flush_works(tty);
 
-	retval = tty_ldisc_wait_idle(tty, 5 * HZ);
-
 	tty_lock(tty);
 	mutex_lock(&tty->ldisc_mutex);
 
@@ -920,11 +932,6 @@ int tty_ldisc_setup(struct tty_struct *tty, struct tty_struct *o_tty)
 
 static void tty_ldisc_kill(struct tty_struct *tty)
 {
-	/* There cannot be users from userspace now. But there still might be
-	 * drivers holding a reference via tty_ldisc_ref. Do not steal them the
-	 * ldisc until they are done. */
-	tty_ldisc_wait_idle(tty, MAX_SCHEDULE_TIMEOUT);
-
 	mutex_lock(&tty->ldisc_mutex);
 	/*
 	 * Now kill off the ldisc
@@ -958,10 +965,10 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	 */
 
 	tty_lock_pair(tty, o_tty);
-	tty_ldisc_halt(tty);
+	tty_ldisc_halt(tty, NULL, MAX_SCHEDULE_TIMEOUT);
 	tty_ldisc_flush_works(tty);
 	if (o_tty) {
-		tty_ldisc_halt(o_tty);
+		tty_ldisc_halt(o_tty, NULL, MAX_SCHEDULE_TIMEOUT);
 		tty_ldisc_flush_works(o_tty);
 	}
 
-- 
1.8.0

