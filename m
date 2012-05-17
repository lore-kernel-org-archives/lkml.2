Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967623Ab2EQSsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 14:48:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:43792 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967531Ab2EQSsn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 14:48:43 -0400
Message-ID: <1337280518.4281.67.camel@twins>
Subject: Re: [PATCH] tty: tty_mutex: fix lockdep warning in tty_lock_pair
From: Peter Zijlstra <peterz@infradead.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>
Date: Thu, 17 May 2012 20:48:38 +0200
In-Reply-To: <20120517182830.GA5254@kroah.com>
References: <1337234296-23313-1-git-send-email-ming.lei@canonical.com>
	 <20120517182830.GA5254@kroah.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 11:28 -0700, Greg Kroah-Hartman wrote:
> > +static void __lockfunc tty_lock_nest_lock(struct tty_struct *tty,
> > +             struct tty_struct *tty2)
> 
> Duplicating tty_lock() just for this one issue seems wrong and prone to
> error, don't you think?
> 
> > +{
> > +     if (tty->magic != TTY_MAGIC) {
> > +             printk(KERN_ERR "L Bad %p\n", tty);
> > +             WARN_ON(1);
> > +             return;
> > +     }
> > +     tty_kref_get(tty);
> > +     mutex_lock_nest_lock(&tty->legacy_mutex, &tty2->legacy_mutex);

Yeah, its completely broken, even the lockdep annotation is the wrong
one.

Something like the (completely untested) below patch is the 'right' way.

---
 drivers/tty/tty_mutex.c |   35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
index 69adc80..587330b 100644
--- a/drivers/tty/tty_mutex.c
+++ b/drivers/tty/tty_mutex.c
@@ -10,7 +10,7 @@
  * Getting the big tty mutex.
  */
 
-void __lockfunc tty_lock(struct tty_struct *tty)
+static void __lockfunc tty_lock_nested(struct tty_struct *tty, int subclass)
 {
 	if (tty->magic != TTY_MAGIC) {
 		printk(KERN_ERR "L Bad %p\n", tty);
@@ -18,7 +18,12 @@ void __lockfunc tty_lock(struct tty_struct *tty)
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
 
@@ -38,25 +43,25 @@ EXPORT_SYMBOL(tty_unlock);
  * Getting the big tty mutex for a pair of ttys with lock ordering
  * On a non pty/tty pair tty2 can be NULL which is just fine.
  */
-void __lockfunc tty_lock_pair(struct tty_struct *tty,
-					struct tty_struct *tty2)
+void __lockfunc tty_lock_pair(struct tty_struct *tty1, struct tty_struct *tty2)
 {
-	if (tty < tty2) {
-		tty_lock(tty);
-		tty_lock(tty2);
-	} else {
-		if (tty2 && tty2 != tty)
-			tty_lock(tty2);
-		tty_lock(tty);
+	if (!tty2 || tty1 == tty2) {
+		tty_lock(tty1);
+		return;
 	}
+
+	if (tty2 < tty1)
+		swap(tty1, tty2);
+
+	tty_lock(tty1);
+	tty_lock_nested(tty2, SINGLE_DEPTH_NESTING);
 }
 EXPORT_SYMBOL(tty_lock_pair);
 
-void __lockfunc tty_unlock_pair(struct tty_struct *tty,
-						struct tty_struct *tty2)
+void __lockfunc tty_unlock_pair(struct tty_struct *tty1, struct tty_struct *tty2)
 {
-	tty_unlock(tty);
-	if (tty2 && tty2 != tty)
+	tty_unlock(tty1);
+	if (tty2 && tty2 != tty1)
 		tty_unlock(tty2);
 }
 EXPORT_SYMBOL(tty_unlock_pair);

