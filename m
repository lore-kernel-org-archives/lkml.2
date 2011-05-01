Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307Ab1EABjj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:39:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab1EABh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HXT9v2k36XF5QQv2VCFYryh1JBjC7eHSetGbZY1pF4Px7ZbVQmMsFKJoh4BF69QqGi
         y4llfPU1LZU6MqnqgEBHnDSydACwki0NrLCuI2WSppZqHymHxwxjl7fGVZI3qAbNqm8Z
         A0FiUqhNbcBMnnh6bd0Cw+ZnxjIaTn3iBuNoU=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 55/69] sysctl: no-child: manually register kernel/random
Date: Sun,  1 May 2011 03:36:25 +0200
Message-Id: <1304213799-10257-56-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
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
index b813724..a3f060c 100644
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

