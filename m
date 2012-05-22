Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777Ab2EVB7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:59:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42334 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2EVB7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:59:05 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] tty: tty_mutex: fix lockdep warning in tty_lock_pair(v1)
Date: Tue, 22 May 2012 09:58:51 +0800
Message-Id: <1337651931-5301-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d29f3ef39be4eec0362b985305fc526d9be318cf(tty_lock:
Localise the lock) introduces tty_lock_pair, in which
may cause lockdep warning because two locks with same lock
class are to be acquired one after another.

This patch uses mutex_lock_nested annotation to avoid
the warning as suggested by Peter.

Cc: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/tty/tty_mutex.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
index 69adc80..fecf592 100644
--- a/drivers/tty/tty_mutex.c
+++ b/drivers/tty/tty_mutex.c
@@ -10,7 +10,8 @@
  * Getting the big tty mutex.
  */
 
-void __lockfunc tty_lock(struct tty_struct *tty)
+static void __lockfunc tty_lock_nested(struct tty_struct *tty,
+		int subclass)
 {
 	if (tty->magic != TTY_MAGIC) {
 		printk(KERN_ERR "L Bad %p\n", tty);
@@ -18,7 +19,12 @@ void __lockfunc tty_lock(struct tty_struct *tty)
 		return;
 	}
 	tty_kref_get(tty);
-	mutex_lock(&tty->legacy_mutex);
+	mutex_lock_nested(&tty->legacy_mutex, subclass);
+}
+
+void __lockfunc tty_lock(struct tty_struct *tty)
+{
+	tty_lock_nested(tty, 0);
 }
 EXPORT_SYMBOL(tty_lock);
 
@@ -43,11 +49,14 @@ void __lockfunc tty_lock_pair(struct tty_struct *tty,
 {
 	if (tty < tty2) {
 		tty_lock(tty);
-		tty_lock(tty2);
+		tty_lock_nested(tty2, SINGLE_DEPTH_NESTING);
 	} else {
-		if (tty2 && tty2 != tty)
+		int nested = 0;
+		if (tty2 && tty2 != tty) {
 			tty_lock(tty2);
-		tty_lock(tty);
+			nested = SINGLE_DEPTH_NESTING;
+		}
+		tty_lock_nested(tty, nested);
 	}
 }
 EXPORT_SYMBOL(tty_lock_pair);
-- 
1.7.9.5

