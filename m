Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162096Ab2CQAAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 20:00:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38397 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162031Ab2CPXgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:36:22 -0400
From: Tejun Heo <tj@kernel.org>
To: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>
Subject: [PATCH 06/10] cgroup: convert memcg controller to the new cftype interface
Date: Fri, 16 Mar 2012 16:35:59 -0700
Message-Id: <1331940963-15756-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331940963-15756-1-git-send-email-tj@kernel.org>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert memcg to use the new cftype based interface. memcg is rather
special in that

* memsw_cgroup_files creation is dependent on do_swap_account.

* ->populate() is abused for mem_cgroup_sockets_init().

memsw_cgroup_files is converted to use CGROUP_SUBSYS_CFTYPES_COND(),
where the condition is really_do_swap_account.

->populate() is preserved for register_kmem_files() invocation but I
strongly urge moving the initialization to the tail of ->create().  If
there's something which can't be done from ->create(), which isn't
clear from the comment, please let me know.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Greg Thelen <gthelen@google.com>
---
 mm/memcontrol.c           |   31 ++++++-------------------------
 net/ipv4/tcp_memcontrol.c |    8 ++++----
 2 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ae2f0a8..f2221ce 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4665,7 +4665,9 @@ static struct cftype mem_cgroup_files[] = {
 		.mode = S_IRUGO,
 	},
 #endif
+	{ },	/* terminate */
 };
+CGROUP_SUBSYS_CFTYPES(mem_cgroup_subsys, mem_cgroup_files);
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 static struct cftype memsw_cgroup_files[] = {
@@ -4694,20 +4696,10 @@ static struct cftype memsw_cgroup_files[] = {
 		.trigger = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read,
 	},
+	{ }	/* terminate */
 };
-
-static int register_memsw_files(struct cgroup *cont, struct cgroup_subsys *ss)
-{
-	if (!do_swap_account)
-		return 0;
-	return cgroup_add_files(cont, ss, memsw_cgroup_files,
-				ARRAY_SIZE(memsw_cgroup_files));
-};
-#else
-static int register_memsw_files(struct cgroup *cont, struct cgroup_subsys *ss)
-{
-	return 0;
-}
+CGROUP_SUBSYS_CFTYPES_COND(mem_cgroup_subsys, memsw_cgroup_files,
+			   really_do_swap_account);
 #endif
 
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
@@ -4963,18 +4955,7 @@ static void mem_cgroup_destroy(struct cgroup *cont)
 static int mem_cgroup_populate(struct cgroup_subsys *ss,
 				struct cgroup *cont)
 {
-	int ret;
-
-	ret = cgroup_add_files(cont, ss, mem_cgroup_files,
-				ARRAY_SIZE(mem_cgroup_files));
-
-	if (!ret)
-		ret = register_memsw_files(cont, ss);
-
-	if (!ret)
-		ret = register_kmem_files(cont, ss);
-
-	return ret;
+	return register_kmem_files(cont, ss);
 }
 
 #ifdef CONFIG_MMU
diff --git a/net/ipv4/tcp_memcontrol.c b/net/ipv4/tcp_memcontrol.c
index e714c68..21f48f3 100644
--- a/net/ipv4/tcp_memcontrol.c
+++ b/net/ipv4/tcp_memcontrol.c
@@ -35,7 +35,9 @@ static struct cftype tcp_files[] = {
 		.trigger = tcp_cgroup_reset,
 		.read_u64 = tcp_cgroup_read,
 	},
+	{ }	/* terminate */
 };
+CGROUP_SUBSYS_CFTYPES(mem_cgroup_subsys, tcp_files);
 
 static inline struct tcp_memcontrol *tcp_from_cgproto(struct cg_proto *cg_proto)
 {
@@ -65,7 +67,7 @@ int tcp_init_cgroup(struct cgroup *cgrp, struct cgroup_subsys *ss)
 
 	cg_proto = tcp_prot.proto_cgroup(memcg);
 	if (!cg_proto)
-		goto create_files;
+		return 0;
 
 	tcp = tcp_from_cgproto(cg_proto);
 
@@ -88,9 +90,7 @@ int tcp_init_cgroup(struct cgroup *cgrp, struct cgroup_subsys *ss)
 	cg_proto->sockets_allocated = &tcp->tcp_sockets_allocated;
 	cg_proto->memcg = memcg;
 
-create_files:
-	return cgroup_add_files(cgrp, ss, tcp_files,
-				ARRAY_SIZE(tcp_files));
+	return 0;
 }
 EXPORT_SYMBOL(tcp_init_cgroup);
 
-- 
1.7.7.3

