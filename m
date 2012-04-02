Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab2DBL4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:47 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48200 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab2DBLzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:18 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 41/69] TTY: hvcs, use kref from tty_port
Date: Mon,  2 Apr 2012 13:54:25 +0200
Message-Id: <1333367693-3244-42-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simple switch. Except we convert destroy_hvcs_struct to be
tty_port_operations->destruct...

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: linuxppc-dev@lists.ozlabs.org
---
 drivers/tty/hvc/hvcs.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index a049ced..817f94b 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -290,12 +290,11 @@ struct hvcs_struct {
 	int chars_in_buffer;
 
 	/*
-	 * Any variable below the kref is valid before a tty is connected and
+	 * Any variable below is valid before a tty is connected and
 	 * stays valid after the tty is disconnected.  These shouldn't be
 	 * whacked until the kobject refcount reaches zero though some entries
 	 * may be changed via sysfs initiatives.
 	 */
-	struct kref kref; /* ref count & hvcs_struct lifetime */
 	int connected; /* is the vty-server currently connected to a vty? */
 	uint32_t p_unit_address; /* partner unit address */
 	uint32_t p_partition_ID; /* partner partition ID */
@@ -304,9 +303,6 @@ struct hvcs_struct {
 	struct vio_dev *vdev;
 };
 
-/* Required to back map a kref to its containing object */
-#define from_kref(k) container_of(k, struct hvcs_struct, kref)
-
 static LIST_HEAD(hvcs_structs);
 static DEFINE_SPINLOCK(hvcs_structs_lock);
 static DEFINE_MUTEX(hvcs_init_mutex);
@@ -701,10 +697,9 @@ static void hvcs_return_index(int index)
 		hvcs_index_list[index] = -1;
 }
 
-/* callback when the kref ref count reaches zero */
-static void destroy_hvcs_struct(struct kref *kref)
+static void hvcs_destruct_port(struct tty_port *p)
 {
-	struct hvcs_struct *hvcsd = from_kref(kref);
+	struct hvcs_struct *hvcsd = container_of(p, struct hvcs_struct, port);
 	struct vio_dev *vdev;
 	unsigned long flags;
 
@@ -741,6 +736,10 @@ static void destroy_hvcs_struct(struct kref *kref)
 	kfree(hvcsd);
 }
 
+static const struct tty_port_operations hvcs_port_ops = {
+	.destruct = hvcs_destruct_port,
+};
+
 static int hvcs_get_index(void)
 {
 	int i;
@@ -790,9 +789,8 @@ static int __devinit hvcs_probe(
 		return -ENODEV;
 
 	tty_port_init(&hvcsd->port);
+	hvcsd->port.ops = &hvcs_port_ops;
 	spin_lock_init(&hvcsd->lock);
-	/* Automatically incs the refcount the first time */
-	kref_init(&hvcsd->kref);
 
 	hvcsd->vdev = dev;
 	dev_set_drvdata(&dev->dev, hvcsd);
@@ -860,7 +858,7 @@ static int __devexit hvcs_remove(struct vio_dev *dev)
 	 * Let the last holder of this object cause it to be removed, which
 	 * would probably be tty_hangup below.
 	 */
-	kref_put(&hvcsd->kref, destroy_hvcs_struct);
+	tty_port_put(&hvcsd->port);
 
 	/*
 	 * The hangup is a scheduled function which will auto chain call
@@ -1094,7 +1092,7 @@ static struct hvcs_struct *hvcs_get_by_index(int index)
 	list_for_each_entry(hvcsd, &hvcs_structs, next) {
 		spin_lock_irqsave(&hvcsd->lock, flags);
 		if (hvcsd->index == index) {
-			kref_get(&hvcsd->kref);
+			tty_port_get(&hvcsd->port);
 			spin_unlock_irqrestore(&hvcsd->lock, flags);
 			spin_unlock(&hvcs_structs_lock);
 			return hvcsd;
@@ -1160,7 +1158,7 @@ static int hvcs_open(struct tty_struct *tty, struct file *filp)
 	 * and will grab the spinlock and free the connection if it fails.
 	 */
 	if (((rc = hvcs_enable_device(hvcsd, unit_address, irq, vdev)))) {
-		kref_put(&hvcsd->kref, destroy_hvcs_struct);
+		tty_port_put(&hvcsd->port);
 		printk(KERN_WARNING "HVCS: enable device failed.\n");
 		return rc;
 	}
@@ -1171,7 +1169,7 @@ fast_open:
 	hvcsd = tty->driver_data;
 
 	spin_lock_irqsave(&hvcsd->lock, flags);
-	kref_get(&hvcsd->kref);
+	tty_port_get(&hvcsd->port);
 	hvcsd->port.count++;
 	hvcsd->todo_mask |= HVCS_SCHED_READ;
 	spin_unlock_irqrestore(&hvcsd->lock, flags);
@@ -1186,7 +1184,7 @@ open_success:
 
 error_release:
 	spin_unlock_irqrestore(&hvcsd->lock, flags);
-	kref_put(&hvcsd->kref, destroy_hvcs_struct);
+	tty_port_put(&hvcsd->port);
 
 	printk(KERN_WARNING "HVCS: partner connect failed.\n");
 	return retval;
@@ -1240,7 +1238,7 @@ static void hvcs_close(struct tty_struct *tty, struct file *filp)
 		tty->driver_data = NULL;
 
 		free_irq(irq, hvcsd);
-		kref_put(&hvcsd->kref, destroy_hvcs_struct);
+		tty_port_put(&hvcsd->port);
 		return;
 	} else if (hvcsd->port.count < 0) {
 		printk(KERN_ERR "HVCS: vty-server@%X open_count: %d"
@@ -1249,7 +1247,7 @@ static void hvcs_close(struct tty_struct *tty, struct file *filp)
 	}
 
 	spin_unlock_irqrestore(&hvcsd->lock, flags);
-	kref_put(&hvcsd->kref, destroy_hvcs_struct);
+	tty_port_put(&hvcsd->port);
 }
 
 static void hvcs_hangup(struct tty_struct * tty)
@@ -1301,7 +1299,7 @@ static void hvcs_hangup(struct tty_struct * tty)
 		 * NOTE:  If this hangup was signaled from user space then the
 		 * final put will never happen.
 		 */
-		kref_put(&hvcsd->kref, destroy_hvcs_struct);
+		tty_port_put(&hvcsd->port);
 	}
 }
 
-- 
1.7.9.2


