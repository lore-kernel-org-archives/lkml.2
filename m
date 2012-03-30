Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935610Ab2C3VKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:10:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60805 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761639Ab2C3VKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:10:44 -0400
Message-Id: <20120330194841.925946024@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Simon Graham <simon.graham@virtualcomputer.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 039/149] rtlwifi: Handle previous allocation failures when freeing device memory
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Graham <simon.graham@virtualcomputer.com>

commit 7f66c2f93e5779625c10d262c84537427a2673ca upstream.

Handle previous allocation failures when freeing device memory

Signed-off-by: Simon Graham <simon.graham@virtualcomputer.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/pci.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1155,10 +1155,12 @@ static void _rtl_pci_free_tx_ring(struct
 		ring->idx = (ring->idx + 1) % ring->entries;
 	}
 
-	pci_free_consistent(rtlpci->pdev,
-			    sizeof(*ring->desc) * ring->entries,
-			    ring->desc, ring->dma);
-	ring->desc = NULL;
+	if (ring->desc) {
+		pci_free_consistent(rtlpci->pdev,
+				    sizeof(*ring->desc) * ring->entries,
+				    ring->desc, ring->dma);
+		ring->desc = NULL;
+	}
 }
 
 static void _rtl_pci_free_rx_ring(struct rtl_pci *rtlpci)
@@ -1182,12 +1184,14 @@ static void _rtl_pci_free_rx_ring(struct
 			kfree_skb(skb);
 		}
 
-		pci_free_consistent(rtlpci->pdev,
+		if (rtlpci->rx_ring[rx_queue_idx].desc) {
+			pci_free_consistent(rtlpci->pdev,
 				    sizeof(*rtlpci->rx_ring[rx_queue_idx].
 					   desc) * rtlpci->rxringcount,
 				    rtlpci->rx_ring[rx_queue_idx].desc,
 				    rtlpci->rx_ring[rx_queue_idx].dma);
-		rtlpci->rx_ring[rx_queue_idx].desc = NULL;
+			rtlpci->rx_ring[rx_queue_idx].desc = NULL;
+		}
 	}
 }
 


