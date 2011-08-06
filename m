Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab1HFQnP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 12:43:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50331 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab1HFQnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 12:43:13 -0400
From: Ari Savolainen <ari.m.savolainen@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix POSIX ACL permission check
Date: Sat,  6 Aug 2011 19:43:07 +0300
Message-Id: <1312648987-4886-1-git-send-email-ari.m.savolainen@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 3567866bf261: "RCUify freeing acls, let check_acl() go ahead in
RCU mode if acl is cached" posix_acl_permission is being called with an
unsupported flag and the permission check fails. This patch fixes the issue.

Signed-off-by: Ari Savolainen <ari.m.savolainen@gmail.com>

---
 fs/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 3d607bd..f5a1351 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -186,7 +186,7 @@ static int check_acl(struct inode *inode, int mask)
 		/* no ->get_acl() calls in RCU mode... */
 		if (acl == ACL_NOT_CACHED)
 			return -ECHILD;
-	        return posix_acl_permission(inode, acl, mask);
+	        return posix_acl_permission(inode, acl, mask & ~MAY_NOT_BLOCK);
 	}
 
 	acl = get_cached_acl(inode, ACL_TYPE_ACCESS);
-- 
1.7.4.1

