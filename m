Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965611Ab2EOCl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:41:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:49768 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964886Ab2EOCRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:41 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 124/179] jme: Fix unmap error (Causing system freeze)
Date: Mon, 14 May 2012 22:13:40 -0400
Message-ID: <1337048075-6132-125-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guo-Fu Tseng <cooldavid@cooldavid.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/jme.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/jme.c b/drivers/net/jme.c
index b2d190e..7b8fc3d 100644
--- a/drivers/net/jme.c
+++ b/drivers/net/jme.c
@@ -682,20 +682,28 @@ jme_make_new_rx_buf(struct jme_adapter *jme, int i)
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
 
-- 
1.7.9.6

