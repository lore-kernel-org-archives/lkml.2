Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab1HSNij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:38:39 -0400
Received: from smtp.citrix.com ([66.165.176.89]:37564 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab1HSN3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:19 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158315"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>, linux-driver@qlogic.com
Subject: [PATCH 44/75] qlge: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:16 +0100
Message-ID: <1313760467-8598-44-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
Cc: Ron Mercer <ron.mercer@qlogic.com>
Cc: linux-driver@qlogic.com
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/qlge/qlge_main.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/qlge/qlge_main.c b/drivers/net/qlge/qlge_main.c
index f07e96e..1da5bc7 100644
--- a/drivers/net/qlge/qlge_main.c
+++ b/drivers/net/qlge/qlge_main.c
@@ -1431,10 +1431,8 @@ static int ql_map_send(struct ql_adapter *qdev,
 			map_idx++;
 		}
 
-		map =
-		    pci_map_page(qdev->pdev, frag->page,
-				 frag->page_offset, frag->size,
-				 PCI_DMA_TODEVICE);
+		map = skb_frag_dma_map(&qdev->pdev->dev, frag, 0, frag->size,
+				       PCI_DMA_TODEVICE);
 
 		err = pci_dma_mapping_error(qdev->pdev, map);
 		if (err) {
@@ -1495,7 +1493,7 @@ static void ql_process_mac_rx_gro_page(struct ql_adapter *qdev,
 	rx_frag = skb_shinfo(skb)->frags;
 	nr_frags = skb_shinfo(skb)->nr_frags;
 	rx_frag += nr_frags;
-	rx_frag->page = lbq_desc->p.pg_chunk.page;
+	__skb_frag_set_page(rx_frag, lbq_desc->p.pg_chunk.page);
 	rx_frag->page_offset = lbq_desc->p.pg_chunk.offset;
 	rx_frag->size = length;
 
-- 
1.7.2.5

