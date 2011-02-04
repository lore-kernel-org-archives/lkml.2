Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab1BDEiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 23:38:12 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46255 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab1BDEiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 23:38:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Wx3laDXKqkDbS4C0vqTuZ6/m9tgq5iV0j1KSYX8cVD2MgBK51og3op4rkrMrWIRM0s
         97tzOvCE4Aa324Y/Vf2pD8ZeRdgxKxv4mYIcCN6bcb874vbLT6oRvlKniJ+n3w9WeZcB
         rfjVXKBSz0pKZmxAXerfy3YM/B4yO4oK7291Q=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Octavian Purdila <opurdila@ixiacom.com>
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 3/5] sysctl: write ctl_table->extra2 to entries created from ctl_path
Date: Fri,  4 Feb 2011 06:37:06 +0200
Message-Id: <ac0aec99ef78f7fe595c3724fe20d2c4f56178b5.1296793770.git.lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.4.rc1.7.g2cf08.dirty
In-Reply-To: <cover.1296793770.git.lucian.grijincu@gmail.com>
References: <cover.1296793770.git.lucian.grijincu@gmail.com>
In-Reply-To: <cover.1296793770.git.lucian.grijincu@gmail.com>
References: <cover.1296793770.git.lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For each entry in an array of 'struct ctl_path' we were registering a
'struct ctl_table' array with two entries:
- one to store the name + permissions,
- one as an end-of-array marker (completely blank).

We were not using any of the data storage fields
(data, extra1, extra2) in the first 'struct ctl_table'.

This patch adds possibility of storring some user provided
pointer in the 'extra2' field.

All users the next functions store NULL in the 'extra2'
field like they used to before this patch:
* register_sysctl_paths
* register_net_sysctl_table
* register_net_sysctl_rotable

Until now sysctl_check_table considered that the 'struct ctl_table' of
directories may not store anything in the 'extra2' field. We no longer
consider this a fault.

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 include/linux/sysctl.h      |    2 +-
 include/net/net_namespace.h |    2 ++
 kernel/sysctl.c             |    7 +++++--
 kernel/sysctl_check.c       |    2 --
 net/sysctl_net.c            |   20 ++++++++++++++------
 5 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 1f1da4b..090b9a3 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1057,7 +1057,7 @@ struct ctl_path {
 void register_sysctl_root(struct ctl_table_root *root);
 struct ctl_table_header *__register_sysctl_paths(
 	struct ctl_table_root *root, struct nsproxy *namespaces,
-	const struct ctl_path *path, struct ctl_table *table);
+	const struct ctl_path *path, struct ctl_table *table, void *pathdata);
 struct ctl_table_header *register_sysctl_table(struct ctl_table * table);
 struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
 						struct ctl_table *table);
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 1bf812b..42d4d61 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -272,6 +272,8 @@ struct ctl_table_header;
 
 extern struct ctl_table_header *register_net_sysctl_table(struct net *net,
 	const struct ctl_path *path, struct ctl_table *table);
+struct ctl_table_header *register_net_sysctl_table_pathdata(struct net *net,
+	const struct ctl_path *path, struct ctl_table *table, void *pathdata);
 extern struct ctl_table_header *register_net_sysctl_rotable(
 	const struct ctl_path *path, struct ctl_table *table);
 extern void unregister_net_sysctl_table(struct ctl_table_header *header);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 42025ec..9b67c9e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1759,6 +1759,8 @@ static void try_attach(struct ctl_table_header *p, struct ctl_table_header *q)
  * @namespaces: Data to compute which lists of sysctl entries are visible
  * @path: The path to the directory the sysctl table is in.
  * @table: the top-level table structure
+ * @pathdata: user provided pointer to data that will be stored in ->extra2
+ *            for every ctl_table node allocated for entries in @path
  *
  * Register a sysctl table hierarchy. @table should be a filled in ctl_table
  * array. A completely 0 filled entry terminates the table.
@@ -1809,7 +1811,7 @@ static void try_attach(struct ctl_table_header *p, struct ctl_table_header *q)
 struct ctl_table_header *__register_sysctl_paths(
 	struct ctl_table_root *root,
 	struct nsproxy *namespaces,
-	const struct ctl_path *path, struct ctl_table *table)
+	const struct ctl_path *path, struct ctl_table *table, void *pathdata)
 {
 	struct ctl_table_header *header;
 	struct ctl_table *new, **prevp;
@@ -1841,6 +1843,7 @@ struct ctl_table_header *__register_sysctl_paths(
 		/* Copy the procname */
 		new->procname = path->procname;
 		new->mode     = 0555;
+		new->extra2   = pathdata;
 
 		*prevp = new;
 		prevp = &new->child;
@@ -1895,7 +1898,7 @@ struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
 						struct ctl_table *table)
 {
 	return __register_sysctl_paths(&sysctl_table_root, current->nsproxy,
-					path, table);
+				       path, table, NULL);
 }
 
 /**
diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index b7d9c66..e09f47f 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -112,8 +112,6 @@ static int __sysctl_check_table(struct nsproxy *namespaces,
 				SET_FAIL("Directory with proc_handler");
 			if (table->extra1)
 				SET_FAIL("Directory with extra1");
-			if (table->extra2)
-				SET_FAIL("Directory with extra2");
 		} else {
 			if ((table->proc_handler == proc_dostring) ||
 			    (table->proc_handler == proc_dointvec) ||
diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index ca84212..9c92cac 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -103,22 +103,30 @@ out:
 }
 subsys_initcall(sysctl_init);
 
-struct ctl_table_header *register_net_sysctl_table(struct net *net,
-	const struct ctl_path *path, struct ctl_table *table)
+struct ctl_table_header *register_net_sysctl_table_pathdata(struct net *net,
+	const struct ctl_path *path, struct ctl_table *table, void *pathdata)
 {
 	struct nsproxy namespaces;
 	namespaces = *current->nsproxy;
 	namespaces.net_ns = net;
-	return __register_sysctl_paths(&net_sysctl_root,
-					&namespaces, path, table);
+	return __register_sysctl_paths(&net_sysctl_root, &namespaces,
+				       path, table, pathdata);
+}
+EXPORT_SYMBOL_GPL(register_net_sysctl_table_pathdata);
+
+struct ctl_table_header *register_net_sysctl_table(struct net *net,
+	const struct ctl_path *path, struct ctl_table *table)
+{
+	return register_net_sysctl_table_pathdata(net, path, table, NULL);
 }
 EXPORT_SYMBOL_GPL(register_net_sysctl_table);
 
+
 struct ctl_table_header *register_net_sysctl_rotable(const
 		struct ctl_path *path, struct ctl_table *table)
 {
-	return __register_sysctl_paths(&net_sysctl_ro_root,
-			&init_nsproxy, path, table);
+	return __register_sysctl_paths(&net_sysctl_ro_root, &init_nsproxy,
+				       path, table, NULL);
 }
 EXPORT_SYMBOL_GPL(register_net_sysctl_rotable);
 
-- 
1.7.4.rc1.7.g2cf08.dirty

