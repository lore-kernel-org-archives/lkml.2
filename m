Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2HOUkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:40:49 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62713 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab2HOTss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:48:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jaxboe@fusionio.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 003/165] fs: assign sb->s_bdi to default_backing_dev_info if the bdi is going away
Date: Wed, 15 Aug 2012 15:45:47 -0400
Message-ID: <1345060109-9187-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jaxboe@fusionio.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 95f28604a65b1c40b6c6cd95e58439cd7ded3add upstream.

We don't have proper reference counting for this yet, so we run into
cases where the device is pulled and we OOPS on flushing the fs data.
This happens even though the dirty inodes have already been
migrated to the default_backing_dev_info.

Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Tested-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/super.c       | 2 ++
 fs/sync.c        | 4 ++--
 mm/backing-dev.c | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 53040a6..7123fa7 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -64,6 +64,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 			goto out;
 		}
 		INIT_LIST_HEAD(&s->s_files);
+		s->s_bdi = &default_backing_dev_info;
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
@@ -962,6 +963,7 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
 		goto out_free_secdata;
 	BUG_ON(!mnt->mnt_sb);
 	WARN_ON(!mnt->mnt_sb->s_bdi);
+	WARN_ON(mnt->mnt_sb->s_bdi == &default_backing_dev_info);
 	mnt->mnt_sb->s_flags |= MS_BORN;
 
 	error = security_sb_kern_mount(mnt->mnt_sb, flags, secdata);
diff --git a/fs/sync.c b/fs/sync.c
index 92b2281..5281fb3 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -33,7 +33,7 @@ static int __sync_filesystem(struct super_block *sb, int wait)
 	 * This should be safe, as we require bdi backing to actually
 	 * write out data in the first place
 	 */
-	if (!sb->s_bdi || sb->s_bdi == &noop_backing_dev_info)
+	if (sb->s_bdi == &noop_backing_dev_info)
 		return 0;
 
 	if (sb->s_qcop && sb->s_qcop->quota_sync)
@@ -110,7 +110,7 @@ restart:
 		spin_unlock(&sb_lock);
 
 		down_read(&sb->s_umount);
-		if (!(sb->s_flags & MS_RDONLY) && sb->s_root && sb->s_bdi)
+		if (!(sb->s_flags & MS_RDONLY) && sb->s_root)
 			__sync_filesystem(sb, wait);
 		up_read(&sb->s_umount);
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 707d0dc..7bd17d2 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -634,7 +634,7 @@ static void bdi_prune_sb(struct backing_dev_info *bdi)
 	spin_lock(&sb_lock);
 	list_for_each_entry(sb, &super_blocks, s_list) {
 		if (sb->s_bdi == bdi)
-			sb->s_bdi = NULL;
+			sb->s_bdi = &default_backing_dev_info;
 	}
 	spin_unlock(&sb_lock);
 }
-- 
1.7.12.rc2

