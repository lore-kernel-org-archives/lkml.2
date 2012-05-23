Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab2EWWWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 18:22:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64612 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2EWWWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 18:22:48 -0400
Date: Wed, 23 May 2012 15:22:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rni@google.com, ctalbott@google.com,
        Vivek Goyal <vgoyal@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] cgroup: make css->refcnt clearing on cgroup removal
 optional
Message-ID: <20120523222242.GD3933@htj.dyndns.org>
References: <20120330223423.GJ28934@google.com>
 <20120330223606.GK28934@google.com>
 <4F77B6BA.4070207@huawei.com>
 <20120401185430.GA9230@dhcp-172-17-108-109.mtv.corp.google.com>
 <CA+1xoqe5hMuxzCRhMy7J0XchDk2ZnuxOHJKikROk1-ReAzcT6g@mail.gmail.com>
 <20120518175548.GM19388@google.com>
 <CA+1xoqfr5aaGbxoX3YKrJHXTjU9fWSbX_xbuEOU=4K7kMay6XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqfr5aaGbxoX3YKrJHXTjU9fWSbX_xbuEOU=4K7kMay6XQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Sasha.

Does the following patch fix the problem you're seeing?

Thanks.

---
 kernel/cgroup.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ad8eae5..7cf9669 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -896,10 +896,13 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		mutex_unlock(&cgroup_mutex);
 
 		/*
-		 * Drop the active superblock reference that we took when we
-		 * created the cgroup
+		 * We want to drop the active superblock reference that we
+		 * took when we created the cgroup after all dentry refs
+		 * are gone - kill_sb gets mighty unhappy otherwise.  Set
+		 * dentry->d_fsdata to cgroup_diput() to tell
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
