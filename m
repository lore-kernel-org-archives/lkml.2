Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab2LCBuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 20:50:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:6556 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab2LCBuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 20:50:20 -0500
X-IronPort-AV: E=Sophos;i="4.83,359,1352044800"; 
   d="scan'208";a="6317466"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: tj@kernel.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, lizefan@huawei.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RESEND] cgroup: remove subsystem files when remounting cgroup
Date: Mon, 3 Dec 2012 09:28:18 +0800
Message-Id: <1354498098-17312-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354292489-18434-2-git-send-email-gaofeng@cn.fujitsu.com>
References: <1354292489-18434-2-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/03 09:28:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/03 09:28:18,
	Serialize complete at 2012/12/03 09:28:18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_clear_directroy is called by cgroup_d_remove_dir
and cgroup_remount.

when we call cgroup_remount to remount the cgroup,the subsystem
may be unlinked from cgroupfs_root->subsys_list in rebind_subsystem,this
subsystem's files will not be removed in cgroup_clear_directroy.
And the system will panic when we try to access these files.

this patch removes subsystems's files before rebind_subsystems,
if rebind_subsystems failed, repopulate these removed files.

With help from Tejun.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/cgroup.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e1293a9..afabd2a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1349,14 +1349,21 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 		goto out_unlock;
 	}
 
+	/*
+	 * Clear out the files of subsystems that should be removed,do
+	 * this job before rebind_subsystems,since rebind_subsystems may
+	 * change this hierarchy's subsys_list.
+	 */
+	cgroup_clear_directory(cgrp->dentry, false, removed_mask);
+
 	ret = rebind_subsystems(root, opts.subsys_mask);
 	if (ret) {
+		/* rebind_subsystems failed,re-populate the removed files */
+		cgroup_populate_dir(cgrp, false, removed_mask);
 		drop_parsed_module_refcounts(opts.subsys_mask);
 		goto out_unlock;
 	}
 
-	/* clear out any existing files and repopulate subsystem files */
-	cgroup_clear_directory(cgrp->dentry, false, removed_mask);
 	/* re-populate subsystem files */
 	cgroup_populate_dir(cgrp, false, added_mask);
 
-- 
1.7.7.6

