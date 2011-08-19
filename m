Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab1HSNe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:34:27 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:58759 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab1HSN3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:50 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732450"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Shreyas Bhatewara <sbhatewara@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>
Subject: [PATCH 60/75] vmxnet3: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:32 +0100
Message-ID: <1313760467-8598-60-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Shreyas Bhatewara <sbhatewara@vmware.com>
Cc: "VMware, Inc." <pv-drivers@vmware.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/vmxnet3/vmxnet3_drv.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 1cbacb3..1acb5c8 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -654,7 +654,7 @@ vmxnet3_append_frag(struct sk_buff *skb, struct Vmxnet3_RxCompDesc *rcd,
 
 	BUG_ON(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS);
 
-	frag->page = rbi->page;
+	__skb_frag_set_page(frag, rbi->page);
 	frag->page_offset = 0;
 	frag->size = rcd->len;
 	skb->data_len += frag->size;
@@ -748,9 +748,9 @@ vmxnet3_map_pkt(struct sk_buff *skb, struct vmxnet3_tx_ctx *ctx,
 
 		tbi = tq->buf_info + tq->tx_ring.next2fill;
 		tbi->map_type = VMXNET3_MAP_PAGE;
-		tbi->dma_addr = pci_map_page(adapter->pdev, frag->page,
-					     frag->page_offset, frag->size,
-					     PCI_DMA_TODEVICE);
+		tbi->dma_addr = skb_frag_dma_map(&adapter->pdev->dev, frag,
+						 0, frag->size,
+						 PCI_DMA_TODEVICE);
 
 		tbi->len = frag->size;
 
-- 
1.7.2.5

