Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab0IPWQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:16:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497Ab0IPWPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:15:25 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 32/34] union-mount: Add lookup_union() wrapper for __lookup_union()
Date: Thu, 16 Sep 2010 15:12:23 -0700
Message-Id: <1284675145-4391-33-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__lookup_union() may overwrite the parent's path in the nameidata
struct for the entry being looked up.  This is because it reuses the
same nameidata to do lookups in each of the lower layer directories.
lookup_union() saves and restores the original parent's path.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index cdff001..ecb1796 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -853,6 +853,33 @@ out_err:
 }
 
 /*
+ * lookup_union - revalidate and build union stack for this path
+ *
+ * We borrow the nameidata struct from the topmost layer to do the
+ * revalidation on lower dentries, replacing the topmost parent
+ * directory's path with that of the matching parent dir in each lower
+ * layer.  This wrapper for __lookup_union() saves the topmost layer's
+ * path and restores it when we are done.
+ */
+static int lookup_union(struct nameidata *nd, struct qstr *name,
+			struct path *topmost)
+{
+	struct path saved_path;
+	int err;
+
+	BUG_ON(!IS_MNT_UNION(nd->path.mnt) && !IS_MNT_UNION(topmost->mnt));
+	BUG_ON(!mutex_is_locked(&nd->path.dentry->d_inode->i_mutex));
+
+	saved_path = nd->path;
+
+	err = __lookup_union(nd, name, topmost);
+
+	nd->path = saved_path;
+
+	return err;
+}
+
+/*
  *  It's more convoluted than I'd like it to be, but... it's still fairly
  *  small and for now I'd prefer to have fast path as straight as possible.
  *  It _is_ time-critical.
-- 
1.6.3.3

