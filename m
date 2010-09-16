Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab0IPWP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:15:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343Ab0IPWPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:15:22 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 30/34] union-mount: Build union stack in __lookup_union()
Date: Thu, 16 Sep 2010 15:12:21 -0700
Message-Id: <1284675145-4391-31-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build the union stack for directories as we look them up.  Create the
topmost directory if it doesn't exist.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c6696d8..0041334 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -811,8 +811,22 @@ static int __lookup_union(struct nameidata *nd, struct qstr *name,
 			goto out_found_file;
 		}
 
-		/* XXX - do nothing, more in later patches */
-		path_put(&lower);
+		/*
+		 * Now we know the target is a directory.  Create a
+		 * matching topmost directory if one doesn't already
+		 * exist, and add this layer's directory to the union
+		 * stack for the topmost directory.
+		 */
+		if (!topmost->dentry->d_inode) {
+			err = union_create_topmost_dir(&parent, name, topmost,
+						       &lower);
+			if (err)
+				goto out_err;
+		}
+
+		err = union_add_dir(topmost, &lower, i);
+		if (err)
+			goto out_err;
 	}
 	return 0;
 
-- 
1.6.3.3

