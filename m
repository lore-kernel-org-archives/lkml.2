Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2A0EtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 23:49:22 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:51916 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab2A0Erz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:47:55 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 25/29] sysctl: Modify __register_sysctl_paths to take a set instead of a root and an nsproxy
Date: Thu, 26 Jan 2012 20:50:06 -0800
Message-Id: <1327639810-12760-25-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m1pqe5ah3z.fsf@fess.ebiederm.org>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+gX3ELXqZ9TvvwsFez/RKdrsQla1l3Im8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An nsproxy argument here has always been awkard and now the nsproxy argument
is completely unnecessary so remove it, replacing it with the set we want
the registered tables to show up in.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c  |   30 ++++++++++++------------------
 include/linux/sysctl.h |    4 ++--
 net/sysctl_net.c       |   10 +++-------
 3 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index ec54a57..e0d3e7e 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1084,8 +1084,7 @@ out:
 
 /**
  * __register_sysctl_table - register a leaf sysctl table
- * @root: List of sysctl headers to register on
- * @namespaces: Data to compute which lists of sysctl entries are visible
+ * @set: Sysctl tree to register on
  * @path: The path to the directory the sysctl table is in.
  * @table: the top-level table structure
  *
@@ -1126,26 +1125,24 @@ out:
  * to the table header on success.
  */
 struct ctl_table_header *__register_sysctl_table(
-	struct ctl_table_root *root,
-	struct nsproxy *namespaces,
+	struct ctl_table_set *set,
 	const char *path, struct ctl_table *table)
 {
+	struct ctl_table_root *root = set->dir.header.root;
 	struct ctl_table_header *links = NULL;
 	struct ctl_table_header *header;
 	const char *name, *nextname;
-	struct ctl_table_set *set;
 	struct ctl_dir *dir;
 
 	header = kzalloc(sizeof(struct ctl_table_header), GFP_KERNEL);
 	if (!header)
 		return NULL;
 
-	init_header(header, root, NULL, table);
+	init_header(header, root, set, table);
 	if (sysctl_check_table(path, table))
 		goto fail;
 
 	spin_lock(&sysctl_lock);
-	header->set = set = lookup_header_set(root, namespaces);
 	dir = &set->dir;
 	dir->header.nreg++;
 	spin_unlock(&sysctl_lock);
@@ -1223,8 +1220,7 @@ static int count_subheaders(struct ctl_table *table)
 }
 
 static int register_leaf_sysctl_tables(const char *path, char *pos,
-	struct ctl_table_header ***subheader,
-	struct ctl_table_root *root, struct nsproxy *namespaces,
+	struct ctl_table_header ***subheader, struct ctl_table_set *set,
 	struct ctl_table *table)
 {
 	struct ctl_table *ctl_table_arg = NULL;
@@ -1261,7 +1257,7 @@ static int register_leaf_sysctl_tables(const char *path, char *pos,
 	/* Register everything except a directory full of subdirectories */
 	if (nr_files || !nr_dirs) {
 		struct ctl_table_header *header;
-		header = __register_sysctl_table(root, namespaces, path, files);
+		header = __register_sysctl_table(set, path, files);
 		if (!header) {
 			kfree(ctl_table_arg);
 			goto out;
@@ -1286,7 +1282,7 @@ static int register_leaf_sysctl_tables(const char *path, char *pos,
 			goto out;
 
 		err = register_leaf_sysctl_tables(path, child_pos, subheader,
-						  root, namespaces, entry->child);
+						  set, entry->child);
 		pos[0] = '\0';
 		if (err)
 			goto out;
@@ -1299,8 +1295,7 @@ out:
 
 /**
  * __register_sysctl_paths - register a sysctl table hierarchy
- * @root: List of sysctl headers to register on
- * @namespaces: Data to compute which lists of sysctl entries are visible
+ * @set: Sysctl tree to register on
  * @path: The path to the directory the sysctl table is in.
  * @table: the top-level table structure
  *
@@ -1310,8 +1305,7 @@ out:
  * See __register_sysctl_table for more details.
  */
 struct ctl_table_header *__register_sysctl_paths(
-	struct ctl_table_root *root,
-	struct nsproxy *namespaces,
+	struct ctl_table_set *set,
 	const struct ctl_path *path, struct ctl_table *table)
 {
 	struct ctl_table *ctl_table_arg = table;
@@ -1337,7 +1331,7 @@ struct ctl_table_header *__register_sysctl_paths(
 		table = table->child;
 	}
 	if (nr_subheaders == 1) {
-		header = __register_sysctl_table(root, namespaces, new_path, table);
+		header = __register_sysctl_table(set, new_path, table);
 		if (header)
 			header->ctl_table_arg = ctl_table_arg;
 	} else {
@@ -1351,7 +1345,7 @@ struct ctl_table_header *__register_sysctl_paths(
 		header->ctl_table_arg = ctl_table_arg;
 
 		if (register_leaf_sysctl_tables(new_path, pos, &subheader,
-						root, namespaces, table))
+						set, table))
 			goto err_register_leaves;
 	}
 
@@ -1384,7 +1378,7 @@ err_register_leaves:
 struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
 						struct ctl_table *table)
 {
-	return __register_sysctl_paths(&sysctl_table_root, current->nsproxy,
+	return __register_sysctl_paths(&sysctl_table_root.default_set,
 					path, table);
 }
 EXPORT_SYMBOL(register_sysctl_paths);
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 2a1446a..cec5941 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1079,10 +1079,10 @@ extern void retire_sysctl_set(struct ctl_table_set *set);
 
 void register_sysctl_root(struct ctl_table_root *root);
 struct ctl_table_header *__register_sysctl_table(
-	struct ctl_table_root *root, struct nsproxy *namespaces,
+	struct ctl_table_set *set,
 	const char *path, struct ctl_table *table);
 struct ctl_table_header *__register_sysctl_paths(
-	struct ctl_table_root *root, struct nsproxy *namespaces,
+	struct ctl_table_set *set,
 	const struct ctl_path *path, struct ctl_table *table);
 struct ctl_table_header *register_sysctl_table(struct ctl_table * table);
 struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index e998c64..c3e65ae 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -105,19 +105,15 @@ subsys_initcall(net_sysctl_init);
 struct ctl_table_header *register_net_sysctl_table(struct net *net,
 	const struct ctl_path *path, struct ctl_table *table)
 {
-	struct nsproxy namespaces;
-	namespaces = *current->nsproxy;
-	namespaces.net_ns = net;
-	return __register_sysctl_paths(&net_sysctl_root,
-					&namespaces, path, table);
+	return __register_sysctl_paths(&net->sysctls, path, table);
 }
 EXPORT_SYMBOL_GPL(register_net_sysctl_table);
 
 struct ctl_table_header *register_net_sysctl_rotable(const
 		struct ctl_path *path, struct ctl_table *table)
 {
-	return __register_sysctl_paths(&net_sysctl_ro_root,
-			&init_nsproxy, path, table);
+	return __register_sysctl_paths(&net_sysctl_ro_root.default_set,
+					path, table);
 }
 EXPORT_SYMBOL_GPL(register_net_sysctl_rotable);
 
-- 
1.7.2.5

