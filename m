Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab0JTSjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:39:09 -0400
Received: from adsl-99-30-218-25.dsl.aus2tx.sbcglobal.net ([99.30.218.25]:37194
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab0JTSjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:39:08 -0400
X-Greylist: delayed 1176 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Oct 2010 14:39:08 EDT
Subject: [PATCH] synclink_gt fix per device locking
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Oct 2010 13:18:52 -0500
Message-Id: <1287598732.4080.16.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a long standing bug with per device locking.

Each device has an associated spinlock for synchronizing
access to hardware and state information with the ISR.
A single hardware card has one or more devices.

Bug: Non ISR code correctly acquires and releases the per device lock.
ISR incorrectly always acquires and releases the lock of the first
device on the card.

The decoupled and list based nature of the ISR and deferred
processing interaction allowed this to work in normal operation.
Exceptional events like an application forcing hardware shutdown,
reset, or reconfiguration while active can trigger the bug.

Fixed ISR to acquire and release the per device lock.

One exception is manipulation of the GPIO card resource
which is global and effectively owned by the first device of the card.
Non-ISR access to GPIO resource is changed to use lock of
first device on card.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/drivers/char/synclink_gt.c	2010-10-18 10:00:28.000000000 -0500
+++ b/drivers/char/synclink_gt.c	2010-10-20 10:08:39.000000000 -0500
@@ -2353,26 +2353,27 @@ static irqreturn_t slgt_interrupt(int du
 
 	DBGISR(("slgt_interrupt irq=%d entry\n", info->irq_level));
 
-	spin_lock(&info->lock);
-
 	while((gsr = rd_reg32(info, GSR) & 0xffffff00)) {
 		DBGISR(("%s gsr=%08x\n", info->device_name, gsr));
 		info->irq_occurred = true;
 		for(i=0; i < info->port_count ; i++) {
 			if (info->port_array[i] == NULL)
 				continue;
+			spin_lock(&info->port_array[i]->lock);
 			if (gsr & (BIT8 << i))
 				isr_serial(info->port_array[i]);
 			if (gsr & (BIT16 << (i*2)))
 				isr_rdma(info->port_array[i]);
 			if (gsr & (BIT17 << (i*2)))
 				isr_tdma(info->port_array[i]);
+			spin_unlock(&info->port_array[i]->lock);
 		}
 	}
 
 	if (info->gpio_present) {
 		unsigned int state;
 		unsigned int changed;
+		spin_lock(&info->lock);
 		while ((changed = rd_reg32(info, IOSR)) != 0) {
 			DBGISR(("%s iosr=%08x\n", info->device_name, changed));
 			/* read latched state of GPIO signals */
@@ -2384,22 +2385,24 @@ static irqreturn_t slgt_interrupt(int du
 					isr_gpio(info->port_array[i], changed, state);
 			}
 		}
+		spin_unlock(&info->lock);
 	}
 
 	for(i=0; i < info->port_count ; i++) {
 		struct slgt_info *port = info->port_array[i];
-
-		if (port && (port->port.count || port->netcount) &&
+		if (port == NULL)
+			continue;
+		spin_lock(&port->lock);
+		if ((port->port.count || port->netcount) &&
 		    port->pending_bh && !port->bh_running &&
 		    !port->bh_requested) {
 			DBGISR(("%s bh queued\n", port->device_name));
 			schedule_work(&port->task);
 			port->bh_requested = true;
 		}
+		spin_unlock(&port->lock);
 	}
 
-	spin_unlock(&info->lock);
-
 	DBGISR(("slgt_interrupt irq=%d exit\n", info->irq_level));
 	return IRQ_HANDLED;
 }
@@ -2902,7 +2905,7 @@ static int set_gpio(struct slgt_info *in
 		 info->device_name, gpio.state, gpio.smask,
 		 gpio.dir, gpio.dmask));
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->port_array[0]->lock, flags);
 	if (gpio.dmask) {
 		data = rd_reg32(info, IODR);
 		data |= gpio.dmask & gpio.dir;
@@ -2915,7 +2918,7 @@ static int set_gpio(struct slgt_info *in
 		data &= ~(gpio.smask & ~gpio.state);
 		wr_reg32(info, IOVR, data);
 	}
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->port_array[0]->lock, flags);
 
 	return 0;
 }
@@ -3016,7 +3019,7 @@ static int wait_gpio(struct slgt_info *i
 		return -EINVAL;
 	init_cond_wait(&wait, gpio.smask);
 
-	spin_lock_irqsave(&info->lock, flags);
+	spin_lock_irqsave(&info->port_array[0]->lock, flags);
 	/* enable interrupts for watched pins */
 	wr_reg32(info, IOER, rd_reg32(info, IOER) | gpio.smask);
 	/* get current pin states */
@@ -3028,20 +3031,20 @@ static int wait_gpio(struct slgt_info *i
 	} else {
 		/* wait for target state */
 		add_cond_wait(&info->gpio_wait_q, &wait);
-		spin_unlock_irqrestore(&info->lock, flags);
+		spin_unlock_irqrestore(&info->port_array[0]->lock, flags);
 		schedule();
 		if (signal_pending(current))
 			rc = -ERESTARTSYS;
 		else
 			gpio.state = wait.data;
-		spin_lock_irqsave(&info->lock, flags);
+		spin_lock_irqsave(&info->port_array[0]->lock, flags);
 		remove_cond_wait(&info->gpio_wait_q, &wait);
 	}
 
 	/* disable all GPIO interrupts if no waiting processes */
 	if (info->gpio_wait_q == NULL)
 		wr_reg32(info, IOER, 0);
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->port_array[0]->lock, flags);
 
 	if ((rc == 0) && copy_to_user(user_gpio, &gpio, sizeof(gpio)))
 		rc = -EFAULT;
@@ -3572,7 +3575,6 @@ static void device_init(int adapter_num,
 
 		/* copy resource information from first port to others */
 		for (i = 1; i < port_count; ++i) {
-			port_array[i]->lock      = port_array[0]->lock;
 			port_array[i]->irq_level = port_array[0]->irq_level;
 			port_array[i]->reg_addr  = port_array[0]->reg_addr;
 			alloc_dma_bufs(port_array[i]);


