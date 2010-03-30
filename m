Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab0C3U6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:58:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51384 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab0C3U5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:57:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 2/9] tty: make atomic_write_lock release tty_lock
Date: Tue, 30 Mar 2010 22:56:13 +0200
Message-Id: <1269982580-9361-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269982580-9361-1-git-send-email-arnd@arndb.de>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18pVB8dhNPURn8julb4hCnNKzLQhGFEaIY2b9g
 h6XVoR2KG8Yyj6sns3nS0Ce31igZE3ihgzD8W6yb0bMe22bPwq
 NE//+9Odr8j5g2ChFGZLQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/tty_io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 25b82eb..ef21e1d 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -915,7 +915,7 @@ int tty_write_lock(struct tty_struct *tty, int ndelay)
 	if (!mutex_trylock(&tty->atomic_write_lock)) {
 		if (ndelay)
 			return -EAGAIN;
-		if (mutex_lock_interruptible(&tty->atomic_write_lock))
+		if (mutex_lock_interruptible_tty(&tty->atomic_write_lock))
 			return -ERESTARTSYS;
 	}
 	return 0;
@@ -1024,7 +1024,7 @@ out:
 void tty_write_message(struct tty_struct *tty, char *msg)
 {
 	if (tty) {
-		mutex_lock(&tty->atomic_write_lock);
+		mutex_lock_tty_off(&tty->atomic_write_lock);
 		tty_lock();
 		if (tty->ops->write && !test_bit(TTY_CLOSING, &tty->flags)) {
 			tty_unlock();
-- 
1.7.0

