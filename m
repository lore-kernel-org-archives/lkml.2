Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603Ab2D0ISY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:18:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57153 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756613Ab2D0ISU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:18:20 -0400
X-Sasl-enc: e8sPeRJsh/EeDT4RLtX2gKgdlLfNwiCvOpYmmNayEgdAUL3ObwYH9F+PvA 1335514698
From: Ian Kent <raven@themaw.net>
Subject: [PATCH] cifs - check S_AUTOMOUNT in revalidate
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>,
        linux-cifs@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 27 Apr 2012 16:18:15 +0800
Message-ID: <20120427081815.4478.26011.stgit@perseus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When revalidating a dentry, if the inode wasn't known to be a dfs
entry when the dentry was instantiated, such as when created via
->readdir(), the DCACHE_NEED_AUTOMOUNT flag needs to be set on the
dentry in ->d_revalidate().

The false return from cifs_d_revalidate(), due to the inode now
being marked with the S_AUTOMOUNT flag, might not invalidate the
dentry if there is a concurrent unlazy path walk. This is because
the dentry reference count will be at least 2 in this case causing
d_invalidate() to return EBUSY. So the asumption that the dentry
will be discarded then correctly instantiated via ->lookup() might
not hold.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Cc: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org
---

 fs/cifs/dir.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index d172c8e..ec4e9a2 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -668,12 +668,19 @@ cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
 			return 0;
 		else {
 			/*
-			 * Forcibly invalidate automounting directory inodes
-			 * (remote DFS directories) so to have them
-			 * instantiated again for automount
+			 * If the inode wasn't known to be a dfs entry when
+			 * the dentry was instantiated, such as when created
+			 * via ->readdir(), it needs to be set now since the
+			 * attributes will have been updated by
+			 * cifs_revalidate_dentry().
 			 */
-			if (IS_AUTOMOUNT(direntry->d_inode))
-				return 0;
+			if (IS_AUTOMOUNT(direntry->d_inode) &&
+			   !(direntry->d_flags & DCACHE_NEED_AUTOMOUNT)) {
+				spin_lock(&direntry->d_lock);
+				direntry->d_flags |= DCACHE_NEED_AUTOMOUNT;
+				spin_unlock(&direntry->d_lock);
+			}
+
 			return 1;
 		}
 	}

