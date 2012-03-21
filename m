Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965066Ab2CUWU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:20:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42808 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760124Ab2CUWSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:18:01 -0400
From: Tejun Heo <tj@kernel.org>
To: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/12] cgroup: relocate cftype and cgroup_subsys definitions in controllers
Date: Wed, 21 Mar 2012 15:17:38 -0700
Message-Id: <1332368265-21586-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332368265-21586-1-git-send-email-tj@kernel.org>
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk-cgroup, netprio_cgroup, cls_cgroup and tcp_memcontrol
unnecessarily define cftype array and cgroup_subsys structures at the
top of the file, which is unconventional and necessiates forward
declaration of methods.

This patch relocates those below the definitions of the methods and
removes the forward declarations.  Note that forward declaration of
tcp_files[] is added in tcp_memcontrol.c for tcp_init_cgroup().  This
will be removed soon by another patch.

This patch doesn't introduce any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c        |   38 ++++++++++++-----------------
 net/core/netprio_cgroup.c |   26 ++++++++------------
 net/ipv4/tcp_memcontrol.c |   57 +++++++++++++++++++++-----------------------
 net/sched/cls_cgroup.c    |   27 ++++++++------------
 4 files changed, 65 insertions(+), 83 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 1359d63..c0cbe8b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -28,34 +28,12 @@ static LIST_HEAD(blkio_list);
 struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
 EXPORT_SYMBOL_GPL(blkio_root_cgroup);
 
-static struct cgroup_subsys_state *blkiocg_create(struct cgroup *);
-static int blkiocg_can_attach(struct cgroup *, struct cgroup_taskset *);
-static void blkiocg_attach(struct cgroup *, struct cgroup_taskset *);
-static void blkiocg_destroy(struct cgroup *);
-static int blkiocg_populate(struct cgroup_subsys *, struct cgroup *);
-
 /* for encoding cft->private value on file */
 #define BLKIOFILE_PRIVATE(x, val)	(((x) << 16) | (val))
 /* What policy owns the file, proportional or throttle */
 #define BLKIOFILE_POLICY(val)		(((val) >> 16) & 0xffff)
 #define BLKIOFILE_ATTR(val)		((val) & 0xffff)
 
-struct cgroup_subsys blkio_subsys = {
-	.name = "blkio",
-	.create = blkiocg_create,
-	.can_attach = blkiocg_can_attach,
-	.attach = blkiocg_attach,
-	.destroy = blkiocg_destroy,
-	.populate = blkiocg_populate,
-#ifdef CONFIG_BLK_CGROUP
-	/* note: blkio_subsys_id is otherwise defined in blk-cgroup.h */
-	.subsys_id = blkio_subsys_id,
-#endif
-	.use_id = 1,
-	.module = THIS_MODULE,
-};
-EXPORT_SYMBOL_GPL(blkio_subsys);
-
 static inline void blkio_policy_insert_node(struct blkio_cgroup *blkcg,
 					    struct blkio_policy_node *pn)
 {
@@ -1658,6 +1636,22 @@ static void blkiocg_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 	}
 }
 
+struct cgroup_subsys blkio_subsys = {
+	.name = "blkio",
+	.create = blkiocg_create,
+	.can_attach = blkiocg_can_attach,
+	.attach = blkiocg_attach,
+	.destroy = blkiocg_destroy,
+	.populate = blkiocg_populate,
+#ifdef CONFIG_BLK_CGROUP
+	/* note: blkio_subsys_id is otherwise defined in blk-cgroup.h */
+	.subsys_id = blkio_subsys_id,
+#endif
+	.use_id = 1,
+	.module = THIS_MODULE,
+};
+EXPORT_SYMBOL_GPL(blkio_subsys);
+
 void blkio_policy_register(struct blkio_policy_type *blkiop)
 {
 	spin_lock(&blkio_list_lock);
diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 22036ab..c802613 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -23,21 +23,6 @@
 #include <net/sock.h>
 #include <net/netprio_cgroup.h>
 
-static struct cgroup_subsys_state *cgrp_create(struct cgroup *cgrp);
-static void cgrp_destroy(struct cgroup *cgrp);
-static int cgrp_populate(struct cgroup_subsys *ss, struct cgroup *cgrp);
-
-struct cgroup_subsys net_prio_subsys = {
-	.name		= "net_prio",
-	.create		= cgrp_create,
-	.destroy	= cgrp_destroy,
-	.populate	= cgrp_populate,
-#ifdef CONFIG_NETPRIO_CGROUP
-	.subsys_id	= net_prio_subsys_id,
-#endif
-	.module		= THIS_MODULE
-};
-
 #define PRIOIDX_SZ 128
 
 static unsigned long prioidx_map[PRIOIDX_SZ];
@@ -263,6 +248,17 @@ static int cgrp_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
 	return cgroup_add_files(cgrp, ss, ss_files, ARRAY_SIZE(ss_files));
 }
 
