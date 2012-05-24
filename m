Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab2EXPlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:41:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65435 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2EXPlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:41:44 -0400
Date: Thu, 24 May 2012 08:41:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>, Sasha Levin <levinsasha928@gmail.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Vivek Goyal <vgoyal@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] cgroup: superblock can't be released with active dentries
Message-ID: <20120524154139.GA27983@google.com>
References: <20120330223423.GJ28934@google.com>
 <20120330223606.GK28934@google.com>
 <4F77B6BA.4070207@huawei.com>
 <20120401185430.GA9230@dhcp-172-17-108-109.mtv.corp.google.com>
 <CA+1xoqe5hMuxzCRhMy7J0XchDk2ZnuxOHJKikROk1-ReAzcT6g@mail.gmail.com>
 <20120518175548.GM19388@google.com>
 <CA+1xoqfr5aaGbxoX3YKrJHXTjU9fWSbX_xbuEOU=4K7kMay6XQ@mail.gmail.com>
 <20120523222242.GD3933@htj.dyndns.org>
 <CA+1xoqdbtkC5Ue3s1qZHHJBLcj9a=djFDGny6AJJSV-pdn7mcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqdbtkC5Ue3s1qZHHJBLcj9a=djFDGny6AJJSV-pdn7mcA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 88787c483106c5830a46d18deaffdc1e70929af7 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 24 May 2012 08:24:39 -0700

48ddbe1946 "cgroup: make css->refcnt clearing on cgroup removal
optional" allowed a css to linger after the associated cgroup is
removed.  As a css holds a reference on the cgroup's dentry, it means
that cgroup dentries may linger for a while.

cgroup_create() does grab an active reference on the superblock to
prevent it from going away while there are !root cgroups; however, the
reference is put from cgroup_diput() which is invoked on cgroup
removal, so cgroup dentries which are removed but persisting due to
lingering csses already have released their superblock active refs
allowing superblock to be killed while those dentries are around.

Given the right condition, this makes cgroup_kill_sb() call
kill_litter_super() with dentries with non-zero d_count leading to
BUG() in shrink_dcache_for_umount_subtree().

Fix it by adding cgroup_dops->d_release() operation and moving
deactivate_super() to it.  cgroup_diput() now marks dentry->d_fsdata
with itself if superblock should be deactivated and cgroup_d_release()
deactivates the superblock on dentry release.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Sasha Levin <levinsasha928@gmail.com>
Tested-by: Sasha Levin <levinsasha928@gmail.com>
LKML-Reference: <CA+1xoqe5hMuxzCRhMy7J0XchDk2ZnuxOHJKikROk1-ReAzcT6g@mail.gmail.com>
---
Li, can you please ack this?

Thanks.

 kernel/cgroup.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ad8eae5..e887b55 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -896,10 +896,13 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		mutex_unlock(&cgroup_mutex);
 
 		/*
-		 * Drop the active superblock reference that we took when we
-		 * created the cgroup
+		 * We want to drop the active superblock reference from the
+		 * cgroup creation after all the dentry refs are gone -
+		 * kill_sb gets mighty unhappy otherwise.  Mark
+		 * dentry->d_fsdata with cgroup_diput() to tell
+		 * cgroup_d_release() to call deactivate_super().
 		 */
-		deactivate_super(cgrp->root->sb);
+		dentry->d_fsdata = cgroup_diput;
 
 		/*
 		 * if we're getting rid of the cgroup, refcount should ensure
@@ -925,6 +928,13 @@ static int cgroup_delete(const struct dentry *d)
 	return 1;
 }
 
+static void cgroup_d_release(struct dentry *dentry)
+{
+	/* did cgroup_diput() tell me to deactivate super? */
+	if (dentry->d_fsdata == cgroup_diput)
+		deactivate_super(dentry->d_sb);
+}
+
 static void remove_dir(struct dentry *d)
 {
 	struct dentry *parent = dget(d->d_parent);
@@ -1532,6 +1542,7 @@ static int cgroup_get_rootdir(struct super_block *sb)
 	static const struct dentry_operations cgroup_dops = {
 		.d_iput = cgroup_diput,
 		.d_delete = cgroup_delete,
+		.d_release = cgroup_d_release,
 	};
 
 	struct inode *inode =
-- 
1.7.7.3

