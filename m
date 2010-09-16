Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab0IPWSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:18:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802Ab0IPWPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:15:20 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 27/34] union-mount: Basic infrastructure of __union_lookup()
Date: Thu, 16 Sep 2010 15:12:18 -0700
Message-Id: <1284675145-4391-28-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a very simple version of union lookup.  This patch only looks
up the target in each layer of the union but does not process it in
any way.  Patches to do whiteouts, etc. follow.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 2de4378..8373463 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -724,6 +724,74 @@ static __always_inline void follow_dotdot(struct nameidata *nd)
 	follow_mount(&nd->path);
 }
 
+static struct dentry *__lookup_hash(struct qstr *name, struct dentry *base,
+				    struct nameidata *nd);
+
+/*
+ * __lookup_union - Lookup and build union stack
+ *
+ * @nd - nameidata for the parent of @topmost
+ * @name - name of target
+ * @topmost - path of the target on the topmost file system
+ *
+ * Do the "union" part of lookup for @topmost - that is, look it up in
+ * the lower layers of its parent directory's union stack.  If
+ * @topmost is a directory, build its union stack.  @topmost is the
+ * path of the target in the topmost layer of the union file system.
+ * It is either a directory or a negative (non-whiteout) dentry.
+ * @topmost and its parent must have passed the needs_union_lookup()
+ * test.
+ *
+ * This function may stomp nd->path with the path of the parent
+ * directory of the lower layers, so the caller must save nd->path and
+ * restore it afterwards.
+ */
+
+static int __lookup_union(struct nameidata *nd, struct qstr *name,
+			  struct path *topmost)
+{
+	struct path lower, parent = nd->path;
+	struct path *path;
+	unsigned int i, layers = parent.dentry->d_sb->s_union_count;
+	int err = 0;
+
+	/*
+	 * Note: This loop iterates through the union stack of the
+	 * parent of the target, not the target itself.  This function
+	 * builds the union stack of the target (if any).  The union
+	 * stack of the root directory is built at mount.
+	 */
+	for (i = 0; i < layers; i++) {
+		/*
+		 * Get the parent directory for this layer and lookup
+		 * the target in it.
+		 */
+		path = union_find_dir(parent.dentry, i);
+		if (!path->mnt)
+			continue;
+
+		nd->path = *path;
+		lower.mnt = mntget(nd->path.mnt);
+		mutex_lock(&nd->path.dentry->d_inode->i_mutex);
+		lower.dentry = __lookup_hash(name, nd->path.dentry, nd);
+		mutex_unlock(&nd->path.dentry->d_inode->i_mutex);
+
+		if (IS_ERR(lower.dentry)) {
+			mntput(lower.mnt);
+			err = PTR_ERR(lower.dentry);
+			goto out_err;
+		}
+		/* XXX - do nothing, lookup rule processing in later patches */
+		path_put(&lower);
+	}
+	return 0;
+
+out_err:
+	d_free_unions(topmost->dentry);
+	path_put(&lower);
+	return err;
+}
+
 /*
  *  It's more convoluted than I'd like it to be, but... it's still fairly
  *  small and for now I'd prefer to have fast path as straight as possible.
-- 
1.6.3.3

