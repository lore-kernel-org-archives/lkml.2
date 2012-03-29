Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2C2GbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:31:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60343 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2C2GbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:31:00 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F74013C.6080703@jp.fujitsu.com>
Date: Thu, 29 Mar 2012 15:29:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, davem@davemloft.net
Subject: [BUGFIX][PATCH 2/3] memcg/tcp: fix static_branch handling
References: <4F73FF9D.4090809@jp.fujitsu.com>
In-Reply-To: <4F73FF9D.4090809@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tcp memcontrol uses static_branch to optimize limit=RESOURCE_MAX case.
If all cgroup's limit=RESOUCE_MAX, resource usage is not accounted.
But it's buggy now.

For example, do following
 # while sleep 1;do
   echo 9223372036854775807 > /cgroup/memory/A/memory.kmem.tcp.limit_in_bytes;
   echo 300M > /cgroup/memory/A/memory.kmem.tcp.limit_in_bytes;
   done

and run network application under A. tcp's usage is sometimes accounted
and sometimes not accounted because of frequent changes of static_branch.
Then, finally, you can see broken tcp.usage_in_bytes.
WARN_ON() is printed because res_counter->usage goes below 0.
==
kernel: ------------[ cut here ]----------
kernel: WARNING: at kernel/res_counter.c:96 res_counter_uncharge_locked+0x37/0x40()
 <snip>
kernel: Pid: 17753, comm: bash Tainted: G  W    3.3.0+ #99
kernel: Call Trace:
kernel: <IRQ>  [<ffffffff8104cc9f>] warn_slowpath_common+0x7f/0xc0
kernel: [<ffffffff810d7e88>] ? rb_reserve__next_event+0x68/0x470
kernel: [<ffffffff8104ccfa>] warn_slowpath_null+0x1a/0x20
kernel: [<ffffffff810b4e37>] res_counter_uncharge_locked+0x37/0x40
...
==

This patch removes static_branch_slow_dec() at changing res_counter's
limit to RESOUCE_MAX. By this, once accounting started, the accountting
will continue until the cgroup is destroyed.

I think this will not be problem in real use.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/net/tcp_memcontrol.h |    1 +
 net/ipv4/tcp_memcontrol.c    |   24 ++++++++++++++++++------
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp_memcontrol.h b/include/net/tcp_memcontrol.h
index 48410ff..f47e3c7 100644
--- a/include/net/tcp_memcontrol.h
+++ b/include/net/tcp_memcontrol.h
@@ -9,6 +9,7 @@ struct tcp_memcontrol {
 	/* those two are read-mostly, leave them at the end */
 	long tcp_prot_mem[3];
 	int tcp_memory_pressure;
+	bool accounting;
 };
 
 struct cg_proto *tcp_proto_cgroup(struct mem_cgroup *memcg);
diff --git a/net/ipv4/tcp_memcontrol.c b/net/ipv4/tcp_memcontrol.c
index 32764a6..cd0b47d 100644
--- a/net/ipv4/tcp_memcontrol.c
+++ b/net/ipv4/tcp_memcontrol.c
@@ -49,6 +49,20 @@ static void memcg_tcp_enter_memory_pressure(struct sock *sk)
 }
 EXPORT_SYMBOL(memcg_tcp_enter_memory_pressure);
 
+static void tcp_start_accounting(struct tcp_memcontrol *tcp)
+{
+	if (tcp->accounting)
+		return;
+	tcp->accounting = true;
+	static_key_slow_inc(&memcg_socket_limit_enabled);
+}
+
+static void tcp_end_accounting(struct tcp_memcontrol *tcp)
+{
+	if (tcp->accounting)
+		static_key_slow_dec(&memcg_socket_limit_enabled);
+}
+
 int tcp_init_cgroup(struct cgroup *cgrp, struct cgroup_subsys *ss)
 {
 	/*
@@ -73,6 +87,7 @@ int tcp_init_cgroup(struct cgroup *cgrp, struct cgroup_subsys *ss)
 	tcp->tcp_prot_mem[1] = net->ipv4.sysctl_tcp_mem[1];
 	tcp->tcp_prot_mem[2] = net->ipv4.sysctl_tcp_mem[2];
 	tcp->tcp_memory_pressure = 0;
+	tcp->accounting = false;
 
 	parent_cg = tcp_prot.proto_cgroup(parent);
 	if (parent_cg && mem_cgroup_use_hierarchy(parent))
@@ -110,8 +125,7 @@ void tcp_destroy_cgroup(struct cgroup *cgrp)
 
 	val = res_counter_read_u64(&tcp->tcp_memory_allocated, RES_LIMIT);
 
-	if (val != RESOURCE_MAX)
-		static_key_slow_dec(&memcg_socket_limit_enabled);
+	tcp_end_accounting(tcp);
 }
 EXPORT_SYMBOL(tcp_destroy_cgroup);
 
@@ -142,10 +156,8 @@ static int tcp_update_limit(struct mem_cgroup *memcg, u64 val)
 		tcp->tcp_prot_mem[i] = min_t(long, val >> PAGE_SHIFT,
 					     net->ipv4.sysctl_tcp_mem[i]);
 
-	if (val == RESOURCE_MAX && old_lim != RESOURCE_MAX)
-		static_key_slow_dec(&memcg_socket_limit_enabled);
-	else if (old_lim == RESOURCE_MAX && val != RESOURCE_MAX)
-		static_key_slow_inc(&memcg_socket_limit_enabled);
+	if (old_lim == RESOURCE_MAX && val != RESOURCE_MAX)
+		tcp_start_accounting(tcp);
 
 	return 0;
 }
-- 
1.7.4.1



