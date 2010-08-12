Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615Ab0HLJym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 05:54:42 -0400
Received: from lo.gmane.org ([80.91.229.12]:57737 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab0HLJyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 05:54:41 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jindrich Makovicka <makovick@gmail.com>
Subject: [PATCH] forcedeth: reconfigure multicast packet filter only when
 needed
Date: Thu, 12 Aug 2010 11:54:30 +0200
Message-ID: <20100812115430.2b5d8683@starbug.prg01.itonis.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/+vDV3aaOdxrm2YKZrRsmiLh"
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 193.239.0.25
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/+vDV3aaOdxrm2YKZrRsmiLh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Currently, the forcedeth driver reconfigures the packet filter every
time a multicast stream is (un-)subscribed. As the receiving has to be
stopped and started in this case, any multicast subscription can cause
packet loss, allowing userspace applications to disrupt incoming
traffic.

With the following patch, nv_set_multicast first checks the cached
state of the packet filter, and skips the reconfiguration if the state
does not change. With the default settings, this can reduce some
useless reconfiguration attempts. When switched to promiscuous mode,
all reconfigurations are skipped with the patch, which can be used to
mitigate packet loss problems when receiving and re-subscribing many
multicasts simultaneously on a single machine.

Signed-off-by: Jindrich Makovicka <makovick@gmail.com>

-- 
Jindrich Makovicka

--MP_/+vDV3aaOdxrm2YKZrRsmiLh
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=forcedeth.c.diff

--- forcedeth.c.orig	2010-04-26 16:48:30.000000000 +0200
+++ forcedeth.c	2010-05-21 13:22:25.705907294 +0200
@@ -837,6 +837,11 @@
 	char name_rx[IFNAMSIZ + 3];       /* -rx    */
 	char name_tx[IFNAMSIZ + 3];       /* -tx    */
 	char name_other[IFNAMSIZ + 6];    /* -other */
+
+	/* current packet filter state */
+	u32 cur_pff;
+	u32 cur_addr[2];
+	u32 cur_mask[2];
 };
 
 /*
@@ -3128,17 +3133,28 @@
 	}
 	addr[0] |= NVREG_MCASTADDRA_FORCE;
 	pff |= NVREG_PFF_ALWAYS;
-	spin_lock_irq(&np->lock);
-	nv_stop_rx(dev);
-	writel(addr[0], base + NvRegMulticastAddrA);
-	writel(addr[1], base + NvRegMulticastAddrB);
-	writel(mask[0], base + NvRegMulticastMaskA);
-	writel(mask[1], base + NvRegMulticastMaskB);
-	writel(pff, base + NvRegPacketFilterFlags);
-	dprintk(KERN_INFO "%s: reconfiguration for multicast lists.\n",
-		dev->name);
-	nv_start_rx(dev);
-	spin_unlock_irq(&np->lock);
+	if (np->cur_pff != (pff & ~NVREG_PFF_PAUSE_RX)
+	    || memcmp(np->cur_addr, addr, sizeof(np->cur_addr)) != 0
+	    || memcmp(np->cur_mask, mask, sizeof(np->cur_mask)) != 0)
+	{
+		dprintk(KERN_INFO "%s: reconfiguration for multicast lists.\n",
+			dev->name);
+		spin_lock_irq(&np->lock);
+		nv_stop_rx(dev);
+		writel(addr[0], base + NvRegMulticastAddrA);
+		writel(addr[1], base + NvRegMulticastAddrB);
+		writel(mask[0], base + NvRegMulticastMaskA);
+		writel(mask[1], base + NvRegMulticastMaskB);
+		writel(pff, base + NvRegPacketFilterFlags);
+		nv_start_rx(dev);
+		spin_unlock_irq(&np->lock);
+		memcpy(np->cur_addr, addr, sizeof(np->cur_addr));
+		memcpy(np->cur_mask, mask, sizeof(np->cur_mask));
+		np->cur_pff = pff & ~NVREG_PFF_PAUSE_RX;
+	} else {
+		dprintk(KERN_INFO "%s: pff state unchanged - skipping reconfiguration.\n",
+			dev->name);
+	}
 }
 
 static void nv_update_pause(struct net_device *dev, u32 pause_flags)
@@ -5369,6 +5385,12 @@
 	writel(NVREG_MCASTMASKB_NONE, base + NvRegMulticastMaskB);
 	writel(0, base + NvRegPacketFilterFlags);
 
+	np->cur_pff = 0;
+	np->cur_addr[0] = NVREG_MCASTADDRA_FORCE;
+	np->cur_addr[1] = 0;
+	np->cur_mask[0] = NVREG_MCASTMASKA_NONE;
+	np->cur_mask[1] = NVREG_MCASTMASKB_NONE;
+
 	writel(0, base + NvRegTransmitterControl);
 	writel(0, base + NvRegReceiverControl);
 

--MP_/+vDV3aaOdxrm2YKZrRsmiLh--


