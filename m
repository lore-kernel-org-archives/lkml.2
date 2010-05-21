Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934290Ab0EUQ5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:57:00 -0400
Received: from kroah.org ([198.145.64.141]:39172 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758255Ab0EUQyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 33/38] netns: Teach network device kobjects which namespace they are in.
Date: Fri, 21 May 2010 09:54:03 -0700
Message-Id: <1274460848-11377-33-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

The problem.  Network devices show up in sysfs and with the network
namespace active multiple devices with the same name can show up in
the same directory, ouch!

To avoid that problem and allow existing applications in network namespaces
to see the same interface that is currently presented in sysfs, this
patch enables the tagging directory support in sysfs.

By using the network namespace pointers as tags to separate out the
the sysfs directory entries we ensure that we don't have conflicts
in the directories and applications only see a limited set of
the network devices.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    1 +
 net/Kconfig             |    8 ++++++++
 net/core/net-sysfs.c    |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index b60d2df..cf343a8 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -142,6 +142,7 @@ extern const struct sysfs_ops kobj_sysfs_ops;
  */
 enum kobj_ns_type {
 	KOBJ_NS_TYPE_NONE = 0,
+	KOBJ_NS_TYPE_NET,
 	KOBJ_NS_TYPES
 };
 
diff --git a/net/Kconfig b/net/Kconfig
index 0d68b40..f495320 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -45,6 +45,14 @@ config COMPAT_NETLINK_MESSAGES
 
 menu "Networking options"
 
+config NET_NS
+	bool "Network namespace support"
+	default n
+	depends on EXPERIMENTAL && NAMESPACES
+	help
+	  Allow user space to create what appear to be multiple instances
+	  of the network stack.
+
 source "net/packet/Kconfig"
 source "net/unix/Kconfig"
 source "net/xfrm/Kconfig"
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index c57c4b2..b388cda 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -14,7 +14,9 @@
 #include <linux/netdevice.h>
 #include <linux/if_arp.h>
 #include <linux/slab.h>
+#include <linux/nsproxy.h>
 #include <net/sock.h>
+#include <net/net_namespace.h>
 #include <linux/rtnetlink.h>
 #include <linux/wireless.h>
 #include <linux/vmalloc.h>
@@ -766,6 +768,38 @@ static void rx_queue_remove_kobjects(struct net_device *net)
 	kset_unregister(net->queues_kset);
 }
 #endif /* CONFIG_RPS */
+
+static const void *net_current_ns(void)
+{
+	return current->nsproxy->net_ns;
+}
+
+static const void *net_initial_ns(void)
+{
+	return &init_net;
+}
+
+static const void *net_netlink_ns(struct sock *sk)
+{
+	return sock_net(sk);
+}
+
+static struct kobj_ns_type_operations net_ns_type_operations = {
+	.type = KOBJ_NS_TYPE_NET,
+	.current_ns = net_current_ns,
+	.netlink_ns = net_netlink_ns,
+	.initial_ns = net_initial_ns,
+};
+
+static void net_kobj_ns_exit(struct net *net)
+{
+	kobj_ns_exit(KOBJ_NS_TYPE_NET, net);
+}
+
+static struct pernet_operations sysfs_net_ops = {
+	.exit = net_kobj_ns_exit,
+};
+
 #endif /* CONFIG_SYSFS */
 
 #ifdef CONFIG_HOTPLUG
@@ -806,6 +840,13 @@ static void netdev_release(struct device *d)
 	kfree((char *)dev - dev->padded);
 }
 
+static const void *net_namespace(struct device *d)
+{
+	struct net_device *dev;
+	dev = container_of(d, struct net_device, dev);
+	return dev_net(dev);
+}
+
 static struct class net_class = {
 	.name = "net",
 	.dev_release = netdev_release,
@@ -815,6 +856,8 @@ static struct class net_class = {
 #ifdef CONFIG_HOTPLUG
 	.dev_uevent = netdev_uevent,
 #endif
+	.ns_type = &net_ns_type_operations,
+	.namespace = net_namespace,
 };
 
 /* Delete sysfs entries but hold kobject reference until after all
@@ -904,5 +947,9 @@ void netdev_initialize_kobject(struct net_device *net)
 
 int netdev_kobject_init(void)
 {
+	kobj_ns_type_register(&net_ns_type_operations);
+#ifdef CONFIG_SYSFS
+	register_pernet_subsys(&sysfs_net_ops);
+#endif
 	return class_register(&net_class);
 }
-- 
1.7.0.3

