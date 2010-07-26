Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab0GZJWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 05:22:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41047 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab0GZJWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 05:22:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GoMTIZumFM6X8wTiMlontgrJd3CGR2P6Ryfq45TkK3LdZvE+n2OCxHJQ8WrKrPjwAb
         qHz2FdL+2PhXWl9ywJJ2gmQdQOOJEeNOS5bIezvT+kkrxKxwIhOIpHeeNI7GusRc/SFS
         57AGhcE9KhxNOFVWTuSbDnBVGeYKtHF4ERCnI=
From: Changli Gao <xiaosuo@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] taskstats: use genl_register_family_with_ops()
Date: Mon, 26 Jul 2010 17:22:03 +0800
Message-Id: <1280136123-17605-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 kernel/taskstats.c |   37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 11281d5..d637a12 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -578,16 +578,17 @@ err:
 	nlmsg_free(rep_skb);
 }
 
-static struct genl_ops taskstats_ops = {
-	.cmd		= TASKSTATS_CMD_GET,
-	.doit		= taskstats_user_cmd,
-	.policy		= taskstats_cmd_get_policy,
-};
-
-static struct genl_ops cgroupstats_ops = {
-	.cmd		= CGROUPSTATS_CMD_GET,
-	.doit		= cgroupstats_user_cmd,
-	.policy		= cgroupstats_cmd_get_policy,
+static struct genl_ops taskstats_ops[] = {
+	{
+		.cmd		= TASKSTATS_CMD_GET,
+		.doit		= taskstats_user_cmd,
+		.policy		= taskstats_cmd_get_policy,
+	},
+	{
+		.cmd		= CGROUPSTATS_CMD_GET,
+		.doit		= cgroupstats_user_cmd,
+		.policy		= cgroupstats_cmd_get_policy,
+	},
 };
 
 /* Needed early in initialization */
@@ -606,26 +607,14 @@ static int __init taskstats_init(void)
 {
 	int rc;
 
-	rc = genl_register_family(&family);
+	rc = genl_register_family_with_ops(&family, taskstats_ops,
+					   ARRAY_SIZE(taskstats_ops));
 	if (rc)
 		return rc;
 
-	rc = genl_register_ops(&family, &taskstats_ops);
-	if (rc < 0)
-		goto err;
-
-	rc = genl_register_ops(&family, &cgroupstats_ops);
-	if (rc < 0)
-		goto err_cgroup_ops;
-
 	family_registered = 1;
 	printk("registered taskstats version %d\n", TASKSTATS_GENL_VERSION);
 	return 0;
-err_cgroup_ops:
-	genl_unregister_ops(&family, &taskstats_ops);
-err:
-	genl_unregister_family(&family);
-	return rc;
 }
 
 /*
