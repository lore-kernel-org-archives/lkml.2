Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab1HSNcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:32:17 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:58759 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab1HSNaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:30:07 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732519"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 69/75] net: only allow paged fragments with the same destructor to be coalesced.
Date: Fri, 19 Aug 2011 14:27:41 +0100
Message-ID: <1313760467-8598-69-git-send-email-ian.campbell@citrix.com>
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
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Pekka Savola (ipv6)" <pekkas@netcore.fi>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Michał Mirosław" <mirq-linux@rere.qmqm.pl>
Cc: netdev@vger.kernel.org
---
 include/linux/skbuff.h |    7 +++++--
 net/core/skbuff.c      |    1 +
 net/ipv4/ip_output.c   |    2 +-
 net/ipv4/tcp.c         |    4 ++--
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c6a3d4b..665a881 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1941,13 +1941,16 @@ static inline int skb_add_data(struct sk_buff *skb,
 }
 
 static inline int skb_can_coalesce(struct sk_buff *skb, int i,
-				   const struct page *page, int off)
+				   const struct page *page,
+				   const struct skb_frag_destructor *destroy,
+				   int off)
 {
 	if (i) {
 		struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i - 1];
 
 		return page == skb_frag_page(frag) &&
-		       off == frag->page_offset + frag->size;
+		       off == frag->page_offset + frag->size &&
+		       frag->page.destructor == destroy;
 	}
 	return 0;
 }
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 906a3e7..e294c34 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2251,6 +2251,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 	 */
 	if (!to ||
 	    !skb_can_coalesce(tgt, to, skb_frag_page(fragfrom),
+			      fragfrom->page.destructor,
 			      fragfrom->page_offset)) {
 		merge = -1;
 	} else {
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index ae3bb14..f198745 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1229,7 +1229,7 @@ ssize_t	ip_append_page(struct sock *sk, struct flowi4 *fl4, struct page *page,
 		i = skb_shinfo(skb)->nr_frags;
 		if (len > size)
 			len = size;
-		if (skb_can_coalesce(skb, i, page, offset)) {
+		if (skb_can_coalesce(skb, i, page, NULL, offset)) {
 			skb_shinfo(skb)->frags[i-1].size += len;
 		} else if (i < MAX_SKB_FRAGS) {
 			get_page(page);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5fe632c..dd93333 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -804,7 +804,7 @@ new_segment:
 			copy = size;
 
 		i = skb_shinfo(skb)->nr_frags;
-		can_coalesce = skb_can_coalesce(skb, i, page, offset);
+		can_coalesce = skb_can_coalesce(skb, i, page, NULL, offset);
 		if (!can_coalesce && i >= MAX_SKB_FRAGS) {
 			tcp_mark_push(tp, skb);
 			goto new_segment;
@@ -1008,7 +1008,7 @@ new_segment:
 				struct page *page = TCP_PAGE(sk);
 				int off = TCP_OFF(sk);
 
-				if (skb_can_coalesce(skb, i, page, off) &&
+				if (skb_can_coalesce(skb, i, page, NULL, off) &&
 				    off != PAGE_SIZE) {
 					/* We can extend the last page
 					 * fragment. */
-- 
1.7.2.5

