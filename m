Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab2DBL4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:16 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48065 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2DBLzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 39/69] TTY: HVC, use count from tty_port
Date: Mon,  2 Apr 2012 13:54:23 +0200
Message-Id: <1333367693-3244-40-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, count is used from tty_port and protected by tty_port->lock.

n_outbuf is left unprotected in hvc_hangup now, because there is no
point to hold any lock, since other uses are unprotected too.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: linuxppc-dev@lists.ozlabs.org
---
 drivers/tty/hvc/hvc_console.c |   40 +++++++++++++++++++++-------------------
 drivers/tty/hvc/hvc_console.h |    1 -
 2 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 92b7f5d..6c45cbf 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -313,18 +313,18 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 	if (!(hp = hvc_get_by_index(tty->index)))
 		return -ENODEV;
 
-	spin_lock_irqsave(&hp->lock, flags);
+	spin_lock_irqsave(&hp->port.lock, flags);
 	/* Check and then increment for fast path open. */
-	if (hp->count++ > 0) {
+	if (hp->port.count++ > 0) {
+		spin_unlock_irqrestore(&hp->port.lock, flags);
+		/* FIXME why taking a reference here? */
 		tty_kref_get(tty);
-		spin_unlock_irqrestore(&hp->lock, flags);
 		hvc_kick();
 		return 0;
 	} /* else count == 0 */
+	spin_unlock_irqrestore(&hp->port.lock, flags);
 
 	tty->driver_data = hp;
-	spin_unlock_irqrestore(&hp->lock, flags);
-
 	tty_port_tty_set(&hp->port, tty);
 
 	if (hp->ops->notifier_add)
@@ -367,10 +367,10 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 
 	hp = tty->driver_data;
 
-	spin_lock_irqsave(&hp->lock, flags);
+	spin_lock_irqsave(&hp->port.lock, flags);
 
-	if (--hp->count == 0) {
-		spin_unlock_irqrestore(&hp->lock, flags);
+	if (--hp->port.count == 0) {
+		spin_unlock_irqrestore(&hp->port.lock, flags);
 		/* We are done with the tty pointer now. */
 		tty_port_tty_set(&hp->port, NULL);
 
@@ -387,10 +387,10 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 		 */
 		tty_wait_until_sent_from_close(tty, HVC_CLOSE_WAIT);
 	} else {
-		if (hp->count < 0)
+		if (hp->port.count < 0)
 			printk(KERN_ERR "hvc_close %X: oops, count is %d\n",
-				hp->vtermno, hp->count);
-		spin_unlock_irqrestore(&hp->lock, flags);
+				hp->vtermno, hp->port.count);
+		spin_unlock_irqrestore(&hp->port.lock, flags);
 	}
 
 	tty_kref_put(tty);
@@ -409,24 +409,25 @@ static void hvc_hangup(struct tty_struct *tty)
 	/* cancel pending tty resize work */
 	cancel_work_sync(&hp->tty_resize);
 
-	spin_lock_irqsave(&hp->lock, flags);
+	spin_lock_irqsave(&hp->port.lock, flags);
 
 	/*
 	 * The N_TTY line discipline has problems such that in a close vs
 	 * open->hangup case this can be called after the final close so prevent
 	 * that from happening for now.
 	 */
-	if (hp->count <= 0) {
-		spin_unlock_irqrestore(&hp->lock, flags);
+	if (hp->port.count <= 0) {
+		spin_unlock_irqrestore(&hp->port.lock, flags);
 		return;
 	}
 
-	temp_open_count = hp->count;
-	hp->count = 0;
-	hp->n_outbuf = 0;
-	spin_unlock_irqrestore(&hp->lock, flags);
+	temp_open_count = hp->port.count;
+	hp->port.count = 0;
+	spin_unlock_irqrestore(&hp->port.lock, flags);
 	tty_port_tty_set(&hp->port, NULL);
 
+	hp->n_outbuf = 0;
+
 	if (hp->ops->notifier_hangup)
 		hp->ops->notifier_hangup(hp, hp->data);
 
@@ -474,7 +475,8 @@ static int hvc_write(struct tty_struct *tty, const unsigned char *buf, int count
 	if (!hp)
 		return -EPIPE;
 
-	if (hp->count <= 0)
+	/* FIXME what's this (unprotected) check for? */
+	if (hp->port.count <= 0)
 		return -EIO;
 
 	spin_lock_irqsave(&hp->lock, flags);
diff --git a/drivers/tty/hvc/hvc_console.h b/drivers/tty/hvc/hvc_console.h
index 594a28f..674d23c 100644
--- a/drivers/tty/hvc/hvc_console.h
+++ b/drivers/tty/hvc/hvc_console.h
@@ -49,7 +49,6 @@ struct hvc_struct {
 	struct tty_port port;
 	spinlock_t lock;
 	int index;
-	int count;
 	int do_wakeup;
 	char *outbuf;
 	int outbuf_size;
-- 
1.7.9.2


