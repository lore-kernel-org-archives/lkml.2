Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab2JBASQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:18:16 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:42333 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab2JBARu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:50 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 31/49] vfs: make do_unlinkat retry on ESTALE errors
Date: Mon,  1 Oct 2012 20:16:40 -0400
Message-Id: <1349137018-21948-32-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 0d0b1c0..f311ed1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3450,8 +3450,11 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 	struct dentry *dentry;
 	struct nameidata nd;
 	struct inode *inode = NULL;
+	unsigned int try = 0;
+	unsigned int lookup_flags = LOOKUP_PARENT;
 
-	name = user_path_parent(dfd, pathname, &nd, 0);
+retry:
+	name = user_path_parent(dfd, pathname, &nd, try);
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 
@@ -3489,6 +3492,10 @@ exit2:
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
1.7.11.4

