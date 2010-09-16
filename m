Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0IPWPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:15:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab0IPWPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:15:22 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 29/34] union-mount: Return files found in lower layers in __union_lookup()
Date: Thu, 16 Sep 2010 15:12:20 -0700
Message-Id: <1284675145-4391-30-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we find a file during union lookup, don't look in any lower layers
and replace the topmost path with the file's path.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f6ad8b3..c6696d8 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -798,11 +798,34 @@ static int __lookup_union(struct nameidata *nd, struct qstr *name,
 			continue;
 		}
 
+		/*
+		 * Files block everything below them.  Special case:
+		 * If we find a file below a directory (which makes no
+		 * sense), just ignore the file and return the
+		 * directory above it.
+		 */
+		if (!S_ISDIR(lower.dentry->d_inode->i_mode)) {
+			if (topmost->dentry->d_inode &&
+			    S_ISDIR(topmost->dentry->d_inode->i_mode))
+				goto out_lookup_done;
+			goto out_found_file;
+		}
+
 		/* XXX - do nothing, more in later patches */
 		path_put(&lower);
 	}
 	return 0;
 
+out_found_file:
+	/*
+	 * Swap out the positive lower dentry with the negative upper
+	 * dentry for this file.  Note that the matching mntput() is done
+	 * in link_path_walk().
+	 */
+	dput(topmost->dentry);
+	*topmost = lower;
+	return 0;
+
 out_lookup_done:
 	path_put(&lower);
 	return 0;
-- 
1.6.3.3

