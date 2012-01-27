Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab2A0FFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 00:05:16 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:51326 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab2A0Erv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:47:51 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 07/29] sysctl: Remove the unnecessary sysctl_set parent concept.
Date: Thu, 26 Jan 2012 20:49:48 -0800
Message-Id: <1327639810-12760-7-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m1pqe5ah3z.fsf@fess.ebiederm.org>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/y4AOEUpf2t3IjnIRQOcE1la7TlJdHtXQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In sysctl_net register the two networking roots in the proper order.

In register_sysctl walk the sysctl sets in the reverse order of the
sysctl roots.

Remove parent from ctl_table_set and setup_sysctl_set as it is no
longer needed.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c  |   11 ++++++++---
 include/linux/sysctl.h |    3 ---
 net/sysctl_net.c       |    5 ++---
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 9d8223c..86d32a3 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -995,13 +995,20 @@ struct ctl_table_header *__register_sysctl_paths(
 	header->attached_by = header->ctl_table;
 	header->attached_to = root_table;
 	header->parent = &root_table_header;
-	for (set = header->set; set; set = set->parent) {
+	set = header->set;
+	root = header->root;
+	for (;;) {
 		struct ctl_table_header *p;
 		list_for_each_entry(p, &set->list, ctl_entry) {
 			if (p->unregistering)
 				continue;
 			try_attach(p, header);
 		}
+		if (root == &sysctl_table_root)
+			break;
+		root = list_entry(root->root_list.prev,
+				  struct ctl_table_root, root_list);
+		set = lookup_header_set(root, namespaces);
 	}
 	header->parent->count++;
 	list_add_tail(&header->ctl_entry, &header->set->list);
@@ -1072,11 +1079,9 @@ void unregister_sysctl_table(struct ctl_table_header * header)
 EXPORT_SYMBOL(unregister_sysctl_table);
 
 void setup_sysctl_set(struct ctl_table_set *p,
-	struct ctl_table_set *parent,
 	int (*is_seen)(struct ctl_table_set *))
 {
 	INIT_LIST_HEAD(&p->list);
-	p->parent = parent ? parent : &sysctl_table_root.default_set;
 	p->is_seen = is_seen;
 }
 
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 475ff0e..43c36ac 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1047,7 +1047,6 @@ struct ctl_table_header
 
 struct ctl_table_set {
 	struct list_head list;
-	struct ctl_table_set *parent;
 	int (*is_seen)(struct ctl_table_set *);
 };
 
@@ -1070,7 +1069,6 @@ struct ctl_path {
 void proc_sys_poll_notify(struct ctl_table_poll *poll);
 
 extern void setup_sysctl_set(struct ctl_table_set *p,
-	struct ctl_table_set *parent,
 	int (*is_seen)(struct ctl_table_set *));
 extern void retire_sysctl_set(struct ctl_table_set *set);
 
@@ -1102,7 +1100,6 @@ static inline void unregister_sysctl_table(struct ctl_table_header * table)
 }
 
 static inline void setup_sysctl_set(struct ctl_table_set *p,
-	struct ctl_table_set *parent,
 	int (*is_seen)(struct ctl_table_set *))
 {
 }
diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index ffd67a6..07c6b87 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -75,7 +75,6 @@ static struct ctl_table_root net_sysctl_ro_root = {
 static int __net_init sysctl_net_init(struct net *net)
 {
 	setup_sysctl_set(&net->sysctls,
-			 &net_sysctl_ro_root.default_set,
 			 is_seen);
 	return 0;
 }
@@ -96,9 +95,9 @@ static __init int net_sysctl_init(void)
 	ret = register_pernet_subsys(&sysctl_pernet_ops);
 	if (ret)
 		goto out;
-	register_sysctl_root(&net_sysctl_root);
-	setup_sysctl_set(&net_sysctl_ro_root.default_set, NULL, NULL);
+	setup_sysctl_set(&net_sysctl_ro_root.default_set, NULL);
 	register_sysctl_root(&net_sysctl_ro_root);
+	register_sysctl_root(&net_sysctl_root);
 out:
 	return ret;
 }
-- 
1.7.2.5

