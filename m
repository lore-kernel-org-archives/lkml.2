Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab0EUQzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:55:13 -0400
Received: from kroah.org ([198.145.64.141]:39173 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934277Ab0EUQyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 34/38] net/sysfs: Fix the bitrot in network device kobject namespace support
Date: Fri, 21 May 2010 09:54:04 -0700
Message-Id: <1274460848-11377-34-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

I had a couple of stupid bugs in:
netns: Teach network device kobjects which namespace they are in.

- I duplicated the Kconfig for the NET_NS
- The build was broken when sysfs was not compiled in

The sysfs breakage is because after I moved the operations
for the sysfs to the kobject layer, to make things cleaner
I forgot to move the ifdefs.  Opps.

I'm not quite certain how I got introduced a second NET_NS Kconfig,
but it was probably a 3 way merge somewhere along the way that
did not notice that the NET_NS Kconfig option had mvoed and thout
that was a bug.  It probably slipped in because it used to be the
sysfs patches were the first patches in my network namespace patches.
Some things just don't go like you would expect.

Neither of these bugs actually affect anything in the common case
but they should be fixed.

Thanks to Serge for noticing they were present.

Reported-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Acked-by: David S. Miller <davem@davemloft.net>
---
 net/Kconfig          |    8 --------
 net/core/net-sysfs.c |    8 +++-----
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/net/Kconfig b/net/Kconfig
index f495320..0d68b40 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -45,14 +45,6 @@ config COMPAT_NETLINK_MESSAGES
 
 menu "Networking options"
 
-config NET_NS
-	bool "Network namespace support"
-	default n
-	depends on EXPERIMENTAL && NAMESPACES
-	help
-	  Allow user space to create what appear to be multiple instances
-	  of the network stack.
-
 source "net/packet/Kconfig"
 source "net/unix/Kconfig"
 source "net/xfrm/Kconfig"
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index b388cda..6881e65 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -469,6 +469,7 @@ static struct attribute_group wireless_group = {
 	.attrs = wireless_attrs,
 };
 #endif
+#endif /* CONFIG_SYSFS */
 
 #ifdef CONFIG_RPS
 /*
@@ -796,11 +797,10 @@ static void net_kobj_ns_exit(struct net *net)
 	kobj_ns_exit(KOBJ_NS_TYPE_NET, net);
 }
 
-static struct pernet_operations sysfs_net_ops = {
+static struct pernet_operations kobj_net_ops = {
 	.exit = net_kobj_ns_exit,
 };
 
-#endif /* CONFIG_SYSFS */
 
 #ifdef CONFIG_HOTPLUG
 static int netdev_uevent(struct device *d, struct kobj_uevent_env *env)
@@ -948,8 +948,6 @@ void netdev_initialize_kobject(struct net_device *net)
 int netdev_kobject_init(void)
 {
 	kobj_ns_type_register(&net_ns_type_operations);
-#ifdef CONFIG_SYSFS
-	register_pernet_subsys(&sysfs_net_ops);
-#endif
+	register_pernet_subsys(&kobj_net_ops);
 	return class_register(&net_class);
 }
-- 
1.7.0.3

