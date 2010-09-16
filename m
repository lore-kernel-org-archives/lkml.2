Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab0IPWTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:19:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756632Ab0IPWPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:15:09 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 25/34] union-mount: Implement union mount
Date: Thu, 16 Sep 2010 15:12:16 -0700
Message-Id: <1284675145-4391-26-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up till this commit, mount with MS_UNION flag succeeded but didn't
actually union the file systems.  Now call the functions to check
the source mounts and create/destroy the per-vfsmount union structures.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c |   13 ++++++++++++-
 fs/super.c     |    1 +
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index e3629dd..6bbeb49 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1632,9 +1632,17 @@ static int attach_recursive_mnt(struct vfsmount *source_mnt,
 		if (err)
 			goto out;
 	}
+
+	/* parent_path means we are moving an existing unioned mount */
+	if (!parent_path && IS_MNT_UNION(source_mnt)) {
+		err = prepare_mnt_union(source_mnt, path);
+		if (err)
+			goto out_cleanup_ids;
+	}
+
 	err = propagate_mnt(dest_mnt, dest_dentry, source_mnt, &tree_list);
 	if (err)
-		goto out_cleanup_ids;
+		goto out_cleanup_union;
 
 	spin_lock(&vfsmount_lock);
 
@@ -1658,6 +1666,9 @@ static int attach_recursive_mnt(struct vfsmount *source_mnt,
 	spin_unlock(&vfsmount_lock);
 	return 0;
 
+ out_cleanup_union:
+	if (!parent_path && IS_MNT_UNION(source_mnt))
+		cleanup_mnt_union(source_mnt);
  out_cleanup_ids:
 	if (IS_MNT_SHARED(dest_mnt))
 		cleanup_group_ids(source_mnt, NULL);
diff --git a/fs/super.c b/fs/super.c
index 3f2df09..c376147 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -160,6 +160,7 @@ void deactivate_locked_super(struct super_block *s)
 	if (atomic_dec_and_test(&s->s_active)) {
 		fs->kill_sb(s);
 		put_filesystem(fs);
+		put_union_sb(s);
 		put_super(s);
 	} else {
 		up_write(&s->s_umount);
-- 
1.6.3.3

