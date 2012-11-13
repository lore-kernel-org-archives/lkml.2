Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab2KMDCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:02:41 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:36312 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab2KMDCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:02:37 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mhocko@suse.cz, glommer@parallels.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/17] cgroup: use mutex_trylock() when grabbing i_mutex of a new cgroup directory
Date: Mon, 12 Nov 2012 19:01:41 -0800
Message-Id: <1352775704-9023-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352775704-9023-1-git-send-email-tj@kernel.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All cgroup directory i_mutexes nest outside cgroup_mutex; however, new
directory creation is a special case.  A new cgroup directory is
created while holding cgroup_mutex.  Populating the new directory
requires both the new directory's i_mutex and cgroup_mutex.  Because
all directory i_mutexes nest outside cgroup_mutex, grabbing both
requires releasing cgroup_mutex first, which isn't a good idea as the
new cgroup isn't yet ready to be manipulated by other cgroup
opreations.

This is worked around by grabbing the new directory's i_mutex while
holding cgroup_mutex before making it visible.  As there's no other
user at that point, grabbing the i_mutex under cgroup_mutex can't lead
to deadlock.

cgroup_create_file() was using I_MUTEX_CHILD to tell lockdep not to
worry about the reverse locking order; however, this creates pseudo
locking dependency cgroup_mutex -> I_MUTEX_CHILD, which isn't true -
all directory i_mutexes are still nested outside cgroup_mutex.  This
pseudo locking dependency can lead to spurious lockdep warnings.

Use mutex_trylock() instead.  This will always succeed and lockdep
doesn't create any locking dependency for it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b42f63f..8ad5e76 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2657,9 +2657,15 @@ static int cgroup_create_file(struct dentry *dentry, umode_t mode,
 		inc_nlink(inode);
 		inc_nlink(dentry->d_parent->d_inode);
 
-		/* start with the directory inode held, so that we can
-		 * populate it without racing with another mkdir */
-		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
+		/*
+		 * Control reaches here with cgroup_mutex held.
+		 * @inode->i_mutex should nest outside cgroup_mutex but we
+		 * want to populate it immediately without releasing
+		 * cgroup_mutex.  As @inode isn't visible to anyone else
+		 * yet, trylock will always succeed without affecting
+		 * lockdep checks.
+		 */
+		WARN_ON_ONCE(!mutex_trylock(&inode->i_mutex));
 	} else if (S_ISREG(mode)) {
 		inode->i_size = 0;
 		inode->i_fop = &cgroup_file_operations;
-- 
1.7.11.7

