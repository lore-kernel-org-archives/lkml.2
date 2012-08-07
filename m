Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab2HGT6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:58:00 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49927 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab2HGT56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:57:58 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 41/41] TTY: hvcs, add tty install
Date: Tue,  7 Aug 2012 21:48:06 +0200
Message-Id: <1344368886-24033-42-git-send-email-jslaby@suse.cz>
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

>From now on, we only increase the reference count in ->install (and
decrease in ->cleanup).

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: linuxppc-dev@lists.ozlabs.org
---
 drivers/tty/hvc/hvcs.c |   52 ++++++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index 6f5c3be..cab5c7a 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -1102,11 +1102,7 @@ static struct hvcs_struct *hvcs_get_by_index(int index)
 	return NULL;
 }
 
-/*
- * This is invoked via the tty_open interface when a user app connects to the
- * /dev node.
- */
-static int hvcs_open(struct tty_struct *tty, struct file *filp)
+static int hvcs_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	struct hvcs_struct *hvcsd;
 	struct vio_dev *vdev;
@@ -1114,9 +1110,6 @@ static int hvcs_open(struct tty_struct *tty, struct file *filp)
 	unsigned int irq;
 	int retval;
 
-	if (tty->driver_data)
-		goto fast_open;
-
 	/*
 	 * Is there a vty-server that shares the same index?
 	 * This function increments the kref index.
@@ -1139,7 +1132,7 @@ static int hvcs_open(struct tty_struct *tty, struct file *filp)
 		}
 	}
 
-	hvcsd->port.count = 1;
+	hvcsd->port.count = 0;
 	hvcsd->port.tty = tty;
 	tty->driver_data = hvcsd;
 
@@ -1166,28 +1159,42 @@ static int hvcs_open(struct tty_struct *tty, struct file *filp)
 		goto err_put;
 	}
 
-	goto open_success;
+	retval = tty_port_install(&hvcsd->port, driver, tty);
+	if (retval)
+		goto err_irq;
 
-fast_open:
-	hvcsd = tty->driver_data;
+	return 0;
+err_irq:
+	spin_lock_irqsave(&hvcsd->lock, flags);
+	vio_disable_interrupts(hvcsd->vdev);
+	spin_unlock_irqrestore(&hvcsd->lock, flags);
+	free_irq(irq, hvcsd);
+err_put:
+	tty_port_put(&hvcsd->port);
+
+	return retval;
+}
+
+/*
+ * This is invoked via the tty_open interface when a user app connects to the
+ * /dev node.
+ */
+static int hvcs_open(struct tty_struct *tty, struct file *filp)
+{
+	struct hvcs_struct *hvcsd = tty->driver_data;
+	unsigned long flags;
 
 	spin_lock_irqsave(&hvcsd->lock, flags);
-	tty_port_get(&hvcsd->port);
 	hvcsd->port.count++;
 	hvcsd->todo_mask |= HVCS_SCHED_READ;
 	spin_unlock_irqrestore(&hvcsd->lock, flags);
 
-open_success:
 	hvcs_kick();
 
 	printk(KERN_INFO "HVCS: vty-server@%X connection opened.\n",
 		hvcsd->vdev->unit_address );
 
 	return 0;
-err_put:
-	tty_port_put(&hvcsd->port);
-
-	return retval;
 }
 
 static void hvcs_close(struct tty_struct *tty, struct file *filp)
@@ -1238,7 +1245,6 @@ static void hvcs_close(struct tty_struct *tty, struct file *filp)
 		tty->driver_data = NULL;
 
 		free_irq(irq, hvcsd);
-		tty_port_put(&hvcsd->port);
 		return;
 	} else if (hvcsd->port.count < 0) {
 		printk(KERN_ERR "HVCS: vty-server@%X open_count: %d"
@@ -1247,6 +1253,12 @@ static void hvcs_close(struct tty_struct *tty, struct file *filp)
 	}
 
 	spin_unlock_irqrestore(&hvcsd->lock, flags);
+}
+
+static void hvcs_cleanup(struct tty_struct * tty)
+{
+	struct hvcs_struct *hvcsd = tty->driver_data;
+
 	tty_port_put(&hvcsd->port);
 }
 
@@ -1433,8 +1445,10 @@ static int hvcs_chars_in_buffer(struct tty_struct *tty)
 }
 
 static const struct tty_operations hvcs_ops = {
+	.install = hvcs_install,
 	.open = hvcs_open,
 	.close = hvcs_close,
+	.cleanup = hvcs_cleanup,
 	.hangup = hvcs_hangup,
 	.write = hvcs_write,
 	.write_room = hvcs_write_room,
-- 
1.7.10.4


