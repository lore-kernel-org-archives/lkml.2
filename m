Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab2BUURy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:17:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab2BUURx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 15:17:53 -0500
Date: Tue, 21 Feb 2012 15:03:25 -0500
From: Jason Baron <jbaron@redhat.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com, hpa@zytor.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        eric.dumazet@gmail.com, glommer@parallels.com,
        linux-kernel@vger.kernel.org
Message-Id: <d74d3ccf5ed8598525ade00b572381e42c9d433a.1329851692.git.jbaron@redhat.com>
In-Reply-To: <cover.1329851692.git.jbaron@redhat.com>
References: <cover.1329851692.git.jbaron@redhat.com>
Subject: [PATCH 09/10] net: update to use very_unlikely()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update networking with api change: static_branch() -> very_unlikely().

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/netfilter.h |    2 +-
 include/net/sock.h        |    2 +-
 net/core/dev.c            |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index b809265..43d0cc0 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -169,7 +169,7 @@ static inline bool nf_hooks_active(u_int8_t pf, unsigned int hook)
 {
 	if (__builtin_constant_p(pf) &&
 	    __builtin_constant_p(hook))
-		return static_branch(&nf_hooks_needed[pf][hook]);
+		return very_unlikely(&nf_hooks_needed[pf][hook]);
 
 	return !list_empty(&nf_hooks[pf][hook]);
 }
diff --git a/include/net/sock.h b/include/net/sock.h
index 91c1c8b..1d16574 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -930,7 +930,7 @@ static inline struct cg_proto *parent_cg_proto(struct proto *proto,
 {
 	return proto->proto_cgroup(parent_mem_cgroup(cg_proto->memcg));
 }
-#define mem_cgroup_sockets_enabled static_branch(&memcg_socket_limit_enabled)
+#define mem_cgroup_sockets_enabled very_unlikely(&memcg_socket_limit_enabled)
 #else
 #define mem_cgroup_sockets_enabled 0
 static inline struct cg_proto *parent_cg_proto(struct proto *proto,
diff --git a/net/core/dev.c b/net/core/dev.c
index 115dee1..6503c14 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1481,12 +1481,12 @@ EXPORT_SYMBOL(net_disable_timestamp);
 static inline void net_timestamp_set(struct sk_buff *skb)
 {
 	skb->tstamp.tv64 = 0;
-	if (static_branch(&netstamp_needed))
+	if (very_unlikely(&netstamp_needed))
 		__net_timestamp(skb);
 }
 
 #define net_timestamp_check(COND, SKB)			\
-	if (static_branch(&netstamp_needed)) {		\
+	if (very_unlikely(&netstamp_needed)) {		\
 		if ((COND) && !(SKB)->tstamp.tv64)	\
 			__net_timestamp(SKB);		\
 	}						\
@@ -2945,7 +2945,7 @@ int netif_rx(struct sk_buff *skb)
 
 	trace_netif_rx(skb);
 #ifdef CONFIG_RPS
-	if (static_branch(&rps_needed))	{
+	if (very_unlikely(&rps_needed)) {
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
 		int cpu;
 
@@ -3309,7 +3309,7 @@ int netif_receive_skb(struct sk_buff *skb)
 		return NET_RX_SUCCESS;
 
 #ifdef CONFIG_RPS
-	if (static_branch(&rps_needed)) {
+	if (very_unlikely(&rps_needed)) {
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
 		int cpu, ret;
 
-- 
1.7.7.5

