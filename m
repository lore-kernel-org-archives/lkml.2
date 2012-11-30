Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab2K3Tra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:47:30 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52855 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2K3Tr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:47:27 -0500
Date: Fri, 30 Nov 2012 11:47:20 -0800
From: Tejun Heo <tj@kernel.org>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: cgroups@vger.kernel.org, lizefan@huawei.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: [PATCH] cgroup: use cgroup_addrm_files() in cgroup_clear_directory()
Message-ID: <20121130194720.GG3873@htj.dyndns.org>
References: <1354292489-18434-1-git-send-email-gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354292489-18434-1-git-send-email-gaofeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 879a3d9dbbde823ac77d39131e7a287f31b8296f Mon Sep 17 00:00:00 2001
From: Gao feng <gaofeng@cn.fujitsu.com>
Date: Sat, 1 Dec 2012 00:21:28 +0800

cgroup_clear_directory() incorrectly invokes cgroup_rm_file() on each
cftset of the target subsystems, which only removes the first file of
each set.  This leaves dangling files after subsystems are removed
from a cgroup root via remount.

Use cgroup_addrm_files() to remove all files of target subsystems.

tj: Move cgroup_addrm_files() prototype decl upwards next to other
    global declarations.  Commit message updated.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to cgroup/for-3.8 with minor updates.  Thanks!

 kernel/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b186a7e..e1293a9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -246,6 +246,8 @@ static DEFINE_SPINLOCK(hierarchy_id_lock);
 static int need_forkexit_callback __read_mostly;
 
 static int cgroup_destroy_locked(struct cgroup *cgrp);
+static int cgroup_addrm_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
+			      struct cftype cfts[], bool is_add);
 
 #ifdef CONFIG_PROVE_LOCKING
 int cgroup_lock_is_held(void)
@@ -964,7 +966,7 @@ static void cgroup_clear_directory(struct dentry *dir, bool base_files,
 		if (!test_bit(ss->subsys_id, &subsys_mask))
 			continue;
 		list_for_each_entry(set, &ss->cftsets, node)
-			cgroup_rm_file(cgrp, set->cfts);
+			cgroup_addrm_files(cgrp, NULL, set->cfts, false);
 	}
 	if (base_files) {
 		while (!list_empty(&cgrp->files))
-- 
1.7.11.7

