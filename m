Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1HSN2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:28:03 -0400
Received: from smtp.citrix.com ([66.165.176.89]:53547 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1HSN16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:27:58 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158199"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: [PATCH 03/75] net: ipv4: convert to SKB frag APIs
Date: Fri, 19 Aug 2011 14:26:35 +0100
Message-ID: <1313760467-8598-3-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Pekka Savola (ipv6)" <pekkas@netcore.fi>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org
---
 net/ipv4/inet_lro.c   |    2 +-
 net/ipv4/ip_output.c  |    7 ++++---
 net/ipv4/tcp.c        |    3 ++-
 net/ipv4/tcp_output.c |    2 +-
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/inet_lro.c b/net/ipv4/inet_lro.c
index ef7ae60..8e6be5a 100644
--- a/net/ipv4/inet_lro.c
+++ b/net/ipv4/inet_lro.c
@@ -433,7 +433,7 @@ static struct sk_buff *__lro_proc_segment(struct net_lro_mgr *lro_mgr,
 	if (!lro_mgr->get_frag_header ||
 	    lro_mgr->get_frag_header(frags, (void *)&mac_hdr, (void *)&iph,
 				     (void *)&tcph, &flags, priv)) {
-		mac_hdr = page_address(frags->page) + frags->page_offset;
+		mac_hdr = skb_frag_address(frags);
 		goto out1;
 	}
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 8c65633..ae3bb14 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -989,13 +989,13 @@ alloc_new_skb:
 			if (page && (left = PAGE_SIZE - off) > 0) {
 				if (copy >= left)
 					copy = left;
-				if (page != frag->page) {
+				if (page != skb_frag_page(frag)) {
 					if (i == MAX_SKB_FRAGS) {
 						err = -EMSGSIZE;
 						goto error;
 					}
-					get_page(page);
 					skb_fill_page_desc(skb, i, page, off, 0);
+					skb_frag_ref(skb, i);
 					frag = &skb_shinfo(skb)->frags[i];
 				}
 			} else if (i < MAX_SKB_FRAGS) {
@@ -1015,7 +1015,8 @@ alloc_new_skb:
 				err = -EMSGSIZE;
 				goto error;
 			}
-			if (getfrag(from, page_address(frag->page)+frag->page_offset+frag->size, offset, copy, skb->len, skb) < 0) {
+			if (getfrag(from, skb_frag_address(frag)+frag->size,
+				    offset, copy, skb->len, skb) < 0) {
 				err = -EFAULT;
 				goto error;
 			}
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 46febca..5fe632c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3035,7 +3035,8 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
 
 	for (i = 0; i < shi->nr_frags; ++i) {
 		const struct skb_frag_struct *f = &shi->frags[i];
-		sg_set_page(&sg, f->page, f->size, f->page_offset);
+		struct page *page = skb_frag_page(f);
+		sg_set_page(&sg, page, f->size, f->page_offset);
 		if (crypto_hash_update(desc, &sg, f->size))
 			return 1;
 	}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 882e0b0..0377c06 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1095,7 +1095,7 @@ static void __pskb_trim_head(struct sk_buff *skb, int len)
 	k = 0;
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		if (skb_shinfo(skb)->frags[i].size <= eat) {
-			put_page(skb_shinfo(skb)->frags[i].page);
+			skb_frag_unref(skb, i);
 			eat -= skb_shinfo(skb)->frags[i].size;
 		} else {
 			skb_shinfo(skb)->frags[k] = skb_shinfo(skb)->frags[i];
-- 
1.7.2.5

