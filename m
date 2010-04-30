Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183Ab0D3R2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:28:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34016 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758529Ab0D3R1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:27:40 -0400
Date: Fri, 30 Apr 2010 15:50:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Diego Giagio <diego@giagio.com>, Daniel Mack <daniel@caiaq.de>
Subject: linux-next: build failure after merge of the staging-next tree
Message-Id: <20100430155052.87507421.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

After merging the staging-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/usb/ipheth.c: In function 'ipheth_alloc_urbs':
drivers/net/usb/ipheth.c:131: error: implicit declaration of function 'usb_buffer_alloc'
drivers/net/usb/ipheth.c:134: warning: assignment makes pointer from integer without a cast
drivers/net/usb/ipheth.c:141: warning: assignment makes pointer from integer without a cast
drivers/net/usb/ipheth.c:153: error: implicit declaration of function 'usb_buffer_free'

Caused by commit 3cc96f50329227fbf34de2459491901b6ee1c98c ("USB: rename
usb_buffer_alloc() and usb_buffer_free() users") from the usb tree
interacting with commit a19259c3d589a014e5f47f148f74dfc44422c82b
("drivers/net/usb: Add new driver ipheth") which entered Linus' tree about
April 25 via the net tree.

I applied the following fixup patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 30 Apr 2010 15:44:06 +1000
Subject: [PATCH] net: fix for usb_buffer_alloc/free rename

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/usb/ipheth.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 418825d..41071d0 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -128,14 +128,14 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
 	if (rx_urb == NULL)
 		goto free_tx_urb;
 
-	tx_buf = usb_buffer_alloc(iphone->udev,
+	tx_buf = usb_alloc_coherent(iphone->udev,
 				  IPHETH_BUF_SIZE,
 				  GFP_KERNEL,
 				  &tx_urb->transfer_dma);
 	if (tx_buf == NULL)
 		goto free_rx_urb;
 
-	rx_buf = usb_buffer_alloc(iphone->udev,
+	rx_buf = usb_alloc_coherent(iphone->udev,
 				  IPHETH_BUF_SIZE,
 				  GFP_KERNEL,
 				  &rx_urb->transfer_dma);
@@ -150,7 +150,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
 	return 0;
 
 free_tx_buf:
-	usb_buffer_free(iphone->udev, IPHETH_BUF_SIZE, tx_buf,
+	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, tx_buf,
 			tx_urb->transfer_dma);
 free_rx_urb:
 	usb_free_urb(rx_urb);
@@ -162,9 +162,9 @@ error_nomem:
 
 static void ipheth_free_urbs(struct ipheth_device *iphone)
 {
-	usb_buffer_free(iphone->udev, IPHETH_BUF_SIZE, iphone->rx_buf,
+	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->rx_buf,
 			iphone->rx_urb->transfer_dma);
-	usb_buffer_free(iphone->udev, IPHETH_BUF_SIZE, iphone->tx_buf,
+	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->tx_buf,
 			iphone->tx_urb->transfer_dma);
 	usb_free_urb(iphone->rx_urb);
 	usb_free_urb(iphone->tx_urb);
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
