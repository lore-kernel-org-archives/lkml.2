Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab1HSNa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:30:28 -0400
Received: from smtp.citrix.com ([66.165.176.89]:24015 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571Ab1HSNaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:30:22 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158401"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Tom Herbert <therbert@google.com>, Neil Horman <nhorman@tuxdriver.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Subject: [PATCH 74/75] net: add skb_frag_k(un)map convenience functions.
Date: Fri, 19 Aug 2011 14:27:46 +0100
Message-ID: <1313760467-8598-74-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Michał Mirosław" <mirq-linux@rere.qmqm.pl>
Cc: Tom Herbert <therbert@google.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 include/linux/skbuff.h |   22 ++++++++++++++++++++++
 net/core/datagram.c    |   20 ++++++++------------
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 73d8f7a..0328428 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1839,6 +1839,28 @@ static inline void skb_frag_kunmap_atomic(void *vaddr)
 }
 
 /**
+ * skb_frag_kmap - kmaps a paged fragment
+ * @frag: the paged fragment
+ *
+ * kmap()s the paged fragment @frag and returns the virtual address.
+ */
+static inline void *skb_frag_kmap(skb_frag_t *frag)
+{
+	return kmap(skb_frag_page(frag));
+}
+
+/**
+ * skb_frag_kunmap - kunmaps a paged fragment
+ * @frag: the paged fragment
+ *
+ * kunmap()s the paged fragment @frag.
+ */
+static inline void skb_frag_kunmap(skb_frag_t *frag)
+{
+	kunmap(skb_frag_page(frag));
+}
+
+/**
  * skb_frag_dma_map - maps a paged fragment via the DMA API
  * @device: the device to map the fragment to
  * @frag: the paged fragment to map
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 6449bed..f0dcaa2 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -332,14 +332,13 @@ int skb_copy_datagram_iovec(const struct sk_buff *skb, int offset,
 			int err;
 			u8  *vaddr;
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-			struct page *page = skb_frag_page(frag);
 
 			if (copy > len)
 				copy = len;
-			vaddr = kmap(page);
+			vaddr = skb_frag_kmap(frag);
 			err = memcpy_toiovec(to, vaddr + frag->page_offset +
 					     offset - start, copy);
-			kunmap(page);
+			skb_frag_kunmap(frag);
 			if (err)
 				goto fault;
 			if (!(len -= copy))
@@ -418,14 +417,13 @@ int skb_copy_datagram_const_iovec(const struct sk_buff *skb, int offset,
 			int err;
 			u8  *vaddr;
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-			struct page *page = skb_frag_page(frag);
 
 			if (copy > len)
 				copy = len;
-			vaddr = kmap(page);
+			vaddr = skb_frag_kmap(frag);
 			err = memcpy_toiovecend(to, vaddr + frag->page_offset +
 						offset - start, to_offset, copy);
-			kunmap(page);
+			skb_frag_kunmap(frag);
 			if (err)
 				goto fault;
 			if (!(len -= copy))
@@ -508,15 +506,14 @@ int skb_copy_datagram_from_iovec(struct sk_buff *skb, int offset,
 			int err;
 			u8  *vaddr;
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-			struct page *page = skb_frag_page(frag);
 
 			if (copy > len)
 				copy = len;
-			vaddr = kmap(page);
+			vaddr = skb_frag_kmap(frag);
 			err = memcpy_fromiovecend(vaddr + frag->page_offset +
 						  offset - start,
 						  from, from_offset, copy);
-			kunmap(page);
+			skb_frag_kunmap(frag);
 			if (err)
 				goto fault;
 
@@ -594,16 +591,15 @@ static int skb_copy_and_csum_datagram(const struct sk_buff *skb, int offset,
 			int err = 0;
 			u8  *vaddr;
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-			struct page *page = skb_frag_page(frag);
 
 			if (copy > len)
 				copy = len;
-			vaddr = kmap(page);
+			vaddr = skb_frag_kmap(frag);
 			csum2 = csum_and_copy_to_user(vaddr +
 							frag->page_offset +
 							offset - start,
 						      to, copy, 0, &err);
-			kunmap(page);
+			skb_frag_kunmap(frag);
 			if (err)
 				goto fault;
 			*csump = csum_block_add(*csump, csum2, pos);
-- 
1.7.2.5

