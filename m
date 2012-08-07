Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab2HGT5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:57:33 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49902 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab2HGT5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:57:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 40/41] TTY: hvcs, clean hvcs_open a bit
Date: Tue,  7 Aug 2012 21:48:05 +0200
Message-Id: <1344368886-24033-41-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the code of hvcs_open a bit more readable by:
- moving all assignments out of if's
- redoing fail paths so that corresponding pieces are nearby
- we need only one of retval and rc

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/hvc/hvcs.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index d56788c..6f5c3be 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -1109,11 +1109,10 @@ static struct hvcs_struct *hvcs_get_by_index(int index)
 static int hvcs_open(struct tty_struct *tty, struct file *filp)
 {
 	struct hvcs_struct *hvcsd;
-	int rc, retval = 0;
-	unsigned long flags;
-	unsigned int irq;
 	struct vio_dev *vdev;
-	unsigned long unit_address;
+	unsigned long unit_address, flags;
+	unsigned int irq;
+	int retval;
 
 	if (tty->driver_data)
 		goto fast_open;
@@ -1122,7 +1121,8 @@ static int hvcs_open(struct tty_struct *tty, struct file *filp)
 	 * Is there a vty-server that shares the same index?
 	 * This function increments the kref index.
 	 */
-	if (!(hvcsd = hvcs_get_by_index(tty->index))) {
+	hvcsd = hvcs_get_by_index(tty->index);
+	if (!hvcsd) {
 		printk(KERN_WARNING "HVCS: open failed, no device associated"
 				" with tty->index %d.\n", tty->index);
 		return -ENODEV;
@@ -1130,9 +1130,14 @@ static int hvcs_open(struct tty_struct *tty, struct file *filp)
 
 	spin_lock_irqsave(&hvcsd->lock, flags);
 
-	if (hvcsd->connected == 0)
-		if ((retval = hvcs_partner_connect(hvcsd)))
-			goto error_release;
+	if (hvcsd->connected == 0) {
+		retval = hvcs_partner_connect(hvcsd);
+		if (retval) {
+			spin_unlock_irqrestore(&hvcsd->lock, flags);
+			printk(KERN_WARNING "HVCS: partner connect failed.\n");
+			goto err_put;
+		}
+	}
 
 	hvcsd->port.count = 1;
 	hvcsd->port.tty = tty;
@@ -1155,10 +1160,10 @@ static int hvcs_open(struct tty_struct *tty, struct file *filp)
 	 * This must be done outside of the spinlock because it requests irqs
 	 * and will grab the spinlock and free the connection if it fails.
 	 */
-	if (((rc = hvcs_enable_device(hvcsd, unit_address, irq, vdev)))) {
-		tty_port_put(&hvcsd->port);
+	retval = hvcs_enable_device(hvcsd, unit_address, irq, vdev);
+	if (retval) {
 		printk(KERN_WARNING "HVCS: enable device failed.\n");
-		return rc;
+		goto err_put;
 	}
 
 	goto open_success;
@@ -1179,12 +1184,9 @@ open_success:
 		hvcsd->vdev->unit_address );
 
 	return 0;
-
-error_release:
-	spin_unlock_irqrestore(&hvcsd->lock, flags);
+err_put:
 	tty_port_put(&hvcsd->port);
 
-	printk(KERN_WARNING "HVCS: partner connect failed.\n");
 	return retval;
 }
 
-- 
1.7.10.4


