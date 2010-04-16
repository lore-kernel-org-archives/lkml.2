Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413Ab0DPOOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:14:36 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:45640 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab0DPOOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:14:35 -0400
Date: Sat, 17 Apr 2010 00:14:36 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: David Miller <davem@davemloft.net>
cc: joe@perches.com, p_gortmaker@yahoo.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: [PATCH] mac8390: change an error return code and some cleanup
In-Reply-To: <alpine.OSX.2.00.1004161403160.271@localhost>
Message-ID: <alpine.OSX.2.00.1004162347390.271@localhost>
References: <alpine.OSX.2.00.1004161214270.271@localhost> <20100415.200113.215578006.davem@davemloft.net> <alpine.OSX.2.00.1004161323340.271@localhost> <alpine.OSX.2.00.1004161403160.271@localhost>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Change an error return from EAGAIN to EBUSY since the former is 
misleading. Also promote the log message. Likewise some other KERN_INFO 
log messages.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

--- a/drivers/net/mac8390.c	2010-04-16 13:31:04.000000000 +1000
+++ b/drivers/net/mac8390.c	2010-04-16 23:50:39.000000000 +1000
@@ -554,7 +554,7 @@
 	case MAC8390_APPLE:
 		switch (mac8390_testio(dev->mem_start)) {
 		case ACCESS_UNKNOWN:
-			pr_info("Don't know how to access card memory!\n");
+			pr_err("Don't know how to access card memory!\n");
 			return -ENODEV;
 			break;
 
@@ -643,8 +643,8 @@
 {
 	__ei_open(dev);
 	if (request_irq(dev->irq, __ei_interrupt, 0, "8390 Ethernet", dev)) {
-		pr_info("%s: unable to get IRQ %d.\n", dev->name, dev->irq);
-		return -EAGAIN;
+		pr_err("%s: unable to get IRQ %d.\n", dev->name, dev->irq);
+		return -EBUSY;
 	}
 	return 0;
 }
@@ -660,7 +660,7 @@
 {
 	ei_status.txing = 0;
 	if (ei_debug > 1)
-		pr_info("reset not supported\n");
+		printk(KERN_DEBUG pr_fmt("reset not supported\n"));
 	return;
 }
 
@@ -668,11 +668,11 @@
 {
 	unsigned char *target = nubus_slot_addr(IRQ2SLOT(dev->irq));
 	if (ei_debug > 1)
-		pr_info("Need to reset the NS8390 t=%lu...", jiffies);
+		printk(KERN_DEBUG pr_fmt("Need to reset the NS8390 t=%lu..."), jiffies);
 	ei_status.txing = 0;
 	target[0xC0000] = 0;
 	if (ei_debug > 1)
-		pr_cont("reset complete\n");
+		printk(KERN_CONT "reset complete\n");
 	return;
 }
 
