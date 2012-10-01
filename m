Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab2JAXDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:03:43 -0400
Received: from 1wt.eu ([62.212.114.60]:35676 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab2JAXDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:03:40 -0400
Message-Id: <20121001225200.027259736@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 057/180] ipsec: be careful of non existing mac headers
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 03606895cd98c0a628b17324fd7b5ff15db7e3cd ]

Niccolo Belli reported ipsec crashes in case we handle a frame without
mac header (atm in his case)

Before copying mac header, better make sure it is present.

Bugzilla reference:  https://bugzilla.kernel.org/show_bug.cgi?id=42809

Reported-by: Niccolò Belli <darkbasic@linuxsystems.it>
Tested-by: Niccolò Belli <darkbasic@linuxsystems.it>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/linux/skbuff.h       |   10 ++++++++++
 net/ipv4/xfrm4_mode_beet.c   |    5 +----
 net/ipv4/xfrm4_mode_tunnel.c |    6 ++----
 net/ipv6/xfrm6_mode_beet.c   |    6 +-----
 net/ipv6/xfrm6_mode_tunnel.c |    6 ++----
 5 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bcdd660..4e647bb 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1312,6 +1312,16 @@ static inline void skb_set_mac_header(struct sk_buff *skb, const int offset)
 }
 #endif /* NET_SKBUFF_DATA_USES_OFFSET */
 
+static inline void skb_mac_header_rebuild(struct sk_buff *skb)
+{
+	if (skb_mac_header_was_set(skb)) {
+		const unsigned char *old_mac = skb_mac_header(skb);
+
+		skb_set_mac_header(skb, -skb->mac_len);
+		memmove(skb_mac_header(skb), old_mac, skb->mac_len);
+	}
+}
+
 static inline int skb_transport_offset(const struct sk_buff *skb)
 {
 	return skb_transport_header(skb) - skb->data;
diff --git a/net/ipv4/xfrm4_mode_beet.c b/net/ipv4/xfrm4_mode_beet.c
index 6341818..e3db3f9 100644
--- a/net/ipv4/xfrm4_mode_beet.c
+++ b/net/ipv4/xfrm4_mode_beet.c
@@ -110,10 +110,7 @@ static int xfrm4_beet_input(struct xfrm_state *x, struct sk_buff *skb)
 
 	skb_push(skb, sizeof(*iph));
 	skb_reset_network_header(skb);
-
-	memmove(skb->data - skb->mac_len, skb_mac_header(skb),
-		skb->mac_len);
-	skb_set_mac_header(skb, -skb->mac_len);
+	skb_mac_header_rebuild(skb);
 
 	xfrm4_beet_make_header(skb);
 
diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
index 3444f3b..5d1d1fd 100644
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -65,7 +65,6 @@ static int xfrm4_mode_tunnel_output(struct xfrm_state *x, struct sk_buff *skb)
 
 static int xfrm4_mode_tunnel_input(struct xfrm_state *x, struct sk_buff *skb)
 {
-	const unsigned char *old_mac;
 	int err = -EINVAL;
 
 	if (XFRM_MODE_SKB_CB(skb)->protocol != IPPROTO_IPIP)
@@ -83,10 +82,9 @@ static int xfrm4_mode_tunnel_input(struct xfrm_state *x, struct sk_buff *skb)
 	if (!(x->props.flags & XFRM_STATE_NOECN))
 		ipip_ecn_decapsulate(skb);
 
-	old_mac = skb_mac_header(skb);
-	skb_set_mac_header(skb, -skb->mac_len);
-	memmove(skb_mac_header(skb), old_mac, skb->mac_len);
 	skb_reset_network_header(skb);
+	skb_mac_header_rebuild(skb);
+
 	err = 0;
 
 out:
diff --git a/net/ipv6/xfrm6_mode_beet.c b/net/ipv6/xfrm6_mode_beet.c
index bbd48b1..6cc7a45 100644
--- a/net/ipv6/xfrm6_mode_beet.c
+++ b/net/ipv6/xfrm6_mode_beet.c
@@ -82,7 +82,6 @@ static int xfrm6_beet_output(struct xfrm_state *x, struct sk_buff *skb)
 static int xfrm6_beet_input(struct xfrm_state *x, struct sk_buff *skb)
 {
 	struct ipv6hdr *ip6h;
-	const unsigned char *old_mac;
 	int size = sizeof(struct ipv6hdr);
 	int err;
 
@@ -92,10 +91,7 @@ static int xfrm6_beet_input(struct xfrm_state *x, struct sk_buff *skb)
 
 	__skb_push(skb, size);
 	skb_reset_network_header(skb);
-
-	old_mac = skb_mac_header(skb);
-	skb_set_mac_header(skb, -skb->mac_len);
-	memmove(skb_mac_header(skb), old_mac, skb->mac_len);
+	skb_mac_header_rebuild(skb);
 
 	xfrm6_beet_make_header(skb);
 
diff --git a/net/ipv6/xfrm6_mode_tunnel.c b/net/ipv6/xfrm6_mode_tunnel.c
index 3927832..672c0da 100644
--- a/net/ipv6/xfrm6_mode_tunnel.c
+++ b/net/ipv6/xfrm6_mode_tunnel.c
@@ -61,7 +61,6 @@ static int xfrm6_mode_tunnel_output(struct xfrm_state *x, struct sk_buff *skb)
 static int xfrm6_mode_tunnel_input(struct xfrm_state *x, struct sk_buff *skb)
 {
 	int err = -EINVAL;
-	const unsigned char *old_mac;
 
 	if (XFRM_MODE_SKB_CB(skb)->protocol != IPPROTO_IPV6)
 		goto out;
@@ -78,10 +77,9 @@ static int xfrm6_mode_tunnel_input(struct xfrm_state *x, struct sk_buff *skb)
 	if (!(x->props.flags & XFRM_STATE_NOECN))
 		ipip6_ecn_decapsulate(skb);
 
-	old_mac = skb_mac_header(skb);
-	skb_set_mac_header(skb, -skb->mac_len);
-	memmove(skb_mac_header(skb), old_mac, skb->mac_len);
 	skb_reset_network_header(skb);
+	skb_mac_header_rebuild(skb);
+
 	err = 0;
 
 out:
-- 
1.7.2.1.45.g54fbc



