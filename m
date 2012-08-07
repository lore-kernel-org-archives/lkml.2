Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab2HGTxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:53:24 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:52857 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab2HGTxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:53:22 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Samuel Ortiz <samuel@sortiz.org>
Subject: [PATCH 37/41] TTY: ircomm_tty, add tty install
Date: Tue,  7 Aug 2012 21:48:02 +0200
Message-Id: <1344368886-24033-38-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has two outcomes:
* we give the TTY layer a tty_port
* we do not find the info structure every time open is called on that
  tty

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Samuel Ortiz <samuel@sortiz.org>
---
 net/irda/ircomm/ircomm_tty.c |   41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 7a0d611..9668990 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -52,6 +52,8 @@
 #include <net/irda/ircomm_tty_attach.h>
 #include <net/irda/ircomm_tty.h>
 
+static int ircomm_tty_install(struct tty_driver *driver,
+		struct tty_struct *tty);
 static int  ircomm_tty_open(struct tty_struct *tty, struct file *filp);
 static void ircomm_tty_close(struct tty_struct * tty, struct file *filp);
 static int  ircomm_tty_write(struct tty_struct * tty,
@@ -82,6 +84,7 @@ static struct tty_driver *driver;
 static hashbin_t *ircomm_tty = NULL;
 
 static const struct tty_operations ops = {
+	.install	 = ircomm_tty_install,
 	.open            = ircomm_tty_open,
 	.close           = ircomm_tty_close,
 	.write           = ircomm_tty_write,
@@ -374,21 +377,11 @@ static int ircomm_tty_block_til_ready(struct ircomm_tty_cb *self,
 	return retval;
 }
 
-/*
- * Function ircomm_tty_open (tty, filp)
- *
- *    This routine is called when a particular tty device is opened. This
- *    routine is mandatory; if this routine is not filled in, the attempted
- *    open will fail with ENODEV.
- */
-static int ircomm_tty_open(struct tty_struct *tty, struct file *filp)
+
+static int ircomm_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	struct ircomm_tty_cb *self;
 	unsigned int line = tty->index;
-	unsigned long	flags;
-	int ret;
-
-	IRDA_DEBUG(2, "%s()\n", __func__ );
 
 	/* Check if instance already exists */
 	self = hashbin_lock_find(ircomm_tty, line, NULL);
@@ -425,14 +418,30 @@ static int ircomm_tty_open(struct tty_struct *tty, struct file *filp)
 		tty->termios.c_oflag = 0;
 
 		/* Insert into hash */
-		/* FIXME there is a window from find to here */
 		hashbin_insert(ircomm_tty, (irda_queue_t *) self, line, NULL);
 	}
+
+	return tty_port_install(&self->port, driver, tty);
+}
+
+/*
+ * Function ircomm_tty_open (tty, filp)
+ *
+ *    This routine is called when a particular tty device is opened. This
+ *    routine is mandatory; if this routine is not filled in, the attempted
+ *    open will fail with ENODEV.
+ */
+static int ircomm_tty_open(struct tty_struct *tty, struct file *filp)
+{
+	struct ircomm_tty_cb *self = tty->driver_data;
+	unsigned long	flags;
+	int ret;
+
+	IRDA_DEBUG(2, "%s()\n", __func__ );
+
 	/* ++ is not atomic, so this should be protected - Jean II */
 	spin_lock_irqsave(&self->port.lock, flags);
 	self->port.count++;
-
-	tty->driver_data = self;
 	spin_unlock_irqrestore(&self->port.lock, flags);
 	tty_port_tty_set(&self->port, tty);
 
@@ -472,7 +481,7 @@ static int ircomm_tty_open(struct tty_struct *tty, struct file *filp)
 	}
 
 	/* Check if this is a "normal" ircomm device, or an irlpt device */
-	if (line < 0x10) {
+	if (self->line < 0x10) {
 		self->service_type = IRCOMM_3_WIRE | IRCOMM_9_WIRE;
 		self->settings.service_type = IRCOMM_9_WIRE; /* 9 wire as default */
 		/* Jan Kiszka -> add DSR/RI -> Conform to IrCOMM spec */
-- 
1.7.10.4


