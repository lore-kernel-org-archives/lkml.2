Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab2A0FGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 00:06:37 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56453 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab2A0Erv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:47:51 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 06/29] sysctl: Implement retire_sysctl_set
Date: Thu, 26 Jan 2012 20:49:47 -0800
Message-Id: <1327639810-12760-6-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m1pqe5ah3z.fsf@fess.ebiederm.org>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18rLgzbkIHZanFEMwuOR3DZM7XTf3lrSAQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a small helper retire_sysctl_set to remove the intimate knowledge about
the how a sysctl_set is implemented from net/sysct_net.c

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c  |    4 ++++
 include/linux/sysctl.h |    1 +
 net/sysctl_net.c       |    2 +-
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index f6aa751..9d8223c 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1080,6 +1080,10 @@ void setup_sysctl_set(struct ctl_table_set *p,
 	p->is_seen = is_seen;
 }
 
+void retire_sysctl_set(struct ctl_table_set *set)
+{
+	WARN_ON(!list_empty(&set->list));
+}
 
 int __init proc_sys_init(void)
 {
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 08cabbf..475ff0e 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1072,6 +1072,7 @@ void proc_sys_poll_notify(struct ctl_table_poll *poll);
 extern void setup_sysctl_set(struct ctl_table_set *p,
 	struct ctl_table_set *parent,
 	int (*is_seen)(struct ctl_table_set *));
+extern void retire_sysctl_set(struct ctl_table_set *set);
 
 void register_sysctl_root(struct ctl_table_root *root);
 struct ctl_table_header *__register_sysctl_paths(
diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index a6bbee2..ffd67a6 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -82,7 +82,7 @@ static int __net_init sysctl_net_init(struct net *net)
 
 static void __net_exit sysctl_net_exit(struct net *net)
 {
-	WARN_ON(!list_empty(&net->sysctls.list));
+	retire_sysctl_set(&net->sysctls);
 }
 
 static struct pernet_operations sysctl_pernet_ops = {
-- 
1.7.2.5

