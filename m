Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246Ab0JVS4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:56:04 -0400
Received: from kroah.org ([198.145.64.141]:33971 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759230Ab0JVS4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:02 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:29 2010
Message-Id: <20101022185228.939475737@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <rolandd@cisco.com>
Subject: [018/103] RDMA/cxgb3: Turn off RX coalescing for iWARP connections
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/hw/cxgb3/iwch_cm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -463,7 +463,8 @@ static int send_connect(struct iwch_ep *
 	    V_MSS_IDX(mtu_idx) |
 	    V_L2T_IDX(ep->l2t->idx) | V_TX_CHANNEL(ep->l2t->smt_idx);
 	opt0l = V_TOS((ep->tos >> 2) & M_TOS) | V_RCV_BUFSIZ(rcv_win>>10);
-	opt2 = V_FLAVORS_VALID(1) | V_CONG_CONTROL_FLAVOR(cong_flavor);
+	opt2 = F_RX_COALESCE_VALID | V_RX_COALESCE(0) | V_FLAVORS_VALID(1) |
+	       V_CONG_CONTROL_FLAVOR(cong_flavor);
 	skb->priority = CPL_PRIORITY_SETUP;
 	set_arp_failure_handler(skb, act_open_req_arp_failure);
 
@@ -1280,7 +1281,8 @@ static void accept_cr(struct iwch_ep *ep
 	    V_MSS_IDX(mtu_idx) |
 	    V_L2T_IDX(ep->l2t->idx) | V_TX_CHANNEL(ep->l2t->smt_idx);
 	opt0l = V_TOS((ep->tos >> 2) & M_TOS) | V_RCV_BUFSIZ(rcv_win>>10);
-	opt2 = V_FLAVORS_VALID(1) | V_CONG_CONTROL_FLAVOR(cong_flavor);
+	opt2 = F_RX_COALESCE_VALID | V_RX_COALESCE(0) | V_FLAVORS_VALID(1) |
+	       V_CONG_CONTROL_FLAVOR(cong_flavor);
 
 	rpl = cplhdr(skb);
 	rpl->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));


