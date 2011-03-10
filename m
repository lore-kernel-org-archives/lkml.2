Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1CJX7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:59:50 -0500
Received: from kroah.org ([198.145.64.141]:46890 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab1CJX51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:37 2011
Message-Id: <20110310235537.920405939@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <kees.cook@canonical.com>, James Morris <jmorris@namei.org>
Subject: [patch 19/29] net: dont allow CAP_NET_ADMIN to load non-netdev kernel modules
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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

---
 include/linux/netdevice.h |    3 +++
 net/core/dev.c            |   12 ++++++++++--
 net/ipv4/ip_gre.c         |    1 +
 net/ipv4/ipip.c           |    1 +
 net/ipv6/sit.c            |    2 +-
 5 files changed, 16 insertions(+), 3 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2336,6 +2336,9 @@ extern int netdev_notice(const struct ne
 extern int netdev_info(const struct net_device *dev, const char *format, ...)
 	__attribute__ ((format (printf, 2, 3)));
 
+#define MODULE_ALIAS_NETDEV(device) \
+	MODULE_ALIAS("netdev-" device)
+
 #if defined(DEBUG)
 #define netdev_dbg(__dev, format, args...)			\
 	netdev_printk(KERN_DEBUG, __dev, format, ##args)
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1116,13 +1116,21 @@ EXPORT_SYMBOL(netdev_bonding_change);
 void dev_load(struct net *net, const char *name)
 {
 	struct net_device *dev;
+	int no_module;
 
 	rcu_read_lock();
 	dev = dev_get_by_name_rcu(net, name);
 	rcu_read_unlock();
 
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
 
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1775,3 +1775,4 @@ module_exit(ipgre_fini);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_RTNL_LINK("gre");
 MODULE_ALIAS_RTNL_LINK("gretap");
+MODULE_ALIAS_NETDEV("gre0");
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -921,3 +921,4 @@ static void __exit ipip_fini(void)
 module_init(ipip_init);
 module_exit(ipip_fini);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_NETDEV("tunl0");
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1292,4 +1292,4 @@ static int __init sit_init(void)
 module_init(sit_init);
 module_exit(sit_cleanup);
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("sit0");
+MODULE_ALIAS_NETDEV("sit0");


