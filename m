Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965075Ab2CUWSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:18:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65325 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760339Ab2CUWSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:18:07 -0400
From: Tejun Heo <tj@kernel.org>
To: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>
Subject: [PATCH 08/12] cgroup: convert memcg controller to the new cftype interface
Date: Wed, 21 Mar 2012 15:17:41 -0700
Message-Id: <1332368265-21586-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332368265-21586-1-git-send-email-tj@kernel.org>
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert memcg to use the new cftype based interface.  kmem support
abuses ->populate() for mem_cgroup_sockets_init() so it can't be
removed at the moment.

tcp_memcontrol is updated so that tcp_files[] is registered via a
__initcall.  This change also allows removing the forward declaration
of tcp_files[].  Removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Greg Thelen <gthelen@google.com>
---
 mm/memcontrol.c           |   12 +++---------
 net/ipv4/tcp_memcontrol.c |   16 ++++++++++------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1e2a9d1..a3eb82f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4708,6 +4708,7 @@ static struct cftype mem_cgroup_files[] = {
 		.read = mem_cgroup_read,
 	},
 #endif
+	{ },	/* terminate */
 };
 
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
@@ -4963,15 +4964,7 @@ static void mem_cgroup_destroy(struct cgroup *cont)
 static int mem_cgroup_populate(struct cgroup_subsys *ss,
 				struct cgroup *cont)
 {
-	int ret;
-
-	ret = cgroup_add_files(cont, ss, mem_cgroup_files,
-				ARRAY_SIZE(mem_cgroup_files));
-
-	if (!ret)
-		ret = register_kmem_files(cont, ss);
-
-	return ret;
+	return register_kmem_files(cont, ss);
 }
 
 #ifdef CONFIG_MMU
@@ -5485,6 +5478,7 @@ struct cgroup_subsys mem_cgroup_subsys = {
 	.can_attach = mem_cgroup_can_attach,
 	.cancel_attach = mem_cgroup_cancel_attach,
 	.attach = mem_cgroup_move_task,
+	.base_cftypes = mem_cgroup_files,
 	.early_init = 0,
 	.use_id = 1,
 };
diff --git a/net/ipv4/tcp_memcontrol.c b/net/ipv4/tcp_memcontrol.c
index e0c5b4e..73ba5fd 100644
--- a/net/ipv4/tcp_memcontrol.c
+++ b/net/ipv4/tcp_memcontrol.c
@@ -6,8 +6,6 @@
 #include <linux/memcontrol.h>
 #include <linux/module.h>
 
-static struct cftype tcp_files[4];	/* XXX: will be removed soon */
-
 static inline struct tcp_memcontrol *tcp_from_cgproto(struct cg_proto *cg_proto)
 {
 	return container_of(cg_proto, struct tcp_memcontrol, cg_proto);
@@ -36,7 +34,7 @@ int tcp_init_cgroup(struct cgroup *cgrp, struct cgroup_subsys *ss)
 
 	cg_proto = tcp_prot.proto_cgroup(memcg);
 	if (!cg_proto)
-		goto create_files;
+		return 0;
 
 	tcp = tcp_from_cgproto(cg_proto);
 
@@ -59,9 +57,7 @@ int tcp_init_cgroup(struct cgroup *cgrp, struct cgroup_subsys *ss)
 	cg_proto->sockets_allocated = &tcp->tcp_sockets_allocated;
 	cg_proto->memcg = memcg;
 
-create_files:
-	return cgroup_add_files(cgrp, ss, tcp_files,
-				ARRAY_SIZE(tcp_files));
+	return 0;
 }
 EXPORT_SYMBOL(tcp_init_cgroup);
 
@@ -266,4 +262,12 @@ static struct cftype tcp_files[] = {
 		.trigger = tcp_cgroup_reset,
 		.read_u64 = tcp_cgroup_read,
 	},
+	{ }	/* terminate */
 };
+
+static int __init tcp_memcontrol_init(void)
+{
+	WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys, tcp_files));
+	return 0;
+}
+__initcall(tcp_memcontrol_init);
-- 
1.7.7.3

