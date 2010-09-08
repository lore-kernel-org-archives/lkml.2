Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547Ab0IHIff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:35:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:55669 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758230Ab0IHIfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:35:32 -0400
Date: Wed, 8 Sep 2010 08:35:02 GMT
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
In-Reply-To: <4C724364.50903@jp.fujitsu.com>
References: <4C724364.50903@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] skb: Add tracepoints to freeing skb
Message-ID: <tip-07dc22e7295f25526f110d704655ff0ea7687420@git.kernel.org>
Git-Commit-ID: 07dc22e7295f25526f110d704655ff0ea7687420
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Sep 2010 08:35:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07dc22e7295f25526f110d704655ff0ea7687420
Gitweb:     http://git.kernel.org/tip/07dc22e7295f25526f110d704655ff0ea7687420
Author:     Koki Sanagi <sanagi.koki@jp.fujitsu.com>
AuthorDate: Mon, 23 Aug 2010 18:46:12 +0900
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 7 Sep 2010 17:51:53 +0200

skb: Add tracepoints to freeing skb

This patch adds tracepoint to consume_skb and add trace_kfree_skb
before __kfree_skb in skb_free_datagram_locked and net_tx_action.
Combinating with tracepoint on dev_hard_start_xmit, we can check
how long it takes to free transmitted packets. And using it, we can
calculate how many packets driver had at that time. It is useful when
a drop of transmitted packet is a problem.

            sshd-6828  [000] 112689.258154: consume_skb: skbaddr=f2d99bb8

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
LKML-Reference: <4C724364.50903@jp.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/events/skb.h |   17 +++++++++++++++++
 net/core/datagram.c        |    1 +
 net/core/dev.c             |    2 ++
 net/core/skbuff.c          |    1 +
 4 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 4b2be6d..75ce9d5 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -35,6 +35,23 @@ TRACE_EVENT(kfree_skb,
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
+	TP_printk("skbaddr=%p", __entry->skbaddr)
+);
+
 TRACE_EVENT(skb_copy_datagram_iovec,
 
 	TP_PROTO(const struct sk_buff *skb, int len),
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 251997a..282806b 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -243,6 +243,7 @@ void skb_free_datagram_locked(struct sock *sk, struct sk_buff *skb)
 	unlock_sock_fast(sk, slow);
 
 	/* skb is now orphaned, can be freed outside of locked section */
+	trace_kfree_skb(skb, skb_free_datagram_locked);
 	__kfree_skb(skb);
 }
 EXPORT_SYMBOL(skb_free_datagram_locked);
diff --git a/net/core/dev.c b/net/core/dev.c
index 5a4fbc7..2308cce 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -129,6 +129,7 @@
 #include <linux/random.h>
 #include <trace/events/napi.h>
 #include <trace/events/net.h>
+#include <trace/events/skb.h>
 #include <linux/pci.h>
 
 #include "net-sysfs.h"
@@ -2576,6 +2577,7 @@ static void net_tx_action(struct softirq_action *h)
 			clist = clist->next;
 
 			WARN_ON(atomic_read(&skb->users));
+			trace_kfree_skb(skb, net_tx_action);
 			__kfree_skb(skb);
 		}
 	}
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3a2513f..12e61e3 100644
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
