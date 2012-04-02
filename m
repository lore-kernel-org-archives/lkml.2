Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab2DBLzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:55:07 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:47974 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2DBLzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:06 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 38/69] TTY: HVC, use tty from tty_port
Date: Mon,  2 Apr 2012 13:54:22 +0200
Message-Id: <1333367693-3244-39-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver already used refcounting. So we just switch it to tty_port
helpers. And switch to tty_port->lock for tty.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: linuxppc-dev@lists.ozlabs.org
---
 drivers/tty/hvc/hvc_console.c |   36 +++++++++++++++---------------------
 drivers/tty/hvc/hvc_console.h |    1 -
 drivers/tty/hvc/hvsi_lib.c    |    2 +-
 3 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 12a4273..92b7f5d 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -323,11 +323,10 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 	} /* else count == 0 */
 
 	tty->driver_data = hp;
-
-	hp->tty = tty_kref_get(tty);
-
 	spin_unlock_irqrestore(&hp->lock, flags);
 
+	tty_port_tty_set(&hp->port, tty);
+
 	if (hp->ops->notifier_add)
 		rc = hp->ops->notifier_add(hp, hp->data);
 
@@ -338,9 +337,7 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 	 * tty fields and return the kref reference.
 	 */
 	if (rc) {
-		spin_lock_irqsave(&hp->lock, flags);
-		hp->tty = NULL;
-		spin_unlock_irqrestore(&hp->lock, flags);
+		tty_port_tty_set(&hp->port, NULL);
 		tty_kref_put(tty);
 		tty->driver_data = NULL;
 		tty_port_put(&hp->port);
@@ -373,9 +370,9 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 	spin_lock_irqsave(&hp->lock, flags);
 
 	if (--hp->count == 0) {
-		/* We are done with the tty pointer now. */
-		hp->tty = NULL;
 		spin_unlock_irqrestore(&hp->lock, flags);
+		/* We are done with the tty pointer now. */
+		tty_port_tty_set(&hp->port, NULL);
 
 		if (hp->ops->notifier_del)
 			hp->ops->notifier_del(hp, hp->data);
@@ -427,9 +424,8 @@ static void hvc_hangup(struct tty_struct *tty)
 	temp_open_count = hp->count;
 	hp->count = 0;
 	hp->n_outbuf = 0;
-	hp->tty = NULL;
-
 	spin_unlock_irqrestore(&hp->lock, flags);
+	tty_port_tty_set(&hp->port, NULL);
 
 	if (hp->ops->notifier_hangup)
 		hp->ops->notifier_hangup(hp, hp->data);
@@ -526,13 +522,12 @@ static void hvc_set_winsz(struct work_struct *work)
 
 	hp = container_of(work, struct hvc_struct, tty_resize);
 
-	spin_lock_irqsave(&hp->lock, hvc_flags);
-	if (!hp->tty) {
-		spin_unlock_irqrestore(&hp->lock, hvc_flags);
+	tty = tty_port_tty_get(&hp->port);
+	if (!tty)
 		return;
-	}
-	ws  = hp->ws;
-	tty = tty_kref_get(hp->tty);
+
+	spin_lock_irqsave(&hp->lock, hvc_flags);
+	ws = hp->ws;
 	spin_unlock_irqrestore(&hp->lock, hvc_flags);
 
 	tty_do_resize(tty, &ws);
@@ -601,7 +596,7 @@ int hvc_poll(struct hvc_struct *hp)
 	}
 
 	/* No tty attached, just skip */
-	tty = tty_kref_get(hp->tty);
+	tty = tty_port_tty_get(&hp->port);
 	if (tty == NULL)
 		goto bail;
 
@@ -681,8 +676,7 @@ int hvc_poll(struct hvc_struct *hp)
 
 		tty_flip_buffer_push(tty);
 	}
-	if (tty)
-		tty_kref_put(tty);
+	tty_kref_put(tty);
 
 	return poll_mask;
 }
@@ -880,9 +874,9 @@ int hvc_remove(struct hvc_struct *hp)
 	unsigned long flags;
 	struct tty_struct *tty;
 
-	spin_lock_irqsave(&hp->lock, flags);
-	tty = tty_kref_get(hp->tty);
+	tty = tty_port_tty_get(&hp->port);
 
+	spin_lock_irqsave(&hp->lock, flags);
 	if (hp->index < MAX_NR_HVC_CONSOLES)
 		vtermnos[hp->index] = -1;
 
diff --git a/drivers/tty/hvc/hvc_console.h b/drivers/tty/hvc/hvc_console.h
index 926d9e4..594a28f 100644
--- a/drivers/tty/hvc/hvc_console.h
+++ b/drivers/tty/hvc/hvc_console.h
@@ -49,7 +49,6 @@ struct hvc_struct {
 	struct tty_port port;
 	spinlock_t lock;
 	int index;
-	struct tty_struct *tty;
 	int count;
 	int do_wakeup;
 	char *outbuf;
diff --git a/drivers/tty/hvc/hvsi_lib.c b/drivers/tty/hvc/hvsi_lib.c
index 6f4dd83..59c135d 100644
--- a/drivers/tty/hvc/hvsi_lib.c
+++ b/drivers/tty/hvc/hvsi_lib.c
@@ -377,7 +377,7 @@ int hvsilib_open(struct hvsi_priv *pv, struct hvc_struct *hp)
 	pr_devel("HVSI@%x: open !\n", pv->termno);
 
 	/* Keep track of the tty data structure */
-	pv->tty = tty_kref_get(hp->tty);
+	pv->tty = tty_port_tty_get(&hp->port);
 
 	hvsilib_establish(pv);
 
-- 
1.7.9.2


