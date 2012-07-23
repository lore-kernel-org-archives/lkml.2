Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab2GWBmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:42:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54114 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753000Ab2GWBmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:43 -0400
Message-Id: <20120723010704.842205054@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        Yaniv Rosner <yanivr@broadcom.com>, Merav Sicron <meravs@broadcom.com>,
        Tom Herbert <therbert@google.com>, Robert Evans <evansr@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 088/108] bnx2x: fix checksum validation
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit d6cb3e41386f20fb0777d0b59a2def82c65d37f7 upstream.

bnx2x driver incorrectly sets ip_summed to CHECKSUM_UNNECESSARY on
encapsulated segments. TCP stack happily accepts frames with bad
checksums, if they are inside a GRE or IPIP encapsulation.

Our understanding is that if no IP or L4 csum validation was done by the
hardware, we should leave ip_summed as is (CHECKSUM_NONE), since
hardware doesn't provide CHECKSUM_COMPLETE support in its cqe.

Then, if IP/L4 checksumming was done by the hardware, set
CHECKSUM_UNNECESSARY if no error was flagged.

Patch based on findings and analysis from Robert Evans

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Eilon Greenstein <eilong@broadcom.com>
Cc: Yaniv Rosner <yanivr@broadcom.com>
Cc: Merav Sicron <meravs@broadcom.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Robert Evans <evansr@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Acked-by: Eilon Greenstein <eilong@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.2: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h     |   15 -------------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |   27 ++++++++++++++++++-----
 2 files changed, 21 insertions(+), 21 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -723,21 +723,6 @@ struct bnx2x_fastpath {
 
 #define ETH_RX_ERROR_FALGS		ETH_FAST_PATH_RX_CQE_PHY_DECODE_ERR_FLG
 
-#define BNX2X_IP_CSUM_ERR(cqe) \
-			(!((cqe)->fast_path_cqe.status_flags & \
-			   ETH_FAST_PATH_RX_CQE_IP_XSUM_NO_VALIDATION_FLG) && \
-			 ((cqe)->fast_path_cqe.type_error_flags & \
-			  ETH_FAST_PATH_RX_CQE_IP_BAD_XSUM_FLG))
-
-#define BNX2X_L4_CSUM_ERR(cqe) \
-			(!((cqe)->fast_path_cqe.status_flags & \
-			   ETH_FAST_PATH_RX_CQE_L4_XSUM_NO_VALIDATION_FLG) && \
-			 ((cqe)->fast_path_cqe.type_error_flags & \
-			  ETH_FAST_PATH_RX_CQE_L4_BAD_XSUM_FLG))
-
-#define BNX2X_RX_CSUM_OK(cqe) \
-			(!(BNX2X_L4_CSUM_ERR(cqe) || BNX2X_IP_CSUM_ERR(cqe)))
-
 #define BNX2X_PRS_FLAG_OVERETH_IPV4(flags) \
 				(((le16_to_cpu(flags) & \
 				   PARSING_FLAGS_OVER_ETHERNET_PROTOCOL) >> \
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -551,6 +551,26 @@ static inline void bnx2x_set_skb_rxhash(
 		le32_to_cpu(cqe->fast_path_cqe.rss_hash_result);
 }
 
+static void bnx2x_csum_validate(struct sk_buff *skb, union eth_rx_cqe *cqe,
+				struct bnx2x_fastpath *fp)
+{
+	/* Do nothing if no IP/L4 csum validation was done */
+
+	if (cqe->fast_path_cqe.status_flags &
+	    (ETH_FAST_PATH_RX_CQE_IP_XSUM_NO_VALIDATION_FLG |
+	     ETH_FAST_PATH_RX_CQE_L4_XSUM_NO_VALIDATION_FLG))
+		return;
+
+	/* If both IP/L4 validation were done, check if an error was found. */
+
+	if (cqe->fast_path_cqe.type_error_flags &
+	    (ETH_FAST_PATH_RX_CQE_IP_BAD_XSUM_FLG |
+	     ETH_FAST_PATH_RX_CQE_L4_BAD_XSUM_FLG))
+		fp->eth_q_stats.hw_csum_err++;
+	else
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+}
+
 int bnx2x_rx_int(struct bnx2x_fastpath *fp, int budget)
 {
 	struct bnx2x *bp = fp->bp;
@@ -746,13 +766,9 @@ reuse_rx:
 
 			skb_checksum_none_assert(skb);
 
-			if (bp->dev->features & NETIF_F_RXCSUM) {
+			if (bp->dev->features & NETIF_F_RXCSUM)
+				bnx2x_csum_validate(skb, cqe, fp);
 
-				if (likely(BNX2X_RX_CSUM_OK(cqe)))
-					skb->ip_summed = CHECKSUM_UNNECESSARY;
-				else
-					fp->eth_q_stats.hw_csum_err++;
-			}
 		}
 
 		skb_record_rx_queue(skb, fp->index);


