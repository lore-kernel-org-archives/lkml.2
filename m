Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab1HSNac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:30:32 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30356 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab1HSNaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:30:23 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732563"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 75/75] net: return a *const* struct page from skb_frag_page.
Date: Fri, 19 Aug 2011 14:27:47 +0100
Message-ID: <1313760467-8598-75-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This attempts to catch bare uses of get/put_page (which take a non-const struct
page) on skb paged fragments.

Add __skb_frag_page for those callers which really need a non-const reference
to the page.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Michał Mirosław" <mirq-linux@rere.qmqm.pl>
Cc: netdev@vger.kernel.org
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |    4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |    2 +-
 drivers/net/bnx2.c                      |    2 +-
 drivers/net/cassini.c                   |    2 +-
 drivers/net/e1000/e1000_main.c          |    2 +-
 drivers/net/jme.c                       |    2 +-
 drivers/net/niu.c                       |    2 +-
 drivers/net/xen-netback/netback.c       |    2 +-
 drivers/net/xen-netfront.c              |    4 ++--
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c       |    2 +-
 drivers/scsi/cxgbi/libcxgbi.c           |    2 +-
 drivers/scsi/fcoe/fcoe_transport.c      |    2 +-
 include/linux/skbuff.h                  |   30 +++++++++++++++++++++---------
 net/core/skbuff.c                       |    6 ++++--
 net/core/user_dma.c                     |    2 +-
 net/ipv4/tcp.c                          |    2 +-
 16 files changed, 41 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 67a477b..be21cc2 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -537,8 +537,8 @@ static void skb_put_frags(struct sk_buff *skb, unsigned int hdr_space,
 
 		if (length == 0) {
 			/* don't need this page */
-			skb_fill_page_desc(toskb, i, skb_frag_page(frag),
-					   0, PAGE_SIZE);
+			skb_fill_page_desc(toskb, i, __skb_frag_page(frag),
+					   0, PAGE_SIZE);/* XXX */
 			--skb_shinfo(skb)->nr_frags;
 		} else {
 			size = min(length, (unsigned) PAGE_SIZE);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 00435be..003fc75 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -324,7 +324,7 @@ static int ipoib_dma_map_tx(struct ib_device *ca,
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; ++i) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		mapping[i + off] = ib_dma_map_page(ca,
-						 skb_frag_page(frag),
+						 __skb_frag_page(frag),
 						 frag->page_offset, frag->size,
 						 DMA_TO_DEVICE);
 		if (unlikely(ib_dma_mapping_error(ca, mapping[i + off])))
diff --git a/drivers/net/bnx2.c b/drivers/net/bnx2.c
index 005dd81..e1e96f5 100644
--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -2929,7 +2929,7 @@ bnx2_reuse_rx_skb_pages(struct bnx2 *bp, struct bnx2_rx_ring_info *rxr,
 
 		shinfo = skb_shinfo(skb);
 		shinfo->nr_frags--;
-		page = skb_frag_page(&shinfo->frags[shinfo->nr_frags]);
+		page = __skb_frag_page(&shinfo->frags[shinfo->nr_frags]);
 		__skb_frag_set_page(&shinfo->frags[shinfo->nr_frags], NULL);
 
 		cons_rx_pg->page = page;
diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
index de5c7590..0f21ab5 100644
--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -2842,7 +2842,7 @@ static inline int cas_xmit_tx_ringN(struct cas *cp, int ring,
 				      ctrl, 0);
 			entry = TX_DESC_NEXT(ring, entry);
 
-			addr = cas_page_map(skb_frag_page(fragp));
+			addr = cas_page_map(__skb_frag_page(fragp));
 			memcpy(tx_tiny_buf(cp, ring, entry),
 			       addr + fragp->page_offset + len - tabort,
 			       tabort);
diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index c96770c..34ad431 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -2927,7 +2927,7 @@ static int e1000_tx_map(struct e1000_adapter *adapter,
 			 * Avoid terminating buffers within evenly-aligned
 			 * dwords. */
 			bufend = (unsigned long)
-				page_to_phys(skb_frag_page(frag));
+				page_to_phys(__skb_frag_page(frag));
 			bufend += offset + size - 1;
 			if (unlikely(adapter->pcix_82544 &&
 				     !(bufend & 4) &&
diff --git a/drivers/net/jme.c b/drivers/net/jme.c
index 610b837..c0fd39e 100644
--- a/drivers/net/jme.c
+++ b/drivers/net/jme.c
@@ -1929,7 +1929,7 @@ jme_map_tx_skb(struct jme_adapter *jme, struct sk_buff *skb, int idx)
 		ctxbi = txbi + ((idx + i + 2) & (mask));
 
 		jme_fill_tx_map(jme->pdev, ctxdesc, ctxbi,
-				skb_frag_page(frag),
+				__skb_frag_page(frag),
 				frag->page_offset, frag->size, hidma);
 	}
 
diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index 0191712..22a7536 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -6736,7 +6736,7 @@ static netdev_tx_t niu_start_xmit(struct sk_buff *skb,
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		len = frag->size;
-		mapping = np->ops->map_page(np->device, skb_frag_page(frag),
+		mapping = np->ops->map_page(np->device, __skb_frag_page(frag),
 					    frag->page_offset, len,
 					    DMA_TO_DEVICE);
 
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 3068f67..824bd42 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -522,7 +522,7 @@ static int netbk_gop_skb(struct sk_buff *skb,
 
 	for (i = 0; i < nr_frags; i++) {
 		netbk_gop_frag_copy(vif, skb, npo,
-				    skb_frag_page(&skb_shinfo(skb)->frags[i]),
+				    __skb_frag_page(&skb_shinfo(skb)->frags[i]),
 				    skb_shinfo(skb)->frags[i].size,
 				    skb_shinfo(skb)->frags[i].page_offset,
 				    &head);
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 882a957..d93a1c6 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -770,7 +770,7 @@ static RING_IDX xennet_fill_frags(struct netfront_info *np,
 			RING_GET_RESPONSE(&np->rx, ++cons);
 		skb_frag_t *nfrag = &skb_shinfo(nskb)->frags[0];
 
-		__skb_frag_set_page(frag, skb_frag_page(nfrag));
+		__skb_frag_set_page(frag, __skb_frag_page(nfrag));
 		frag->page_offset = rx->offset;
 		frag->size = rx->status;
 
@@ -956,7 +956,7 @@ err:
 		}
 
 		NETFRONT_SKB_CB(skb)->page =
-			skb_frag_page(&skb_shinfo(skb)->frags[0]);
+			__skb_frag_page(&skb_shinfo(skb)->frags[0]);
 		NETFRONT_SKB_CB(skb)->offset = rx->offset;
 
 		len = rx->status;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 2c780a7..7828cb9 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -302,7 +302,7 @@ static int bnx2fc_xmit(struct fc_lport *lport, struct fc_frame *fp)
 			return -ENOMEM;
 		}
 		frag = &skb_shinfo(skb)->frags[skb_shinfo(skb)->nr_frags - 1];
-		cp = kmap_atomic(skb_frag_page(frag), KM_SKB_DATA_SOFTIRQ)
+		cp = kmap_atomic(__skb_frag_page(frag), KM_SKB_DATA_SOFTIRQ)
 				+ frag->page_offset;
 	} else {
 		cp = (struct fcoe_crc_eof *)skb_put(skb, tlen);
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 43cc6c6..ed3d48d 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1948,7 +1948,7 @@ int cxgbi_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
 
 			/* data fits in the skb's headroom */
 			for (i = 0; i < tdata->nr_frags; i++, frag++) {
-				char *src = kmap_atomic(skb_frag_page(frag),
+				char *src = kmap_atomic(__skb_frag_page(frag),
 							KM_SOFTIRQ0);
 
 				memcpy(dst, src+frag->page_offset, frag->size);
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index f6613f9..40243ce 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -109,7 +109,7 @@ u32 fcoe_fc_crc(struct fc_frame *fp)
 		while (len > 0) {
 			clen = min(len, PAGE_SIZE - (off & ~PAGE_MASK));
 			data = kmap_atomic(
-				skb_frag_page(frag) + (off >> PAGE_SHIFT),
+				__skb_frag_page(frag) + (off >> PAGE_SHIFT),
 				KM_SKB_DATA_SOFTIRQ);
 			crc = crc32(crc, data + (off & ~PAGE_MASK), clen);
 			kunmap_atomic(data, KM_SKB_DATA_SOFTIRQ);
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0328428..40dde83 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1698,12 +1698,24 @@ static inline void netdev_free_page(struct net_device *dev, struct page *page)
 }
 
 /**
- * skb_frag_page - retrieve the page refered to by a paged fragment
+ * __skb_frag_page - retrieve the page refered to by a paged fragment
  * @frag: the paged fragment
  *
- * Returns the &struct page associated with @frag.
+ * Returns the &struct page associated with @frag. Where possible you
+ * should use skb_frag_page() which returns a const &struct page.
  */
-static inline struct page *skb_frag_page(const skb_frag_t *frag)
+static inline struct page *__skb_frag_page(const skb_frag_t *frag)
+{
+	return frag->page.p;
+}
+
+/**
+ * __skb_frag_page - retrieve the page refered to by a paged fragment
+ * @frag: the paged fragment
+ *
+ * Returns the &struct page associated with @frag as a const.
+ */
+static inline const struct page *skb_frag_page(const skb_frag_t *frag)
 {
 	return frag->page.p;
 }
@@ -1723,7 +1735,7 @@ static inline void __skb_frag_ref(skb_frag_t *frag)
 		skb_frag_destructor_ref(frag->page.destructor);
 		return;
 	}
-	get_page(skb_frag_page(frag));
+	get_page(__skb_frag_page(frag));
 }
 
 /**
@@ -1750,7 +1762,7 @@ static inline void __skb_frag_unref(skb_frag_t *frag)
 		skb_frag_destructor_unref(frag->page.destructor);
 		return;
 	}
-	put_page(skb_frag_page(frag));
+	put_page(__skb_frag_page(frag));
 }
 
 /**
@@ -1827,7 +1839,7 @@ static inline void *skb_frag_kmap_atomic(const skb_frag_t *frag)
 
 	local_bh_disable();
 #endif
-	return kmap_atomic(skb_frag_page(frag), KM_SKB_DATA_SOFTIRQ);
+	return kmap_atomic(__skb_frag_page(frag), KM_SKB_DATA_SOFTIRQ);
 }
 
 static inline void skb_frag_kunmap_atomic(void *vaddr)
@@ -1846,7 +1858,7 @@ static inline void skb_frag_kunmap_atomic(void *vaddr)
  */
 static inline void *skb_frag_kmap(skb_frag_t *frag)
 {
-	return kmap(skb_frag_page(frag));
+	return kmap(__skb_frag_page(frag));
 }
 
 /**
@@ -1857,7 +1869,7 @@ static inline void *skb_frag_kmap(skb_frag_t *frag)
  */
 static inline void skb_frag_kunmap(skb_frag_t *frag)
 {
-	kunmap(skb_frag_page(frag));
+	kunmap(__skb_frag_page(frag));
 }
 
 /**
@@ -1876,7 +1888,7 @@ static inline dma_addr_t skb_frag_dma_map(struct device *dev,
 					  size_t offset, size_t size,
 					  enum dma_data_direction dir)
 {
-	return dma_map_page(dev, skb_frag_page(frag),
+	return dma_map_page(dev, __skb_frag_page(frag),
 			    frag->page_offset + offset, size, dir);
 }
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index d09d312..fbce6e7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1628,7 +1628,8 @@ static int __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 	for (seg = 0; seg < skb_shinfo(skb)->nr_frags; seg++) {
 		const skb_frag_t *f = &skb_shinfo(skb)->frags[seg];
 
-		if (__splice_segment(skb_frag_page(f),
+		/* XXX */
+		if (__splice_segment(__skb_frag_page(f),
 				     f->page_offset, f->size,
 				     offset, len, skb, spd, 0, sk, pipe))
 			return 1;
@@ -2940,7 +2941,8 @@ __skb_to_sgvec(struct sk_buff *skb, struct scatterlist *sg, int offset, int len)
 
 			if (copy > len)
 				copy = len;
-			sg_set_page(&sg[elt], skb_frag_page(frag), copy,
+			/* XXX */
+			sg_set_page(&sg[elt], __skb_frag_page(frag), copy,
 					frag->page_offset+offset-start);
 			elt++;
 			if (!(len -= copy))
diff --git a/net/core/user_dma.c b/net/core/user_dma.c
index 34e9664..d22ec3e 100644
--- a/net/core/user_dma.c
+++ b/net/core/user_dma.c
@@ -78,7 +78,7 @@ int dma_skb_copy_datagram_iovec(struct dma_chan *chan,
 		copy = end - offset;
 		if (copy > 0) {
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-			struct page *page = skb_frag_page(frag);
+			struct page *page = __skb_frag_page(frag); /* XXX */
 
 			if (copy > len)
 				copy = len;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5dd6d50..0b715bb 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3043,7 +3043,7 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
 
 	for (i = 0; i < shi->nr_frags; ++i) {
 		const struct skb_frag_struct *f = &shi->frags[i];
-		struct page *page = skb_frag_page(f);
+		struct page *page = __skb_frag_page(f); /* XXX */
 		sg_set_page(&sg, page, f->size, f->page_offset);
 		if (crypto_hash_update(desc, &sg, f->size))
 			return 1;
-- 
1.7.2.5

