Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab2BUSRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:17:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab2BUSRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:17:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 51/73] union-mount: Create whiteout on rmdir() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:03:52 +0000
Message-ID: <20120221180351.25235.23932.stgit@warthog.procyon.org.uk>
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

Whiteout a deleted directory in a union mounted file system.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index ce941ac..f9e0d68 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3228,11 +3228,6 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	if (error)
 		return error;
 
-	/* rmdir() on union mounts not implemented yet */
-	error = -EINVAL;
-	if (IS_DIR_UNIONED(nd.path.dentry))
-		goto exit1;
-
 	switch(nd.last_type) {
 	case LAST_DOTDOT:
 		error = -ENOTEMPTY;
@@ -3261,6 +3256,10 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	error = security_path_rmdir(&nd.path, path.dentry);
 	if (error)
 		goto exit4;
+	if (IS_DIR_UNIONED(nd.path.dentry)) {
+		error = do_whiteout(&nd, &path, 1);
+		goto exit4;
+	}
 	error = vfs_rmdir(nd.path.dentry->d_inode, path.dentry);
 exit4:
 	mnt_drop_write(nd.path.mnt);

