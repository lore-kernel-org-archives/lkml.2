Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422777Ab2JaLW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:22:56 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63014 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935416Ab2JaLWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:22:51 -0400
Message-ID: <50910A04.5000003@gmail.com>
Date: Wed, 31 Oct 2012 19:22:44 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: jesse@nicira.com, dev@openvswitch.org, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, cl@linux-foundation.org
Subject: [PATCH 4/9] net: openvswitch: use this_cpu_ptr per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>

Signed-off-by: Shan Wei <davidshan@tencent.com>
---
 net/openvswitch/datapath.c |    4 ++--
 net/openvswitch/vport.c    |    5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 4c4b62c..77d16a5 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -208,7 +208,7 @@ void ovs_dp_process_received_packet(struct vport *p, struct sk_buff *skb)
 	int error;
 	int key_len;
 
-	stats = per_cpu_ptr(dp->stats_percpu, smp_processor_id());
+	stats = this_cpu_ptr(dp->stats_percpu);
 
 	/* Extract flow from 'skb' into 'key'. */
 	error = ovs_flow_extract(skb, p->port_no, &key, &key_len);
@@ -282,7 +282,7 @@ int ovs_dp_upcall(struct datapath *dp, struct sk_buff *skb,
 	return 0;
 
 err:
-	stats = per_cpu_ptr(dp->stats_percpu, smp_processor_id());
+	stats = this_cpu_ptr(dp->stats_percpu);
 
 	u64_stats_update_begin(&stats->sync);
 	stats->n_lost++;
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 03779e8..70af0be 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -333,8 +333,7 @@ void ovs_vport_receive(struct vport *vport, struct sk_buff *skb)
 {
 	struct vport_percpu_stats *stats;
 
-	stats = per_cpu_ptr(vport->percpu_stats, smp_processor_id());
-
+	stats = this_cpu_ptr(vport->percpu_stats);
 	u64_stats_update_begin(&stats->sync);
 	stats->rx_packets++;
 	stats->rx_bytes += skb->len;
@@ -359,7 +358,7 @@ int ovs_vport_send(struct vport *vport, struct sk_buff *skb)
 	if (likely(sent)) {
 		struct vport_percpu_stats *stats;
 
-		stats = per_cpu_ptr(vport->percpu_stats, smp_processor_id());
+		stats = this_cpu_ptr(vport->percpu_stats);
 
 		u64_stats_update_begin(&stats->sync);
 		stats->tx_packets++;
-- 
1.7.1

