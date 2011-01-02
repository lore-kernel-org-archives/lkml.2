Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab1ABHY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:24:29 -0500
Received: from mail.windriver.com ([147.11.1.11]:36275 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab1ABHYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:21 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <rolandd@cisco.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 169/260] RDMA/cxgb3: Turn off RX coalescing for iWARP connections
Date: Sun,  2 Jan 2011 02:17:45 -0500
Message-Id: <1293952756-15010-170-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:15.0978 (UTC) FILETIME=[EC0EAEA0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>

commit bec658ff31453a5726b1c188674d587a5d40c482 upstream.

The HW by default has RX coalescing on.  For iWARP connections, this
causes a 100ms delay in connection establishement due to the ingress
MPA Start message being stalled in HW.  So explicitly turn RX
coalescing off when setting up iWARP connections.

This was causing very bad performance for NP64 gather operations using
Open MPI, due to the way it sets up connections on larger jobs.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/infiniband/hw/cxgb3/iwch_cm.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 4fef032..025c3f8 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -487,7 +487,8 @@ static int send_connect(struct iwch_ep *ep)
 	    V_MSS_IDX(mtu_idx) |
 	    V_L2T_IDX(ep->l2t->idx) | V_TX_CHANNEL(ep->l2t->smt_idx);
 	opt0l = V_TOS((ep->tos >> 2) & M_TOS) | V_RCV_BUFSIZ(rcv_win>>10);
-	opt2 = V_FLAVORS_VALID(1) | V_CONG_CONTROL_FLAVOR(cong_flavor);
+	opt2 = F_RX_COALESCE_VALID | V_RX_COALESCE(0) | V_FLAVORS_VALID(1) |
+	       V_CONG_CONTROL_FLAVOR(cong_flavor);
 	skb->priority = CPL_PRIORITY_SETUP;
 	set_arp_failure_handler(skb, act_open_req_arp_failure);
 
@@ -1304,7 +1305,8 @@ static void accept_cr(struct iwch_ep *ep, __be32 peer_ip, struct sk_buff *skb)
 	    V_MSS_IDX(mtu_idx) |
 	    V_L2T_IDX(ep->l2t->idx) | V_TX_CHANNEL(ep->l2t->smt_idx);
 	opt0l = V_TOS((ep->tos >> 2) & M_TOS) | V_RCV_BUFSIZ(rcv_win>>10);
-	opt2 = V_FLAVORS_VALID(1) | V_CONG_CONTROL_FLAVOR(cong_flavor);
+	opt2 = F_RX_COALESCE_VALID | V_RX_COALESCE(0) | V_FLAVORS_VALID(1) |
+	       V_CONG_CONTROL_FLAVOR(cong_flavor);
 
 	rpl = cplhdr(skb);
 	rpl->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
-- 
1.7.3.3

