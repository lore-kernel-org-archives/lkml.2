Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab2BUT7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:59:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab2BUTxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 47/73] union-mount: Add lookup_union_locked() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:03:22 +0000
Message-ID: <20120221180322.25235.3494.stgit@warthog.procyon.org.uk>
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

lookup_union_locked() checks if union lookup is actually necessary for this
dentry, and marks the dentry to show that the union lookup has been performed -
all whilst the caller holds the directory i_mutex.

__lookup_union() may overwrite the parent's path in the nameidata
struct for the entry being looked up.  This is because it reuses the
same nameidata to do lookups in each of the lower layer directories.
lookup_union() saves and restores the original parent's path in the
nameidata.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 37e32b4..2d69ce1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1229,6 +1229,53 @@ out_err:
 	return err;
 }
 
+/**
+ * lookup_union_locked - Lookup and/or build union stack if needed
+ * @nd - nameidata for the parent of @topmost
+ * @name - name of target
+ * @topmost - path of the target on the topmost file system
+ *
+ * Check if we need to do a union lookup on this target.  Mark dentry
+ * to show lookup union has been performed.
+ *
+ * We borrow the nameidata struct from the topmost layer to do the
+ * revalidation on lower dentries, replacing the topmost parent
+ * directory's path with that of the matching parent dir in each lower
+ * layer.  This wrapper for __lookup_union() saves the topmost layer's
+ * path and restores it when we are done.
+ *
+ * Caller must hold parent i_mutex.
+ */
+static int lookup_union_locked(struct nameidata *nd, struct qstr *name,
+			       struct path *topmost)
+{
+	struct path saved_path;
+	int err;
+
+	BUG_ON(!IS_MNT_UNION(nd->path.mnt) && !IS_MNT_UNION(topmost->mnt));
+	BUG_ON(!mutex_is_locked(&nd->path.dentry->d_inode->i_mutex));
+
+	/* Initial test done outside of parent i_mutex lock, recheck it.  We
+	 * only set this flag inside parent i_mutex so it's safe to check it
+	 * here (only need d_lock when setting to avoid squashing other flags).
+	 */
+	if (topmost->dentry->d_flags & DCACHE_UNION_LOOKUP_DONE)
+		return 0;
+
+	saved_path = nd->path;
+
+	err = __lookup_union(nd, name, topmost);
+
+	nd->path = saved_path;
+
+	/* XXX move into dcache.h */
+	spin_lock(&topmost->dentry->d_lock);
+	topmost->dentry->d_flags |= DCACHE_UNION_LOOKUP_DONE;
+	spin_unlock(&topmost->dentry->d_lock);
+
+	return err;
+}
+
 /*
  * Allocate a dentry with name and parent, and perform a parent
  * directory ->lookup on it. Returns the new dentry, or ERR_PTR

