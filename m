Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab1EABpr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:45:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49864 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264Ab1EABh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SMnpe8TMUkbnKvXaN6CcQX04P1ZJ4Z7bqhfOCEznkR/z7nmDg5MmDmn0QjHhBVN49k
         p7j3w368AGLB9LDR/YNAvVHlDjGpwkobnjkENXPVrW/w/8ikCPKH9w+EI9FQqQ9zZdHO
         mzF2Ar2lcYXvaQxLctwZUMhF3X3TYJb1Yt48c=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 59/69] sysctl: no-child: manually register root tables
Date: Sun,  1 May 2011 03:36:29 +0200
Message-Id: <1304213799-10257-60-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 kernel/sysctl.c |  121 +++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 83 insertions(+), 38 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ca89653..d44c280 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -211,12 +211,6 @@ static struct ctl_table_root sysctl_table_root = {
 	.default_set.list = LIST_HEAD_INIT(root_table_header.ctl_entry),
 };
 
-static struct ctl_table kern_table[];
-static struct ctl_table vm_table[];
-static struct ctl_table fs_table[];
-static struct ctl_table debug_table[];
-static struct ctl_table dev_table[];
-
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
 int sysctl_legacy_va_layout;
 #endif
@@ -224,31 +218,6 @@ int sysctl_legacy_va_layout;
 /* The default sysctl tables: */
 
 static struct ctl_table root_table[] = {
-	{
-		.procname	= "kernel",
-		.mode		= 0555,
-		.child		= kern_table,
-	},
-	{
-		.procname	= "vm",
-		.mode		= 0555,
-		.child		= vm_table,
-	},
-	{
-		.procname	= "fs",
-		.mode		= 0555,
-		.child		= fs_table,
-	},
-	{
-		.procname	= "debug",
-		.mode		= 0555,
-		.child		= debug_table,
-	},
-	{
-		.procname	= "dev",
-		.mode		= 0555,
-		.child		= dev_table,
-	},
 	{ }
 };
 
@@ -266,6 +235,11 @@ static int min_extfrag_threshold;
 static int max_extfrag_threshold = 1000;
 #endif
 
+static const __initdata struct ctl_path kern_path [] = {
+	{ .procname = "kernel" },
+	{ },
+};
+
 static struct ctl_table kern_table[] = {
 	{
 		.procname	= "sched_child_runs_first",
@@ -955,6 +929,11 @@ static struct ctl_table kern_table[] = {
 	{ }
 };
 
+static const __initdata struct ctl_path vm_path [] = {
+	{ .procname = "vm" },
+	{ },
+};
+
 static struct ctl_table vm_table[] = {
 	{
 		.procname	= "overcommit_memory",
@@ -1324,11 +1303,23 @@ static struct ctl_table vm_table[] = {
 };
 
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
+
+static const __initdata struct ctl_path binfmt_misc_path [] = {
+	{ .procname = "fs" },
+	{ .procname = "binfmt_misc" },
+	{ },
+};
+
 static struct ctl_table binfmt_misc_table[] = {
 	{ }
 };
 #endif
 
+static const __initdata struct ctl_path fs_path [] = {
+	{ .procname = "fs" },
+	{ },
+};
+
 static struct ctl_table fs_table[] = {
 	{
 		.procname	= "inode-nr",
@@ -1446,13 +1437,6 @@ static struct ctl_table fs_table[] = {
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
-#if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
-	{
-		.procname	= "binfmt_misc",
-		.mode		= 0555,
-		.child		= binfmt_misc_table,
-	},
-#endif
 	{
 		.procname	= "pipe-max-size",
 		.data		= &pipe_max_size,
@@ -1464,6 +1448,11 @@ static struct ctl_table fs_table[] = {
 	{ }
 };
 
+static const __initdata struct ctl_path debug_path [] = {
+	{ .procname = "debug" },
+	{ },
+};
+
 static struct ctl_table debug_table[] = {
 #if defined(CONFIG_X86) || defined(CONFIG_PPC) || defined(CONFIG_SPARC) || \
     defined(CONFIG_S390)
@@ -1489,6 +1478,11 @@ static struct ctl_table debug_table[] = {
 	{ }
 };
 
+static const __initdata struct ctl_path dev_path [] = {
+	{ .procname = "dev" },
+	{ },
+};
+
 static struct ctl_table dev_table[] = {
 	{ }
 };
@@ -1688,11 +1682,62 @@ static void sysctl_set_parent(struct ctl_table *parent, struct ctl_table *table)
 
 static __init int sysctl_init(void)
 {
+	struct ctl_table_header *kern_header, *vm_header, *fs_header,
+		*debug_header, *dev_header;
+#if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
+	struct ctl_table_header *binfmt_misc_header;
+#endif
+
 	sysctl_set_parent(NULL, root_table);
+
+	kern_header = register_sysctl_paths(kern_path, kern_table);
+	if (kern_header == NULL)
+		goto fail_register_kern;
+
+	vm_header = register_sysctl_paths(vm_path, vm_table);
+	if (vm_header == NULL)
+		goto fail_register_vm;
+
+	fs_header = register_sysctl_paths(fs_path, fs_table);
+	if (fs_header == NULL)
+		goto fail_register_fs;
+
+	debug_header = register_sysctl_paths(debug_path, debug_table);
+	if (debug_header == NULL)
+		goto fail_register_debug;
+
+	dev_header = register_sysctl_paths(dev_path, dev_table);
+	if (dev_header == NULL)
+		goto fail_register_dev;
+
+#if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
+	binfmt_misc_header = register_sysctl_paths(binfmt_misc_path, binfmt_misc_table);
+	if (binfmt_misc_header == NULL)
+		goto fail_register_binfmt_misc;
+#endif
+
+
 #ifdef CONFIG_SYSCTL_SYSCALL_CHECK
 	sysctl_check_table(current->nsproxy, root_table);
 #endif
 	return 0;
+
+
+#if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
+fail_register_binfmt_misc:
+	unregister_sysctl_table(dev_header);
+#endif
+
+fail_register_dev:
+	unregister_sysctl_table(debug_header);
+fail_register_debug:
+	unregister_sysctl_table(fs_header);
+fail_register_fs:
+	unregister_sysctl_table(vm_header);
+fail_register_vm:
+	unregister_sysctl_table(kern_header);
+fail_register_kern:
+	return -ENOMEM;
 }
 
 core_initcall(sysctl_init);
-- 
1.7.5.134.g1c08b

