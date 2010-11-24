Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab0KXQX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:23:27 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:44288 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab0KXQX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:23:26 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        "Alan \"I must be out of my tree\" Cox" <alan@linux.intel.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv5 05/17] tty: don't allow ldisc dcd_change() after ldisc halt
Date: Wed, 24 Nov 2010 19:15:43 +0300
Message-Id: <48e935cac42ae455e2ef8fc45f7eef7631eece6b.1290599844.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1290599843.git.lasaine@lvk.cs.msu.su>
References: <cover.1290599843.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a possibility that uart_handle_dcd_change() could obtain a
reference to ldisc while running in parallel with tty_set_ldisc() on
different CPU but call dcd_change() operation after tty_ldisc_close()
which is incorrect.

Treat this situation specially by locking the whole
uart_handle_dcd_change() with spinlock and adding a "barrier" to
tty_ldisc_halt() which ensures that there are no active ldisc
references in uart_handle_dcd_change() after tty_ldisc_halt().

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/char/tty_io.c       |    1 +
 drivers/char/tty_ldisc.c    |    7 +++++++
 include/linux/serial_core.h |   18 ++++++++++++------
 include/linux/tty.h         |    1 +
 4 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 613c852..18576d4 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2816,6 +2816,7 @@ void initialize_tty_struct(struct tty_struct *tty,
 	mutex_init(&tty->echo_lock);
 	spin_lock_init(&tty->read_lock);
 	spin_lock_init(&tty->ctrl_lock);
+	spin_lock_init(&tty->dcd_change_lock);
 	INIT_LIST_HEAD(&tty->tty_files);
 	INIT_WORK(&tty->SAK_work, do_SAK_work);
 
diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 412f977..27fadb0 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -522,11 +522,18 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
  *	You need to do a 'flush_scheduled_work()' (outside the ldisc_mutex)
  *	in order to make sure any currently executing ldisc work is also
  *	flushed.
+ *
+ *	dcd_change() doesn't use workqueues so it needs a special
+ *	"barrier", which ensures that there are no active ldisc references
+ *	in dcd_change().
  */
 
 static int tty_ldisc_halt(struct tty_struct *tty)
 {
+	spin_lock_irq(&tty->dcd_change_lock);
 	clear_bit(TTY_LDISC, &tty->flags);
+	spin_unlock_irq(&tty->dcd_change_lock);
+
 	return cancel_delayed_work_sync(&tty->buf.work);
 }
 
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 55c8192..62835b6 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -508,11 +508,15 @@ static inline int uart_handle_break(struct uart_port *port)
 static inline void
 uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
 {
-	struct uart_state *state = uport->state;
-	struct tty_port *port = &state->port;
-	struct tty_ldisc *ld = tty_ldisc_ref(port->tty);
+	struct tty_port *port = &uport->state->port;
+	struct tty_struct *tty = port->tty;
 	struct pps_event_time ts;
+	struct tty_ldisc *ld;
+	unsigned long flags;
 
+	spin_lock_irqsave(&tty->dcd_change_lock, flags);
+
+	ld = tty_ldisc_ref(tty);
 	if (ld && ld->ops->dcd_change)
 		pps_get_ts(&ts);
 
@@ -525,14 +529,16 @@ uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
 	if (port->flags & ASYNC_CHECK_CD) {
 		if (status)
 			wake_up_interruptible(&port->open_wait);
-		else if (port->tty)
-			tty_hangup(port->tty);
+		else if (tty)
+			tty_hangup(tty);
 	}
 
 	if (ld && ld->ops->dcd_change)
-		ld->ops->dcd_change(port->tty, status, &ts);
+		ld->ops->dcd_change(tty, status, &ts);
 	if (ld)
 		tty_ldisc_deref(ld);
+
+	spin_unlock_irqrestore(&tty->dcd_change_lock, flags);
 }
 
 /**
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 67d64e6..506fe1c 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -327,6 +327,7 @@ struct tty_struct {
 	/* If the tty has a pending do_SAK, queue it here - akpm */
 	struct work_struct SAK_work;
 	struct tty_port *port;
+	spinlock_t dcd_change_lock;
 };
 
 /* Each of a tty's open files has private_data pointing to tty_file_private */
-- 
1.7.2.3

