Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab2BUSHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:07:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab2BUSHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:07:50 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 50/73] union-mount: Create whiteout on unlink() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:03:44 +0000
Message-ID: <20120221180344.25235.79487.stgit@warthog.procyon.org.uk>
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

Whiteout an unlinked directory entry in a union mounted file system.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 586913f..ce941ac 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3333,11 +3333,6 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 	if (nd.last_type != LAST_NORM)
 		goto exit1;
 
-	/* unlink() on union mounts not implemented yet */
-	error = -EINVAL;
-	if (IS_DIR_UNIONED(nd.path.dentry))
-		goto exit1;
-
 	nd.flags &= ~LOOKUP_PARENT;
 
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
@@ -3356,6 +3351,10 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 		error = security_path_unlink(&nd.path, path.dentry);
 		if (error)
 			goto exit3;
+		if (IS_DIR_UNIONED(nd.path.dentry)) {
+			error = do_whiteout(&nd, &path, 0);
+			goto exit3;
+		}
 		error = vfs_unlink(nd.path.dentry->d_inode, path.dentry);
 exit3:
 		mnt_drop_write(nd.path.mnt);

