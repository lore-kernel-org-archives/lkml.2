Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab2EAPTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 11:19:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46409 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362Ab2EAPR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 11:17:58 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 2/5] overlayfs: switch to use inode_only_permissions
Date: Tue,  1 May 2012 16:17:52 +0100
Message-Id: <1335885475-11990-3-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1335885475-11990-1-git-send-email-apw@canonical.com>
References: <1335885475-11990-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When checking permissions on an overlayfs inode we do not take into
account either device cgroup restrictions nor security permissions.
This allows a user to mount an overlayfs layer over a restricted device
directory and by pass those permissions to open otherwise restricted
files.

Switch over to the newly introduced inode_only_permissions.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/overlayfs/inode.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index ba1a777..bc9178c 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -105,19 +105,9 @@ int ovl_permission(struct inode *inode, int mask)
 		if (is_upper && !IS_RDONLY(inode) && IS_RDONLY(realinode) &&
 		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
 			goto out_dput;
-
-		/*
-		 * Nobody gets write access to an immutable file.
-		 */
-		err = -EACCES;
-		if (IS_IMMUTABLE(realinode))
-			goto out_dput;
 	}
 
-	if (realinode->i_op->permission)
-		err = realinode->i_op->permission(realinode, mask);
-	else
-		err = generic_permission(realinode, mask);
+	err = inode_only_permission(realinode, mask);
 out_dput:
 	dput(alias);
 	return err;
-- 
1.7.9.5

