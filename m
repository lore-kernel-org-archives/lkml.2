Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340Ab0EUQ52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:57:28 -0400
Received: from kroah.org ([198.145.64.141]:39170 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934271Ab0EUQyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:37 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 32/38] kobject: Send hotplug events in all network namespaces
Date: Fri, 21 May 2010 09:54:02 -0700
Message-Id: <1274460848-11377-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Open a copy of the uevent kernel socket in each network
namespace so we can send uevents in all network namespaces.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject_uevent.c |   68 ++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 7b48d44..9084f25 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -24,13 +24,19 @@
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
 #include <net/sock.h>
+#include <net/net_namespace.h>
 
 
 u64 uevent_seqnum;
 char uevent_helper[UEVENT_HELPER_PATH_LEN] = CONFIG_UEVENT_HELPER_PATH;
 static DEFINE_SPINLOCK(sequence_lock);
-#if defined(CONFIG_NET)
-static struct sock *uevent_sock;
+#ifdef CONFIG_NET
+struct uevent_sock {
+	struct list_head list;
+	struct sock *sk;
+};
+static LIST_HEAD(uevent_sock_list);
+static DEFINE_MUTEX(uevent_sock_mutex);
 #endif
 
 /* the strings here must match the enum in include/linux/kobject.h */
@@ -100,6 +106,9 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	u64 seq;
 	int i = 0;
 	int retval = 0;
+#ifdef CONFIG_NET
+	struct uevent_sock *ue_sk;
+#endif
 
 	pr_debug("kobject: '%s' (%p): %s\n",
 		 kobject_name(kobj), kobj, __func__);
@@ -211,7 +220,9 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 
 #if defined(CONFIG_NET)
 	/* send netlink message */
-	if (uevent_sock) {
+	mutex_lock(&uevent_sock_mutex);
+	list_for_each_entry(ue_sk, &uevent_sock_list, list) {
+		struct sock *uevent_sock = ue_sk->sk;
 		struct sk_buff *skb;
 		size_t len;
 
@@ -241,6 +252,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 		} else
 			retval = -ENOMEM;
 	}
+	mutex_unlock(&uevent_sock_mutex);
 #endif
 
 	/* call uevent_helper, usually only enabled during early boot */
@@ -320,18 +332,58 @@ int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
 EXPORT_SYMBOL_GPL(add_uevent_var);
 
 #if defined(CONFIG_NET)
-static int __init kobject_uevent_init(void)
+static int uevent_net_init(struct net *net)
 {
-	uevent_sock = netlink_kernel_create(&init_net, NETLINK_KOBJECT_UEVENT,
-					    1, NULL, NULL, THIS_MODULE);
-	if (!uevent_sock) {
+	struct uevent_sock *ue_sk;
+
+	ue_sk = kzalloc(sizeof(*ue_sk), GFP_KERNEL);
+	if (!ue_sk)
+		return -ENOMEM;
+
+	ue_sk->sk = netlink_kernel_create(net, NETLINK_KOBJECT_UEVENT,
+					  1, NULL, NULL, THIS_MODULE);
+	if (!ue_sk->sk) {
 		printk(KERN_ERR
 		       "kobject_uevent: unable to create netlink socket!\n");
 		return -ENODEV;
 	}
-	netlink_set_nonroot(NETLINK_KOBJECT_UEVENT, NL_NONROOT_RECV);
+	mutex_lock(&uevent_sock_mutex);
+	list_add_tail(&ue_sk->list, &uevent_sock_list);
+	mutex_unlock(&uevent_sock_mutex);
 	return 0;
 }
 
+static void uevent_net_exit(struct net *net)
+{
+	struct uevent_sock *ue_sk;
+
+	mutex_lock(&uevent_sock_mutex);
+	list_for_each_entry(ue_sk, &uevent_sock_list, list) {
+		if (sock_net(ue_sk->sk) == net)
+			goto found;
+	}
+	mutex_unlock(&uevent_sock_mutex);
+	return;
+
+found:
+	list_del(&ue_sk->list);
+	mutex_unlock(&uevent_sock_mutex);
+
+	netlink_kernel_release(ue_sk->sk);
+	kfree(ue_sk);
+}
+
+static struct pernet_operations uevent_net_ops = {
+	.init	= uevent_net_init,
+	.exit	= uevent_net_exit,
+};
+
+static int __init kobject_uevent_init(void)
+{
+	netlink_set_nonroot(NETLINK_KOBJECT_UEVENT, NL_NONROOT_RECV);
+	return register_pernet_subsys(&uevent_net_ops);
+}
+
+
 postcore_initcall(kobject_uevent_init);
 #endif
-- 
1.7.0.3

