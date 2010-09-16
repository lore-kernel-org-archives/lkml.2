Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab0IPWQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:16:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab0IPWPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:15:25 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 33/34] union-mount: Add do_lookup_union() wrapper for __lookup_union()
Date: Thu, 16 Sep 2010 15:12:24 -0700
Message-Id: <1284675145-4391-34-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_lookup_union() locks the parent directory and follows the mount
after lookup.  It is appropriate for calling from do_lookup().

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index ecb1796..7656442 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -880,6 +880,28 @@ static int lookup_union(struct nameidata *nd, struct qstr *name,
 }
 
 /*
+ * do_union_lookup - union mount-aware part of do_lookup
+ *
+ * do_lookup()-style wrapper for lookup_union().  Follows mounts.
+ */
+
+static int do_lookup_union(struct nameidata *nd, struct qstr *name,
+			   struct path *topmost)
+{
+	struct dentry *parent = nd->path.dentry;
+	struct inode *dir = parent->d_inode;
+	int err;
+
+	mutex_lock(&dir->i_mutex);
+	err = lookup_union(nd, name, topmost);
+	mutex_unlock(&dir->i_mutex);
+
+	__follow_mount(topmost);
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

