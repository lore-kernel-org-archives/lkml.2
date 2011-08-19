Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab1HSNbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:31:14 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30356 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab1HSNaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:30:19 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732555"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Robert Love <robert.w.love@intel.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Tom Herbert <therbert@google.com>, devel@open-fcoe.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 73/75] net: move skb frag kmap functions to skbuff.h
Date: Fri, 19 Aug 2011 14:27:45 +0100
Message-ID: <1313760467-8598-73-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage is open-coded in drivers/scsi/fcoe/fcoe.c and net/appletalk/ddp.c
uses an out-of-directory local include of "../core/kmap_skb.h".

Rename functions k(un)map_skb_frag to skb_frag_k(un)map_atomic to avoid
confusion with shortly to be introduced skb_frag_k(un)map.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Michał Mirosław" <mirq-linux@rere.qmqm.pl>
Cc: Tom Herbert <therbert@google.com>
Cc: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/scsi/fcoe/fcoe.c |    5 ++---
 include/linux/skbuff.h   |   19 +++++++++++++++++++
 net/appletalk/ddp.c      |    5 ++---
 net/core/kmap_skb.h      |   19 -------------------
 net/core/skbuff.c        |   35 +++++++++++++++++------------------
 5 files changed, 40 insertions(+), 43 deletions(-)
 delete mode 100644 net/core/kmap_skb.h

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 3416ab6..857e281 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1514,8 +1514,7 @@ int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 			return -ENOMEM;
 		}
 		frag = &skb_shinfo(skb)->frags[skb_shinfo(skb)->nr_frags - 1];
-		cp = kmap_atomic(skb_frag_page(frag), KM_SKB_DATA_SOFTIRQ)
-			+ frag->page_offset;
+		cp = skb_frag_kmap_atomic(frag) + frag->page_offset;
 	} else {
 		cp = (struct fcoe_crc_eof *)skb_put(skb, tlen);
 	}
@@ -1525,7 +1524,7 @@ int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 	cp->fcoe_crc32 = cpu_to_le32(~crc);
 
 	if (skb_is_nonlinear(skb)) {
-		kunmap_atomic(cp, KM_SKB_DATA_SOFTIRQ);
+		skb_frag_kunmap_atomic(frag);
 		cp = NULL;
 	}
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 665a881..73d8f7a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -29,6 +29,7 @@
 #include <linux/rcupdate.h>
 #include <linux/dmaengine.h>
 #include <linux/hrtimer.h>
+#include <linux/highmem.h>
 #include <linux/dma-mapping.h>
 
 /* Don't change this without changing skb_csum_unnecessary! */
@@ -1819,6 +1820,24 @@ static inline void skb_frag_set_page(struct sk_buff *skb, int f,
 	__skb_frag_set_page(&skb_shinfo(skb)->frags[f], page);
 }
 
