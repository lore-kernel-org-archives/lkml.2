Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab0HJHHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 03:07:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37431
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753602Ab0HJHHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 03:07:32 -0400
Date: Tue, 10 Aug 2010 00:07:51 -0700 (PDT)
Message-Id: <20100810.000751.260105232.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: greg@kroah.com, dwmw2@infradead.org, vapier@gentoo.org,
        jbarnes@virtuousgeek.org, kevin.curtis@farsite.co.uk,
        phillip@lougher.demon.co.uk, faisal.latif@intel.com,
        chien.tin.tung@intel.com, dan.j.williams@intel.com,
        samuel.ortiz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org, x86@kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: i386 allmodconfig, current mainline
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100809164346.6e30cf8c.akpm@linux-foundation.org>
References: <20100809164346.6e30cf8c.akpm@linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 9 Aug 2010 16:43:46 -0700

> drivers/net/wan/farsync.c: In function 'fst_intr_rx':
> drivers/net/wan/farsync.c:1312: warning: cast to pointer from integer of different size
> drivers/net/wan/farsync.c: In function 'do_bottom_half_tx':
> drivers/net/wan/farsync.c:1407: warning: cast to pointer from integer of different size

I'll toss the following into net-2.6:

--------------------
farsync: Fix compile warnings.

drivers/net/wan/farsync.c: In function 'fst_intr_rx':
drivers/net/wan/farsync.c:1312: warning: cast to pointer from integer of different size
drivers/net/wan/farsync.c: In function 'do_bottom_half_tx':
drivers/net/wan/farsync.c:1407: warning: cast to pointer from integer of different size

The "skb" and "mem" arguments being passed here are DMA addresses
being programmed into the hardware registers, so pass them as the type
that they actually are.  And use the correct printf formatting in
debug logging statements for these things to match the type change.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/wan/farsync.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index ad7719f..e050bd6 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -885,20 +885,21 @@ fst_rx_dma_complete(struct fst_card_info *card, struct fst_port_info *port,
  *      Receive a frame through the DMA
  */
 static inline void
-fst_rx_dma(struct fst_card_info *card, unsigned char *skb,
-	   unsigned char *mem, int len)
+fst_rx_dma(struct fst_card_info *card, dma_addr_t skb,
+	   dma_addr_t mem, int len)
 {
 	/*
 	 * This routine will setup the DMA and start it
 	 */
 
-	dbg(DBG_RX, "In fst_rx_dma %p %p %d\n", skb, mem, len);
+	dbg(DBG_RX, "In fst_rx_dma %lx %lx %d\n",
+	    (unsigned long) skb, (unsigned long) mem, len);
 	if (card->dmarx_in_progress) {
 		dbg(DBG_ASS, "In fst_rx_dma while dma in progress\n");
 	}
 
-	outl((unsigned long) skb, card->pci_conf + DMAPADR0);	/* Copy to here */
-	outl((unsigned long) mem, card->pci_conf + DMALADR0);	/* from here */
+	outl(skb, card->pci_conf + DMAPADR0);	/* Copy to here */
+	outl(mem, card->pci_conf + DMALADR0);	/* from here */
 	outl(len, card->pci_conf + DMASIZ0);	/* for this length */
 	outl(0x00000000c, card->pci_conf + DMADPR0);	/* In this direction */
 
@@ -1309,8 +1310,8 @@ fst_intr_rx(struct fst_card_info *card, struct fst_port_info *port)
 		card->dma_port_rx = port;
 		card->dma_len_rx = len;
 		card->dma_rxpos = rxp;
-		fst_rx_dma(card, (char *) card->rx_dma_handle_card,
-			   (char *) BUF_OFFSET(rxBuffer[pi][rxp][0]), len);
+		fst_rx_dma(card, card->rx_dma_handle_card,
+			   BUF_OFFSET(rxBuffer[pi][rxp][0]), len);
 	}
 	if (rxp != port->rxpos) {
 		dbg(DBG_ASS, "About to increment rxpos by more than 1\n");
-- 
1.7.2.1

