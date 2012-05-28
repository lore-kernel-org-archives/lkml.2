Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab2E1Sny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 14:43:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab2E1Snw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 14:43:52 -0400
Date: Mon, 28 May 2012 20:43:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] tty: annotate tty_lock() for lockdep
Message-ID: <alpine.LNX.2.00.1205282042290.15057@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=============================================
[ INFO: possible recursive locking detected ]
3.4.0-08218-gb48b2c3 #7 Not tainted
---------------------------------------------
blogd/279 is trying to acquire lock:
 (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff8150f51e>] tty_lock+0x3e/0x90

but task is already holding lock:
 (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff8150f51e>] tty_lock+0x3e/0x90

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&tty->legacy_mutex);
  lock(&tty->legacy_mutex);

 *** DEADLOCK ***

[ .. stacktraces removed .. ]

This is a false positive stemming from the fact that lockdep doesn't
understand that proper lock ordering is already achieved in tty_lock_pair()
by ordering by struct tty address.

Introduce tty_lock_nested() to be able to express this explicit
ordering to lockdep and teach tty_lock_pair() to use it.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/tty/tty_mutex.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
index 69adc80..90d43ad 100644
--- a/drivers/tty/tty_mutex.c
+++ b/drivers/tty/tty_mutex.c
@@ -10,7 +10,7 @@
  * Getting the big tty mutex.
  */
 
-void __lockfunc tty_lock(struct tty_struct *tty)
+void tty_lock_common(struct tty_struct *tty)
 {
 	if (tty->magic != TTY_MAGIC) {
 		printk(KERN_ERR "L Bad %p\n", tty);
@@ -18,10 +18,22 @@ void __lockfunc tty_lock(struct tty_struct *tty)
 		return;
 	}
 	tty_kref_get(tty);
+}
+
+void __lockfunc tty_lock(struct tty_struct *tty)
+{
+	tty_lock_common(tty);
 	mutex_lock(&tty->legacy_mutex);
 }
 EXPORT_SYMBOL(tty_lock);
 
+void __lockfunc tty_lock_nested(struct tty_struct *tty,
+					unsigned int subclass)
+{
+	tty_lock_common(tty);
+	mutex_lock_nested(&tty->legacy_mutex, subclass);
+}
+
 void __lockfunc tty_unlock(struct tty_struct *tty)
 {
 	if (tty->magic != TTY_MAGIC) {
@@ -42,12 +54,12 @@ void __lockfunc tty_lock_pair(struct tty_struct *tty,
 					struct tty_struct *tty2)
 {
 	if (tty < tty2) {
-		tty_lock(tty);
-		tty_lock(tty2);
+		tty_lock_nested(tty, 1);
+		tty_lock_nested(tty2, 2);
 	} else {
 		if (tty2 && tty2 != tty)
-			tty_lock(tty2);
-		tty_lock(tty);
+			tty_lock_nested(tty2, 2);
+		tty_lock_nested(tty, 1);
 	}
 }
 EXPORT_SYMBOL(tty_lock_pair);

-- 
Jiri Kosina
SUSE Labs
