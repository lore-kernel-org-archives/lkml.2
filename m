Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab0DVUNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:13:53 -0400
Received: from kroah.org ([198.145.64.141]:59921 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757748Ab0DVUBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:18 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:15 2010
Message-Id: <20100422195415.072260176@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eli Cohen <eli@mellanox.co.il>, Roland Dreier <rolandd@cisco.com>,
       maximilian attems <max@stro.at>
Subject: [097/139] IPoIB: Fix TX queue lockup with mixed UD/CM traffic
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eli Cohen <eli@mellanox.co.il>

commit f0dc117abdfa9a0e96c3d013d836460ef3cd08c7 upstream.

The IPoIB UD QP reports send completions to priv->send_cq, which is
usually left unarmed; it only gets armed when the number of
outstanding send requests reaches the size of the TX queue. This
arming is done only in the send path for the UD QP.  However, when
sending CM packets, the net queue may be stopped for the same reasons
but no measures are taken to recover the UD path from a lockup.

Consider this scenario: a host sends high rate of both CM and UD
packets, with a TX queue length of N.  If at some time the number of
outstanding UD packets is more than N/2 and the overall outstanding
packets is N-1, and CM sends a packet (making the number of
outstanding sends equal N), the TX queue will be stopped.  When all
the CM packets complete, the number of outstanding packets will still
be higher than N/2 so the TX queue will not be restarted.

Fix this by calling ib_req_notify_cq() when the queue is stopped in
the CM path.

Signed-off-by: Eli Cohen <eli@mellanox.co.il>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -752,6 +752,8 @@ void ipoib_cm_send(struct net_device *de
 		if (++priv->tx_outstanding == ipoib_sendq_size) {
 			ipoib_dbg(priv, "TX ring 0x%x full, stopping kernel net queue\n",
 				  tx->qp->qp_num);
+			if (ib_req_notify_cq(priv->send_cq, IB_CQ_NEXT_COMP))
+				ipoib_warn(priv, "request notify on send CQ failed\n");
 			netif_stop_queue(dev);
 		}
 	}


