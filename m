Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab1EGC0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 22:26:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34294 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab1EGCZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 22:25:57 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-arch@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, jamal <hadi@cyberus.ca>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 4/7] ns proc: Add support for the uts namespace
Date: Fri,  6 May 2011 19:24:58 -0700
Message-Id: <1304735101-1824-4-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.1.217.g4e3aa
In-Reply-To: <1304735101-1824-1-git-send-email-ebiederm@xmission.com>
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
 <1304735101-1824-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+9iWpdyUiECSjCzO+bYmNxnRwIDGf2EPU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/namespaces.c    |    3 +++
 include/linux/proc_fs.h |    1 +
 kernel/utsname.c        |   39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index dcbd483..b017181 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -19,6 +19,9 @@ static const struct proc_ns_operations *ns_entries[] = {
 #ifdef CONFIG_NET_NS
 	&netns_operations,
 #endif
+#ifdef CONFIG_UTS_NS
+	&utsns_operations,
+#endif
 };
 
 static const struct file_operations ns_file_operations = {
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 62126ec..52aa89d 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -266,6 +266,7 @@ struct proc_ns_operations {
 	int (*install)(struct nsproxy *nsproxy, void *ns);
 };
 extern const struct proc_ns_operations netns_operations;
+extern const struct proc_ns_operations utsns_operations;
 
 union proc_op {
 	int (*proc_get_link)(struct inode *, struct path *);
diff --git a/kernel/utsname.c b/kernel/utsname.c
index 4464617..bff131b 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/user_namespace.h>
+#include <linux/proc_fs.h>
 
 static struct uts_namespace *create_uts_ns(void)
 {
@@ -79,3 +80,41 @@ void free_uts_ns(struct kref *kref)
 	put_user_ns(ns->user_ns);
 	kfree(ns);
 }
+
+static void *utsns_get(struct task_struct *task)
+{
+	struct uts_namespace *ns = NULL;
+	struct nsproxy *nsproxy;
+
+	rcu_read_lock();
+	nsproxy = task_nsproxy(task);
+	if (nsproxy) {
+		ns = nsproxy->uts_ns;
+		get_uts_ns(ns);
+	}
+	rcu_read_unlock();
+
+	return ns;
+}
+
+static void utsns_put(void *ns)
+{
+	put_uts_ns(ns);
+}
+
+static int utsns_install(struct nsproxy *nsproxy, void *ns)
+{
+	get_uts_ns(ns);
+	put_uts_ns(nsproxy->uts_ns);
+	nsproxy->uts_ns = ns;
+	return 0;
+}
+
+const struct proc_ns_operations utsns_operations = {
+	.name		= "uts",
+	.type		= CLONE_NEWUTS,
+	.get		= utsns_get,
+	.put		= utsns_put,
+	.install	= utsns_install,
+};
+
-- 
1.6.5.2.143.g8cc62

