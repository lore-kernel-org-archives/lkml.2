Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab2JDX5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 19:57:06 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:41535 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2JDX5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 19:57:04 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: viro@zeniv.linux.org.uk, keescook@chromium.org
Cc: levinsasha928@gmail.com, davej@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] fs: prevent use after free in auditing when symlink following was denied
Date: Thu,  4 Oct 2012 19:56:40 -0400
Message-Id: <1349395000-12050-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.7.12
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "fs: add link restriction audit reporting" has added auditing of failed
attempts to follow symlinks. Unfortunately, the auditing was being done after
the struct path structure was released earlier.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index aa30d19..6d47fac 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -692,9 +692,9 @@ static inline int may_follow_link(struct path *link, struct nameidata *nd)
 	if (uid_eq(parent->i_uid, inode->i_uid))
 		return 0;
 
+	audit_log_link_denied("follow_link", link);
 	path_put_conditional(link, nd);
 	path_put(&nd->path);
-	audit_log_link_denied("follow_link", link);
 	return -EACCES;
 }
 
-- 
1.7.12

