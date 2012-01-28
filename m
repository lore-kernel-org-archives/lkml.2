Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2A1Lun (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 06:50:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46759 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab2A1Lul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 06:50:41 -0500
Date: Sat, 28 Jan 2012 12:50:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <glommer@parallels.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/tcp: Fix tcp memory limits initialization when
 !CONFIG_SYSCTL
Message-ID: <20120128115028.GA14020@elte.hu>
References: <20120127142246.GA22318@elte.hu>
 <4F22B634.2020007@parallels.com>
 <4F22D05A.8030604@parallels.com>
 <20120127.162823.1960229872591588915.davem@davemloft.net>
 <4F231703.4040803@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F231703.4040803@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ok, the patch works fine - in the tested version i've renamed 
the function and cleaned up the changelog a bit, see the final 
patch below.

Thanks,

	Ingo

-------------------->
>From c5b258533cb5f6f216522163a9aa7ff029dc390f Mon Sep 17 00:00:00 2001
From: Glauber Costa <glommer@parallels.com>
Date: Fri, 27 Jan 2012 20:27:06 +0400
Subject: [PATCH] net/tcp: Fix tcp memory limits initialization when !CONFIG_SYSCTL

sysctl_tcp_mem() initialization was moved to sysctl_tcp_ipv4.c 
in commit 3dc43e3e4d0b52197d3205214fe8f162f9e0c334, since it 
became a per-ns value.

That code, however, will never run when CONFIG_SYSCTL is 
disabled, leading to bogus values on those fields - causing hung 
TCP sockets.

This patch fixes it by keeping an initialization code in 
tcp_init(). It will be overwritten by the first net namespace 
init if CONFIG_SYSCTL is compiled in, and do the right thing if 
it is compiled out.

It is also named properly as tcp_init_mem(), to properly signal 
its non-sysctl side effect on TCP limits.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: David S. Miller <davem@davemloft.net>
Link: http://lkml.kernel.org/r/4F22D05A.8030604@parallels.com
[ renamed the function, tidied up the changelog a bit ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/net/tcp.h          |    2 ++
 net/ipv4/sysctl_net_ipv4.c |    1 +
 net/ipv4/tcp.c             |   16 +++++++++++++---
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 0118ea9..d49db01 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -311,6 +311,8 @@ extern struct proto tcp_prot;
 #define TCP_ADD_STATS_USER(net, field, val) SNMP_ADD_STATS_USER((net)->mib.tcp_statistics, field, val)
 #define TCP_ADD_STATS(net, field, val)	SNMP_ADD_STATS((net)->mib.tcp_statistics, field, val)
 
+extern void tcp_init_mem(struct net *net);
+
 extern void tcp_v4_err(struct sk_buff *skb, u32);
 
 extern void tcp_shutdown (struct sock *sk, int how);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 4aa7e9d..4cb9cd2 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -814,6 +814,7 @@ static __net_init int ipv4_sysctl_init_net(struct net *net)
 
 	net->ipv4.sysctl_rt_cache_rebuild_count = 4;
 
+	tcp_init_mem(net);
 	limit = nr_free_buffer_pages() / 8;
 	limit = max(limit, 128UL);
 	net->ipv4.sysctl_tcp_mem[0] = limit / 4 * 3;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9bcdec3..06373b4 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3216,6 +3216,16 @@ static int __init set_thash_entries(char *str)
 }
 __setup("thash_entries=", set_thash_entries);
 
+void tcp_init_mem(struct net *net)
+{
+	/* Set per-socket limits to no more than 1/128 the pressure threshold */
+	unsigned long limit = nr_free_buffer_pages() / 8;
+	limit = max(limit, 128UL);
+	net->ipv4.sysctl_tcp_mem[0] = limit / 4 * 3;
+	net->ipv4.sysctl_tcp_mem[1] = limit;
+	net->ipv4.sysctl_tcp_mem[2] = net->ipv4.sysctl_tcp_mem[0] * 2;
+}
+
 void __init tcp_init(void)
 {
 	struct sk_buff *skb = NULL;
@@ -3276,9 +3286,9 @@ void __init tcp_init(void)
 	sysctl_tcp_max_orphans = cnt / 2;
 	sysctl_max_syn_backlog = max(128, cnt / 256);
 
-	/* Set per-socket limits to no more than 1/128 the pressure threshold */
-	limit = ((unsigned long)init_net.ipv4.sysctl_tcp_mem[1])
-		<< (PAGE_SHIFT - 7);
+	tcp_init_mem(&init_net);
+	limit = nr_free_buffer_pages() / 8;
+	limit = max(limit, 128UL);
 	max_share = min(4UL*1024*1024, limit);
 
 	sysctl_tcp_wmem[0] = SK_MEM_QUANTUM;
