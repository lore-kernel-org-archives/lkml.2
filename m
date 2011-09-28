Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab1I1WqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:46:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932904Ab1I1Wp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:45:56 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:39 2011
Message-Id: <20110928220139.049624112@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Brian King <brking@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [130/244] ibmveth: Fix DMA unmap error
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Brian King <brking@linux.vnet.ibm.com>

commit 33a48ab105a75d37021e422a0a3283241099b142 upstream.

Commit 6e8ab30ec677 (ibmveth: Add scatter-gather support) introduced a
DMA mapping API inconsistency resulting in dma_unmap_page getting
called on memory mapped via dma_map_single. This was seen when
CONFIG_DMA_API_DEBUG was enabled. Fix up this API usage inconsistency.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Acked-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ibmveth.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -1025,7 +1025,12 @@ retry_bounce:
 		netdev->stats.tx_bytes += skb->len;
 	}
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags + 1; i++)
+	dma_unmap_single(&adapter->vdev->dev,
+			 descs[0].fields.address,
+			 descs[0].fields.flags_len & IBMVETH_BUF_LEN_MASK,
+			 DMA_TO_DEVICE);
+
+	for (i = 1; i < skb_shinfo(skb)->nr_frags + 1; i++)
 		dma_unmap_page(&adapter->vdev->dev, descs[i].fields.address,
 			       descs[i].fields.flags_len & IBMVETH_BUF_LEN_MASK,
 			       DMA_TO_DEVICE);


