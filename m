Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559Ab0EDWgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:36:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934525Ab0EDWfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:35:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 02/13] tty: make atomic_write_lock release tty_lock
Date: Wed,  5 May 2010 00:33:41 +0200
Message-Id: <1273012433-6125-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273012433-6125-1-git-send-email-arnd@arndb.de>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Y/qQCgRRrgBKdhfFZ8a1ns1dszwxx7g47YTF
 XSyTtH9zBkB9baNRhjOpgHrxyKZshIWNkJLdYIJ8gIN26NsXe8
 mzZev1AhGYnZ5xlVLvKpQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic_write_lock never nests below BTM as far
as I can tell, so this can eventually get
reverted again unless it triggers bugs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/tty_io.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 3bf2c75..8331dd3 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -912,10 +912,15 @@ void tty_write_unlock(struct tty_struct *tty)
 
 int tty_write_lock(struct tty_struct *tty, int ndelay)
 {
+	/*
+	 * code inspection has shown that this is never called
+	 * with the BTM held. Make sure this stays that way.
+	 */
+	WARN_ON_ONCE(tty_locked());
 	if (!mutex_trylock(&tty->atomic_write_lock)) {
 		if (ndelay)
 			return -EAGAIN;
-		if (mutex_lock_interruptible(&tty->atomic_write_lock))
+		if (mutex_lock_interruptible_tty(&tty->atomic_write_lock))
 			return -ERESTARTSYS;
 	}
 	return 0;
@@ -1024,7 +1029,7 @@ out:
 void tty_write_message(struct tty_struct *tty, char *msg)
 {
 	if (tty) {
-		mutex_lock(&tty->atomic_write_lock);
+		mutex_lock_tty_off(&tty->atomic_write_lock);
 		tty_lock();
 		if (tty->ops->write && !test_bit(TTY_CLOSING, &tty->flags)) {
 			tty_unlock();
-- 
1.7.0.4

