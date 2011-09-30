Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab1I3MGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:06:38 -0400
Received: from mx.kernel.net.pl ([217.73.31.3]:55545 "EHLO an2.kernel.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758509Ab1I3MFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:05:42 -0400
From: Witold Krecicki <wpk@culm.net>
To: Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Witold Krecicki <wpk@culm.net>
Subject: [PATCH 5/6] cgroup: make cgroup filesystem mounts performed by task inside isolation root see its isolation root as top cgroup
Date: Fri, 30 Sep 2011 13:36:24 +0200
Message-Id: <1317382585-12172-6-git-send-email-wpk@culm.net>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317382585-12172-1-git-send-email-wpk@culm.net>
References: <1317382585-12172-1-git-send-email-wpk@culm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes all mounts of cgroup filesystems performed by task
contained in isolation root see its isolation root as top cgroup.

Signed-off-by: Witold Krecicki <wpk@culm.net>
---
 kernel/cgroup.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c3fee33..db66a82 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1504,6 +1504,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	int ret = 0;
 	struct super_block *sb;
 	struct cgroupfs_root *new_root;
+	struct dentry *dret;
 
 	/* First find the desired set of subsystems */
 	mutex_lock(&cgroup_mutex);
@@ -1624,7 +1625,9 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		revert_creds(cred);
 		mutex_unlock(&cgroup_mutex);
 		mutex_unlock(&inode->i_mutex);
+		dret = sb->s_root;
 	} else {
+		struct cgroup *isol_root;
 		/*
 		 * We re-used an existing hierarchy - the new root (if
 		 * any) is not needed
@@ -1632,11 +1635,20 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		cgroup_drop_root(opts.new_root);
 		/* no subsys rebinding, so refcounts don't change */
 		drop_parsed_module_refcounts(opts.subsys_bits);
+		/* If root isolation is enabled give partial root */
+		cgroup_lock();
+		isol_root = cgroup_get_isolation_root(
+				task_cgroup_from_root(current, root));
+		if (isol_root)
+			dret = isol_root->dentry;
+		else
+			dret = sb->s_root;
+		cgroup_unlock();
 	}
 
 	kfree(opts.release_agent);
 	kfree(opts.name);
-	return dget(sb->s_root);
+	return dget(dret);
 
  drop_new_super:
 	deactivate_locked_super(sb);
-- 
1.7.4.1

