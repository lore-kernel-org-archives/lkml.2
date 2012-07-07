Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab2GGXql (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 19:46:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55429 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab2GGXqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 19:46:40 -0400
Date: Sat, 7 Jul 2012 16:46:34 -0700
From: "'Tejun Heo'" <tj@kernel.org>
To: Shyju PV <shyju.pv@huawei.com>
Cc: "'Li Zefan'" <lizefan@huawei.com>,
        "'Sanil kumar'" <sanil.kumar@huawei.com>,
        "'Masanari Iida'" <standby24x7@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Cgroups'" <cgroups@vger.kernel.org>, viro@zeniv.linux.org.uk,
        levinsasha928@gmail.com, nagamani.mantha@huawei.com
Subject: [PATCH 1/2] Revert "cgroup: superblock can't be released with
 active dentries"
Message-ID: <20120707234634.GC16783@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4FEEA5CB.8070809@huawei.com>
 <20120703170317.GB555@google.com>
 <20120703225218.GF555@google.com>
 <4ff55c60.27da440a.65ec.ffff83dfSMTPIN_ADDED@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ff55c60.27da440a.65ec.ffff83dfSMTPIN_ADDED@mx.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7db5b3ca0ecdb2e8fad52a4770e4e320e61c77a6 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Sat, 7 Jul 2012 15:55:47 -0700

This reverts commit fa980ca87d15bb8a1317853f257a505990f3ffde.  The
commit was an attempt to fix a race condition where a cgroup hierarchy
may be unmounted with positive dentry reference on root cgroup.  While
the commit made the race condition slightly more difficult to trigger,
the race was still there and could be reliably triggered using a
different test case.

Revert the incorrect fix.  The next commit will describe the race and
fix it correctly.

Signed-off-by: Tejun Heo <tj@kernel.org>
LKML-Reference: <4FEEA5CB.8070809@huawei.com>
Reported-by: shyju pv <shyju.pv@huawei.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
Acked-by: Li Zefan <lizefan@huawei.com>
---
Sorry about the delay.  Was on vacation.  Will soon push these two
patches to Linus.

(Shyju, didn't realize I was replying to private reply, resending)

Thanks.

 kernel/cgroup.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2097684..5f134a0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -901,13 +901,10 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		mutex_unlock(&cgroup_mutex);
 
 		/*
-		 * We want to drop the active superblock reference from the
-		 * cgroup creation after all the dentry refs are gone -
-		 * kill_sb gets mighty unhappy otherwise.  Mark
-		 * dentry->d_fsdata with cgroup_diput() to tell
-		 * cgroup_d_release() to call deactivate_super().
+		 * Drop the active superblock reference that we took when we
+		 * created the cgroup
 		 */
-		dentry->d_fsdata = cgroup_diput;
+		deactivate_super(cgrp->root->sb);
 
 		/*
 		 * if we're getting rid of the cgroup, refcount should ensure
@@ -933,13 +930,6 @@ static int cgroup_delete(const struct dentry *d)
 	return 1;
 }
 
-static void cgroup_d_release(struct dentry *dentry)
-{
-	/* did cgroup_diput() tell me to deactivate super? */
-	if (dentry->d_fsdata == cgroup_diput)
-		deactivate_super(dentry->d_sb);
-}
-
 static void remove_dir(struct dentry *d)
 {
 	struct dentry *parent = dget(d->d_parent);
@@ -1547,7 +1537,6 @@ static int cgroup_get_rootdir(struct super_block *sb)
 	static const struct dentry_operations cgroup_dops = {
 		.d_iput = cgroup_diput,
 		.d_delete = cgroup_delete,
-		.d_release = cgroup_d_release,
 	};
 
 	struct inode *inode =
-- 
1.7.7.3

