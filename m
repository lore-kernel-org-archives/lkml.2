Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0FYA6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 20:58:33 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44928 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab0FYA6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 20:58:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C23FF3E.1080503@jp.fujitsu.com>
Date: Fri, 25 Jun 2010 09:58:38 +0900
From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: kaneshige.kenji@jp.fujitsu.com, izumi.taku@jp.fujitsu.com
Subject: [RFC PATCH v2 3/5] netdev: add tracepoints to netdev layer
References: <4C2312A8.9060903@jp.fujitsu.com>
In-Reply-To: <4C2312A8.9060903@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds tracepoint to dev_queue_xmit, dev_hard_start_xmit and
netif_receive_skb. These tracepints help you to monitor network driver's
input/output.

            sshd-4445  [001] 241367.066046: net_dev_queue: dev=eth3 skbaddr=dd6b2538 len=114
            sshd-4445  [001] 241367.066047: net_dev_xmit: dev=eth3 skbaddr=dd6b2538 len=114 rc=0
          <idle>-0     [001] 241367.067472: net_dev_receive: dev=eth3 skbaddr=f5e59000 len=52

Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
---
 include/trace/events/net.h |   83 ++++++++++++++++++++++++++++++++++++++++++++
 net/core/dev.c             |    5 +++
 net/core/net-traces.c      |    1 +
 3 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/net.h b/include/trace/events/net.h
new file mode 100644
index 0000000..ee10970
--- /dev/null
+++ b/include/trace/events/net.h
@@ -0,0 +1,83 @@
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
+TRACE_EVENT(net_dev_queue,
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
+);
+
+TRACE_EVENT(net_dev_receive,
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
+);
+#endif /* _TRACE_NET_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/net/core/dev.c b/net/core/dev.c
index 5902426..4b64b21 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -130,6 +130,7 @@
 #include <linux/jhash.h>
 #include <linux/random.h>
 #include <trace/events/napi.h>
+#include <trace/events/net.h>
 #include <linux/pci.h>
 
 #include "net-sysfs.h"
@@ -1922,6 +1923,7 @@ int dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 		}
 
 		rc = ops->ndo_start_xmit(skb, dev);
+		trace_net_dev_xmit(skb, rc);
 		if (rc == NETDEV_TX_OK)
 			txq_trans_update(txq);
 		return rc;
@@ -1942,6 +1944,7 @@ gso:
 			skb_dst_drop(nskb);
 
 		rc = ops->ndo_start_xmit(nskb, dev);
+		trace_net_dev_xmit(nskb, rc);
 		if (unlikely(rc != NETDEV_TX_OK)) {
 			if (rc & ~NETDEV_TX_MASK)
 				goto out_kfree_gso_skb;
@@ -2156,6 +2159,7 @@ int dev_queue_xmit(struct sk_buff *skb)
 	}
 
 gso:
+	trace_net_dev_queue(skb);
 	/* Disable soft irqs for various locks below. Also
 	 * stops preemption for RCU.
 	 */
@@ -2942,6 +2946,7 @@ int netif_receive_skb(struct sk_buff *skb)
 	if (netdev_tstamp_prequeue)
 		net_timestamp_check(skb);
 
+	trace_net_dev_receive(skb);
 #ifdef CONFIG_RPS
 	{
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
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

