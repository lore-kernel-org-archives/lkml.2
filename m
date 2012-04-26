Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab2DZP7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:59:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58169 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085Ab2DZP7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:59:07 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
        michael.brantley@deshaw.com
Subject: [PATCH v1 09/12] vfs: make do_unlinkat retry on ESTALE errors
Date: Thu, 26 Apr 2012 11:57:20 -0400
Message-Id: <1335455843-16089-8-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1335455843-16089-1-git-send-email-jlayton@redhat.com>
References: <1335455843-16089-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d754460..3a8e5e4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2863,8 +2863,9 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 	struct dentry *dentry;
 	struct nameidata nd;
 	struct inode *inode = NULL;
-
-	error = user_path_parent(dfd, pathname, &nd, &name, false);
+	unsigned int try = 0;
+retry:
+	error = user_path_parent(dfd, pathname, &nd, &name, try);
 	if (error)
 		return error;
 
@@ -2903,6 +2904,8 @@ exit3:
 exit1:
 	path_put(&nd.path);
 	putname(name);
+	if (retry_estale(error, try++))
+		goto retry;
 	return error;
 
 slashes:
-- 
1.7.7.6

