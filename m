Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab2EVONi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:13:38 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53920 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101Ab2EVOMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:12:48 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: inux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
        michael.brantley@deshaw.com, pstaubach@exagrid.com
Subject: [PATCH v2 13/15] vfs: make do_unlinkat retry on ESTALE errors
Date: Tue, 22 May 2012 10:12:17 -0400
Message-Id: <1337695939-2741-14-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1337695939-2741-1-git-send-email-jlayton@redhat.com>
References: <1337695939-2741-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a11fcc7..486a60a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2888,8 +2888,14 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 	struct dentry *dentry;
 	struct nameidata nd;
 	struct inode *inode = NULL;
+	unsigned int try = 0;
+	unsigned int lookup_flags = LOOKUP_PARENT;
 
-	error = user_path_parent(dfd, pathname, &nd, &name);
+	name = getname(pathname);
+	if (IS_ERR(name))
+		return PTR_ERR(name);
+retry:
+	error = do_path_lookup(dfd, name, lookup_flags, &nd);
 	if (error)
 		return error;
 
@@ -2927,6 +2933,10 @@ exit3:
 		iput(inode);	/* truncate the inode here */
 exit1:
 	path_put(&nd.path);
+	if (retry_estale(error, try++)) {
+		lookup_flags |= LOOKUP_REVAL;
+		goto retry;
+	}
 	putname(name);
 	return error;
 
-- 
1.7.7.6

