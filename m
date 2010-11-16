Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118Ab0KPOYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:24:53 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:2280 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758711Ab0KPOYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:24:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogKAKMh4kx5Ldur/2dsb2JhbACUX4ECjH1yvmaFSwSKWIUQ
Message-Id: <20101116142028.741959418@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:06 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 06/28] jfs: dont overwrite dentry name in d_revalidate
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=jfs-d_compare-constify.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use vfat's method for dealing with negative dentries to preserve case,
rather than overwrite dentry name in d_revalidate, which is a bit ugly
and also gets in the way of doing lock-free path walking.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/jfs/namei.c |   43 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

Index: linux-2.6/fs/jfs/namei.c
===================================================================
--- linux-2.6.orig/fs/jfs/namei.c	2010-11-17 00:50:54.000000000 +1100
+++ linux-2.6/fs/jfs/namei.c	2010-11-17 01:05:50.000000000 +1100
@@ -18,6 +18,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/namei.h>
 #include <linux/ctype.h>
 #include <linux/quotaops.h>
 #include <linux/exportfs.h>
@@ -1597,21 +1598,47 @@ static int jfs_ci_compare(struct dentry
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


