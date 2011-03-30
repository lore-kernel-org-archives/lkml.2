Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965035Ab1C3VcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:32:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:26964 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965003Ab1C3VIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621238099"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: segoon@openwall.com, mjt@tls.msk.ru, davem@davemloft.net,
        kees.cook@canonical.com, jmorris@namei.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [182/275] net: don't allow CAP_NET_ADMIN to load non-netdev kernel modules
Message-Id: <20110330210705.571ED3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segoon@openwall.com>

commit 8909c9ad8ff03611c9c96c9a92656213e4bb495b upstream.

Since a8f80e8ff94ecba629542d9b4b5f5a8ee3eb565c any process with
CAP_NET_ADMIN may load any module from /lib/modules/.  This doesn't mean
that CAP_NET_ADMIN is a superset of CAP_SYS_MODULE as modules are
limited to /lib/modules/**.  However, CAP_NET_ADMIN capability shouldn't
allow anybody load any module not related to networking.

This patch restricts an ability of autoloading modules to netdev modules
with explicit aliases.  This fixes CVE-2011-1019.

Arnd Bergmann suggested to leave untouched the old pre-v2.6.32 behavior
of loading netdev modules by name (without any prefix) for processes
with CAP_SYS_MODULE to maintain the compatibility with network scripts
that use autoloading netdev modules by aliases like "eth0", "wlan0".

Currently there are only three users of the feature in the upstream
kernel: ipip, ip_gre and sit.

    root@albatros:~# capsh --drop=$(seq -s, 0 11),$(seq -s, 13 34) --
    root@albatros:~# grep Cap /proc/$$/status
    CapInh:	0000000000000000
    CapPrm:	fffffff800001000
    CapEff:	fffffff800001000
    CapBnd:	fffffff800001000
    root@albatros:~# modprobe xfs
    FATAL: Error inserting xfs
    (/lib/modules/2.6.38-rc6-00001-g2bf4ca3/kernel/fs/xfs/xfs.ko): Operation not permitted
    root@albatros:~# lsmod | grep xfs
    root@albatros:~# ifconfig xfs
    xfs: error fetching interface information: Device not found
    root@albatros:~# lsmod | grep xfs
    root@albatros:~# lsmod | grep sit
    root@albatros:~# ifconfig sit
    sit: error fetching interface information: Device not found
    root@albatros:~# lsmod | grep sit
    root@albatros:~# ifconfig sit0
    sit0      Link encap:IPv6-in-IPv4
	      NOARP  MTU:1480  Metric:1

    root@albatros:~# lsmod | grep sit
    sit                    10457  0
    tunnel4                 2957  1 sit

For CAP_SYS_MODULE module loading is still relaxed:

    root@albatros:~# grep Cap /proc/$$/status
    CapInh:	0000000000000000
    CapPrm:	ffffffffffffffff
    CapEff:	ffffffffffffffff
    CapBnd:	ffffffffffffffff
    root@albatros:~# ifconfig xfs
    xfs: error fetching interface information: Device not found
    root@albatros:~# lsmod | grep xfs
    xfs                   745319  0

Reference: https://lkml.org/lkml/2011/2/24/203

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Michael Tokarev <mjt@tls.msk.ru>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Kees Cook <kees.cook@canonical.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/netdevice.h |    4 ++++
 net/core/dev.c            |   13 ++++++++++---
 net/ipv4/ip_gre.c         |    1 +
 net/ipv4/ipip.c           |    1 +
 net/ipv6/sit.c            |    2 +-
 5 files changed, 17 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/include/linux/netdevice.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/netdevice.h	2011-03-29 22:50:49.747985492 -0700
+++ linux-2.6.35.y/include/linux/netdevice.h	2011-03-29 23:03:02.015248604 -0700
@@ -2344,6 +2344,10 @@
 })
 #endif
 
+#define MODULE_ALIAS_NETDEV(device) \
+	MODULE_ALIAS("netdev-" device)
+
+
 #endif /* __KERNEL__ */
 
 #endif	/* _LINUX_NETDEVICE_H */
Index: linux-2.6.35.y/net/core/dev.c
===================================================================
--- linux-2.6.35.y.orig/net/core/dev.c	2011-03-29 22:50:49.746985518 -0700
+++ linux-2.6.35.y/net/core/dev.c	2011-03-29 23:03:02.017248554 -0700
@@ -1121,13 +1121,20 @@
 void dev_load(struct net *net, const char *name)
 {
 	struct net_device *dev;
+	int no_module;
 
 	rcu_read_lock();
 	dev = dev_get_by_name_rcu(net, name);
 	rcu_read_unlock();
-
-	if (!dev && capable(CAP_NET_ADMIN))
-		request_module("%s", name);
+	no_module = !dev;
+	if (no_module && capable(CAP_NET_ADMIN))
+		no_module = request_module("netdev-%s", name);
+	if (no_module && capable(CAP_SYS_MODULE)) {
+		if (!request_module("%s", name))
+			pr_err("Loading kernel module for a network device "
+"with CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias netdev-%s "
+"instead\n", name);
+	}
 }
 EXPORT_SYMBOL(dev_load);
 
Index: linux-2.6.35.y/net/ipv4/ip_gre.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv4/ip_gre.c	2011-03-29 22:50:49.747985492 -0700
+++ linux-2.6.35.y/net/ipv4/ip_gre.c	2011-03-29 23:03:02.019248504 -0700
@@ -1701,3 +1701,4 @@
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_RTNL_LINK("gre");
 MODULE_ALIAS_RTNL_LINK("gretap");
+MODULE_ALIAS_NETDEV("gre0");
Index: linux-2.6.35.y/net/ipv4/ipip.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv4/ipip.c	2011-03-29 22:50:49.747985492 -0700
+++ linux-2.6.35.y/net/ipv4/ipip.c	2011-03-29 23:03:02.021248452 -0700
@@ -850,3 +850,4 @@
 module_init(ipip_init);
 module_exit(ipip_fini);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_NETDEV("tunl0");
Index: linux-2.6.35.y/net/ipv6/sit.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv6/sit.c	2011-03-29 22:50:49.747985492 -0700
+++ linux-2.6.35.y/net/ipv6/sit.c	2011-03-29 23:03:02.040247960 -0700
@@ -1239,4 +1239,4 @@
 module_init(sit_init);
 module_exit(sit_cleanup);
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("sit0");
+MODULE_ALIAS_NETDEV("sit0");
