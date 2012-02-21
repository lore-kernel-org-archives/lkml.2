Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab2BUUGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:06:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab2BUTww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:52:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 41/73] union-mount: Temporarily disable some syscalls [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:02:39 +0000
Message-ID: <20120221180238.25235.15885.stgit@warthog.procyon.org.uk>
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

After some of the following patches in this series, a few system calls
will crash the kernel if called on union-mounted file systems.
Temporarily disable rename(), unlink(), and rmdir() on unioned file
systems until they are correctly implemented by later patches.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 991a32c..f53c0bc 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -38,6 +38,7 @@
 
 #include "internal.h"
 #include "mount.h"
+#include "union.h"
 
 /* [Feb-1997 T. Schoebel-Theuer]
  * Fundamental changes in the pathname lookup mechanisms (namei)
@@ -2891,6 +2892,11 @@ static long do_rmdir(int dfd, const char __user *pathname)
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
@@ -2991,6 +2997,11 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 	if (nd.last_type != LAST_NORM)
 		goto exit1;
 
+	/* unlink() on union mounts not implemented yet */
+	error = -EINVAL;
+	if (IS_DIR_UNIONED(nd.path.dentry))
+		goto exit1;
+
 	nd.flags &= ~LOOKUP_PARENT;
 
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
@@ -3384,6 +3395,12 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
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

