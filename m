Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2JGXXB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:23:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38401 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078Ab2JGXWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:37 -0400
Message-Id: <20121007225844.810347963@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Schmidt <mschmidt@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 073/108] bnx2x: fix rx checksum validation for IPv6
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit e488921f44765e8ab6c48ca35e3f6b78df9819df ]

Commit d6cb3e41 "bnx2x: fix checksum validation" caused a performance
regression for IPv6. Rx checksum offload does not work. IPv6 packets
are passed to the stack with CHECKSUM_NONE.

The hardware obviously cannot perform IP checksum validation for IPv6,
because there is no checksum in the IPv6 header. This should not prevent
us from setting CHECKSUM_UNNECESSARY.

Tested on BCM57711.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Eilon Greenstein <eilong@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 2c1a5c0..4c50ac0 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -554,14 +554,16 @@ static inline void bnx2x_set_skb_rxhash(struct bnx2x *bp, union eth_rx_cqe *cqe,
 static void bnx2x_csum_validate(struct sk_buff *skb, union eth_rx_cqe *cqe,
 				struct bnx2x_fastpath *fp)
 {
-	/* Do nothing if no IP/L4 csum validation was done */
-
+	/* Do nothing if no L4 csum validation was done.
+	 * We do not check whether IP csum was validated. For IPv4 we assume
+	 * that if the card got as far as validating the L4 csum, it also
+	 * validated the IP csum. IPv6 has no IP csum.
+	 */
 	if (cqe->fast_path_cqe.status_flags &
-	    (ETH_FAST_PATH_RX_CQE_IP_XSUM_NO_VALIDATION_FLG |
-	     ETH_FAST_PATH_RX_CQE_L4_XSUM_NO_VALIDATION_FLG))
+	    ETH_FAST_PATH_RX_CQE_L4_XSUM_NO_VALIDATION_FLG)
 		return;
 
-	/* If both IP/L4 validation were done, check if an error was found. */
+	/* If L4 validation was done, check if an error was found. */
 
 	if (cqe->fast_path_cqe.type_error_flags &
 	    (ETH_FAST_PATH_RX_CQE_IP_BAD_XSUM_FLG |


