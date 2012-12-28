Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab2L1Tyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:54:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55002 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754360Ab2L1TRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:13 -0500
Message-Id: <20121228190400.856420448@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>, Eric Leblond <eric@regit.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 157/173] ipv4: ip_check_defrag must not modify skb before unsharing
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1bf3751ec90cc3174e01f0d701e8449ce163d113 ]

ip_check_defrag() might be called from af_packet within the
RX path where shared SKBs are used, so it must not modify
the input SKB before it has unshared it for defragmentation.
Use skb_copy_bits() to get the IP header and only pull in
everything later.

The same is true for the other caller in macvlan as it is
called from dev->rx_handler which can also get a shared SKB.

Reported-by: Eric Leblond <eric@regit.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/ip_fragment.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index fdaabf2..a4e7131 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -684,28 +684,27 @@ EXPORT_SYMBOL(ip_defrag);
 
 struct sk_buff *ip_check_defrag(struct sk_buff *skb, u32 user)
 {
-	const struct iphdr *iph;
+	struct iphdr iph;
 	u32 len;
 
 	if (skb->protocol != htons(ETH_P_IP))
 		return skb;
 
-	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+	if (!skb_copy_bits(skb, 0, &iph, sizeof(iph)))
 		return skb;
 
-	iph = ip_hdr(skb);
-	if (iph->ihl < 5 || iph->version != 4)
+	if (iph.ihl < 5 || iph.version != 4)
 		return skb;
-	if (!pskb_may_pull(skb, iph->ihl*4))
-		return skb;
-	iph = ip_hdr(skb);
-	len = ntohs(iph->tot_len);
-	if (skb->len < len || len < (iph->ihl * 4))
+
+	len = ntohs(iph.tot_len);
+	if (skb->len < len || len < (iph.ihl * 4))
 		return skb;
 
-	if (ip_is_fragment(ip_hdr(skb))) {
+	if (ip_is_fragment(&iph)) {
 		skb = skb_share_check(skb, GFP_ATOMIC);
 		if (skb) {
+			if (!pskb_may_pull(skb, iph.ihl*4))
+				return skb;
 			if (pskb_trim_rcsum(skb, len))
 				return skb;
 			memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));


