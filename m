Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab1EGC0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 22:26:07 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35753 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab1EGCZ5 (ORCPT
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
Subject: [PATCH 3/7] ns proc: Add support for the network namespace.
Date: Fri,  6 May 2011 19:24:57 -0700
Message-Id: <1304735101-1824-3-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.1.217.g4e3aa
In-Reply-To: <1304735101-1824-1-git-send-email-ebiederm@xmission.com>
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
 <1304735101-1824-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18dpXItJkHg/EHMUN2cNBQam+mYld9F+wo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implementing file descriptors for the network namespace
is simple and straight forward.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/namespaces.c     |    3 +++
 include/linux/proc_fs.h  |    1 +
 net/core/net_namespace.c |   31 +++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 6ae9f07..dcbd483 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -16,6 +16,9 @@
 
 
 static const struct proc_ns_operations *ns_entries[] = {
+#ifdef CONFIG_NET_NS
+	&netns_operations,
+#endif
 };
 
 static const struct file_operations ns_file_operations = {
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index a6d2c6d..62126ec 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -265,6 +265,7 @@ struct proc_ns_operations {
 	void (*put)(void *ns);
 	int (*install)(struct nsproxy *nsproxy, void *ns);
 };
+extern const struct proc_ns_operations netns_operations;
 
 union proc_op {
 	int (*proc_get_link)(struct inode *, struct path *);
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 3f86026..bf7707e 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -573,3 +573,34 @@ void unregister_pernet_device(struct pernet_operations *ops)
 	mutex_unlock(&net_mutex);
 }
 EXPORT_SYMBOL_GPL(unregister_pernet_device);
+
+#ifdef CONFIG_NET_NS
+static void *netns_get(struct task_struct *task)
+{
+	struct net *net;
+	rcu_read_lock();
+	net = get_net(task->nsproxy->net_ns);
+	rcu_read_unlock();
+	return net;
+}
+
+static void netns_put(void *ns)
+{
+	put_net(ns);
+}
+
+static int netns_install(struct nsproxy *nsproxy, void *ns)
+{
+	put_net(nsproxy->net_ns);
+	nsproxy->net_ns = get_net(ns);
+	return 0;
+}
+
+const struct proc_ns_operations netns_operations = {
+	.name		= "net",
+	.type		= CLONE_NEWNET,
+	.get		= netns_get,
+	.put		= netns_put,
+	.install	= netns_install,
+};
+#endif
-- 
1.6.5.2.143.g8cc62

