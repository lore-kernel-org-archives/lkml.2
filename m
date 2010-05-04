Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934467Ab0EDWea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:34:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61408 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934422Ab0EDWe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:34:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 13/13] tty: turn ldisc_mutex into a regular mutex
Date: Wed,  5 May 2010 00:33:52 +0200
Message-Id: <1273012433-6125-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273012433-6125-1-git-send-email-arnd@arndb.de>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX187aHt5FGDd/DM1zDFSHVnKdPVi+Ikk2IYp0TJ
 cc4o8NVjgP4NNN+3iRYMIMgTuP8gM+eci0le/ZKQymLJ02cQaa
 FOJ9OS6NmAWix3sH+HrGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the lock order of the BTM and
ldisc_mutex so that we never take the BTM
while holding ldisc_mutex, which means
we no longer have to use mutex_lock_tty
when getting ldisc_mutex.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/tty_io.c    |    2 +-
 drivers/char/tty_ldisc.c |   15 ++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 4e16b34..80178cc 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1289,7 +1289,7 @@ static int tty_reopen(struct tty_struct *tty)
 	tty->count++;
 	tty->driver = driver; /* N.B. why do this every time?? */
 
-	mutex_lock_tty_on(&tty->ldisc_mutex);
+	mutex_lock(&tty->ldisc_mutex);
 	WARN_ON(!test_bit(TTY_LDISC, &tty->flags));
 	mutex_unlock(&tty->ldisc_mutex);
 
diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 0c0e935..dda31b0 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -598,7 +598,8 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	tty_wait_until_sent(tty, 0);
 
-	mutex_lock_tty_off(&tty->ldisc_mutex);
+	tty_lock();
+	mutex_lock(&tty->ldisc_mutex);
 
 	/*
 	 *	We could be midstream of another ldisc change which has
@@ -607,13 +608,13 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	while (test_bit(TTY_LDISC_CHANGING, &tty->flags)) {
 		mutex_unlock(&tty->ldisc_mutex);
+		tty_unlock();
 		wait_event(tty_ldisc_wait,
 			test_bit(TTY_LDISC_CHANGING, &tty->flags) == 0);
-		mutex_lock_tty_off(&tty->ldisc_mutex);
+		tty_lock();
+		mutex_lock(&tty->ldisc_mutex);
 	}
 
-	tty_lock();
-
 	set_bit(TTY_LDISC_CHANGING, &tty->flags);
 
 	/*
@@ -650,8 +651,8 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	flush_scheduled_work();
 
-	mutex_lock_tty_off(&tty->ldisc_mutex);
 	tty_lock();
+	mutex_lock(&tty->ldisc_mutex);
 	if (test_bit(TTY_HUPPED, &tty->flags)) {
 		/* We were raced by the hangup method. It will have stomped
 		   the ldisc data and closed the ldisc down */
@@ -797,7 +798,7 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	 *
 	 * Avoid racing set_ldisc or tty_ldisc_release
 	 */
-	mutex_lock_tty_on(&tty->ldisc_mutex);
+	mutex_lock(&tty->ldisc_mutex);
 	tty_ldisc_halt(tty);
 	/* At this point we have a closed ldisc and we want to
 	   reopen it. We could defer this to the next open but
@@ -873,7 +874,7 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	tty_unlock();
 	flush_scheduled_work();
 	tty_lock();
-	mutex_lock_tty_on(&tty->ldisc_mutex);
+	mutex_lock(&tty->ldisc_mutex);
 	/*
 	 * Now kill off the ldisc
 	 */
-- 
1.7.0.4

