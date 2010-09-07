Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab0IGQsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:48:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47445 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab0IGQsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:48:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=Xe3sSCCDYRA2fn++ZI7+q3veSIc1vqfFIeMdPvUfMfz6lIZmUJRrPIBuU6RQEsR7Ko
         pZny5Brx5uRCGbsj+fcb1QQ+wTUye/3ZhF+jVcthZMFKmrAj5ttXXmvOtO0Q+w10viUQ
         B6hC5R3L+AsUn1SqTxvTE79DiA45ANf+pWx/s=
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
Subject: [PATCH 4/5] skb: Add tracepoints to freeing skb
Date: Tue,  7 Sep 2010 18:48:10 +0200
Message-Id: <1283878091-5751-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1283878091-5751-1-git-send-regression-fweisbec@gmail.com>
References: <1283878091-5751-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>

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
-- 
1.6.2.3

