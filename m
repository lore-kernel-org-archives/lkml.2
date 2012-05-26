Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab2EZCyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 22:54:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52852 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab2EZCyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 22:54:45 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] tty: tty_mutex: fix lockdep warning in tty_lock_pair(v3)
Date: Sat, 26 May 2012 10:54:29 +0800
Message-Id: <1338000869-15129-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Commit d29f3ef39be4eec0362b985305fc526d9be318cf(tty_lock:
Localise the lock) introduces tty_lock_pair, in which
may cause lockdep warning[1] because two locks with same lock
class are to be acquired one after another.

This patch uses mutex_lock_nested annotation to avoid
the warning as suggested by Peter.


[1], lockdep warning

[  104.147918] =============================================
[  104.153564] [ INFO: possible recursive locking detected ]
[  104.159240] 3.4.0-next-20120524+ #887 Not tainted
[  104.164184] ---------------------------------------------
[  104.169830] dropbear/1337 is trying to acquire lock:
[  104.175079]  (&tty->legacy_mutex){+.+.+.}, at: [<c025f1d8>] tty_release+0x174/0x440
[  104.183105] 
[  104.183105] but task is already holding lock:
[  104.189270]  (&tty->legacy_mutex){+.+.+.}, at: [<c03d7294>] tty_lock_pair+0x34/0x40
[  104.197296] 
[  104.197296] other info that might help us debug this:
[  104.204132]  Possible unsafe locking scenario:
[  104.204132] 
[  104.210357]        CPU0
[  104.212921]        ----
[  104.215484]   lock(&tty->legacy_mutex);
[  104.219512]   lock(&tty->legacy_mutex);
[  104.223541] 
[  104.223541]  *** DEADLOCK ***
[  104.223541] 
[  104.229736]  May be due to missing lock nesting notation
[  104.229736] 
[  104.236877] 2 locks held by dropbear/1337:
[  104.241180]  #0:  (tty_mutex){+.+.+.}, at: [<c025f1cc>] tty_release+0x168/0x440
[  104.248870]  #1:  (&tty->legacy_mutex){+.+.+.}, at: [<c03d7294>] tty_lock_pair+0x34/0x40
[  104.257354] 
[  104.257354] stack backtrace:
[  104.261962] [<c0015694>] (unwind_backtrace+0x0/0x11c) from [<c007dba0>] (__lock_acquire+0x1a54/0x1b10)
[  104.271759] [<c007dba0>] (__lock_acquire+0x1a54/0x1b10) from [<c007e2d8>] (lock_acquire+0x120/0x144)
[  104.281341] [<c007e2d8>] (lock_acquire+0x120/0x144) from [<c03d435c>] (mutex_lock_nested+0x50/0x390)
[  104.290954] [<c03d435c>] (mutex_lock_nested+0x50/0x390) from [<c025f1d8>] (tty_release+0x174/0x440)
[  104.300445] [<c025f1d8>] (tty_release+0x174/0x440) from [<c00f3294>] (fput+0x10c/0x21c)
[  104.308868] [<c00f3294>] (fput+0x10c/0x21c) from [<c00efeec>] (filp_close+0x70/0x7c)
[  104.317016] [<c00efeec>] (filp_close+0x70/0x7c) from [<c00effa8>] (sys_close+0xb0/0xf0)
[  104.325408] [<c00effa8>] (sys_close+0xb0/0xf0) from [<c000e020>] (ret_fast_syscall+0x0/0x48)


Cc: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
v3:
	fix unlock order in tty_unlock_pair

 drivers/tty/tty_mutex.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
index 69adc80..c7f4523 100644
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
@@ -55,8 +64,13 @@ EXPORT_SYMBOL(tty_lock_pair);
 void __lockfunc tty_unlock_pair(struct tty_struct *tty,
 						struct tty_struct *tty2)
 {
-	tty_unlock(tty);
-	if (tty2 && tty2 != tty)
+	if (tty < tty2) {
 		tty_unlock(tty2);
+		tty_unlock(tty);
+	} else {
+		tty_unlock(tty);
+		if (tty2 && tty2 != tty)
+			tty_unlock(tty2);
+	}
 }
 EXPORT_SYMBOL(tty_unlock_pair);
-- 
1.7.9.5

