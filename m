Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab2EWGBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:01:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56882 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab2EWGBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:01:44 -0400
MIME-Version: 1.0
In-Reply-To: <1337651931-5301-1-git-send-email-ming.lei@canonical.com>
References: <1337651931-5301-1-git-send-email-ming.lei@canonical.com>
Date: Wed, 23 May 2012 14:01:41 +0800
Message-ID: <CACVXFVP290dwgJVhgMf9girR9h0yU_mjxcN2Po0u1c1y4=QL0w@mail.gmail.com>
Subject: Re: [PATCH] tty: tty_mutex: fix lockdep warning in tty_lock_pair(v1)
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 22, 2012 at 9:58 AM, Ming Lei <ming.lei@canonical.com> wrote:
> Commit d29f3ef39be4eec0362b985305fc526d9be318cf(tty_lock:
> Localise the lock) introduces tty_lock_pair, in which
> may cause lockdep warning because two locks with same lock
> class are to be acquired one after another.
>
> This patch uses mutex_lock_nested annotation to avoid
> the warning as suggested by Peter.

Sorry, please ignore the patch because it misses the change on
tty_unlock_pair, and the correct one should be [1].

Even though the patch is applied, there is still one related problem about
mixing tty_lock_pair with tty_unlock and tty_lock. If tty locks are
held by calling
tty_lock_pair, then deadlock warning between legacy_mutex/1 and legacy_mutex
may be triggered if tty_unlock(tty) and tty_lock(tty) are called later
when tty < tty2,
see tty_ldisc_release() in tty_release().


Thanks,
--
Ming Lei


[1],
---
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
