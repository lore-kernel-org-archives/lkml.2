Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab0K0Kfb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:35:31 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34802 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582Ab0K0K0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcFAO1p8Ex5Lcx2/2dsb2JhbACVC44Acr12hUcEimGFFA
Message-Id: <166004d5b1b60f7db3dc2a212871761b0066f585.1290852958.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:37 +1100
Subject: [PATCH 07/46] jfs: dont overwrite dentry name in d_revalidate
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use vfat's method for dealing with negative dentries to preserve case,
rather than overwrite dentry name in d_revalidate, which is a bit ugly
and also gets in the way of doing lock-free path walking.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/jfs/namei.c |   43 +++++++++++++++++++++++++++++++++++--------
 1 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 231ca4a..2da1546 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/namei.h>
 #include <linux/ctype.h>
 #include <linux/quotaops.h>
 #include <linux/exportfs.h>
@@ -1597,21 +1598,47 @@ static int jfs_ci_compare(struct dentry *dir, struct qstr *a, struct qstr *b)
 			goto out;
 	}
 	result = 0;
+out:
+	return result;
+}
 
+static int jfs_ci_revalidate(struct dentry *dentry, struct nameidata *nd)
+{
 	/*
-	 * We want creates to preserve case.  A negative dentry, a, that
-	 * has a different case than b may cause a new entry to be created
-	 * with the wrong case.  Since we can't tell if a comes from a negative
-	 * dentry, we blindly replace it with b.  This should be harmless if
-	 * a is not a negative dentry.
+	 * This is not negative dentry. Always valid.
+	 *
+	 * Note, rename() to existing directory entry will have ->d_inode,
+	 * and will use existing name which isn't specified name by user.
+	 *
+	 * We may be able to drop this positive dentry here. But dropping
+	 * positive dentry isn't good idea. So it's unsupported like
+	 * rename("filename", "FILENAME") for now.
 	 */
-	memcpy((unsigned char *)a->name, b->name, a->len);
-out:
-	return result;
+	if (dentry->d_inode)
+		return 1;
+
+	/*
+	 * This may be nfsd (or something), anyway, we can't see the
+	 * intent of this. So, since this can be for creation, drop it.
+	 */
+	if (!nd)
+		return 0;
+
+	/*
+	 * Drop the negative dentry, in order to make sure to use the
+	 * case sensitive name which is specified by user if this is
+	 * for creation.
+	 */
+	if (!(nd->flags & (LOOKUP_CONTINUE | LOOKUP_PARENT))) {
+		if (nd->flags & (LOOKUP_CREATE | LOOKUP_RENAME_TARGET))
+			return 0;
+	}
+	return 1;
 }
 
 const struct dentry_operations jfs_ci_dentry_operations =
 {
 	.d_hash = jfs_ci_hash,
 	.d_compare = jfs_ci_compare,
+	.d_revalidate = jfs_ci_revalidate,
 };
-- 
1.7.1

