Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654Ab2ERCwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:52:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40407 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762557Ab2ERCw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:28 -0400
Message-Id: <20120518023256.239396381@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, stephen hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 14/53] sky2: propogate rx hash when packet is copied
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <shemminger@vyatta.com>

[ Upstream commit 3f42941b5d1d13542b1a755a9e4f633aa72e4d3e ]

When a small packet is received, the driver copies it to a new skb to allow
reusing the full size Rx buffer. The copy was propogating the checksum offload
but not the receive hash information. The bug is impact was mostly harmless
and therefore not observed until reviewing this area of code.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/marvell/sky2.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 7eb8a00..e1f4b65 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -2475,8 +2475,11 @@ static struct sk_buff *receive_copy(struct sky2_port *sky2,
 		skb_copy_from_linear_data(re->skb, skb->data, length);
 		skb->ip_summed = re->skb->ip_summed;
 		skb->csum = re->skb->csum;
+		skb->rxhash = re->skb->rxhash;
+
 		pci_dma_sync_single_for_device(sky2->hw->pdev, re->data_addr,
 					       length, PCI_DMA_FROMDEVICE);
+		re->skb->rxhash = 0;
 		re->skb->ip_summed = CHECKSUM_NONE;
 		skb_put(skb, length);
 	}
-- 
1.7.10.1




