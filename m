Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab2DMRYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:24:22 -0400
Received: from mail.vyatta.com ([76.74.103.46]:43015 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab2DMRYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:24:17 -0400
Date: Fri, 13 Apr 2012 10:24:13 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: LinoSanfilippo@gmx.de, mlindner@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: sky2: in free_buffers() do proper checks before call of
 rx_clean()
Message-ID: <20120413102413.41c0d053@nehalam.linuxnetplumber.net>
In-Reply-To: <20120413.125954.1123124134206162716.davem@davemloft.net>
References: <20120403001327.GB10227@Neptun>
	<20120413.125954.1123124134206162716.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about this instead? It moves the rx_clean out of free_buffers and
into the proper place in the unwind code.


--- a/drivers/net/ethernet/marvell/sky2.c	2012-04-12 08:07:11.572640522 -0700
+++ b/drivers/net/ethernet/marvell/sky2.c	2012-04-13 10:19:39.466839378 -0700
@@ -1630,7 +1630,8 @@ static int sky2_alloc_buffers(struct sky
 	if (!sky2->rx_ring)
 		goto nomem;
 
-	return sky2_alloc_rx_skbs(sky2);
+	return 0;
+
 nomem:
 	return -ENOMEM;
 }
@@ -1639,8 +1640,6 @@ static void sky2_free_buffers(struct sky
 {
 	struct sky2_hw *hw = sky2->hw;
 
-	sky2_rx_clean(sky2);
-
 	if (sky2->rx_le) {
 		pci_free_consistent(hw->pdev, RX_LE_BYTES,
 				    sky2->rx_le, sky2->rx_le_map);
@@ -1761,9 +1760,13 @@ static int sky2_open(struct net_device *
 	if (err)
 		goto err_out;
 
+	err = sky2_alloc_rx_skbs(sky2);
+	if (err)
+		goto err_clean;
+
 	/* With single port, IRQ is setup when device is brought up */
 	if (hw->ports == 1 && (err = sky2_setup_irq(hw, dev->name)))
-		goto err_out;
+		goto err_clean;
 
 	sky2_hw_up(sky2);
 
@@ -1783,6 +1786,8 @@ static int sky2_open(struct net_device *
 
 	return 0;
 
+err_clean:
+	sky2_rx_clean(sky2);
 err_out:
 	sky2_free_buffers(sky2);
 	return err;
@@ -2158,6 +2163,7 @@ static int sky2_close(struct net_device
 
 	sky2_hw_down(sky2);
 
+	sky2_rx_clean(sky2);
 	sky2_free_buffers(sky2);
 
 	return 0;
