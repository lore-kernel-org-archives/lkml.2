Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338Ab3AIVou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:44:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:41765 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933124Ab3AIUhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eric Leblond <eric@regit.org>, Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 07/80] ipv4: ip_check_defrag must not modify skb before unsharing
Date: Wed,  9 Jan 2013 12:34:59 -0800
Message-Id: <20130109201501.314845055@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_fragment.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -685,28 +685,27 @@ EXPORT_SYMBOL(ip_defrag);
 
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


