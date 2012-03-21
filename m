Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965184Ab2CUWVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:21:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65325 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab2CUWRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:17:52 -0400
From: Tejun Heo <tj@kernel.org>
To: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/12] cgroup: move cgroup_clear_directory() call out of cgroup_populate_dir()
Date: Wed, 21 Mar 2012 15:17:34 -0700
Message-Id: <1332368265-21586-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332368265-21586-1-git-send-email-tj@kernel.org>
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_populate_dir() currently clears all files and then repopulate
the directory; however, the clearing part is only useful when it's
called from cgroup_remount().  Relocate the invocation to
cgroup_remount().

This is to prepare for further cgroup file handling updates.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index deeab87..2e2f93b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1313,7 +1313,8 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 		goto out_unlock;
 	}
 
-	/* (re)populate subsystem files */
+	/* clear out any existing files and repopulate subsystem files */
+	cgroup_clear_directory(cgrp->dentry);
 	cgroup_populate_dir(cgrp);
 
 	if (opts.release_agent)
@@ -3648,9 +3649,6 @@ static int cgroup_populate_dir(struct cgroup *cgrp)
 	int err;
 	struct cgroup_subsys *ss;
 
-	/* First clear out any existing files */
-	cgroup_clear_directory(cgrp->dentry);
-
 	err = cgroup_add_files(cgrp, NULL, files, ARRAY_SIZE(files));
 	if (err < 0)
 		return err;
-- 
1.7.7.3

