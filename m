Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab1EABqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:46:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61911 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab1EABhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tt6TA/3BJVfhlf1XzrFZ3bR/pWE/U+VODCCrAFWJzisTDKtX8rWVDDUCgEGoCmacTe
         eDXwGIgi/TPxtI1+NvKTGN4SSeco4cuOflbzdgKPWIsAry8bsyyKSDkwoSoeDwHatqNP
         TMjf3durnE0KI6G2PA4MPEVVW4fdhQmYKNdqE=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 53/69] sysctl: remove .child from net/ipv6/route, net/ipv6/icmp, net/ipv6 tables
Date: Sun,  1 May 2011 03:36:23 +0200
Message-Id: <1304213799-10257-54-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 include/net/netns/ipv6.h   |    4 +-
 net/ipv6/sysctl_net_ipv6.c |  101 +++++++++++++++++++++++++-------------------
 2 files changed, 60 insertions(+), 45 deletions(-)

diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 81abfcb..2d9c6f1 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -12,7 +12,9 @@ struct ctl_table_header;
 
 struct netns_sysctl_ipv6 {
 #ifdef CONFIG_SYSCTL
-	struct ctl_table_header *table;
+	struct ctl_table_header *bindv6only_hdr;
+	struct ctl_table_header *route6_hdr;
+	struct ctl_table_header *icmp6_hdr;
 	struct ctl_table_header *frags_hdr;
 #endif
 	int bindv6only;
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index a0d9916..1d2d8c7 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -17,19 +17,7 @@
 
 static struct ctl_table empty[1];
 
-static ctl_table ipv6_table_template[] = {
-	{
-		.procname	= "route",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= ipv6_route_table_template
-	},
-	{
-		.procname	= "icmp",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= ipv6_icmp_table_template
-	},
+static ctl_table ipv6_bindv6only_template[] = {
 	{
 		.procname	= "bindv6only",
 		.data		= &init_net.ipv6.sysctl.bindv6only,
@@ -58,64 +46,89 @@ struct ctl_path net_ipv6_ctl_path[] = {
 };
 EXPORT_SYMBOL_GPL(net_ipv6_ctl_path);
 
+static const struct ctl_path net_ipv6_route_path[] = {
+	{ .procname = "net", },
+	{ .procname = "ipv6", },
+	{ .procname = "route", },
+	{ },
+};
+
+static const struct ctl_path net_ipv6_icmp_path[] = {
+	{ .procname = "net", },
+	{ .procname = "ipv6", },
+	{ .procname = "icmp", },
+	{ },
+};
+
 static int __net_init ipv6_sysctl_net_init(struct net *net)
 {
-	struct ctl_table *ipv6_table;
+	struct ctl_table *ipv6_bindv6only_table;
 	struct ctl_table *ipv6_route_table;
 	struct ctl_table *ipv6_icmp_table;
-	int err;
 
-	err = -ENOMEM;
-	ipv6_table = kmemdup(ipv6_table_template, sizeof(ipv6_table_template),
-			     GFP_KERNEL);
-	if (!ipv6_table)
-		goto out;
+	ipv6_bindv6only_table = kmemdup(ipv6_bindv6only_template,
+					sizeof(ipv6_bindv6only_template), GFP_KERNEL);
+	if (!ipv6_bindv6only_table)
+		goto fail_alloc_ipv6_bindv6only_table;
+	ipv6_bindv6only_table[0].data = &net->ipv6.sysctl.bindv6only;
 
 	ipv6_route_table = ipv6_route_sysctl_init(net);
 	if (!ipv6_route_table)
-		goto out_ipv6_table;
-	ipv6_table[0].child = ipv6_route_table;
+		goto fail_alloc_ipv6_route_table;
 
 	ipv6_icmp_table = ipv6_icmp_sysctl_init(net);
 	if (!ipv6_icmp_table)
-		goto out_ipv6_route_table;
-	ipv6_table[1].child = ipv6_icmp_table;
+		goto fail_alloc_ipv6_icmp_table;
 
-	ipv6_table[2].data = &net->ipv6.sysctl.bindv6only;
 
-	net->ipv6.sysctl.table = register_net_sysctl_table(net, net_ipv6_ctl_path,
-							   ipv6_table);
-	if (!net->ipv6.sysctl.table)
-		goto out_ipv6_icmp_table;
+	net->ipv6.sysctl.bindv6only_hdr = register_net_sysctl_table(
+		net, net_ipv6_ctl_path, ipv6_bindv6only_table);
+	if (!net->ipv6.sysctl.bindv6only_hdr)
+		goto fail_reg_bindv6only_hdr;
 
-	err = 0;
-out:
-	return err;
+	net->ipv6.sysctl.route6_hdr = register_net_sysctl_table(
+		net, net_ipv6_route_path, ipv6_route_table);
+	if (!net->ipv6.sysctl.route6_hdr)
+		goto fail_reg_route6_hdr;
+
+	net->ipv6.sysctl.icmp6_hdr = register_net_sysctl_table(
+		net, net_ipv6_icmp_path, ipv6_icmp_table);
+	if (!net->ipv6.sysctl.icmp6_hdr)
+		goto fail_reg_icmp6_hdr;
 
-out_ipv6_icmp_table:
+	return 0;
+
+fail_reg_icmp6_hdr:
+	unregister_net_sysctl_table(net->ipv6.sysctl.route6_hdr);
+fail_reg_route6_hdr:
+	unregister_net_sysctl_table(net->ipv6.sysctl.bindv6only_hdr);
+fail_reg_bindv6only_hdr:
 	kfree(ipv6_icmp_table);
-out_ipv6_route_table:
+fail_alloc_ipv6_icmp_table:
 	kfree(ipv6_route_table);
-out_ipv6_table:
-	kfree(ipv6_table);
-	goto out;
+fail_alloc_ipv6_route_table:
+	kfree(ipv6_bindv6only_table);
+fail_alloc_ipv6_bindv6only_table:
+	return -ENOMEM;
 }
 
 static void __net_exit ipv6_sysctl_net_exit(struct net *net)
 {
-	struct ctl_table *ipv6_table;
+	struct ctl_table *ipv6_bindv6only_table;
 	struct ctl_table *ipv6_route_table;
 	struct ctl_table *ipv6_icmp_table;
 
-	ipv6_table = net->ipv6.sysctl.table->ctl_table_arg;
-	ipv6_route_table = ipv6_table[0].child;
-	ipv6_icmp_table = ipv6_table[1].child;
+	ipv6_bindv6only_table = net->ipv6.sysctl.bindv6only_hdr->ctl_table_arg;
+	ipv6_route_table = net->ipv6.sysctl.route6_hdr->ctl_table_arg;
+	ipv6_icmp_table = net->ipv6.sysctl.icmp6_hdr->ctl_table_arg;
 
-	unregister_net_sysctl_table(net->ipv6.sysctl.table);
+	unregister_net_sysctl_table(net->ipv6.sysctl.icmp6_hdr);
+	unregister_net_sysctl_table(net->ipv6.sysctl.route6_hdr);
+	unregister_net_sysctl_table(net->ipv6.sysctl.bindv6only_hdr);
 
-	kfree(ipv6_table);
-	kfree(ipv6_route_table);
 	kfree(ipv6_icmp_table);
+	kfree(ipv6_route_table);
+	kfree(ipv6_bindv6only_table);
 }
 
 static struct pernet_operations ipv6_sysctl_net_ops = {
-- 
1.7.5.134.g1c08b