+struct cgroup_subsys net_prio_subsys = {
+	.name		= "net_prio",
+	.create		= cgrp_create,
+	.destroy	= cgrp_destroy,
+	.populate	= cgrp_populate,
+#ifdef CONFIG_NETPRIO_CGROUP
+	.subsys_id	= net_prio_subsys_id,
+#endif
+	.module		= THIS_MODULE
+};
+
 static int netprio_device_event(struct notifier_block *unused,
 				unsigned long event, void *ptr)
 {
diff --git a/net/ipv4/tcp_memcontrol.c b/net/ipv4/tcp_memcontrol.c
index e714c68..e0c5b4e 100644
--- a/net/ipv4/tcp_memcontrol.c
+++ b/net/ipv4/tcp_memcontrol.c
@@ -6,36 +6,7 @@
 #include <linux/memcontrol.h>
 #include <linux/module.h>
 
-static u64 tcp_cgroup_read(struct cgroup *cont, struct cftype *cft);
-static int tcp_cgroup_write(struct cgroup *cont, struct cftype *cft,
-			    const char *buffer);
-static int tcp_cgroup_reset(struct cgroup *cont, unsigned int event);
-
-static struct cftype tcp_files[] = {
-	{
-		.name = "kmem.tcp.limit_in_bytes",
-		.write_string = tcp_cgroup_write,
-		.read_u64 = tcp_cgroup_read,
-		.private = RES_LIMIT,
-	},
-	{
-		.name = "kmem.tcp.usage_in_bytes",
-		.read_u64 = tcp_cgroup_read,
-		.private = RES_USAGE,
-	},
-	{
-		.name = "kmem.tcp.failcnt",
-		.private = RES_FAILCNT,
-		.trigger = tcp_cgroup_reset,
-		.read_u64 = tcp_cgroup_read,
-	},
-	{
-		.name = "kmem.tcp.max_usage_in_bytes",
-		.private = RES_MAX_USAGE,
-		.trigger = tcp_cgroup_reset,
-		.read_u64 = tcp_cgroup_read,
-	},
-};
+static struct cftype tcp_files[4];	/* XXX: will be removed soon */
 
 static inline struct tcp_memcontrol *tcp_from_cgproto(struct cg_proto *cg_proto)
 {
@@ -270,3 +241,29 @@ void tcp_prot_mem(struct mem_cgroup *memcg, long val, int idx)
 
 	tcp->tcp_prot_mem[idx] = val;
 }
+
+static struct cftype tcp_files[] = {
+	{
+		.name = "kmem.tcp.limit_in_bytes",
+		.write_string = tcp_cgroup_write,
+		.read_u64 = tcp_cgroup_read,
+		.private = RES_LIMIT,
+	},
+	{
+		.name = "kmem.tcp.usage_in_bytes",
+		.read_u64 = tcp_cgroup_read,
+		.private = RES_USAGE,
+	},
+	{
+		.name = "kmem.tcp.failcnt",
+		.private = RES_FAILCNT,
+		.trigger = tcp_cgroup_reset,
+		.read_u64 = tcp_cgroup_read,
+	},
+	{
+		.name = "kmem.tcp.max_usage_in_bytes",
+		.private = RES_MAX_USAGE,
+		.trigger = tcp_cgroup_reset,
+		.read_u64 = tcp_cgroup_read,
+	},
+};
diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index 1afaa28..024df8a 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -22,22 +22,6 @@
 #include <net/sock.h>
 #include <net/cls_cgroup.h>
 
-static struct cgroup_subsys_state *cgrp_create(struct cgroup *cgrp);
-static void cgrp_destroy(struct cgroup *cgrp);
-static int cgrp_populate(struct cgroup_subsys *ss, struct cgroup *cgrp);
-
-struct cgroup_subsys net_cls_subsys = {
-	.name		= "net_cls",
-	.create		= cgrp_create,
-	.destroy	= cgrp_destroy,
-	.populate	= cgrp_populate,
-#ifdef CONFIG_NET_CLS_CGROUP
-	.subsys_id	= net_cls_subsys_id,
-#endif
-	.module		= THIS_MODULE,
-};
-
-
 static inline struct cgroup_cls_state *cgrp_cls_state(struct cgroup *cgrp)
 {
 	return container_of(cgroup_subsys_state(cgrp, net_cls_subsys_id),
@@ -93,6 +77,17 @@ static int cgrp_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
 	return cgroup_add_files(cgrp, ss, ss_files, ARRAY_SIZE(ss_files));
 }
 
+struct cgroup_subsys net_cls_subsys = {
+	.name		= "net_cls",
+	.create		= cgrp_create,
+	.destroy	= cgrp_destroy,
+	.populate	= cgrp_populate,
+#ifdef CONFIG_NET_CLS_CGROUP
+	.subsys_id	= net_cls_subsys_id,
+#endif
+	.module		= THIS_MODULE,
+};
+
 struct cls_cgroup_head {
 	u32			handle;
 	struct tcf_exts		exts;
-- 
1.7.7.3

