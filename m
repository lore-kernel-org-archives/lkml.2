Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842Ab2JKBgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:36:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38144 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933645Ab2JKBSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:18:31 -0400
X-Sasl-enc: KH2CKckVS+CviRILQ2k8PPibXOl7GepSLT5Ia5KMc3Tm 1349918309
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Michal Schmidt <mschmidt@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 022/120] bnx2x: fix rx checksum validation for IPv6
Date: Thu, 11 Oct 2012 09:59:34 +0900
Message-Id: <20121011005829.442724690@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -571,14 +571,16 @@ drop:
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


