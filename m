Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab0IPWUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:20:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756505Ab0IPWOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:48 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 20/34] union-mount: Create build_root_union()
Date: Thu, 16 Sep 2010 15:12:11 -0700
Message-Id: <1284675145-4391-21-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During mount(), build_root_union() creates the union stack for the
root directory.  All other directory union stacks are bootstrapped
from their parents' union stacks during path lookup.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index e966890..2bb4645 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1464,6 +1464,54 @@ static int clone_union_tree(struct vfsmount *topmost, struct path *mntpnt)
 	return 0;
 }
 
+/**
+ * build_root_union - Create the union stack for the root dir
+ *
+ * @topmost_mnt - vfsmount of topmost mount
+ *
+ * Build the union stack for the root dir.  Annoyingly, we have to
+ * traverse union "up" from the root of the cloned tree to find the
+ * topmost read-only mount, and then traverse back "down" to build the
+ * stack.
+ */
+
+static int build_root_union(struct vfsmount *topmost_mnt)
+{
+	struct path lower, topmost_path;
+	struct vfsmount *mnt, *topmost_ro_mnt;
+	unsigned int i, layers = 1;
+	int err = 0;
+
+	/* Find the topmost read-only mount */
+	topmost_ro_mnt = topmost_mnt->mnt_sb->s_union_lower_mnts;
+	for (mnt = topmost_ro_mnt; mnt; mnt = next_mnt(mnt, topmost_ro_mnt)) {
+		if ((mnt->mnt_parent == topmost_ro_mnt) &&
+		    (mnt->mnt_mountpoint == topmost_ro_mnt->mnt_root)) {
+			topmost_ro_mnt = mnt;
+			layers++;
+		}
+	}
+	topmost_mnt->mnt_sb->s_union_count = layers;
+
+	/* Build the root dir's union stack from the top down */
+	topmost_path.mnt = topmost_mnt;
+	topmost_path.dentry = topmost_mnt->mnt_root;
+	mnt = topmost_ro_mnt;
+	for (i = 0; i < layers; i++) {
+		lower.mnt = mntget(mnt);
+		lower.dentry = dget(mnt->mnt_root);
+		err = union_add_dir(&topmost_path, &lower, i);
+		if (err)
+			goto out;
+		mnt = mnt->mnt_parent;
+	}
+	return 0;
+out:
+	d_free_unions(topmost_path.dentry);
+	topmost_mnt->mnt_sb->s_union_count = 0;
+	return err;
+}
+
 /*
  *  @source_mnt : mount tree to be attached
  *  @nd         : place the mount tree @source_mnt is attached
-- 
1.6.3.3

