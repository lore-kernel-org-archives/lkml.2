Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab0IHIfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:35:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:55653 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758448Ab0IHIfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:35:10 -0400
Date: Wed, 8 Sep 2010 08:34:41 GMT
From: tip-bot for Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Cc: mingo@redhat.com, mathieu.desnoyers@efficios.com,
        sanagi.koki@jp.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
        nhorman@tuxdriver.com, scott.a.mcmillan@intel.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        davem@davemloft.net, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com
Reply-To: mingo@redhat.com, mathieu.desnoyers@efficios.com,
        sanagi.koki@jp.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
        nhorman@tuxdriver.com, scott.a.mcmillan@intel.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        davem@davemloft.net, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <4C72431E.3000901@jp.fujitsu.com>
References: <4C72431E.3000901@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] netdev: Add tracepoints to netdev layer
Message-ID: <tip-cf66ba58b5cb8b1526e9dd2fb96ff8db048d4d44@git.kernel.org>
Git-Commit-ID: cf66ba58b5cb8b1526e9dd2fb96ff8db048d4d44
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Sep 2010 08:34:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf66ba58b5cb8b1526e9dd2fb96ff8db048d4d44
Gitweb:     http://git.kernel.org/tip/cf66ba58b5cb8b1526e9dd2fb96ff8db048d4d44
Author:     Koki Sanagi <sanagi.koki@jp.fujitsu.com>
AuthorDate: Mon, 23 Aug 2010 18:45:02 +0900
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 7 Sep 2010 17:51:33 +0200

netdev: Add tracepoints to netdev layer

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
