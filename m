Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964933Ab2EPThH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:37:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54899 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964775Ab2EPThB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:37:01 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v3] xfrm: take iphdr size into account for esp payload size calculation
Date: Wed, 16 May 2012 15:35:25 -0400
Message-Id: <1337196925-4919-1-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <20120514.183952.1459413342269893446.davem@davemloft.net>
References: <20120514.183952.1459413342269893446.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrects the function that determines the esp payload size.
The calculations done in esp4_get_mtu lead to overlength frames in transport
mode for certain mtu values and suboptimal frames for others.

According to what is done, mainly in esp_output(), net_header_len aka
sizeof(struct iphdr) must be taken into account before doing the alignment
calculation.

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>

---
Changes since v2:
* rename l3_adj to net_adj
* fix indentation

Changes since v1:
* introduce l3_adj to preserve the same returned value as before for tunnel
  mode

For example, with md5 AH and 3des ESP (transport mode):
mtu = 1499 leads to FRAGFAILS
mtu = 1500 the addition of padding in the esp header could be avoided

Tested with
* transport mode E
* transport mode EA
* transport mode E + ah
* tunnel mode E

Not tested with BEET, but it should be the same as transport mode
	draft-nikander-esp-beet-mode-03.txt Section 5.2:
	"The wire packet format is identical to the ESP transport mode"
---
 net/ipv4/esp4.c |   24 +++++++++---------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 89a47b3..cb982a6 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -459,28 +459,22 @@ static u32 esp4_get_mtu(struct xfrm_state *x, int mtu)
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
-- 
1.7.7

