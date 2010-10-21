Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab0JUOAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:00:06 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:54616 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956Ab0JUOAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:00:05 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/1] Char: TTY, restore tty_ldisc_wait_idle
Date: Thu, 21 Oct 2010 15:58:59 +0200
Message-Id: <1287669539-22644-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 21 Oct 2010 15:59:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was removed in 65b770468e98 (tty-ldisc: turn ldisc user count into
a proper refcount), but we need to wait for last user to quit the
ldisc before we close it in tty_set_ldisc.

Otherwise weird things start to happen. There might be processes
waiting in tty_read->n_tty_read on tty->read_wait for input to appear
and at that moment, a change of ldisc is fatal. n_tty_close is called,
it frees read_buf and the waiting process is still in the middle of
reading and goes nuts after it is woken.

Previously we prevented close to happen when others are in ldisc ops
by tty_ldisc_wait_idle in tty_set_ldisc. But the commit above removed
that. So revoke the change and test whether there is 1 user (=we), and
allow the close then.

I don't understand why tty_ldisc_lock would be needed when it's an
atomic variable, so this is a lockless tty_ldisc_wait_idle.

NOTE: This is an untested patch, because I cannot reproduce myself
(partly because I haven't tried yet) and because I want to hear back
from you.

NOT-signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_ldisc.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 412f977..86032b5 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -47,6 +47,7 @@
 
 static DEFINE_SPINLOCK(tty_ldisc_lock);
 static DECLARE_WAIT_QUEUE_HEAD(tty_ldisc_wait);
+static DECLARE_WAIT_QUEUE_HEAD(tty_ldisc_idle);
 /* Line disc dispatch table */
 static struct tty_ldisc_ops *tty_ldiscs[NR_LDISCS];
 
@@ -83,6 +84,7 @@ static void put_ldisc(struct tty_ldisc *ld)
 		return;
 	}
 	local_irq_restore(flags);
+	wake_up(&tty_ldisc_idle);
 }
 
 /**
@@ -531,6 +533,23 @@ static int tty_ldisc_halt(struct tty_struct *tty)
 }
 
 /**
+ *	tty_ldisc_wait_idle	-	wait for the ldisc to become idle
+ *	@tty: tty to wait for
+ *
+ *	Wait for the line discipline to become idle. The discipline must
+ *	have been halted for this to guarantee it remains idle.
+ */
+static int tty_ldisc_wait_idle(struct tty_struct *tty)
+{
+	int ret;
+	ret = wait_event_interruptible_timeout(tty_ldisc_idle,
+			atomic_read(&tty->ldisc->users) == 1, 5 * HZ);
+	if (ret < 0)
+		return ret;
+	return ret > 0 ? 0 : -EBUSY;
+}
+
+/**
  *	tty_set_ldisc		-	set line discipline
  *	@tty: the terminal to set
  *	@ldisc: the line discipline
@@ -634,6 +653,13 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	flush_scheduled_work();
 
+	retval = tty_ldisc_wait_idle(tty);
+	if (retval) {
+		clear_bit(TTY_LDISC_CHANGING, &tty->flags);
+		tty_ldisc_put(new_ldisc);
+		return retval;
+	}
+
 	tty_lock();
 	mutex_lock(&tty->ldisc_mutex);
 	if (test_bit(TTY_HUPPED, &tty->flags)) {
-- 
1.7.3.1

