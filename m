Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934485Ab0EDWfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:35:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63120 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934512Ab0EDWfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:35:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 05/13] tty: make ldisc_mutex nest under tty_lock
Date: Wed,  5 May 2010 00:33:44 +0200
Message-Id: <1273012433-6125-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273012433-6125-1-git-send-email-arnd@arndb.de>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18D7nqTvejX1q37s/avomkdWzXbyumEO7wieLv
 rTqaIm7EplklCPcceGk4uvssXJviuMEkpnp38lAZbH0vHPOGKi
 JB7zU52aBxFaFFObStGQA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/tty_io.c    |    2 +-
 drivers/char/tty_ldisc.c |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index b1a40a1..82c723a 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1284,7 +1284,7 @@ static int tty_reopen(struct tty_struct *tty)
 	tty->count++;
 	tty->driver = driver; /* N.B. why do this every time?? */
 
-	mutex_lock(&tty->ldisc_mutex);
+	mutex_lock_tty_on(&tty->ldisc_mutex);
 	WARN_ON(!test_bit(TTY_LDISC, &tty->flags));
 	mutex_unlock(&tty->ldisc_mutex);
 
diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index f0efca2..630e1ef 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -582,7 +582,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	tty_wait_until_sent(tty, 0);
 
-	mutex_lock(&tty->ldisc_mutex);
+	mutex_lock_tty_off(&tty->ldisc_mutex);
 
 	/*
 	 *	We could be midstream of another ldisc change which has
@@ -593,7 +593,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 		mutex_unlock(&tty->ldisc_mutex);
 		wait_event(tty_ldisc_wait,
 			test_bit(TTY_LDISC_CHANGING, &tty->flags) == 0);
-		mutex_lock(&tty->ldisc_mutex);
+		mutex_lock_tty_off(&tty->ldisc_mutex);
 	}
 
 	tty_lock();
@@ -634,7 +634,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	flush_scheduled_work();
 
-	mutex_lock(&tty->ldisc_mutex);
+	mutex_lock_tty_off(&tty->ldisc_mutex);
 	tty_lock();
 	if (test_bit(TTY_HUPPED, &tty->flags)) {
 		/* We were raced by the hangup method. It will have stomped
@@ -781,7 +781,7 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	 *
 	 * Avoid racing set_ldisc or tty_ldisc_release
 	 */
-	mutex_lock(&tty->ldisc_mutex);
+	mutex_lock_tty_on(&tty->ldisc_mutex);
 	tty_ldisc_halt(tty);
 	/* At this point we have a closed ldisc and we want to
 	   reopen it. We could defer this to the next open but
@@ -856,7 +856,7 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	tty_ldisc_halt(tty);
 	flush_scheduled_work();
 
-	mutex_lock(&tty->ldisc_mutex);
+	mutex_lock_tty_on(&tty->ldisc_mutex);
 	/*
 	 * Now kill off the ldisc
 	 */
-- 
1.7.0.4

