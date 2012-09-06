Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab2IFP4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:56:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44557 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557Ab2IFP4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:56:37 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: [RFC PATCH 1/2] ovl: ovl_copy_up_xattr may fail when the upper filesystem does not support the same xattrs
Date: Thu,  6 Sep 2012 16:56:33 +0100
Message-Id: <1346946994-21286-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346946994-21286-1-git-send-email-apw@canonical.com>
References: <1346946994-21286-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the upper filesystem does not support the same extended attribute
families as the lower filesystem attempts to copy these xattrs up will
fail EOPNOTSUPP.  This is tickled by NFS which stores access information
in an NFS specific prefix.  Ignore failures to set these attributes.

BugLink: http://bugs.launchpad.net/bugs/1039402
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/overlayfs/copy_up.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 87dbeee..b0b4229 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -58,7 +58,14 @@ static int ovl_copy_up_xattr(struct dentry *old, struct dentry *new)
 			goto out_free_value;
 		}
 		error = vfs_setxattr(new, name, value, size, 0);
-		if (error)
+		/*
+		 * It is possible that the upper filesystem does not
+                 * support the same xattrs as the lower filesystem.  Ignore
+                 * unsupported types.
+                 */
+		if (error == -EOPNOTSUPP)
+			error = 0;
+		else if (error)
 			goto out_free_value;
 	}
 
-- 
1.7.9.5

