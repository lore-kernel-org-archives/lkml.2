Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0EOVAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:00:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49618 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab0EOVAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:00:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 07/10] tty: reorder ldisc locking
Date: Sat, 15 May 2010 22:59:53 +0200
Message-Id: <1273957196-13768-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273957196-13768-1-git-send-email-arnd@arndb.de>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19DZTx80F4yMdcE0ktmHpgElc83x3ASvX9b7mx
 kAjdfCFB2u0u8ioPPUOmi7du5h52Vszk35PqaoMkcqLna6mQ8m
 8YY2S91wOWjZpThXWHylQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to release the BTM in paste_selection() when
sleeping in tty_ldisc_ref_wait to avoid deadlocks
with tty_ldisc_enable.

In tty_set_ldisc, we now always grab the BTM before
taking the ldisc_mutex in order to avoid AB-BA
deadlocks between the two.

tty_ldisc_halt potentially blocks on a workqueue
function that takes the BTM, so we must release
the BTM before calling it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/selection.c |    9 +++++++--
 drivers/char/tty_ldisc.c |   24 ++++++++++++++++++++----
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/char/selection.c b/drivers/char/selection.c
index 85211a3..75889cd 100644
--- a/drivers/char/selection.c
+++ b/drivers/char/selection.c
@@ -319,8 +319,13 @@ int paste_selection(struct tty_struct *tty)
 	poke_blanked_console();
 	release_console_sem();
 
-	ld = tty_ldisc_ref_wait(tty);
-	
+	ld = tty_ldisc_ref(tty);
+	if (!ld) {
+		tty_unlock();
+		ld = tty_ldisc_ref_wait(tty);
+		tty_lock();
+	}
+
 	add_wait_queue(&vc->paste_wait, &wait);
 	while (sel_buffer && sel_buffer_lth > pasted) {
 		set_current_state(TASK_INTERRUPTIBLE);
diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 97681ff..0f49479 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -582,6 +582,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	tty_wait_until_sent(tty, 0);
 
+	tty_lock();
 	mutex_lock(&tty->ldisc_mutex);
 
 	/*
@@ -591,13 +592,13 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	while (test_bit(TTY_LDISC_CHANGING, &tty->flags)) {
 		mutex_unlock(&tty->ldisc_mutex);
+		tty_unlock();
 		wait_event(tty_ldisc_wait,
 			test_bit(TTY_LDISC_CHANGING, &tty->flags) == 0);
+		tty_lock();
 		mutex_lock(&tty->ldisc_mutex);
 	}
 
-	tty_lock();
-
 	set_bit(TTY_LDISC_CHANGING, &tty->flags);
 
 	/*
@@ -634,8 +635,8 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	flush_scheduled_work();
 
-	mutex_lock(&tty->ldisc_mutex);
 	tty_lock();
+	mutex_lock(&tty->ldisc_mutex);
 	if (test_bit(TTY_HUPPED, &tty->flags)) {
 		/* We were raced by the hangup method. It will have stomped
 		   the ldisc data and closed the ldisc down */
@@ -782,7 +783,20 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	 * Avoid racing set_ldisc or tty_ldisc_release
 	 */
 	mutex_lock(&tty->ldisc_mutex);
-	tty_ldisc_halt(tty);
+
+	/*
+	 * this is like tty_ldisc_halt, but we need to give up
+	 * the BTM before calling cancel_delayed_work_sync,
+	 * which may need to wait for another function taking the BTM
+	 */
+	clear_bit(TTY_LDISC, &tty->flags);
+	tty_unlock();
+	cancel_delayed_work_sync(&tty->buf.work);
+	mutex_unlock(&tty->ldisc_mutex);
+
+	tty_lock();
+	mutex_lock(&tty->ldisc_mutex);
+
 	/* At this point we have a closed ldisc and we want to
 	   reopen it. We could defer this to the next open but
 	   it means auditing a lot of other paths so this is
@@ -853,8 +867,10 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	 * race with the set_ldisc code path.
 	 */
 
+	tty_unlock();
 	tty_ldisc_halt(tty);
 	flush_scheduled_work();
+	tty_lock();
 
 	mutex_lock(&tty->ldisc_mutex);
 	/*
-- 
1.7.0.4

