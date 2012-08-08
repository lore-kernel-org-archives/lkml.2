Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab2HHNZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:25:23 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63544 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758475Ab2HHNWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:22:06 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v5 13/19] vfs: make do_unlinkat retry on ESTALE errors
Date: Wed,  8 Aug 2012 09:21:36 -0400
Message-Id: <1344432102-22312-14-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1344432102-22312-1-git-send-email-jlayton@redhat.com>
References: <1344432102-22312-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 7eb59cc..0c112c3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3392,8 +3392,14 @@ static long do_unlinkat(int dfd, const char __user *pathname)
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
 
@@ -3430,6 +3436,10 @@ exit2:
 	mnt_drop_write(nd.path.mnt);
 exit1:
 	path_put(&nd.path);
+	if (retry_estale(error, try++)) {
+		lookup_flags |= LOOKUP_REVAL;
+		goto retry;
+	}
 	putname(name);
 	return error;
 
-- 
1.7.11.2