+static inline void *skb_frag_kmap_atomic(const skb_frag_t *frag)
+{
+#ifdef CONFIG_HIGHMEM
+	BUG_ON(in_irq());
+
+	local_bh_disable();
+#endif
+	return kmap_atomic(skb_frag_page(frag), KM_SKB_DATA_SOFTIRQ);
+}
+
+static inline void skb_frag_kunmap_atomic(void *vaddr)
+{
+	kunmap_atomic(vaddr, KM_SKB_DATA_SOFTIRQ);
+#ifdef CONFIG_HIGHMEM
+	local_bh_enable();
+#endif
+}
+
 /**
  * skb_frag_dma_map - maps a paged fragment via the DMA API
  * @device: the device to map the fragment to
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index b1fe7c3..4a1b2bc 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -63,7 +63,6 @@
 #include <net/tcp_states.h>
 #include <net/route.h>
 #include <linux/atalk.h>
-#include "../core/kmap_skb.h"
 
 struct datalink_proto *ddp_dl, *aarp_dl;
 static const struct proto_ops atalk_dgram_ops;
@@ -961,10 +960,10 @@ static unsigned long atalk_sum_skb(const struct sk_buff *skb, int offset,
 
 			if (copy > len)
 				copy = len;
-			vaddr = kmap_skb_frag(frag);
+			vaddr = skb_frag_kmap_atomic(frag);
 			sum = atalk_sum_partial(vaddr + frag->page_offset +
 						  offset - start, copy, sum);
-			kunmap_skb_frag(vaddr);
+			skb_frag_kunmap_atomic(vaddr);
 
 			if (!(len -= copy))
 				return sum;
diff --git a/net/core/kmap_skb.h b/net/core/kmap_skb.h
deleted file mode 100644
index 81e1ed7..0000000
--- a/net/core/kmap_skb.h
+++ /dev/null
@@ -1,19 +0,0 @@
-#include <linux/highmem.h>
-
-static inline void *kmap_skb_frag(const skb_frag_t *frag)
-{
-#ifdef CONFIG_HIGHMEM
-	BUG_ON(in_irq());
-
-	local_bh_disable();
-#endif
-	return kmap_atomic(skb_frag_page(frag), KM_SKB_DATA_SOFTIRQ);
-}
-
-static inline void kunmap_skb_frag(void *vaddr)
-{
-	kunmap_atomic(vaddr, KM_SKB_DATA_SOFTIRQ);
-#ifdef CONFIG_HIGHMEM
-	local_bh_enable();
-#endif
-}
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e294c34..d09d312 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -69,8 +69,6 @@
 #include <asm/system.h>
 #include <trace/events/skb.h>
 
-#include "kmap_skb.h"
-
 static struct kmem_cache *skbuff_head_cache __read_mostly;
 static struct kmem_cache *skbuff_fclone_cache __read_mostly;
 
@@ -649,10 +647,10 @@ static int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 			}
 			return -ENOMEM;
 		}
-		vaddr = kmap_skb_frag(&skb_shinfo(skb)->frags[i]);
+		vaddr = skb_frag_kmap_atomic(&skb_shinfo(skb)->frags[i]);
 		memcpy(page_address(page),
 		       vaddr + f->page_offset, f->size);
-		kunmap_skb_frag(vaddr);
+		skb_frag_kunmap_atomic(vaddr);
 		page->private = (unsigned long)head;
 		head = page;
 	}
@@ -1434,15 +1432,16 @@ int skb_copy_bits(const struct sk_buff *skb, int offset, void *to, int len)
 		end = start + skb_shinfo(skb)->frags[i].size;
 		if ((copy = end - offset) > 0) {
 			u8 *vaddr;
+			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 			if (copy > len)
 				copy = len;
 
-			vaddr = kmap_skb_frag(&skb_shinfo(skb)->frags[i]);
+			vaddr = skb_frag_kmap_atomic(frag);
 			memcpy(to,
-			       vaddr + skb_shinfo(skb)->frags[i].page_offset+
-			       offset - start, copy);
-			kunmap_skb_frag(vaddr);
+			       vaddr + frag->page_offset + offset - start,
+			       copy);
+			skb_frag_kunmap_atomic(vaddr);
 
 			if ((len -= copy) == 0)
 				return 0;
@@ -1747,10 +1746,10 @@ int skb_store_bits(struct sk_buff *skb, int offset, const void *from, int len)
 			if (copy > len)
 				copy = len;
 
-			vaddr = kmap_skb_frag(frag);
+			vaddr = skb_frag_kmap_atomic(frag);
 			memcpy(vaddr + frag->page_offset + offset - start,
 			       from, copy);
-			kunmap_skb_frag(vaddr);
+			skb_frag_kunmap_atomic(vaddr);
 
 			if ((len -= copy) == 0)
 				return 0;
@@ -1821,10 +1820,10 @@ __wsum skb_checksum(const struct sk_buff *skb, int offset,
 
 			if (copy > len)
 				copy = len;
-			vaddr = kmap_skb_frag(frag);
+			vaddr = skb_frag_kmap_atomic(frag);
 			csum2 = csum_partial(vaddr + frag->page_offset +
 					     offset - start, copy, 0);
-			kunmap_skb_frag(vaddr);
+			skb_frag_kunmap_atomic(vaddr);
 			csum = csum_block_add(csum, csum2, pos);
 			if (!(len -= copy))
 				return csum;
@@ -1896,12 +1895,12 @@ __wsum skb_copy_and_csum_bits(const struct sk_buff *skb, int offset,
 
 			if (copy > len)
 				copy = len;
-			vaddr = kmap_skb_frag(frag);
+			vaddr = skb_frag_kmap_atomic(frag);
 			csum2 = csum_partial_copy_nocheck(vaddr +
 							  frag->page_offset +
 							  offset - start, to,
 							  copy, 0);
-			kunmap_skb_frag(vaddr);
+			skb_frag_kunmap_atomic(vaddr);
 			csum = csum_block_add(csum, csum2, pos);
 			if (!(len -= copy))
 				return csum;
@@ -2422,7 +2421,7 @@ next_skb:
 
 		if (abs_offset < block_limit) {
 			if (!st->frag_data)
-				st->frag_data = kmap_skb_frag(frag);
+				st->frag_data = skb_frag_kmap_atomic(frag);
 
 			*data = (u8 *) st->frag_data + frag->page_offset +
 				(abs_offset - st->stepped_offset);
@@ -2431,7 +2430,7 @@ next_skb:
 		}
 
 		if (st->frag_data) {
-			kunmap_skb_frag(st->frag_data);
+			skb_frag_kunmap_atomic(st->frag_data);
 			st->frag_data = NULL;
 		}
 
@@ -2440,7 +2439,7 @@ next_skb:
 	}
 
 	if (st->frag_data) {
-		kunmap_skb_frag(st->frag_data);
+		skb_frag_kunmap_atomic(st->frag_data);
 		st->frag_data = NULL;
 	}
 
@@ -2468,7 +2467,7 @@ EXPORT_SYMBOL(skb_seq_read);
 void skb_abort_seq_read(struct skb_seq_state *st)
 {
 	if (st->frag_data)
-		kunmap_skb_frag(st->frag_data);
+		skb_frag_kunmap_atomic(st->frag_data);
 }
 EXPORT_SYMBOL(skb_abort_seq_read);
 
-- 
1.7.2.5

