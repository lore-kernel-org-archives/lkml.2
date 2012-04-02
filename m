Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab2DBL4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:39 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48192 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab2DBLzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 42/69] TTY: hvcs, use tty from tty_port
Date: Mon,  2 Apr 2012 13:54:26 +0200
Message-Id: <1333367693-3244-43-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No refcounting, just a switch. The locking in the driver prevents
races, so in fact the refcounting is not needed. But while we have a
tty in tty_port, don't duplicate that and remove the one from
hvcs_struct.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: linuxppc-dev@lists.ozlabs.org
---
 drivers/tty/hvc/hvcs.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index 817f94b..d56788c 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -270,8 +270,6 @@ struct hvcs_struct {
 	 */
 	unsigned int index;
 
-	struct tty_struct *tty;
-
 	/*
 	 * Used to tell the driver kernel_thread what operations need to take
 	 * place upon this hvcs_struct instance.
@@ -560,7 +558,7 @@ static irqreturn_t hvcs_handle_interrupt(int irq, void *dev_instance)
 static void hvcs_try_write(struct hvcs_struct *hvcsd)
 {
 	uint32_t unit_address = hvcsd->vdev->unit_address;
-	struct tty_struct *tty = hvcsd->tty;
+	struct tty_struct *tty = hvcsd->port.tty;
 	int sent;
 
 	if (hvcsd->todo_mask & HVCS_TRY_WRITE) {
@@ -598,7 +596,7 @@ static int hvcs_io(struct hvcs_struct *hvcsd)
 	spin_lock_irqsave(&hvcsd->lock, flags);
 
 	unit_address = hvcsd->vdev->unit_address;
-	tty = hvcsd->tty;
+	tty = hvcsd->port.tty;
 
 	hvcs_try_write(hvcsd);
 
@@ -850,7 +848,7 @@ static int __devexit hvcs_remove(struct vio_dev *dev)
 
 	spin_lock_irqsave(&hvcsd->lock, flags);
 
-	tty = hvcsd->tty;
+	tty = hvcsd->port.tty;
 
 	spin_unlock_irqrestore(&hvcsd->lock, flags);
 
@@ -1137,7 +1135,7 @@ static int hvcs_open(struct tty_struct *tty, struct file *filp)
 			goto error_release;
 
 	hvcsd->port.count = 1;
-	hvcsd->tty = tty;
+	hvcsd->port.tty = tty;
 	tty->driver_data = hvcsd;
 
 	memset(&hvcsd->buffer[0], 0x00, HVCS_BUFF_LEN);
@@ -1223,7 +1221,7 @@ static void hvcs_close(struct tty_struct *tty, struct file *filp)
 		 * execute any operations on the TTY even though it is obligated
 		 * to deliver any pending I/O to the hypervisor.
 		 */
-		hvcsd->tty = NULL;
+		hvcsd->port.tty = NULL;
 
 		irq = hvcsd->vdev->irq;
 		spin_unlock_irqrestore(&hvcsd->lock, flags);
@@ -1271,8 +1269,8 @@ static void hvcs_hangup(struct tty_struct * tty)
 	hvcsd->todo_mask = 0;
 
 	/* I don't think the tty needs the hvcs_struct pointer after a hangup */
-	hvcsd->tty->driver_data = NULL;
-	hvcsd->tty = NULL;
+	tty->driver_data = NULL;
+	hvcsd->port.tty = NULL;
 
 	hvcsd->port.count = 0;
 
-- 
1.7.9.2


