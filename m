Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab0C3U5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:57:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58654 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830Ab0C3U5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:57:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 5/9] tty: make ldisc_mutex nest under tty_lock
Date: Tue, 30 Mar 2010 22:56:16 +0200
Message-Id: <1269982580-9361-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269982580-9361-1-git-send-email-arnd@arndb.de>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+sE4guZTQVMCVAIin2L2w8cm+4ycVRpGoTaMm
 0pw6onQaiBNdlTJHW5un/7jxhBSkW03hUM3//nWbEsGEjKbuti
 cxt9+jlys+DzBkEMcVGJA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/tty_io.c    |    2 +-
 drivers/char/tty_ldisc.c |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 91cc978..aeab6cb 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1279,7 +1279,7 @@ static int tty_reopen(struct tty_struct *tty)
 	tty->count++;
 	tty->driver = driver; /* N.B. why do this every time?? */
 
-	mutex_lock(&tty->ldisc_mutex);
+	mutex_lock_tty_on(&tty->ldisc_mutex);
 	WARN_ON(!test_bit(TTY_LDISC, &tty->flags));
 	mutex_unlock(&tty->ldisc_mutex);
 
diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index af5b4a7..946ac05 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -580,7 +580,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	tty_wait_until_sent(tty, 0);
 
-	mutex_lock(&tty->ldisc_mutex);
+	mutex_lock_tty_off(&tty->ldisc_mutex);
 
 	/*
 	 *	We could be midstream of another ldisc change which has
@@ -591,7 +591,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 		mutex_unlock(&tty->ldisc_mutex);
 		wait_event(tty_ldisc_wait,
 			test_bit(TTY_LDISC_CHANGING, &tty->flags) == 0);
-		mutex_lock(&tty->ldisc_mutex);
+		mutex_lock_tty_off(&tty->ldisc_mutex);
 	}
 
 	tty_lock();
@@ -632,7 +632,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	flush_scheduled_work();
 
-	mutex_lock(&tty->ldisc_mutex);
+	mutex_lock_tty_off(&tty->ldisc_mutex);
 	tty_lock();
 	if (test_bit(TTY_HUPPED, &tty->flags)) {
 		/* We were raced by the hangup method. It will have stomped
@@ -779,7 +779,7 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	 *
 	 * Avoid racing set_ldisc or tty_ldisc_release
 	 */
-	mutex_lock(&tty->ldisc_mutex);
+	mutex_lock_tty_on(&tty->ldisc_mutex);
 	tty_ldisc_halt(tty);
 	/* At this point we have a closed ldisc and we want to
 	   reopen it. We could defer this to the next open but
@@ -854,7 +854,7 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	tty_ldisc_halt(tty);
 	flush_scheduled_work();
 
-	mutex_lock(&tty->ldisc_mutex);
+	mutex_lock_tty_on(&tty->ldisc_mutex);
 	/*
 	 * Now kill off the ldisc
 	 */
-- 
1.7.0

