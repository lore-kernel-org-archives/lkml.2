Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1ESLJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:09:21 -0400
Received: from gate.krista.ru ([84.47.172.34]:19317 "EHLO gate.krista.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396Ab1ESLJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:09:20 -0400
X-Greylist: delayed 2034 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 May 2011 07:09:19 EDT
Date: Thu, 19 May 2011 14:32:13 +0400
From: samsonov@krista.ru
To: linux-kernel@vger.kernel.org
Subject: Some patches for ppp_generic.c and proc/base.c
Message-ID: <20110519143213.094da1eb@wks1198.krista.ru>
Organization: =?KOI8-R?B?7vDvIOvSydPUwQ==?=
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.8 [-37] (---) (gate.krista.ru)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day!
I mean that /proc file permission for process information must be
secure:

--- ./linux-2.6.33.4.orig/fs/proc/base.c	2010-05-13 02:04:27.000000000 +0400
+++ ./linux-2.6.33.4/fs/proc/base.c	2011-05-16 15:36:29.385923198 +0400
@@ -2570,11 +2570,11 @@
 static const struct inode_operations proc_task_inode_operations;
 
 static const struct pid_entry tgid_base_stuff[] = {
-	DIR("task",       S_IRUGO|S_IXUGO, proc_task_inode_operations, proc_task_operations),
-	DIR("fd",         S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
-	DIR("fdinfo",     S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
+	DIR("task",       S_IWUSR|S_IRUGO|S_IXUGO, proc_task_inode_operations, proc_task_operations),
+	DIR("fd",         S_IWUSR|S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
+	DIR("fdinfo",     S_IRUSR|S_IWUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 #ifdef CONFIG_NET
-	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
+	DIR("net",        S_IRUGO|S_IWUSR|S_IXUGO, proc_net_inode_operations, proc_net_operations),
 #endif
 	REG("environ",    S_IRUSR, proc_environ_operations),
 	INF("auxv",       S_IRUSR, proc_pid_auxv),
@@ -2608,7 +2608,7 @@
 	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
-	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
+	DIR("attr",       S_IRUGO|S_IWUSR|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
 #endif
 #ifdef CONFIG_KALLSYMS
 	INF("wchan",      S_IRUGO, proc_pid_wchan),
@@ -2767,7 +2767,7 @@
 	if (!inode)
 		goto out;
 
-	inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
+	inode->i_mode = S_IFDIR|S_IRUSR|S_IWUSR|S_IXUSR|S_IRGRP|S_IXGRP;
 	inode->i_op = &proc_tgid_base_inode_operations;
 	inode->i_fop = &proc_tgid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
@@ -2909,8 +2909,8 @@
  * Tasks
  */
 static const struct pid_entry tid_base_stuff[] = {
-	DIR("fd",        S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
-	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
+	DIR("fd",        S_IRUSR|S_IWUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
+	DIR("fdinfo",    S_IRUSR|S_IWUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	REG("environ",   S_IRUSR, proc_environ_operations),
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
@@ -2942,7 +2942,7 @@
 	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
-	DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
+	DIR("attr",      S_IRUGO|S_IWUSR|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
 #endif
 #ifdef CONFIG_KALLSYMS
 	INF("wchan",     S_IRUGO, proc_pid_wchan),
@@ -3008,7 +3008,7 @@
 
 	if (!inode)
 		goto out;
-	inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
+	inode->i_mode = S_IFDIR|S_IRUSR|S_IWUSR|S_IXUSR|S_IRGRP|S_IXGRP;
 	inode->i_op = &proc_tid_base_inode_operations;
 	inode->i_fop = &proc_tid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;

This example is for system with private system groups, with common
system group the processes dirs in proc must have permissions 600, IMHO.

In ppp driver IMHO:

--- ./linux-2.6.33.4.orig/drivers/net/ppp_generic.c	2010-05-13 02:04:27.000000000 +0400
+++ ./linux-2.6.33.4/drivers/net/ppp_generic.c	2011-05-10 13:51:11.909607463 +0400
@@ -366,8 +366,8 @@
 	/*
 	 * This could (should?) be enforced by the permissions on /dev/ppp.
 	 */
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
+//	if (!capable(CAP_NET_ADMIN))
+//		return -EPERM;
 	return 0;
 }


I mean, that change group of file must able fileowner (CAP_FOWNER), but
not the CAP_CHOWN. May be I right?


--- ./linux-2.6.33.4.orig/fs/attr.c	2010-05-13 02:04:27.000000000 +0400
+++ ./linux-2.6.33.4/fs/attr.c	2011-05-10 14:25:57.727062904 +0400
@@ -35,11 +35,10 @@
 
 	/* Make sure caller can chgrp. */
 	if ((ia_valid & ATTR_GID) &&
-	    (current_fsuid() != inode->i_uid ||
-	    (!in_group_p(attr->ia_gid) && attr->ia_gid != inode->i_gid)) &&
-	    !capable(CAP_CHOWN))
+	    !(in_group_p(attr->ia_gid) && is_owner_or_cap(inode)))
 		goto error;
 
+
 	/* Make sure a caller can chmod. */
 	if (ia_valid & ATTR_MODE) {
 		if (!is_owner_or_cap(inode))


Thanks for attention!

 

