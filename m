Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab1BYSx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:53:27 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36182 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595Ab1BYSxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:53:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YDFi1/FV0If371aoM/iJf1M6/HYdTIhcVeVqKdw1mPA/avEZnlYxJOTTwWVQodz7o0
         1eORX68IZUR4do6ZFVgPjuWO6o8bT2kMEJH2Xn7eDm0TikIiPSR74nZ4wJYeNym4PRYf
         0S9f8YBm9Zw+glz7+CraBYCVtD+ulm3HLTgYk=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Octavian Purdila <tavi@cs.pub.ro>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 8/9] sysctl: ipv6: share ip6_frags_ns_ctl_table between nets
Date: Fri, 25 Feb 2011 20:52:40 +0200
Message-Id: <1298659961-23863-9-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.4.rc1.7.g2cf08.dirty
In-Reply-To: <1298659961-23863-1-git-send-email-lucian.grijincu@gmail.com>
References: <1298659961-23863-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/ipv6/reassembly.c |   34 ++++++----------------------------
 1 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 07beeb0..868cbd5 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -600,21 +600,21 @@ static struct ctl_table ip6_frags_ns_ctl_table[] = {
 		.data		= &init_net.ipv6.frags.high_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= (proc_handler *) netns_proc_dointvec,
 	},
 	{
 		.procname	= "ip6frag_low_thresh",
 		.data		= &init_net.ipv6.frags.low_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= (proc_handler *) netns_proc_dointvec,
 	},
 	{
 		.procname	= "ip6frag_time",
 		.data		= &init_net.ipv6.frags.timeout,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
+		.proc_handler	= (proc_handler *) netns_proc_dointvec_jiffies,
 	},
 	{ }
 };
@@ -632,42 +632,20 @@ static struct ctl_table ip6_frags_ctl_table[] = {
 
 static int __net_init ip6_frags_ns_sysctl_register(struct net *net)
 {
-	struct ctl_table *table;
 	struct ctl_table_header *hdr;
 
-	table = ip6_frags_ns_ctl_table;
-	if (!net_eq(net, &init_net)) {
-		table = kmemdup(table, sizeof(ip6_frags_ns_ctl_table), GFP_KERNEL);
-		if (table == NULL)
-			goto err_alloc;
-
-		table[0].data = &net->ipv6.frags.high_thresh;
-		table[1].data = &net->ipv6.frags.low_thresh;
-		table[2].data = &net->ipv6.frags.timeout;
-	}
-
-	hdr = register_net_sysctl_table(net, net_ipv6_ctl_path, table);
+	hdr = register_net_sysctl_table(net, net_ipv6_ctl_path,
+					ip6_frags_ns_ctl_table);
 	if (hdr == NULL)
-		goto err_reg;
+		return -ENOMEM;
 
 	net->ipv6.sysctl.frags_hdr = hdr;
 	return 0;
-
-err_reg:
-	if (!net_eq(net, &init_net))
-		kfree(table);
-err_alloc:
-	return -ENOMEM;
 }
 
 static void __net_exit ip6_frags_ns_sysctl_unregister(struct net *net)
 {
-	struct ctl_table *table;
-
-	table = net->ipv6.sysctl.frags_hdr->ctl_table_arg;
 	unregister_net_sysctl_table(net->ipv6.sysctl.frags_hdr);
-	if (!net_eq(net, &init_net))
-		kfree(table);
 }
 
 static struct ctl_table_header *ip6_ctl_header;
-- 
1.7.4.rc1.7.g2cf08.dirty

