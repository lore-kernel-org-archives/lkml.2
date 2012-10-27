Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2J0MlJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 08:41:09 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:64114 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab2J0MeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 08:34:11 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v8 11/32] vfs: make do_unlinkat retry on ESTALE errors
Date: Sat, 27 Oct 2012 08:33:18 -0400
Message-Id: <1351341219-17837-12-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351341219-17837-1-git-send-email-jlayton@redhat.com>
References: <1351341219-17837-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 7c9bb50..467b9f1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3446,9 +3446,13 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 	struct filename *name;
 	struct dentry *dentry;
 	struct nameidata nd;
-	struct inode *inode = NULL;
+	struct inode *inode;
+	unsigned int try = 0;
+	unsigned int lookup_flags = LOOKUP_PARENT;
 
-	name = user_path_parent(dfd, pathname, &nd, 0);
+retry:
+	inode = NULL;
+	name = user_path_parent(dfd, pathname, &nd, try);
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 
@@ -3486,6 +3490,10 @@ exit2:
 exit1:
 	path_put(&nd.path);
 	putname(name);
+	if (retry_estale(error, try++)) {
+		lookup_flags |= LOOKUP_REVAL;
+		goto retry;
+	}
 	return error;
 
 slashes:
-- 
1.7.11.7

