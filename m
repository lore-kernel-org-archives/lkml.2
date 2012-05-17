Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab2EQF6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 01:58:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55360 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab2EQF6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 01:58:38 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] tty: tty_mutex: fix lockdep warning in tty_lock_pair
Date: Thu, 17 May 2012 13:58:16 +0800
Message-Id: <1337234296-23313-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d29f3ef39be4eec0362b985305fc526d9be318cf(tty_lock:
Localise the lock) introduces tty_lock_pair, in which
may cause lockdep warning because two locks with same lock
class are to be acquired one after another.

This patch uses mutex_lock_nest_lock annotation to avoid
the warning.

Cc: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/tty/tty_mutex.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
index 69adc80..079f9d7 100644
--- a/drivers/tty/tty_mutex.c
+++ b/drivers/tty/tty_mutex.c
@@ -10,6 +10,18 @@
  * Getting the big tty mutex.
  */
 
+static void __lockfunc tty_lock_nest_lock(struct tty_struct *tty,
+		struct tty_struct *tty2)
+{
+	if (tty->magic != TTY_MAGIC) {
+		printk(KERN_ERR "L Bad %p\n", tty);
+		WARN_ON(1);
+		return;
+	}
+	tty_kref_get(tty);
+	mutex_lock_nest_lock(&tty->legacy_mutex, &tty2->legacy_mutex);
+}
+
 void __lockfunc tty_lock(struct tty_struct *tty)
 {
 	if (tty->magic != TTY_MAGIC) {
@@ -43,11 +55,14 @@ void __lockfunc tty_lock_pair(struct tty_struct *tty,
 {
 	if (tty < tty2) {
 		tty_lock(tty);
-		tty_lock(tty2);
+		tty_lock_nest_lock(tty2, tty);
 	} else {
-		if (tty2 && tty2 != tty)
+		if (tty2 && tty2 != tty) {
 			tty_lock(tty2);
-		tty_lock(tty);
+			tty_lock_nest_lock(tty, tty2);
+		} else {
+			tty_lock(tty);
+		}
 	}
 }
 EXPORT_SYMBOL(tty_lock_pair);
-- 
1.7.9.5

