Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab2JBAU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:20:59 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53967 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab2JBASD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:18:03 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 40/49] vfs: convert do_file_open_root to use retry_estale helper
Date: Mon,  1 Oct 2012 20:16:49 -0400
Message-Id: <1349137018-21948-41-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 8e39510..9a7736f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3031,6 +3031,7 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 	struct nameidata nd;
 	struct file *file;
 	struct getname_info ginfo = { .name = name };
+	unsigned int try = 0;
 
 	nd.root.mnt = mnt;
 	nd.root.dentry = dentry;
@@ -3043,7 +3044,7 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 	file = path_openat(-1, &ginfo, &nd, op, flags | LOOKUP_RCU);
 	if (unlikely(file == ERR_PTR(-ECHILD)))
 		file = path_openat(-1, &ginfo, &nd, op, flags);
-	if (unlikely(file == ERR_PTR(-ESTALE)))
+	while (retry_estale(PTR_ERR(file), try++))
 		file = path_openat(-1, &ginfo, &nd, op, flags | LOOKUP_REVAL);
 	return file;
 }
-- 
1.7.11.4

