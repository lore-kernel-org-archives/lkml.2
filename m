Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab0FAU6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:58:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57533 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab0FAUxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:53:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 25/31] tty: introduce wait_event_interruptible_tty
Date: Tue,  1 Jun 2010 22:53:05 +0200
Message-Id: <1275425591-8803-26-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275425591-8803-1-git-send-email-arnd@arndb.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19NSzzt/zyC0DaFkb4lSpI48PZNfqP/5IRXNT7
 Xl4qptv6cEKwGzfMDMSm+9Tgv/a0P0NzaIa/ZIlJIvgj31DiY1
 rTkmz1UWEonf06iuBc08g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling wait_event_interruptible implicitly
releases the BKL when it sleeps, but we need
to do this explcitly when we have converted
it to a mutex.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/cyclades.c  |    2 +-
 drivers/char/istallion.c |   12 ++++++++----
 drivers/char/n_r3964.c   |    2 +-
 drivers/char/tty_port.c  |    2 +-
 drivers/char/vt_ioctl.c  |    2 +-
 drivers/serial/crisv10.c |    4 ++--
 include/linux/tty.h      |   42 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 56 insertions(+), 10 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 51acfe3..27aad94 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1607,7 +1607,7 @@ static int cy_open(struct tty_struct *tty, struct file *filp)
 	 * If the port is the middle of closing, bail out now
 	 */
 	if (tty_hung_up_p(filp) || (info->port.flags & ASYNC_CLOSING)) {
-		wait_event_interruptible(info->port.close_wait,
+		wait_event_interruptible_tty(info->port.close_wait,
 				!(info->port.flags & ASYNC_CLOSING));
 		return (info->port.flags & ASYNC_HUP_NOTIFY) ? -EAGAIN: -ERESTARTSYS;
 	}
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 5e9a81d..be28391 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -954,7 +954,7 @@ static int stli_rawopen(struct stlibrd *brdp, struct stliport *portp, unsigned l
  *	order of opens and closes may not be preserved across shared
  *	memory, so we must wait until it is complete.
  */
-	wait_event_interruptible(portp->raw_wait,
+	wait_event_interruptible_tty(portp->raw_wait,
 			!test_bit(ST_CLOSING, &portp->state));
 	if (signal_pending(current)) {
 		return -ERESTARTSYS;
@@ -989,7 +989,7 @@ static int stli_rawopen(struct stlibrd *brdp, struct stliport *portp, unsigned l
 	set_bit(ST_OPENING, &portp->state);
 	spin_unlock_irqrestore(&brd_lock, flags);
 
-	wait_event_interruptible(portp->raw_wait,
+	wait_event_interruptible_tty(portp->raw_wait,
 			!test_bit(ST_OPENING, &portp->state));
 	if (signal_pending(current))
 		rc = -ERESTARTSYS;
@@ -1020,7 +1020,7 @@ static int stli_rawclose(struct stlibrd *brdp, struct stliport *portp, unsigned
  *	occurs on this port.
  */
 	if (wait) {
-		wait_event_interruptible(portp->raw_wait,
+		wait_event_interruptible_tty(portp->raw_wait,
 				!test_bit(ST_CLOSING, &portp->state));
 		if (signal_pending(current)) {
 			return -ERESTARTSYS;
@@ -1052,7 +1052,7 @@ static int stli_rawclose(struct stlibrd *brdp, struct stliport *portp, unsigned
  *	to come back.
  */
 	rc = 0;
-	wait_event_interruptible(portp->raw_wait,
+	wait_event_interruptible_tty(portp->raw_wait,
 			!test_bit(ST_CLOSING, &portp->state));
 	if (signal_pending(current))
 		rc = -ERESTARTSYS;
@@ -1073,6 +1073,10 @@ static int stli_rawclose(struct stlibrd *brdp, struct stliport *portp, unsigned
 
 static int stli_cmdwait(struct stlibrd *brdp, struct stliport *portp, unsigned long cmd, void *arg, int size, int copyback)
 {
+	/*
+	 * no need for wait_event_tty because clearing ST_CMDING cannot block
+	 * on BTM
+	 */
 	wait_event_interruptible(portp->raw_wait,
 			!test_bit(ST_CMDING, &portp->state));
 	if (signal_pending(current))
diff --git a/drivers/char/n_r3964.c b/drivers/char/n_r3964.c
index f4bd259..a98290d 100644
--- a/drivers/char/n_r3964.c
+++ b/drivers/char/n_r3964.c
@@ -1079,7 +1079,7 @@ static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
 				goto unlock;
 			}
 			/* block until there is a message: */
-			wait_event_interruptible(pInfo->read_wait,
+			wait_event_interruptible_tty(pInfo->read_wait,
 					(pMsg = remove_msg(pInfo, pClient)));
 		}
 
diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index a3bd1d0..35eb304 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -231,7 +231,7 @@ int tty_port_block_til_ready(struct tty_port *port,
 
 	/* block if port is in the process of being closed */
 	if (tty_hung_up_p(filp) || port->flags & ASYNC_CLOSING) {
-		wait_event_interruptible(port->close_wait,
+		wait_event_interruptible_tty(port->close_wait,
 				!(port->flags & ASYNC_CLOSING));
 		if (port->flags & ASYNC_HUP_NOTIFY)
 			return -EAGAIN;
diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index cc07fab..c56c4f3 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -133,7 +133,7 @@ static void vt_event_wait(struct vt_event_wait *vw)
 	list_add(&vw->list, &vt_events);
 	spin_unlock_irqrestore(&vt_event_lock, flags);
 	/* Wait for it to pass */
-	wait_event_interruptible(vt_event_waitqueue, vw->done);
+	wait_event_interruptible_tty(vt_event_waitqueue, vw->done);
 	/* Dequeue it */
 	spin_lock_irqsave(&vt_event_lock, flags);
 	list_del(&vw->list);
diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index d11d898..e6a1cb7 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -3981,7 +3981,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 	 */
 	if (tty_hung_up_p(filp) ||
 	    (info->flags & ASYNC_CLOSING)) {
-		wait_event_interruptible(info->close_wait,
+		wait_event_interruptible_tty(info->close_wait,
 			!(info->flags & ASYNC_CLOSING));
 #ifdef SERIAL_DO_RESTART
 		if (info->flags & ASYNC_HUP_NOTIFY)
@@ -4139,7 +4139,7 @@ rs_open(struct tty_struct *tty, struct file * filp)
 	 */
 	if (tty_hung_up_p(filp) ||
 	    (info->flags & ASYNC_CLOSING)) {
-		wait_event_interruptible(info->close_wait,
+		wait_event_interruptible_tty(info->close_wait,
 			!(info->flags & ASYNC_CLOSING));
 #ifdef SERIAL_DO_RESTART
 		return ((info->flags & ASYNC_HUP_NOTIFY) ?
diff --git a/include/linux/tty.h b/include/linux/tty.h
index faf0bcd..18a7955 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -603,5 +603,47 @@ static inline void tty_unlock(void) __releases(kernel_lock)
 }
 #define tty_locked()		(kernel_locked())
 
+/*
+ * wait_event_interruptible_tty -- wait for a condition with the tty lock held
+ *
+ * The condition we are waiting for might take a long time to
+ * become true, or might depend on another thread taking the
+ * BTM. In either case, we need to drop the BTM to guarantee
+ * forward progress. This is a leftover from the conversion
+ * from the BKL and should eventually get removed as the BTM
+ * falls out of use.
+ *
+ * Do not use in new code.
+ */
+#define wait_event_interruptible_tty(wq, condition)			\
+({									\
+	int __ret = 0;							\
+	if (!(condition)) {						\
+		__wait_event_interruptible_tty(wq, condition, __ret);	\
+	}								\
+	__ret;								\
+})
+
+#define __wait_event_interruptible_tty(wq, condition, ret)		\
+do {									\
+	DEFINE_WAIT(__wait);						\
+									\
+	for (;;) {							\
+		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		if (!signal_pending(current)) {				\
+			tty_unlock();					\
+			schedule();					\
+			tty_lock();					\
+			continue;					\
+		}							\
+		ret = -ERESTARTSYS;					\
+		break;							\
+	}								\
+	finish_wait(&wq, &__wait);					\
+} while (0)
+
+
 #endif /* __KERNEL__ */
 #endif
-- 
1.7.0.4

