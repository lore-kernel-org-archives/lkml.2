Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab0IPWPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:15:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab0IPWPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:15:14 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 26/34] union-mount: Temporarily disable some syscalls
Date: Thu, 16 Sep 2010 15:12:17 -0700
Message-Id: <1284675145-4391-27-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After some of the following patches in this series, a few system calls
will crash the kernel if called on union-mounted file systems.
Temporarily disable rename(), unlink(), and rmdir() on unioned file
systems until they are correctly implemented by later patches.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 0b6378e..2de4378 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -35,6 +35,7 @@
 #include <asm/uaccess.h>
 
 #include "internal.h"
+#include "union.h"
 
 /* [Feb-1997 T. Schoebel-Theuer]
  * Fundamental changes in the pathname lookup mechanisms (namei)
@@ -2404,6 +2405,11 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	if (error)
 		return error;
 
+	/* rmdir() on union mounts not implemented yet */
+	error = -EINVAL;
+	if (IS_DIR_UNIONED(nd.path.dentry))
+		goto exit1;
+
 	switch(nd.last_type) {
 	case LAST_DOTDOT:
 		error = -ENOTEMPTY;
@@ -2500,6 +2506,11 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 	if (nd.last_type != LAST_NORM)
 		goto exit1;
 
+	/* unlink() on union mounts not implemented yet */
+	error = -EINVAL;
+	if (IS_DIR_UNIONED(nd.path.dentry))
+		goto exit1;
+
 	nd.flags &= ~LOOKUP_PARENT;
 
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
@@ -2890,6 +2901,12 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	if (oldnd.path.mnt != newnd.path.mnt)
 		goto exit2;
 
+	/* rename() on union mounts not implemented yet */
+	error = -EXDEV;
+	if (IS_DIR_UNIONED(oldnd.path.dentry) ||
+	    IS_DIR_UNIONED(newnd.path.dentry))
+		goto exit2;
+
 	old_dir = oldnd.path.dentry;
 	error = -EBUSY;
 	if (oldnd.last_type != LAST_NORM)
-- 
1.6.3.3

