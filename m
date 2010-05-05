Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934642Ab0EEAhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:37:06 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34746 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933808Ab0EEAhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:37:02 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>, <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue,  4 May 2010 17:36:45 -0700
Message-Id: <1273019809-16472-2-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1fx3hk6gw.fsf@fess.ebiederm.org>
References: <m1fx3hk6gw.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: gregkh@suse.de, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, eric.dumazet@gmail.com, bcrl@lhnet.ca, serue@us.ibm.com, netdev@vger.kernel.org, davem@davemloft.net, ebiederm@xmission.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 2/6] netns: Teach network device kobjects which namespace they are in.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
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
---
 include/linux/kobject.h |    1 +
 net/Kconfig             |    8 ++++++++
 net/core/net-sysfs.c    |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 0 deletions(-)

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
index 041c35e..265e33b 100644
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
index 099c753..1b98e36 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -13,7 +13,9 @@
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
 #include <linux/if_arp.h>
+#include <linux/nsproxy.h>
 #include <net/sock.h>
+#include <net/net_namespace.h>
 #include <linux/rtnetlink.h>
 #include <linux/wireless.h>
 #include <net/wext.h>
@@ -466,6 +468,37 @@ static struct attribute_group wireless_group = {
 };
 #endif
 
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
@@ -506,6 +539,13 @@ static void netdev_release(struct device *d)
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
@@ -515,6 +555,8 @@ static struct class net_class = {
 #ifdef CONFIG_HOTPLUG
 	.dev_uevent = netdev_uevent,
 #endif
+	.ns_type = &net_ns_type_operations,
+	.namespace = net_namespace,
 };
 
 /* Delete sysfs entries but hold kobject reference until after all
@@ -587,5 +629,9 @@ void netdev_initialize_kobject(struct net_device *net)
 
 int netdev_kobject_init(void)
 {
+	kobj_ns_type_register(&net_ns_type_operations);
+#ifdef CONFIG_SYSFS
+	register_pernet_subsys(&sysfs_net_ops);
+#endif
 	return class_register(&net_class);
 }
-- 
1.6.5.2.143.g8cc62

