Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab1DBC5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 22:57:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32917 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab1DBCyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 22:54:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UNI4j/SVkSzCcEO5wYqj5aG6zxmawvWt1NuqLmoHKZE28ZixAwo1mpo1dfn2ds060C
         TkAtrIv/WWs70IsoeR/8BQ7tQS3brcV/GYHbbjM8BzJO4rT4jfl0bEWLq+LjRb+YOaGf
         3JEM8yRsKiHpxq5WSut/vpqZBUUEl+BRN5qJc=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: "'David S . Miller'" <davem@davemloft.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Octavian Purdila <tavi@cs.pub.ro>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 14/24] sysctl: cookie: share unix_table between nets
Date: Sat,  2 Apr 2011 04:53:28 +0200
Message-Id: <08df352d32bf9a8f1ce37b6ccb5d4d610af21757.1301711868.git.lucian.grijincu@gmail.com>
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
 net/unix/sysctl_net_unix.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index 397cffe..d514f62 100644
--- a/net/unix/sysctl_net_unix.c
+++ b/net/unix/sysctl_net_unix.c
@@ -21,7 +21,7 @@ static ctl_table unix_table[] = {
 		.data		= &init_net.unx.sysctl_max_dgram_qlen,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= netns_proc_dointvec,
 	},
 	{ }
 };
@@ -34,30 +34,14 @@ static struct ctl_path unix_path[] = {
 
 int __net_init unix_sysctl_register(struct net *net)
 {
-	struct ctl_table *table;
-
-	table = kmemdup(unix_table, sizeof(unix_table), GFP_KERNEL);
-	if (table == NULL)
-		goto err_alloc;
-
-	table[0].data = &net->unx.sysctl_max_dgram_qlen;
-	net->unx.ctl = register_net_sysctl_table(net, unix_path, table);
+	net->unx.ctl = register_net_sysctl_table(net, unix_path, unix_table);
 	if (net->unx.ctl == NULL)
-		goto err_reg;
+		return -ENOMEM;
 
 	return 0;
-
-err_reg:
-	kfree(table);
-err_alloc:
-	return -ENOMEM;
 }
 
 void unix_sysctl_unregister(struct net *net)
 {
-	struct ctl_table *table;
-
-	table = net->unx.ctl->ctl_table_arg;
 	unregister_sysctl_table(net->unx.ctl);
-	kfree(table);
 }
-- 
1.7.5.rc0

