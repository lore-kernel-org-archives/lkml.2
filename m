Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab2F2S7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:59:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46821 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762Ab2F2S60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:58:26 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v3 13/17] vfs: make do_unlinkat retry on ESTALE errors
Date: Fri, 29 Jun 2012 14:57:56 -0400
Message-Id: <1340996280-27123-14-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340996280-27123-1-git-send-email-jlayton@redhat.com>
References: <1340996280-27123-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 7fccc1c..7fadc99 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2955,8 +2955,14 @@ static long do_unlinkat(int dfd, const char __user *pathname)
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
 
@@ -2994,6 +3000,10 @@ exit3:
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

