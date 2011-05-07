Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1EGC1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 22:27:54 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35766 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab1EGCZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 22:25:58 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-arch@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, jamal <hadi@cyberus.ca>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 6/7] net: Allow setting the network namespace by fd
Date: Fri,  6 May 2011 19:25:00 -0700
Message-Id: <1304735101-1824-6-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.1.217.g4e3aa
In-Reply-To: <1304735101-1824-1-git-send-email-ebiederm@xmission.com>
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
 <1304735101-1824-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19iu8crrUgSFKVvVjGEQEsVYJM9YetmqVk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take advantage of the new abstraction and allow network devices
to be placed in any network namespace that we have a fd to talk
about.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/if_link.h     |    1 +
 include/net/net_namespace.h |    1 +
 net/core/net_namespace.c    |   33 +++++++++++++++++++++++++++++++--
 net/core/rtnetlink.c        |    5 ++++-
 4 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/include/linux/if_link.h b/include/linux/if_link.h
index f4a2e6b..0ee969a 100644
--- a/include/linux/if_link.h
+++ b/include/linux/if_link.h
@@ -136,6 +136,7 @@ enum {
 	IFLA_PORT_SELF,
 	IFLA_AF_SPEC,
 	IFLA_GROUP,		/* Group the device belongs to */
+	IFLA_NET_NS_FD,
 	__IFLA_MAX
 };
 
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 3ae4919..dcc8f57 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -119,6 +119,7 @@ static inline struct net *copy_net_ns(unsigned long flags, struct net *net_ns)
 extern struct list_head net_namespace_list;
 
 extern struct net *get_net_ns_by_pid(pid_t pid);
+extern struct net *get_net_ns_by_fd(int pid);
 
 #ifdef CONFIG_NET_NS
 extern void __put_net(struct net *net);
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index bf7707e..b7403ff 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -8,6 +8,8 @@
 #include <linux/idr.h>
 #include <linux/rculist.h>
 #include <linux/nsproxy.h>
+#include <linux/proc_fs.h>
+#include <linux/file.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 
@@ -343,6 +345,28 @@ struct net *get_net_ns_by_pid(pid_t pid)
 }
 EXPORT_SYMBOL_GPL(get_net_ns_by_pid);
 
+struct net *get_net_ns_by_fd(int fd)
+{
+	struct proc_inode *ei;
+	struct file *file;
+	struct net *net;
+
+	net = ERR_PTR(-EINVAL);
+	file = proc_ns_fget(fd);
+	if (!file)
+		goto out;
+
+	ei = PROC_I(file->f_dentry->d_inode);
+	if (ei->ns_ops != &netns_operations)
+		goto out;
+
+	net = get_net(ei->ns);
+out:
+	if (file)
+		fput(file);
+	return net;
+}
+
 static int __init net_ns_init(void)
 {
 	struct net_generic *ng;
@@ -577,10 +601,15 @@ EXPORT_SYMBOL_GPL(unregister_pernet_device);
 #ifdef CONFIG_NET_NS
 static void *netns_get(struct task_struct *task)
 {
-	struct net *net;
+	struct net *net = NULL;
+	struct nsproxy *nsproxy;
+
 	rcu_read_lock();
-	net = get_net(task->nsproxy->net_ns);
+	nsproxy = task_nsproxy(task);
+	if (nsproxy)
+		net = get_net(nsproxy->net_ns);
 	rcu_read_unlock();
+
 	return net;
 }
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index d7c4bb4..dca9602 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1043,6 +1043,7 @@ const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_LINKMODE]		= { .type = NLA_U8 },
 	[IFLA_LINKINFO]		= { .type = NLA_NESTED },
 	[IFLA_NET_NS_PID]	= { .type = NLA_U32 },
+	[IFLA_NET_NS_FD]	= { .type = NLA_U32 },
 	[IFLA_IFALIAS]	        = { .type = NLA_STRING, .len = IFALIASZ-1 },
 	[IFLA_VFINFO_LIST]	= {. type = NLA_NESTED },
 	[IFLA_VF_PORTS]		= { .type = NLA_NESTED },
@@ -1091,6 +1092,8 @@ struct net *rtnl_link_get_net(struct net *src_net, struct nlattr *tb[])
 	 */
 	if (tb[IFLA_NET_NS_PID])
 		net = get_net_ns_by_pid(nla_get_u32(tb[IFLA_NET_NS_PID]));
+	else if (tb[IFLA_NET_NS_FD])
+		net = get_net_ns_by_fd(nla_get_u32(tb[IFLA_NET_NS_FD]));
 	else
 		net = get_net(src_net);
 	return net;
@@ -1221,7 +1224,7 @@ static int do_setlink(struct net_device *dev, struct ifinfomsg *ifm,
 	int send_addr_notify = 0;
 	int err;
 
-	if (tb[IFLA_NET_NS_PID]) {
+	if (tb[IFLA_NET_NS_PID] || tb[IFLA_NET_NS_FD]) {
 		struct net *net = rtnl_link_get_net(dev_net(dev), tb);
 		if (IS_ERR(net)) {
 			err = PTR_ERR(net);
-- 
1.6.5.2.143.g8cc62

