Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab2BUUBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:01:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab2BUTxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 34/73] union-mount: Create build_root_union() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:01:47 +0000
Message-ID: <20120221180146.25235.80201.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

During mount(), build_root_union() creates the union stack for the
root directory.  All other directory union stacks are bootstrapped
from their parents' union stacks during path lookup.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namespace.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 1f24a6b..3355b99 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -22,6 +22,7 @@
 #include <linux/uaccess.h>
 #include "pnode.h"
 #include "internal.h"
+#include "union.h"
 
 #define HASH_SHIFT ilog2(PAGE_SIZE / sizeof(struct list_head))
 #define HASH_SIZE (1UL << HASH_SHIFT)
@@ -1520,6 +1521,54 @@ static int clone_union_tree(struct mount *topmost, struct path *mntpnt)
 	return 0;
 }
 
+/**
+ * build_root_union - Create the union stack for the root dir
+ * @topmost_mnt - vfsmount of topmost mount
+ *
+ * Build the union stack for the root dir.  Annoyingly, we have to traverse
+ * union "up" from the root of the cloned tree to find the topmost read-only
+ * mount, and then traverse back "down" to build the stack.
+ */
+static int build_root_union(struct vfsmount *topmost_mnt)
+{
+	struct path lower, topmost_path;
+	struct mount *mnt, *topmost_ro_mnt;
+	unsigned int i, layers = 1;
+	int err = 0;
+
+	/* Find the topmost read-only mount */
+	topmost_ro_mnt = real_mount(topmost_mnt->mnt_sb->s_union_lower_mnts);
+	for (mnt = topmost_ro_mnt; mnt; mnt = next_mnt(mnt, topmost_ro_mnt)) {
+		if (mnt->mnt_parent == topmost_ro_mnt &&
+		    mnt->mnt_mountpoint == topmost_ro_mnt->mnt.mnt_root) {
+			topmost_ro_mnt = mnt;
+			layers++;
+		}
+	}
+	topmost_mnt->mnt_sb->s_union_count = layers;
+
+	// SHOULD USE collect_mounts() here rather than merely mntgetting
+
+	/* Build the root dir's union stack from the top down */
+	topmost_path.mnt = topmost_mnt;
+	topmost_path.dentry = topmost_mnt->mnt_root;
+	mnt = topmost_ro_mnt;
+	for (i = 0; i < layers; i++) {
+		lower.mnt = mntget(&mnt->mnt); // !!!!!!!!!! TODO: FIX
+		lower.dentry = dget(mnt->mnt.mnt_root);
+		err = union_add_dir(&topmost_path, &lower, i);
+		if (err)
+			goto out;
+		mnt = mnt->mnt_parent;
+	}
+	return 0;
+
+out:
+	d_free_unions(topmost_path.dentry);
+	topmost_mnt->mnt_sb->s_union_count = 0;
+	return err;
+}
+
 /*
  *  @source_mnt : mount tree to be attached
  *  @nd         : place the mount tree @source_mnt is attached

