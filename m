Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab2KBEz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 00:55:58 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:34554 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab2KBEzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 00:55:55 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: Use dev_ printks in ni_tiocmd.c
Date: Fri,  2 Nov 2012 13:55:48 +0900
Message-Id: <1351832148-32098-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
- WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then pr_notice(...  to printk(KERN_NOTICE ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/ni_tiocmd.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_tiocmd.c b/drivers/staging/comedi/drivers/ni_tiocmd.c
index 8ee93d3..11a377a 100644
--- a/drivers/staging/comedi/drivers/ni_tiocmd.c
+++ b/drivers/staging/comedi/drivers/ni_tiocmd.c
@@ -173,7 +173,8 @@ static int ni_tio_input_cmd(struct ni_gpct *counter, struct comedi_async *async)
 static int ni_tio_output_cmd(struct ni_gpct *counter,
 			     struct comedi_async *async)
 {
-	printk(KERN_ERR "ni_tio: output commands not yet implemented.\n");
+	dev_err(counter->counter_dev->dev->class_dev,
+		"output commands not yet implemented.\n");
 	return -ENOTSUPP;
 
 	counter->mite_chan->dir = COMEDI_OUTPUT;
@@ -219,7 +220,10 @@ int ni_tio_cmd(struct ni_gpct *counter, struct comedi_async *async)
 
 	spin_lock_irqsave(&counter->lock, flags);
 	if (counter->mite_chan == NULL) {
-		printk(KERN_ERR "ni_tio: commands only supported with DMA.  Interrupt-driven commands not yet implemented.\n");
+		dev_err(counter->counter_dev->dev->class_dev,
+			"commands only supported with DMA.  ");
+		dev_err(counter->counter_dev->dev->class_dev,
+			"Interrupt-driven commands not yet implemented.\n");
 		retval = -EIO;
 	} else {
 		retval = ni_tio_cmd_setup(counter, async);
@@ -427,8 +431,9 @@ void ni_tio_acknowledge_and_confirm(struct ni_gpct *counter, int *gate_error,
 				  NITIO_Gxx_Joint_Status2_Reg
 				  (counter->counter_index)) &
 		    Gi_Permanent_Stale_Bit(counter->counter_index)) {
-			printk(KERN_INFO "%s: Gi_Permanent_Stale_Data detected.\n",
-			       __func__);
+			dev_info(counter->counter_dev->dev->class_dev,
+				 "%s: Gi_Permanent_Stale_Data detected.\n",
+				 __func__);
 			if (perm_stale_data)
 				*perm_stale_data = 1;
 		}
@@ -448,7 +453,8 @@ void ni_tio_handle_interrupt(struct ni_gpct *counter,
 	ni_tio_acknowledge_and_confirm(counter, &gate_error, &tc_error,
 				       &perm_stale_data, NULL);
 	if (gate_error) {
-		printk(KERN_NOTICE "%s: Gi_Gate_Error detected.\n", __func__);
+		dev_notice(counter->counter_dev->dev->class_dev,
+			   "%s: Gi_Gate_Error detected.\n", __func__);
 		s->async->events |= COMEDI_CB_OVERFLOW;
 	}
 	if (perm_stale_data)
@@ -459,8 +465,8 @@ void ni_tio_handle_interrupt(struct ni_gpct *counter,
 		if (read_register(counter,
 				NITIO_Gi_DMA_Status_Reg
 				(counter->counter_index)) & Gi_DRQ_Error_Bit) {
-			printk(KERN_NOTICE "%s: Gi_DRQ_Error detected.\n",
-							__func__);
+			dev_notice(counter->counter_dev->dev->class_dev,
+				   "%s: Gi_DRQ_Error detected.\n", __func__);
 			s->async->events |= COMEDI_CB_OVERFLOW;
 		}
 		break;
-- 
1.7.9.5

