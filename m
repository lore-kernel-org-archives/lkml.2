Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2KMBw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:52:56 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64882 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab2KMBwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:52:53 -0500
Message-ID: <50A1A7D9.2040506@gmail.com>
Date: Tue, 13 Nov 2012 09:52:25 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: jesse@nicira.com, dev@openvswitch.org, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, cl@linux-foundation.org,
        Shan Wei <shanwei88@gmail.com>
Subject: [PATCH v4 4/9] net: openvswitch: use this_cpu_ptr per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>

just use more faster this_cpu_ptr instead of per_cpu_ptr(p, smp_processor_id());


Signed-off-by: Shan Wei <davidshan@tencent.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
---
no changes vs v3,v2.
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


