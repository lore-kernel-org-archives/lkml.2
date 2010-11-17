Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935169Ab0KQRhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:37:13 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43760 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935136Ab0KQRhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:37:10 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 2/2] overlayfs: ovl_copy_up_xattr -- handle EOPNOTSUPP from vfs_listxattr
Date: Wed, 17 Nov 2010 17:37:04 +0000
Message-Id: <1290015424-5583-3-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290015424-5583-1-git-send-email-apw@canonical.com>
References: <1290015424-5583-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even when an underlying filesystem had a getxattr op it may not support
xattrs.  In this case vfs_listxattr will return EOPNOTSUPP.  Handle
this return when copying up attributes.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/overlayfs/overlayfs.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/overlayfs/overlayfs.c b/fs/overlayfs/overlayfs.c
index 6b8a7b9..1148b8c 100644
--- a/fs/overlayfs/overlayfs.c
+++ b/fs/overlayfs/overlayfs.c
@@ -692,8 +692,11 @@ static int ovl_copy_up_xattr(struct dentry *old, struct dentry *new)
 		return 0;
 
 	list_size = vfs_listxattr(old, NULL, 0);
-	if (list_size <= 0)
+	if (list_size <= 0) {
+		if (list_size == -EOPNOTSUPP)
+			return 0;
 		return list_size;
+	}
 
 	buf = kzalloc(list_size, GFP_KERNEL);
 	if (!buf)
-- 
1.7.0.4

