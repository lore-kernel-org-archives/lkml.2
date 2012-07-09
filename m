Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab2GIOo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:44:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38232 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754435Ab2GIOiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:15 -0400
Message-Id: <20120709143122.271968053@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Graf <tgraf@suug.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 39/48] ipv6: Move ipv6 proc file registration to end of init  order
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Graf <tgraf@suug.ch>

[ Upstream commit d189634ecab947c10f6f832258b103d0bbfe73cc ]

/proc/net/ipv6_route reflects the contents of fib_table_hash. The proc
handler is installed in ip6_route_net_init() whereas fib_table_hash is
allocated in fib6_net_init() _after_ the proc handler has been installed.

This opens up a short time frame to access fib_table_hash with its pants
down.

Move the registration of the proc files to a later point in the init
order to avoid the race.

Tested :-)

Signed-off-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/route.c |   41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 059b9d9..2e21751 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2881,10 +2881,6 @@ static int __net_init ip6_route_net_init(struct net *net)
 	net->ipv6.sysctl.ip6_rt_mtu_expires = 10*60*HZ;
 	net->ipv6.sysctl.ip6_rt_min_advmss = IPV6_MIN_MTU - 20 - 40;
 
-#ifdef CONFIG_PROC_FS
-	proc_net_fops_create(net, "ipv6_route", 0, &ipv6_route_proc_fops);
-	proc_net_fops_create(net, "rt6_stats", S_IRUGO, &rt6_stats_seq_fops);
-#endif
 	net->ipv6.ip6_rt_gc_expire = 30*HZ;
 
 	ret = 0;
@@ -2905,10 +2901,6 @@ out_ip6_dst_ops:
 
 static void __net_exit ip6_route_net_exit(struct net *net)
 {
-#ifdef CONFIG_PROC_FS
-	proc_net_remove(net, "ipv6_route");
-	proc_net_remove(net, "rt6_stats");
-#endif
 	kfree(net->ipv6.ip6_null_entry);
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
 	kfree(net->ipv6.ip6_prohibit_entry);
@@ -2917,11 +2909,33 @@ static void __net_exit ip6_route_net_exit(struct net *net)
 	dst_entries_destroy(&net->ipv6.ip6_dst_ops);
 }
 
+static int __net_init ip6_route_net_init_late(struct net *net)
+{
+#ifdef CONFIG_PROC_FS
+	proc_net_fops_create(net, "ipv6_route", 0, &ipv6_route_proc_fops);
+	proc_net_fops_create(net, "rt6_stats", S_IRUGO, &rt6_stats_seq_fops);
+#endif
+	return 0;
+}
+
+static void __net_exit ip6_route_net_exit_late(struct net *net)
+{
+#ifdef CONFIG_PROC_FS
+	proc_net_remove(net, "ipv6_route");
+	proc_net_remove(net, "rt6_stats");
+#endif
+}
+
 static struct pernet_operations ip6_route_net_ops = {
 	.init = ip6_route_net_init,
 	.exit = ip6_route_net_exit,
 };
 
+static struct pernet_operations ip6_route_net_late_ops = {
+	.init = ip6_route_net_init_late,
+	.exit = ip6_route_net_exit_late,
+};
+
 static struct notifier_block ip6_route_dev_notifier = {
 	.notifier_call = ip6_route_dev_notify,
 	.priority = 0,
@@ -2971,19 +2985,25 @@ int __init ip6_route_init(void)
 	if (ret)
 		goto xfrm6_init;
 
+	ret = register_pernet_subsys(&ip6_route_net_late_ops);
+	if (ret)
+		goto fib6_rules_init;
+
 	ret = -ENOBUFS;
 	if (__rtnl_register(PF_INET6, RTM_NEWROUTE, inet6_rtm_newroute, NULL, NULL) ||
 	    __rtnl_register(PF_INET6, RTM_DELROUTE, inet6_rtm_delroute, NULL, NULL) ||
 	    __rtnl_register(PF_INET6, RTM_GETROUTE, inet6_rtm_getroute, NULL, NULL))
-		goto fib6_rules_init;
+		goto out_register_late_subsys;
 
 	ret = register_netdevice_notifier(&ip6_route_dev_notifier);
 	if (ret)
-		goto fib6_rules_init;
+		goto out_register_late_subsys;
 
 out:
 	return ret;
 
+out_register_late_subsys:
+	unregister_pernet_subsys(&ip6_route_net_late_ops);
 fib6_rules_init:
 	fib6_rules_cleanup();
 xfrm6_init:
@@ -3002,6 +3022,7 @@ out_kmem_cache:
 void ip6_route_cleanup(void)
 {
 	unregister_netdevice_notifier(&ip6_route_dev_notifier);
+	unregister_pernet_subsys(&ip6_route_net_late_ops);
 	fib6_rules_cleanup();
 	xfrm6_fini();
 	fib6_gc_cleanup();


