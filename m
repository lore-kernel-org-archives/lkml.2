Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab1AEBu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 20:50:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:43919 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab1AEBu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 20:50:26 -0500
Date: Wed, 5 Jan 2011 12:50:16 +1100
From: NeilBrown <neilb@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: [PATCH] Change wait_for_completion_*_timeout to return a signed
 long
Message-ID: <20110105125016.64ccab0e@notabene.brown>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


wait_for_completion_*_timeout can return:

 0 if the wait timed out
 -ve if the wait was interrupted
 +ve if the completion was completed.

As they currently return an 'unsigned long', the last two cases are not
easily distinguished which can easily result in buggy code, as is the
case for the recently added wait_for_completion_interruptible_timeout
call in net/sunrpc/cache.c

So change them both to return 'long'.  As MAX_SCHEDULE_TIMEOUT is
LONG_MAX, a large +ve return value should never overflow.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/include/linux/completion.h b/include/linux/completion.h
index 36d57f7..142fe6f 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -80,11 +80,11 @@ extern void wait_for_completion(struct completion *);
 extern int wait_for_completion_interruptible(struct completion *x);
 extern int wait_for_completion_killable(struct completion *x);
 extern unsigned long wait_for_completion_timeout(struct completion *x,
 						   unsigned long timeout);
-extern unsigned long wait_for_completion_interruptible_timeout(
-			struct completion *x, unsigned long timeout);
-extern unsigned long wait_for_completion_killable_timeout(
-			struct completion *x, unsigned long timeout);
+extern long wait_for_completion_interruptible_timeout(
+	struct completion *x, unsigned long timeout);
+extern long wait_for_completion_killable_timeout(
+	struct completion *x, unsigned long timeout);
 extern bool try_wait_for_completion(struct completion *x);
 extern bool completion_done(struct completion *x);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 297d1a0..8f35baf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4526,7 +4526,7 @@ EXPORT_SYMBOL(wait_for_completion_interruptible);
  * This waits for either a completion of a specific task to be signaled or for a
  * specified timeout to expire. It is interruptible. The timeout is in jiffies.
  */
-unsigned long __sched
+long __sched
 wait_for_completion_interruptible_timeout(struct completion *x,
 					  unsigned long timeout)
 {
@@ -4559,7 +4559,7 @@ EXPORT_SYMBOL(wait_for_completion_killable);
  * signaled or for a specified timeout to expire. It can be
  * interrupted by a kill signal. The timeout is in jiffies.
  */
-unsigned long __sched
+long __sched
 wait_for_completion_killable_timeout(struct completion *x,
 				     unsigned long timeout)
 {
