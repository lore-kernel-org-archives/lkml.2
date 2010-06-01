Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab0FAMSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:18:37 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:34005 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab0FAMSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:18:35 -0400
Date: Tue, 1 Jun 2010 22:18:32 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: David Miller <davem@davemloft.net>
cc: geert@linux-m68k.org, joe@perches.com, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: [PATCH 1/2] mac8390: propagate error code from request_irq
In-Reply-To: <20100531.060225.68146363.davem@davemloft.net>
Message-ID: <alpine.OSX.2.00.1006011738330.299@localhost>
References: <alpine.LNX.2.00.1005312011210.469@nippy.intranet> <20100531.043056.258120791.davem@davemloft.net> <alpine.OSX.2.00.1005312244520.1490@localhost> <20100531.060225.68146363.davem@davemloft.net>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the request_irq() error code as the return value for mac8390_open(). 
EAGAIN doesn't make sense for Nubus slot IRQs. Only this driver can claim 
this IRQ (until the NIC is removed, which means everything is powered 
down).

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Index: linux-2.6.34/drivers/net/mac8390.c
===================================================================
--- linux-2.6.34.orig/drivers/net/mac8390.c	2010-06-01 20:20:29.000000000 +1000
+++ linux-2.6.34/drivers/net/mac8390.c	2010-06-01 20:22:23.000000000 +1000
@@ -643,12 +643,13 @@ static int __init mac8390_initdev(struct
 
 static int mac8390_open(struct net_device *dev)
 {
+	int err;
+
 	__ei_open(dev);
-	if (request_irq(dev->irq, __ei_interrupt, 0, "8390 Ethernet", dev)) {
-		pr_info("%s: unable to get IRQ %d.\n", dev->name, dev->irq);
-		return -EAGAIN;
-	}
-	return 0;
+	err = request_irq(dev->irq, __ei_interrupt, 0, "8390 Ethernet", dev);
+	if (err)
+		pr_info("%s: unable to get IRQ %d\n", dev->name, dev->irq);
+	return err;
 }
 
 static int mac8390_close(struct net_device *dev)
