Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab2BUT4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:56:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab2BUTym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:54:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 42/73] union-mount: Basic infrastructure of __lookup_union()
 [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:02:46 +0000
Message-ID: <20120221180246.25235.91666.stgit@warthog.procyon.org.uk>
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

Create a very simple version of union lookup.  This patch only looks
up the target in each layer of the union but does not process it in
any way.  Patches to do whiteouts, etc. follow.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c |   77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f53c0bc..8caed86 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1097,6 +1097,83 @@ static void follow_dotdot(struct nameidata *nd)
 	nd->inode = nd->path.dentry->d_inode;
 }
 
+static struct dentry *__lookup_hash(struct qstr *name, struct dentry *base,
+				    struct nameidata *nd);
+
+/**
+ * __lookup_union - Lookup and build union stack
+ * @nd - nameidata for the parent of @topmost
+ * @name - name of target
+ * @topmost - path of the target on the topmost file system
+ *
+ * Do the "union" part of lookup for @topmost - that is, look it up in the
+ * lower layers of its parent directory's union stack.  If @topmost is a
+ * directory, build its union stack.  @topmost is the path of the target in the
+ * topmost layer of the union file system.  It is either a directory or a
+ * negative (non-whiteout) dentry.
+ *
+ * This function may stomp nd->path with the path of the parent directory of
+ * the lower layers, so the caller must save nd->path and restore it
+ * afterwards.
+ */
+static int __lookup_union(struct nameidata *nd, struct qstr *name,
+			  struct path *topmost)
+{
+	struct path lower, parent = nd->path;
+	struct path *path;
+	unsigned i, layers = parent.dentry->d_sb->s_union_count;
+	int err;
+
+	if (!topmost->dentry->d_inode) {
+		if (d_is_whiteout(topmost->dentry))
+			return 0;
+		if (IS_OPAQUE(parent.dentry->d_inode) &&
+		    !d_is_fallthru(topmost->dentry))
+			return 0;
+	}
+
+	/* If it's positive and not a dir, no lookup needed */
+	if (topmost->dentry->d_inode &&
+	    !S_ISDIR(topmost->dentry->d_inode->i_mode))
+		return 0;
+
+	/* At this point we have either a negative fallthru dentry or we have a
+	 * positive directory dentry.
+	 *
+	 * Loop through the union stack of the parent of the target, building
+	 * the union stack of the target (if applicable).  Note that the union
+	 * stack of the root directory is built at mount.
+	 */
+	for (i = 0; i < layers; i++) {
+		/* Get the parent directory for this layer and lookup
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
  * Allocate a dentry with name and parent, and perform a parent
  * directory ->lookup on it. Returns the new dentry, or ERR_PTR

