Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab0IPWPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:15:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab0IPWPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:15:18 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 28/34] union-mount: Process negative dentries in __union_lookup()
Date: Thu, 16 Sep 2010 15:12:19 -0700
Message-Id: <1284675145-4391-29-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whiteouts end a union lookup.  So do opaque directories, unless
specific fallthru entry exists for this name.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 8373463..f6ad8b3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -781,11 +781,32 @@ static int __lookup_union(struct nameidata *nd, struct qstr *name,
 			err = PTR_ERR(lower.dentry);
 			goto out_err;
 		}
-		/* XXX - do nothing, lookup rule processing in later patches */
+
+		/*
+		 * A negative dentry can mean several things.  A plain
+		 * negative dentry is ignored and lookup continues to
+		 * the next layer.  But a whiteout or a non-fallthru
+		 * in an opaque dir covers everything below it.
+		 */
+		if (!lower.dentry->d_inode) {
+			if (d_is_whiteout(lower.dentry))
+				goto out_lookup_done;
+			if (IS_OPAQUE(nd->path.dentry->d_inode) &&
+			    !d_is_fallthru(lower.dentry))
+				goto out_lookup_done;
+			path_put(&lower);
+			continue;
+		}
+
+		/* XXX - do nothing, more in later patches */
 		path_put(&lower);
 	}
 	return 0;
 
+out_lookup_done:
+	path_put(&lower);
+	return 0;
+
 out_err:
 	d_free_unions(topmost->dentry);
 	path_put(&lower);
-- 
1.6.3.3

