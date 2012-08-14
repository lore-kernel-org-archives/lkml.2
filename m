Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab2HNIHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:07:43 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:55004 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801Ab2HNIHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:07:40 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, pablo@netfilter.org,
        kaber@trash.net, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH v2] bridge: rcu_deref outside read-lock section
Date: Tue, 14 Aug 2012 12:08:52 +0400
Message-Id: <1344931732-1858-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1344898062-23633-1-git-send-email-yefremov.denis@gmail.com>
References: <1344898062-23633-1-git-send-email-yefremov.denis@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it noted in the comment before the br_handle_frame_finish
function, this function should be called under rcu_read_lock.

The problem callgraph:
br_dev_xmit -> br_nf_pre_routing_finish_bridge_slow ->
-> br_handle_frame_finish -> br_port_get_rcu -> rcu_dereference

And in this case there is no read-lock section.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 net/bridge/br_device.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 3334845..f9ae07f 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -33,7 +33,9 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 
 #ifdef CONFIG_BRIDGE_NETFILTER
 	if (skb->nf_bridge && (skb->nf_bridge->mask & BRNF_BRIDGED_DNAT)) {
+		rcu_read_lock();
 		br_nf_pre_routing_finish_bridge_slow(skb);
+		rcu_read_unlock();
 		return NETDEV_TX_OK;
 	}
 #endif
-- 
1.7.7

