Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab1DBCyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 22:54:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32917 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab1DBCyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 22:54:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NI/CdujCrDq5wbvIZQtU0Dtm6iMYJqBOvF3wKPU15vgQ0dUmogjWLnab6LrUL1y+Yr
         eaq7FdeRkkYupRW+5bOJcqvcyMJQHeW73EhJwg850W5HlYlE6pBXq4Y2asKxXIg814xM
         TFRKbu57vKoLabKkDH5cz+6YV+i/BmE3PJlGs=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: "'David S . Miller'" <davem@davemloft.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Octavian Purdila <tavi@cs.pub.ro>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 11/24] sysctl: cookie: share acct_sysctl_table table between nets
Date: Sat,  2 Apr 2011 04:53:25 +0200
Message-Id: <b81c09907ec9c297413678d5f1f210a2fa144943.1301711868.git.lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.rc0
In-Reply-To: <cover.1301711868.git.lucian.grijincu@gmail.com>
References: <cover.1301711868.git.lucian.grijincu@gmail.com>
In-Reply-To: <cover.1301711868.git.lucian.grijincu@gmail.com>
References: <cover.1301711868.git.lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/netfilter/nf_conntrack_acct.c |   24 +++---------------------
 1 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index 5178c69..8f37d96 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -29,7 +29,7 @@ static struct ctl_table acct_sysctl_table[] = {
 		.data		= &init_net.ct.sysctl_acct,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= netns_proc_dointvec,
 	},
 	{}
 };
@@ -59,36 +59,18 @@ static struct nf_ct_ext_type acct_extend __read_mostly = {
 #ifdef CONFIG_SYSCTL
 static int nf_conntrack_acct_init_sysctl(struct net *net)
 {
-	struct ctl_table *table;
-
-	table = kmemdup(acct_sysctl_table, sizeof(acct_sysctl_table),
-			GFP_KERNEL);
-	if (!table)
-		goto out;
-
-	table[0].data = &net->ct.sysctl_acct;
-
 	net->ct.acct_sysctl_header = register_net_sysctl_table(net,
-			nf_net_netfilter_sysctl_path, table);
+			nf_net_netfilter_sysctl_path, acct_sysctl_table);
 	if (!net->ct.acct_sysctl_header) {
 		printk(KERN_ERR "nf_conntrack_acct: can't register to sysctl.\n");
-		goto out_register;
+		return -ENOMEM;
 	}
 	return 0;
-
-out_register:
-	kfree(table);
-out:
-	return -ENOMEM;
 }
 
 static void nf_conntrack_acct_fini_sysctl(struct net *net)
 {
-	struct ctl_table *table;
-
-	table = net->ct.acct_sysctl_header->ctl_table_arg;
 	unregister_net_sysctl_table(net->ct.acct_sysctl_header);
-	kfree(table);
 }
 #else
 static int nf_conntrack_acct_init_sysctl(struct net *net)
-- 
1.7.5.rc0

