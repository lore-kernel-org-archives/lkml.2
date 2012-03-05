Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965131Ab2CEODE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:03:04 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34714 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410Ab2CENxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:16 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Hansjoerg Lipp <hjlipp@web.de>, Tilman Schmidt <tilman@imap.cc>,
        gigaset307x-common@lists.sourceforge.net
Subject: [PATCH 68/68] TTY: isdn/gigaset, use tty_port
Date: Mon,  5 Mar 2012 14:52:55 +0100
Message-Id: <1330955575-26641-69-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let us port the code to use tty_port. We now use open_count and tty
from there. This allows us also to use tty_port_tty_set with tty
refcounting instead of hand-written locking and logic.

Note that tty and open_count are no longer protected by cs->lock. It is
protected by tty_port->lock. But since all the places where they were
used are now switched to the helpers, we are fine.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Hansjoerg Lipp <hjlipp@web.de>
Cc: Tilman Schmidt <tilman@imap.cc>
Cc: gigaset307x-common@lists.sourceforge.net
---
 drivers/isdn/gigaset/common.c    |    3 +--
 drivers/isdn/gigaset/gigaset.h   |    3 +--
 drivers/isdn/gigaset/interface.c |   46 ++++++++++++++++----------------------
 3 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/drivers/isdn/gigaset/common.c b/drivers/isdn/gigaset/common.c
index db6e434..7679270 100644
--- a/drivers/isdn/gigaset/common.c
+++ b/drivers/isdn/gigaset/common.c
@@ -720,12 +720,11 @@ struct cardstate *gigaset_initcs(struct gigaset_driver *drv, int channels,
 
 	tasklet_init(&cs->event_tasklet, gigaset_handle_event,
 		     (unsigned long) cs);
+	tty_port_init(&cs->port);
 	cs->commands_pending = 0;
 	cs->cur_at_seq = 0;
 	cs->gotfwver = -1;
-	cs->open_count = 0;
 	cs->dev = NULL;
-	cs->tty = NULL;
 	cs->tty_dev = NULL;
 	cs->cidmode = cidmode != 0;
 	cs->tabnocid = gigaset_tab_nocid;
diff --git a/drivers/isdn/gigaset/gigaset.h b/drivers/isdn/gigaset/gigaset.h
index 8fad99e..1dc2513 100644
--- a/drivers/isdn/gigaset/gigaset.h
+++ b/drivers/isdn/gigaset/gigaset.h
@@ -433,8 +433,7 @@ struct cardstate {
 	spinlock_t cmdlock;
 	unsigned curlen, cmdbytes;
 
-	unsigned open_count;
-	struct tty_struct *tty;
+	struct tty_port port;
 	struct tasklet_struct if_wake_tasklet;
 	unsigned control_state;
 
diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index 040f5f9..b3d6ac1 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -146,7 +146,6 @@ static const struct tty_operations if_ops = {
 static int if_open(struct tty_struct *tty, struct file *filp)
 {
 	struct cardstate *cs;
-	unsigned long flags;
 
 	gig_dbg(DEBUG_IF, "%d+%d: %s()",
 		tty->driver->minor_start, tty->index, __func__);
@@ -161,12 +160,10 @@ static int if_open(struct tty_struct *tty, struct file *filp)
 	}
 	tty->driver_data = cs;
 
-	++cs->open_count;
+	++cs->port.count;
 
-	if (cs->open_count == 1) {
-		spin_lock_irqsave(&cs->lock, flags);
-		cs->tty = tty;
-		spin_unlock_irqrestore(&cs->lock, flags);
+	if (cs->port.count == 1) {
+		tty_port_tty_set(&cs->port, tty);
 		tty->low_latency = 1;
 	}
 
@@ -177,7 +174,6 @@ static int if_open(struct tty_struct *tty, struct file *filp)
 static void if_close(struct tty_struct *tty, struct file *filp)
 {
 	struct cardstate *cs = tty->driver_data;
-	unsigned long flags;
 
 	if (!cs) { /* happens if we didn't find cs in open */
 		printk(KERN_DEBUG "%s: no cardstate\n", __func__);
@@ -190,15 +186,10 @@ static void if_close(struct tty_struct *tty, struct file *filp)
 
 	if (!cs->connected)
 		gig_dbg(DEBUG_IF, "not connected");	/* nothing to do */
-	else if (!cs->open_count)
+	else if (!cs->port.count)
 		dev_warn(cs->dev, "%s: device not opened\n", __func__);
-	else {
-		if (!--cs->open_count) {
-			spin_lock_irqsave(&cs->lock, flags);
-			cs->tty = NULL;
-			spin_unlock_irqrestore(&cs->lock, flags);
-		}
-	}
+	else if (!--cs->port.count)
+		tty_port_tty_set(&cs->port, NULL);
 
 	mutex_unlock(&cs->mutex);
 
@@ -511,10 +502,13 @@ out:
 /* wakeup tasklet for the write operation */
 static void if_wake(unsigned long data)
 {
-	struct cardstate *cs = (struct cardstate *) data;
+	struct cardstate *cs = (struct cardstate *)data;
+	struct tty_struct *tty = tty_port_tty_get(&cs->port);
 
-	if (cs->tty)
-		tty_wakeup(cs->tty);
+	if (tty) {
+		tty_wakeup(tty);
+		tty_kref_put(tty);
+	}
 }
 
 /*** interface to common ***/
@@ -567,18 +561,16 @@ void gigaset_if_free(struct cardstate *cs)
 void gigaset_if_receive(struct cardstate *cs,
 			unsigned char *buffer, size_t len)
 {
-	unsigned long flags;
-	struct tty_struct *tty;
+	struct tty_struct *tty = tty_port_tty_get(&cs->port);
 
-	spin_lock_irqsave(&cs->lock, flags);
-	tty = cs->tty;
-	if (tty == NULL)
+	if (tty == NULL) {
 		gig_dbg(DEBUG_IF, "receive on closed device");
-	else {
-		tty_insert_flip_string(tty, buffer, len);
-		tty_flip_buffer_push(tty);
+		return;
 	}
-	spin_unlock_irqrestore(&cs->lock, flags);
+
+	tty_insert_flip_string(tty, buffer, len);
+	tty_flip_buffer_push(tty);
+	tty_kref_put(tty);
 }
 EXPORT_SYMBOL_GPL(gigaset_if_receive);
 
-- 
1.7.9.2


