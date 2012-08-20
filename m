Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab2HTRaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:30:17 -0400
Received: from mx.meyering.net ([88.168.87.75]:44792 "EHLO hx.meyering.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755348Ab2HTR3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:29:44 -0400
From: Jim Meyering <jim@meyering.net>
To: linux-kernel@vger.kernel.org
Cc: Jim Meyering <meyering@redhat.com>, Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net
Subject: [PATCH] fs/9p: avoid debug OOPS when reading a long symlink
Date: Mon, 20 Aug 2012 18:55:21 +0200
Message-Id: <1345481724-30108-3-git-send-email-jim@meyering.net>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345481724-30108-1-git-send-email-jim@meyering.net>
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Meyering <meyering@redhat.com>

Reading a symlink longer than the given buffer, a p9_debug use would
try to print the link name (not NUL-terminated) using a %s format.
Use %.*s instead, and replace the strncpy+strnlen with functionally
equivalent strlen+memcpy.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 fs/9p/vfs_inode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index cbf9dbb..16ed405 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1276,12 +1276,12 @@ static int v9fs_readlink(struct dentry *dentry, char *buffer, int buflen)
 	}

 	/* copy extension buffer into buffer */
-	strncpy(buffer, st->extension, buflen);
+	retval = min(strlen(st->extension)+1, buflen);
+	memcpy(buffer, st->extension, retval);

-	p9_debug(P9_DEBUG_VFS, "%s -> %s (%s)\n",
-		 dentry->d_name.name, st->extension, buffer);
+	p9_debug(P9_DEBUG_VFS, "%s -> %s (%.*s)\n",
+		 dentry->d_name.name, st->extension, buflen, buffer);

-	retval = strnlen(buffer, buflen);
 done:
 	p9stat_free(st);
 	kfree(st);
-- 
1.7.12

