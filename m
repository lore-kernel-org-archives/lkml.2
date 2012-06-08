Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761813Ab2FHFMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:12:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43259 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761309Ab2FHFHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:31 -0400
Message-Id: <20120608041850.814187846@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Benjamin Poirier <bpoirier@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 74/82] xfrm: take net hdr len into account for esp payload  size calculation
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Poirier <bpoirier@suse.de>

[ Upstream commit 91657eafb64b4cb53ec3a2fbc4afc3497f735788 ]

Corrects the function that determines the esp payload size. The calculations
done in esp{4,6}_get_mtu() lead to overlength frames in transport mode for
certain mtu values and suboptimal frames for others.

According to what is done, mainly in esp{,6}_output() and tcp_mtu_to_mss(),
net_header_len must be taken into account before doing the alignment
calculation.

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/esp4.c |   24 +++++++++---------------
 net/ipv6/esp6.c |   18 +++++++-----------
 2 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index a5b4134..530787b 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -457,28 +457,22 @@ static u32 esp4_get_mtu(struct xfrm_state *x, int mtu)
 	struct esp_data *esp = x->data;
 	u32 blksize = ALIGN(crypto_aead_blocksize(esp->aead), 4);
 	u32 align = max_t(u32, blksize, esp->padlen);
-	u32 rem;
-
-	mtu -= x->props.header_len + crypto_aead_authsize(esp->aead);
-	rem = mtu & (align - 1);
-	mtu &= ~(align - 1);
+	unsigned int net_adj;
 
 	switch (x->props.mode) {
-	case XFRM_MODE_TUNNEL:
-		break;
-	default:
 	case XFRM_MODE_TRANSPORT:
-		/* The worst case */
-		mtu -= blksize - 4;
-		mtu += min_t(u32, blksize - 4, rem);
-		break;
 	case XFRM_MODE_BEET:
-		/* The worst case. */
-		mtu += min_t(u32, IPV4_BEET_PHMAXLEN, rem);
+		net_adj = sizeof(struct iphdr);
 		break;
+	case XFRM_MODE_TUNNEL:
+		net_adj = 0;
+		break;
+	default:
+		BUG();
 	}
 
-	return mtu - 2;
+	return ((mtu - x->props.header_len - crypto_aead_authsize(esp->aead) -
+		 net_adj) & ~(align - 1)) + (net_adj - 2);
 }
 
 static void esp4_err(struct sk_buff *skb, u32 info)
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 1ac7938..65dd543 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -411,19 +411,15 @@ static u32 esp6_get_mtu(struct xfrm_state *x, int mtu)
 	struct esp_data *esp = x->data;
 	u32 blksize = ALIGN(crypto_aead_blocksize(esp->aead), 4);
 	u32 align = max_t(u32, blksize, esp->padlen);
-	u32 rem;
+	unsigned int net_adj;
 
-	mtu -= x->props.header_len + crypto_aead_authsize(esp->aead);
-	rem = mtu & (align - 1);
-	mtu &= ~(align - 1);
-
-	if (x->props.mode != XFRM_MODE_TUNNEL) {
-		u32 padsize = ((blksize - 1) & 7) + 1;
-		mtu -= blksize - padsize;
-		mtu += min_t(u32, blksize - padsize, rem);
-	}
+	if (x->props.mode != XFRM_MODE_TUNNEL)
+		net_adj = sizeof(struct ipv6hdr);
+	else
+		net_adj = 0;
 
-	return mtu - 2;
+	return ((mtu - x->props.header_len - crypto_aead_authsize(esp->aead) -
+		 net_adj) & ~(align - 1)) + (net_adj - 2);
 }
 
 static void esp6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,


