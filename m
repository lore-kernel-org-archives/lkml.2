Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab0IGQs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:48:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47445 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041Ab0IGQsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:48:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=rvcxJLM3bPjWz3Wka279TovH1M6sWUnNNDGwLAwKdRbYMoxn4ZTcP/uEcMTMkE0PRX
         MqI2+kaTe2xbLY3Bf9UnoxEIpjLFOIbDjg/p0IC15aSoyEnjJcjPipCfFviCUVh8Kc8t
         bp9NsAnltwZDAsEGk3hvr34FyetvRIvbXVEDU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Kaneshige Kenji <kaneshige.kenji@jp.fujitsu.com>,
        Izumo Taku <izumi.taku@jp.fujitsu.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Scott Mcmillan <scott.a.mcmillan@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/5] netdev: Add tracepoints to netdev layer
Date: Tue,  7 Sep 2010 18:48:09 +0200
Message-Id: <1283878091-5751-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1283878091-5751-1-git-send-regression-fweisbec@gmail.com>
References: <1283878091-5751-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>

This patch adds tracepoint to dev_queue_xmit, dev_hard_start_xmit,
netif_rx and netif_receive_skb. These tracepoints help you to monitor
network driver's input/output.

          <idle>-0     [001] 112447.902030: netif_rx: dev=eth1 skbaddr=f3ef0900 len=84
          <idle>-0     [001] 112447.902039: netif_receive_skb: dev=eth1 skbaddr=f3ef0900 len=84
            sshd-6828  [000] 112447.903257: net_dev_queue: dev=eth4 skbaddr=f3fca538 len=226
            sshd-6828  [000] 112447.903260: net_dev_xmit: dev=eth4 skbaddr=f3fca538 len=226 rc=0

Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Kaneshige Kenji <kaneshige.kenji@jp.fujitsu.com>
Cc: Izumo Taku <izumi.taku@jp.fujitsu.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Scott Mcmillan <scott.a.mcmillan@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
LKML-Reference: <4C72431E.3000901@jp.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/events/net.h |   82 ++++++++++++++++++++++++++++++++++++++++++++
 net/core/dev.c             |    6 +++
 net/core/net-traces.c      |    1 +
 3 files changed, 89 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/net.h

diff --git a/include/trace/events/net.h b/include/trace/events/net.h
new file mode 100644
index 0000000..5f247f5
--- /dev/null
+++ b/include/trace/events/net.h
@@ -0,0 +1,82 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM net
+
+#if !defined(_TRACE_NET_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_NET_H
+
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/ip.h>
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(net_dev_xmit,
+
+	TP_PROTO(struct sk_buff *skb,
+		 int rc),
+
+	TP_ARGS(skb, rc),
+
+	TP_STRUCT__entry(
+		__field(	void *,		skbaddr		)
+		__field(	unsigned int,	len		)
+		__field(	int,		rc		)
+		__string(	name,		skb->dev->name	)
+	),
+
+	TP_fast_assign(
+		__entry->skbaddr = skb;
+		__entry->len = skb->len;
+		__entry->rc = rc;
+		__assign_str(name, skb->dev->name);
+	),
+
+	TP_printk("dev=%s skbaddr=%p len=%u rc=%d",
+		__get_str(name), __entry->skbaddr, __entry->len, __entry->rc)
+);
+
+DECLARE_EVENT_CLASS(net_dev_template,
+
+	TP_PROTO(struct sk_buff *skb),
+
+	TP_ARGS(skb),
+
+	TP_STRUCT__entry(
+		__field(	void *,		skbaddr		)
+		__field(	unsigned int,	len		)
+		__string(	name,		skb->dev->name	)
+	),
+
+	TP_fast_assign(
+		__entry->skbaddr = skb;
+		__entry->len = skb->len;
+		__assign_str(name, skb->dev->name);
+	),
+
+	TP_printk("dev=%s skbaddr=%p len=%u",
+		__get_str(name), __entry->skbaddr, __entry->len)
+)
+
+DEFINE_EVENT(net_dev_template, net_dev_queue,
+
+	TP_PROTO(struct sk_buff *skb),
+
+	TP_ARGS(skb)
+);
+
+DEFINE_EVENT(net_dev_template, netif_receive_skb,
+
+	TP_PROTO(struct sk_buff *skb),
+
+	TP_ARGS(skb)
+);
+
+DEFINE_EVENT(net_dev_template, netif_rx,
+
+	TP_PROTO(struct sk_buff *skb),
+
+	TP_ARGS(skb)
+);
+#endif /* _TRACE_NET_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/net/core/dev.c b/net/core/dev.c
index 3721fbb..5a4fbc7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -128,6 +128,7 @@
 #include <linux/jhash.h>
 #include <linux/random.h>
 #include <trace/events/napi.h>
+#include <trace/events/net.h>
 #include <linux/pci.h>
 
 #include "net-sysfs.h"
@@ -1978,6 +1979,7 @@ int dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 		}
 
 		rc = ops->ndo_start_xmit(skb, dev);
+		trace_net_dev_xmit(skb, rc);
 		if (rc == NETDEV_TX_OK)
 			txq_trans_update(txq);
 		return rc;
@@ -1998,6 +2000,7 @@ gso:
 			skb_dst_drop(nskb);
 
 		rc = ops->ndo_start_xmit(nskb, dev);
+		trace_net_dev_xmit(nskb, rc);
 		if (unlikely(rc != NETDEV_TX_OK)) {
 			if (rc & ~NETDEV_TX_MASK)
 				goto out_kfree_gso_skb;
@@ -2186,6 +2189,7 @@ int dev_queue_xmit(struct sk_buff *skb)
 #ifdef CONFIG_NET_CLS_ACT
 	skb->tc_verd = SET_TC_AT(skb->tc_verd, AT_EGRESS);
 #endif
+	trace_net_dev_queue(skb);
 	if (q->enqueue) {
 		rc = __dev_xmit_skb(skb, q, dev, txq);
 		goto out;
@@ -2512,6 +2516,7 @@ int netif_rx(struct sk_buff *skb)
 	if (netdev_tstamp_prequeue)
 		net_timestamp_check(skb);
 
+	trace_netif_rx(skb);
 #ifdef CONFIG_RPS
 	{
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
@@ -2828,6 +2833,7 @@ static int __netif_receive_skb(struct sk_buff *skb)
 	if (!netdev_tstamp_prequeue)
 		net_timestamp_check(skb);
 
+	trace_netif_receive_skb(skb);
 	if (vlan_tx_tag_present(skb) && vlan_hwaccel_do_receive(skb))
 		return NET_RX_SUCCESS;
 
diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index afa6380..7f1bb2a 100644
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@ -26,6 +26,7 @@
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/skb.h>
+#include <trace/events/net.h>
 #include <trace/events/napi.h>
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(kfree_skb);
-- 
1.6.2.3

