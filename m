Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab2CFQS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:18:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42581 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab2CFQSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:18:09 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: [PATCH 2/2] overlayfs: switch to use inode_only_permissions
Date: Tue,  6 Mar 2012 16:18:06 +0000
Message-Id: <1331050686-1815-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1331050686-1815-1-git-send-email-apw@canonical.com>
References: <20120306161224.GE9978@shadowen.org>
 <1331050686-1815-1-git-send-email-apw@canonical.com>
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
 fs/overlayfs/inode.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index ba1a777..1e3d157 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -114,10 +114,7 @@ int ovl_permission(struct inode *inode, int mask)
 			goto out_dput;
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
1.7.9

