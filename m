Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab1HFAH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:07:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757037Ab1HFAHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:07:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:51 2011
Message-Id: <20110806000251.174644129@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:01:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guo-Fu Tseng <cooldavid@cooldavid.org>,
        Chris Wright <chrisw@sous-sol.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [23/55] jme: Fix unmap error (Causing system freeze)
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Guo-Fu Tseng <cooldavid@cooldavid.org>

commit 94c5b41b327e08de0ddf563237855f55080652a1 upstream.

This patch add the missing dma_unmap().
Which solved the critical issue of system freeze on heavy load.

Michal Miroslaw's rejected patch:
[PATCH v2 10/46] net: jme: convert to generic DMA API
Pointed out the issue also, thank you Michal.
But the fix was incorrect. It would unmap needed address
when low memory.

Got lots of feedback from End user and Gentoo Bugzilla.
https://bugs.gentoo.org/show_bug.cgi?id=373109
Thank you all. :)

Signed-off-by: Guo-Fu Tseng <cooldavid@cooldavid.org>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/jme.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/net/jme.c
+++ b/drivers/net/jme.c
@@ -681,20 +681,28 @@ jme_make_new_rx_buf(struct jme_adapter *
 	struct jme_ring *rxring = &(jme->rxring[0]);
 	struct jme_buffer_info *rxbi = rxring->bufinf + i;
 	struct sk_buff *skb;
+	dma_addr_t mapping;
 
 	skb = netdev_alloc_skb(jme->dev,
 		jme->dev->mtu + RX_EXTRA_LEN);
 	if (unlikely(!skb))
 		return -ENOMEM;
 
+	mapping = pci_map_page(jme->pdev, virt_to_page(skb->data),
+			       offset_in_page(skb->data), skb_tailroom(skb),
+			       PCI_DMA_FROMDEVICE);
+	if (unlikely(pci_dma_mapping_error(jme->pdev, mapping))) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	if (likely(rxbi->mapping))
+		pci_unmap_page(jme->pdev, rxbi->mapping,
+			       rxbi->len, PCI_DMA_FROMDEVICE);
+
 	rxbi->skb = skb;
 	rxbi->len = skb_tailroom(skb);
-	rxbi->mapping = pci_map_page(jme->pdev,
-					virt_to_page(skb->data),
-					offset_in_page(skb->data),
-					rxbi->len,
-					PCI_DMA_FROMDEVICE);
-
+	rxbi->mapping = mapping;
 	return 0;
 }
 


