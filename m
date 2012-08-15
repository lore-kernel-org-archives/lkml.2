Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab2HOPsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:48:01 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56976 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab2HOPr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:47:57 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com, dhowells@redhat.com,
        hpj@urpla.net, sedat.dilek@googlemail.com, penberg@kernel.org,
        goran.cetusic@gmail.com, romain@orebokech.com, mszeredi@suse.cz
Subject: [PATCH 12/13] ovl: switch to __inode_permission()
Date: Wed, 15 Aug 2012 17:48:19 +0200
Message-Id: <1345045700-9062-13-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

When checking permissions on an overlayfs inode we do not take into
account either device cgroup restrictions nor security permissions.
This allows a user to mount an overlayfs layer over a restricted device
directory and by pass those permissions to open otherwise restricted
files.

Switch over to __inode_permissions.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/inode.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index e854720..f3a534f 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -100,19 +100,9 @@ int ovl_permission(struct inode *inode, int mask)
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
+	err = __inode_permission(realinode, mask);
 out_dput:
 	dput(alias);
 	return err;
-- 
1.7.7

