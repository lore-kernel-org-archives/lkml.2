Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1BAJCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 04:02:16 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60667 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1BAJCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 04:02:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :message-id;
        b=OxVl5GJrM6WuuqfmGIuARXNeQuTHj6jD8yZJpN0EJ6X+umQs0TNpq2d7vvWQmyVJIM
         OJiH+o0FkkrPRt9eW7nNtHmYkuSvlHEk/6VRPuYT1GIsc6PrMWvG3393PjgSwMqkNMYi
         xWCVepVBQETtxnG67E9lF9aWfoF1onSzhnUSg=
From: Jordi Pujol <jordipujolp@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC/RFT PATCH] cgroup: enable write permission for the group of users
Date: Tue, 1 Feb 2011 10:02:09 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-0.jpp.12-lnet-amd64; KDE/4.4.5; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Rw8RNYc8d+zmSQ9"
Message-Id: <201102011002.09819.jordipujolp@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Rw8RNYc8d+zmSQ9
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

Working in a development that uses control groups and libcgroup, I have found 
that the files in control groups directories need write permission for the 
group of users also.

In example,
here is an excerpt of the configuration of libcgroup, from file 
"/etc/cgconfig.conf"
******** BEGIN OF EXCERPT
group realtime {
	perm {
		task {
			uid = root;
			gid = audio;
		}
		admin {
			uid = root;
			gid = jobadmin;
		}
	}
	cpu {
		cpu.policy = 1;
		cpu.shares = 800;
		cpu.rt_runtime_us = 900000;
	}
	memory {
		memory.swappiness = 10;
	}
}
group usr {
  ....
}

# batch processes
group usr/batch {
	perm {
		task {
			uid = root;
			gid = users;
		}
		admin {
			uid = root;
			gid = jobadmin;
		}
	}
	cpu {
		cpu.policy = 3;
		cpu.shares = 400;
	}
	memory {
		memory.swappiness = 60;
	}
}
******* END OF EXCERPT

In cgroup "realtime" We obtain from this configuration that the user "root" is 
the owner of the cgroup's files, the admins are users in the "jobadmin" group 
and the users are the "audio" group.
the users that are members of group audio must have write permission to the 
tasks file to add jobs to this cgroup. And the members of group jobadmin need 
write permission to the cgroup control files.

Here is attached a near trivial patch to enable it.
******** BEGIN OF PATCH
--- linux-2.6.37/kernel/cgroup.c
+++ linux-2.6.37/kernel/cgroup.c	2011-01-30 15:16:00.556562499 +0100
@@ -1441,7 +1441,7 @@ static int cgroup_set_super(struct super
 static int cgroup_get_rootdir(struct super_block *sb)
 {
 	struct inode *inode =
-		cgroup_new_inode(S_IFDIR | S_IRUGO | S_IXUGO | S_IWUSR, sb);
+		cgroup_new_inode(S_IFDIR | S_IRUGO | S_IXUGO | S_IWUSR | S_IWGRP, 
sb);
 	struct dentry *dentry;
 
 	if (!inode)
@@ -2265,9 +2265,9 @@ static int cgroup_create_dir(struct cgro
  * @cft: the control file in question
  *
  * returns cft->mode if ->mode is not 0
- * returns S_IRUGO|S_IWUSR if it has both a read and a write handler
+ * returns S_IRUGO|S_IWUSR|S_IWGRP if it has both a read and a write handler
  * returns S_IRUGO if it has only a read handler
- * returns S_IWUSR if it has only a write hander
+ * returns S_IWUSR|S_IWGRP if it has only a write hander
  */
 static mode_t cgroup_file_mode(const struct cftype *cft)
 {
@@ -2281,8 +2281,10 @@ static mode_t cgroup_file_mode(const str
 		mode |= S_IRUGO;
 
 	if (cft->write || cft->write_u64 || cft->write_s64 ||
-	    cft->write_string || cft->trigger)
+	    cft->write_string || cft->trigger) {
 		mode |= S_IWUSR;
+		mode |= S_IWGRP;
+	}
 
 	return mode;
 }
@@ -3244,7 +3246,7 @@ static struct cftype files[] = {
 		.open = cgroup_tasks_open,
 		.write_u64 = cgroup_tasks_write,
 		.release = cgroup_pidlist_release,
-		.mode = S_IRUGO | S_IWUSR,
+		.mode = S_IRUGO | S_IWUSR | S_IWGRP,
 	},
 	{
 		.name = CGROUP_FILE_GENERIC_PREFIX "procs",
******** END OF PATCH

see a more complete explanation of the development and the related code in 
following URL.

http://livenet.selfip.com/?content=06utilitats-Ccgroups

http://livenet.selfip.com/ftp/debian/cgroups-daemon/

Jordi Pujol

Live never ending Tale
GNU/Linux Live forever!
http://livenet.selfip.com

--Boundary-00=_Rw8RNYc8d+zmSQ9
Content-Type: text/x-patch;
  charset="UTF-8";
  name="cgroups-perm-wgrp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cgroups-perm-wgrp.patch"

Signed-off-by: Jordi Pujol <jordipujolp@gmail.com>

 cgroup: Add write permission for the group of users.

--- linux-2.6.37/kernel/cgroup.c
+++ linux-2.6.37/kernel/cgroup.c	2011-01-30 15:16:00.556562499 +0100
@@ -1441,7 +1441,7 @@ static int cgroup_set_super(struct super
 static int cgroup_get_rootdir(struct super_block *sb)
 {
 	struct inode *inode =
-		cgroup_new_inode(S_IFDIR | S_IRUGO | S_IXUGO | S_IWUSR, sb);
+		cgroup_new_inode(S_IFDIR | S_IRUGO | S_IXUGO | S_IWUSR | S_IWGRP, sb);
 	struct dentry *dentry;
 
 	if (!inode)
@@ -2265,9 +2265,9 @@ static int cgroup_create_dir(struct cgro
  * @cft: the control file in question
  *
  * returns cft->mode if ->mode is not 0
- * returns S_IRUGO|S_IWUSR if it has both a read and a write handler
+ * returns S_IRUGO|S_IWUSR|S_IWGRP if it has both a read and a write handler
  * returns S_IRUGO if it has only a read handler
- * returns S_IWUSR if it has only a write hander
+ * returns S_IWUSR|S_IWGRP if it has only a write hander
  */
 static mode_t cgroup_file_mode(const struct cftype *cft)
 {
@@ -2281,8 +2281,10 @@ static mode_t cgroup_file_mode(const str
 		mode |= S_IRUGO;
 
 	if (cft->write || cft->write_u64 || cft->write_s64 ||
-	    cft->write_string || cft->trigger)
+	    cft->write_string || cft->trigger) {
 		mode |= S_IWUSR;
+		mode |= S_IWGRP;
+	}
 
 	return mode;
 }
@@ -3244,7 +3246,7 @@ static struct cftype files[] = {
 		.open = cgroup_tasks_open,
 		.write_u64 = cgroup_tasks_write,
 		.release = cgroup_pidlist_release,
-		.mode = S_IRUGO | S_IWUSR,
+		.mode = S_IRUGO | S_IWUSR | S_IWGRP,
 	},
 	{
 		.name = CGROUP_FILE_GENERIC_PREFIX "procs",

--Boundary-00=_Rw8RNYc8d+zmSQ9--
