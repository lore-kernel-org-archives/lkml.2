Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab2A0Ewt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 23:52:49 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56535 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab2A0Etg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:49:36 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 21/29] sysctl: Add a root pointer to ctl_table_set
Date: Thu, 26 Jan 2012 20:51:57 -0800
Message-Id: <1327639925-12920-21-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m1pqe5ah3z.fsf@fess.ebiederm.org>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19ej1DxfR0u54cCcGOOywecqC34g8Di6MU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a ctl_table_root pointer to ctl_table set so it is easy to
go from a ctl_table_set to a ctl_table_root.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c  |    3 +++
 include/linux/sysctl.h |    3 +++
 net/sysctl_net.c       |    5 ++---
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index d9c3ae6..65c13dd 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -45,6 +45,7 @@ static struct ctl_table_header root_table_header = {
 static struct ctl_table_root sysctl_table_root = {
 	.root_list = LIST_HEAD_INIT(sysctl_table_root.root_list),
 	.default_set.list = LIST_HEAD_INIT(root_table_header.ctl_entry),
+	.default_set.root = &sysctl_table_root,
 };
 
 static DEFINE_SPINLOCK(sysctl_lock);
@@ -1348,9 +1349,11 @@ void unregister_sysctl_table(struct ctl_table_header * header)
 EXPORT_SYMBOL(unregister_sysctl_table);
 
 void setup_sysctl_set(struct ctl_table_set *p,
+	struct ctl_table_root *root,
 	int (*is_seen)(struct ctl_table_set *))
 {
 	INIT_LIST_HEAD(&p->list);
+	p->root = root;
 	p->is_seen = is_seen;
 }
 
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index e40b8f6..e73ba33 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1047,6 +1047,7 @@ struct ctl_table_header
 
 struct ctl_table_set {
 	struct list_head list;
+	struct ctl_table_root *root;
 	int (*is_seen)(struct ctl_table_set *);
 };
 
@@ -1069,6 +1070,7 @@ struct ctl_path {
 void proc_sys_poll_notify(struct ctl_table_poll *poll);
 
 extern void setup_sysctl_set(struct ctl_table_set *p,
+	struct ctl_table_root *root,
 	int (*is_seen)(struct ctl_table_set *));
 extern void retire_sysctl_set(struct ctl_table_set *set);
 
@@ -1103,6 +1105,7 @@ static inline void unregister_sysctl_table(struct ctl_table_header * table)
 }
 
 static inline void setup_sysctl_set(struct ctl_table_set *p,
+	struct ctl_table_root *root,
 	int (*is_seen)(struct ctl_table_set *))
 {
 }
diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index 07c6b87..e998c64 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -74,8 +74,7 @@ static struct ctl_table_root net_sysctl_ro_root = {
 
 static int __net_init sysctl_net_init(struct net *net)
 {
-	setup_sysctl_set(&net->sysctls,
-			 is_seen);
+	setup_sysctl_set(&net->sysctls, &net_sysctl_root, is_seen);
 	return 0;
 }
 
@@ -95,7 +94,7 @@ static __init int net_sysctl_init(void)
 	ret = register_pernet_subsys(&sysctl_pernet_ops);
 	if (ret)
 		goto out;
-	setup_sysctl_set(&net_sysctl_ro_root.default_set, NULL);
+	setup_sysctl_set(&net_sysctl_ro_root.default_set, &net_sysctl_ro_root, NULL);
 	register_sysctl_root(&net_sysctl_ro_root);
 	register_sysctl_root(&net_sysctl_root);
 out:
-- 
1.7.2.5

