Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab2HMWox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:44:53 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44129 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab2HMWov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:44:51 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] [NETFILTER] bridge: rcu_deref outside read-lock section
Date: Tue, 14 Aug 2012 02:47:42 +0400
Message-Id: <1344898062-23633-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it noted in the comment before the br_handle_frame_finish
function, this function should be called under rcu_read_lock.

The problem callgraph:
br_dev_xmit -> br_nf_pre_routing_finish_bridge_slow ->
-> br_handle_frame_finish -> br_port_get_rcu -> rcu_dereference

And in this case there is no read-lock section.
I have put lock/unlock in br_nf_pre_routing_finish_bridge_slow,
as the only function that calls it(for now) - is br_dev_xmit.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 include/linux/netfilter_bridge.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 31d2844..ceb048e 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -79,6 +79,7 @@ extern int br_handle_frame_finish(struct sk_buff *skb);
 /* Only used in br_device.c */
 static inline int br_nf_pre_routing_finish_bridge_slow(struct sk_buff *skb)
 {
+	int res;
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
 
 	skb_pull(skb, ETH_HLEN);
@@ -86,7 +87,10 @@ static inline int br_nf_pre_routing_finish_bridge_slow(struct sk_buff *skb)
 	skb_copy_to_linear_data_offset(skb, -(ETH_HLEN-ETH_ALEN),
 				       skb->nf_bridge->data, ETH_HLEN-ETH_ALEN);
 	skb->dev = nf_bridge->physindev;
-	return br_handle_frame_finish(skb);
+	rcu_read_lock();
+	res = br_handle_frame_finish(skb);
+	rcu_read_unlock();
+	return res;
 }
 
 /* This is called by the IP fragmenting code and it ensures there is
-- 
1.7.7

