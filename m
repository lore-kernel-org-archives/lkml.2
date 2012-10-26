Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab2JZJ5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:57:45 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49002 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2JZJ5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:57:44 -0400
MIME-Version: 1.0
Date: Fri, 26 Oct 2012 13:57:43 +0400
Message-ID: <CA+JonM0vrXtGzhv44o5rOH-3z_BuU52=Nu8WmiMz5m1=ENZ9HA@mail.gmail.com>
Subject: procfs does not return error code when file name is already in use
From: =?KOI8-R?B?5M3J1NLJyiDsxc/O1NjF1w==?= <dm.leontiev7@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, dleontie@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working a kernel module, and one of my tasks is to disallow a
process to open my character device(/dev/xxx) more than once. I tried
to solve this problem by creating /proc/apu directory, and creating a
/proc/xxx/{pid} file for when process opens /dev/xxx. This file will
act as per-process mutex, and provide a way to control resource usage.

Then, I investigated,if procfs acts as I expect from it, and found
that procfs checks file names for uniqueness, but does not return an
error when I add two files with same name. Instead, it posts silly
messages to kernel log, and adds new entry as if nothing happened.
This is a vulnerability:

Let we have 2 modules A and B trying to create file /proc/foo on load,
and removing it on unload. Load A, Load B, unload B. at step 3 B
removed /proc/foo owned by A, and /proc/foo created by B remains
accessible from userspace.

My patch fixes this behaviour: proc_register will return -EEXIST when
file name is in use, and refuse to add a duplicate.

----start of patch for fs/proc/generic.c---------------------------------------
--- generic.c.orig	2012-10-25 22:20:05.196606263 +0400
+++ generic.c	2012-10-25 22:13:49.556955392 +0400
@@ -554,45 +554,51 @@ static const struct inode_operations pro

 static int proc_register(struct proc_dir_entry * dir, struct
proc_dir_entry * dp)
 {
+	int errorcode=-EAGAIN;
 	unsigned int i;
 	struct proc_dir_entry *tmp;
 	
 	i = get_inode_number();
-	if (i == 0)
-		return -EAGAIN;
-	dp->low_ino = i;
-
-	if (S_ISDIR(dp->mode)) {
-		if (dp->proc_iops == NULL) {
-			dp->proc_fops = &proc_dir_operations;
-			dp->proc_iops = &proc_dir_inode_operations;
+	if (i != 0)
+	{
+		errorcode=0;
+
+		dp->low_ino = i;
+
+		if (S_ISDIR(dp->mode)) {
+			if (dp->proc_iops == NULL) {
+				dp->proc_fops = &proc_dir_operations;
+				dp->proc_iops = &proc_dir_inode_operations;
+			}
+			dir->nlink++;
+		} else if (S_ISLNK(dp->mode)) {
+			if (dp->proc_iops == NULL)
+				dp->proc_iops = &proc_link_inode_operations;
+		} else if (S_ISREG(dp->mode)) {
+			if (dp->proc_fops == NULL)
+				dp->proc_fops = &proc_file_operations;
+			if (dp->proc_iops == NULL)
+				dp->proc_iops = &proc_file_inode_operations;
 		}
-		dir->nlink++;
-	} else if (S_ISLNK(dp->mode)) {
-		if (dp->proc_iops == NULL)
-			dp->proc_iops = &proc_link_inode_operations;
-	} else if (S_ISREG(dp->mode)) {
-		if (dp->proc_fops == NULL)
-			dp->proc_fops = &proc_file_operations;
-		if (dp->proc_iops == NULL)
-			dp->proc_iops = &proc_file_inode_operations;
-	}

-	spin_lock(&proc_subdir_lock);
+		spin_lock(&proc_subdir_lock);

-	for (tmp = dir->subdir; tmp; tmp = tmp->next)
-		if (strcmp(tmp->name, dp->name) == 0) {
-			WARN(1, KERN_WARNING "proc_dir_entry '%s/%s' already registered\n",
-				dir->name, dp->name);
-			break;
+		for (tmp = dir->subdir; tmp; tmp = tmp->next)
+		{
+			if (strcmp(tmp->name, dp->name) == 0) {
+				errorcode=-EEXIST;
+				break;
+			}
 		}
-
-	dp->next = dir->subdir;
-	dp->parent = dir;
-	dir->subdir = dp;
-	spin_unlock(&proc_subdir_lock);
-
-	return 0;
+		if(!errorcode)
+		{
+			dp->next = dir->subdir;
+			dp->parent = dir;
+			dir->subdir = dp;
+		}
+		spin_unlock(&proc_subdir_lock);
+	}
+	return errorcode;
 }

 static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
----end of patch---------------------------------------

Regards
Dmitry
