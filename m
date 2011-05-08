Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab1EHWyW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:54:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51704 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392Ab1EHWld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vYmq6y54+g/WWOa3t6+Bed3lp3UqxurPx9uioeQ8PLfwknF/IvitLxPUHecWPh7tXg
         Ru+JDH0tzeF8TxAa1D0i87e1Qa2qnU1wvJZXRIUKdwgI9GBXX00fgCmLUUkbidGwAKE3
         lKRZYk8+Mtjzq10G8gSMjBih1C1BUFEJMo7/8=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 056/115] sysctl: no-child: manually register kernel/random
Date: Mon,  9 May 2011 00:39:08 +0200
Message-Id: <1304894407-32201-57-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 drivers/char/random.c |   27 ++++++++++++++++++++++++++-
 kernel/sysctl.c       |    6 ------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d4ddeba..8893c4b 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -959,8 +959,15 @@ static void init_std_data(struct entropy_store *r)
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
 }
 
+static int __init register_random_sysctls(void);
+
 static int rand_initialize(void)
 {
+	int rc;
+	rc = register_random_sysctls();
+	if (!rc)
+		return rc;
+
 	init_std_data(&input_pool);
 	init_std_data(&blocking_pool);
 	init_std_data(&nonblocking_pool);
@@ -1250,7 +1257,7 @@ static int proc_do_uuid(ctl_table *table, int write,
 }
 
 static int sysctl_poolsize = INPUT_POOL_WORDS * 32;
-ctl_table random_table[] = {
+static struct ctl_table random_table[] = {
 	{
 		.procname	= "poolsize",
 		.data		= &sysctl_poolsize,
@@ -1298,6 +1305,24 @@ ctl_table random_table[] = {
 	},
 	{ }
 };
+
+static const __initdata struct ctl_path random_path[] = {
+	{ .procname = "kernel" },
+	{ .procname = "random" },
+	{ }
+};
+
+static struct ctl_table_header *random_header;
+
+static int __init register_random_sysctls(void)
+{
+	random_header = register_sysctl_paths(random_path, random_table);
+	if (!random_header)
+		return -ENOMEM;
+	return 0;
+}
+#else /* CONFIG_SYSCTL */
+static int __init register_random_sysctls(void) { return 0; }
 #endif 	/* CONFIG_SYSCTL */
 
 /********************************************************************
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 6167daa..b020156 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -216,7 +216,6 @@ static struct ctl_table vm_table[];
 static struct ctl_table fs_table[];
 static struct ctl_table debug_table[];
 static struct ctl_table dev_table[];
-extern struct ctl_table random_table[];
 #ifdef CONFIG_EPOLL
 extern struct ctl_table epoll_table[];
 #endif
@@ -611,11 +610,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
-		.procname	= "random",
-		.mode		= 0555,
-		.child		= random_table,
-	},
-	{
 		.procname	= "overflowuid",
 		.data		= &overflowuid,
 		.maxlen		= sizeof(int),
-- 
1.7.5.134.g1c08b

