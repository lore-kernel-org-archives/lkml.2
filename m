Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2EaJf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:35:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54857 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab2EaJfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:35:25 -0400
Subject: [PATCH] tty: add lockdep annotations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1338410107.2760.544.camel@edumazet-glaptop>
References: <4FC6189B.9080909@fusionio.com>
	 <1338402812.2760.413.camel@edumazet-glaptop>
	 <4FC66D3D.6080509@fusionio.com>
	 <1338404902.2760.451.camel@edumazet-glaptop>
	 <1338410107.2760.544.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 May 2012 11:35:18 +0200
Message-ID: <1338456918.2760.1318.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

tty_lock_pair() do the right thing to avoid deadlocks, but should
instruct LOCKDEP of this to avoid a splat. 

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
Latest Linus tree still hang on my machine, at least this patch removes
the lockdep problem...

 drivers/tty/tty_mutex.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
index 69adc80..67feac9 100644
--- a/drivers/tty/tty_mutex.c
+++ b/drivers/tty/tty_mutex.c
@@ -6,11 +6,17 @@
 
 /* Legacy tty mutex glue */
 
+enum {
+	TTY_MUTEX_NORMAL,
+	TTY_MUTEX_NESTED,
+};
+
 /*
  * Getting the big tty mutex.
  */
 
-void __lockfunc tty_lock(struct tty_struct *tty)
+static void __lockfunc tty_lock_nested(struct tty_struct *tty,
+				       unsigned int subclass)
 {
 	if (tty->magic != TTY_MAGIC) {
 		printk(KERN_ERR "L Bad %p\n", tty);
@@ -18,7 +24,12 @@ void __lockfunc tty_lock(struct tty_struct *tty)
 		return;
 	}
 	tty_kref_get(tty);
-	mutex_lock(&tty->legacy_mutex);
+	mutex_lock_nested(&tty->legacy_mutex, subclass);
+}
+
+void __lockfunc tty_lock(struct tty_struct *tty)
+{
+	return tty_lock_nested(tty, TTY_MUTEX_NORMAL);
 }
 EXPORT_SYMBOL(tty_lock);
 
@@ -43,11 +54,11 @@ void __lockfunc tty_lock_pair(struct tty_struct *tty,
 {
 	if (tty < tty2) {
 		tty_lock(tty);
-		tty_lock(tty2);
+		tty_lock_nested(tty2, TTY_MUTEX_NESTED);
 	} else {
 		if (tty2 && tty2 != tty)
 			tty_lock(tty2);
-		tty_lock(tty);
+		tty_lock_nested(tty, TTY_MUTEX_NESTED);
 	}
 }
 EXPORT_SYMBOL(tty_lock_pair);


