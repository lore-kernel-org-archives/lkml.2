Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab0IPWUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:20:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541Ab0IPWOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:51 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 21/34] union-mount: Create prepare_mnt_union() and cleanup_mnt_union()
Date: Thu, 16 Sep 2010 15:12:12 -0700
Message-Id: <1284675145-4391-22-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare_mnt_union() ties together all the mount-time checks and setup
for union mounts.  It tests the layers for suitability and builds the
root union stack.

cleanup_mnt_union() unwinds everything prepare_mnt_union() does.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 2bb4645..ff83cee 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1512,6 +1512,49 @@ out:
 	return err;
 }
 
+/**
+ * prepare_mnt_union - do setup necessary for a union mount
+ *
+ * @topmost_mnt: vfsmount of topmost layer
+ * @mntpnt: path of requested mountpoint
+ *
+ * We union every underlying file system that is mounted on the same
+ * mountpoint (well, pathname), read-only, and not shared.  If we get
+ * at least one layer, we don't return an error, although we will
+ * complain in the kernel log if we hit a mount that can't be
+ * unioned.
+ *
+ * Caller needs namespace_sem, but can't have vfsmount_lock.
+ */
+
+static int prepare_mnt_union(struct vfsmount *topmost_mnt, struct path *mntpnt)
+{
+	int err;
+
+	err = check_topmost_union_mnt(topmost_mnt, topmost_mnt->mnt_flags);
+	if (err)
+		return err;
+
+	err = clone_union_tree(topmost_mnt, mntpnt);
+	if (err)
+		return err;
+
+	err = build_root_union(topmost_mnt);
+	if (err)
+		goto out;
+
+	return 0;
+out:
+	put_union_sb(topmost_mnt->mnt_sb);
+	return err;
+}
+
+static void cleanup_mnt_union(struct vfsmount *topmost_mnt)
+{
+	d_free_unions(topmost_mnt->mnt_root);
+	put_union_sb(topmost_mnt->mnt_sb);
+}
+
 /*
  *  @source_mnt : mount tree to be attached
  *  @nd         : place the mount tree @source_mnt is attached
-- 
1.6.3.3

