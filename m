Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab1I1WjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:39:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab1I1WjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:39:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:28 2011
Message-Id: <20110928220128.399630785@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [030/244] ibmveth: Fix leak when recycling skb and hypervisor returns error
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit c6f59d13e24187ff95427a9f4a5a7e14fb8faf5a upstream.

If h_add_logical_lan_buffer returns an error we need to free
the skb.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ibmveth.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -394,7 +394,7 @@ static inline struct sk_buff *ibmveth_rx
 }
 
 /* recycle the current buffer on the rx queue */
-static void ibmveth_rxq_recycle_buffer(struct ibmveth_adapter *adapter)
+static int ibmveth_rxq_recycle_buffer(struct ibmveth_adapter *adapter)
 {
 	u32 q_index = adapter->rx_queue.index;
 	u64 correlator = adapter->rx_queue.queue_addr[q_index].correlator;
@@ -402,6 +402,7 @@ static void ibmveth_rxq_recycle_buffer(s
 	unsigned int index = correlator & 0xffffffffUL;
 	union ibmveth_buf_desc desc;
 	unsigned long lpar_rc;
+	int ret = 1;
 
 	BUG_ON(pool >= IBMVETH_NUM_BUFF_POOLS);
 	BUG_ON(index >= adapter->rx_buff_pool[pool].size);
@@ -409,7 +410,7 @@ static void ibmveth_rxq_recycle_buffer(s
 	if (!adapter->rx_buff_pool[pool].active) {
 		ibmveth_rxq_harvest_buffer(adapter);
 		ibmveth_free_buffer_pool(adapter, &adapter->rx_buff_pool[pool]);
-		return;
+		goto out;
 	}
 
 	desc.fields.flags_len = IBMVETH_BUF_VALID |
@@ -422,12 +423,16 @@ static void ibmveth_rxq_recycle_buffer(s
 		netdev_dbg(adapter->netdev, "h_add_logical_lan_buffer failed "
 			   "during recycle rc=%ld", lpar_rc);
 		ibmveth_remove_buffer_from_pool(adapter, adapter->rx_queue.queue_addr[adapter->rx_queue.index].correlator);
+		ret = 0;
 	}
 
 	if (++adapter->rx_queue.index == adapter->rx_queue.num_slots) {
 		adapter->rx_queue.index = 0;
 		adapter->rx_queue.toggle = !adapter->rx_queue.toggle;
 	}
+
+out:
+	return ret;
 }
 
 static void ibmveth_rxq_harvest_buffer(struct ibmveth_adapter *adapter)
@@ -1083,8 +1088,9 @@ restart_poll:
 				if (rx_flush)
 					ibmveth_flush_buffer(skb->data,
 						length + offset);
+				if (!ibmveth_rxq_recycle_buffer(adapter))
+					kfree_skb(skb);
 				skb = new_skb;
-				ibmveth_rxq_recycle_buffer(adapter);
 			} else {
 				ibmveth_rxq_harvest_buffer(adapter);
 				skb_reserve(skb, offset);


