Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0FYA67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 20:58:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49113 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab0FYA65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 20:58:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C23FF55.3090604@jp.fujitsu.com>
Date: Fri, 25 Jun 2010 09:59:01 +0900
From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: kaneshige.kenji@jp.fujitsu.com, izumi.taku@jp.fujitsu.com
Subject: [RFC PATCH v2 4/5] skb: add tracepoints to freeing skb
References: <4C2312A8.9060903@jp.fujitsu.com>
In-Reply-To: <4C2312A8.9060903@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch adds tracepoint to consume_skb and dev_kfree_skb_irq.
Combinating with tracepoint on dev_hard_start_xmit, we can check how long it
takes to free transmited packets. And using it, we can calculate how many
packets driver had at that time. It is useful when a drop of transmited packet
is a problem.

          <idle>-0     [001] 241409.218333: consume_skb: skbaddr=dd6b2fb8
          <idle>-0     [001] 241409.490555: dev_kfree_skb_irq: skbaddr=f5e29840

Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
---
include/trace/events/skb.h |   36 ++++++++++++++++++++++++++++++++++++
 net/core/dev.c             |    2 ++
 net/core/skbuff.c          |    1 +
 3 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 4b2be6d..6ab5b34 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -35,6 +35,42 @@ TRACE_EVENT(kfree_skb,
 		__entry->skbaddr, __entry->protocol, __entry->location)
 );
 
+TRACE_EVENT(consume_skb,
+
+	TP_PROTO(struct sk_buff *skb),
+
+	TP_ARGS(skb),
+
+	TP_STRUCT__entry(
+		__field(	void *,	skbaddr	)
+	),
+
+	TP_fast_assign(
+		__entry->skbaddr = skb;
+	),
+
+	TP_printk("skbaddr=%p",
+		__entry->skbaddr)
+);
+
+TRACE_EVENT(dev_kfree_skb_irq,
+
+	TP_PROTO(struct sk_buff *skb),
+
+	TP_ARGS(skb),
+
+	TP_STRUCT__entry(
+		__field(	void *,	skbaddr	)
+	),
+
+	TP_fast_assign(
+		__entry->skbaddr = skb;
+	),
+
+	TP_printk("skbaddr=%p",
+		__entry->skbaddr)
+);
+
 TRACE_EVENT(skb_copy_datagram_iovec,
 
 	TP_PROTO(const struct sk_buff *skb, int len),
diff --git a/net/core/dev.c b/net/core/dev.c
index 4b64b21..807b1ca 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -131,6 +131,7 @@
 #include <linux/random.h>
 #include <trace/events/napi.h>
 #include <trace/events/net.h>
+#include <trace/events/skb.h>
 #include <linux/pci.h>
 
 #include "net-sysfs.h"
@@ -1580,6 +1581,7 @@ void dev_kfree_skb_irq(struct sk_buff *skb)
 		struct softnet_data *sd;
 		unsigned long flags;
 
+		trace_dev_kfree_skb_irq(skb);
 		local_irq_save(flags);
 		sd = &__get_cpu_var(softnet_data);
 		skb->next = sd->completion_queue;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 34432b4..a7b4036 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -466,6 +466,7 @@ void consume_skb(struct sk_buff *skb)
 		smp_rmb();
 	else if (likely(!atomic_dec_and_test(&skb->users)))
 		return;
+	trace_consume_skb(skb);
 	__kfree_skb(skb);
 }
 EXPORT_SYMBOL(consume_skb);

