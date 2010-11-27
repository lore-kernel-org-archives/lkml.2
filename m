Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0K0Kfv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:35:51 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34794 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561Ab0K0K0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcFAO1p8Ex5Lcx2/2dsb2JhbACVC44Acr12hUcEimGFFA
Message-Id: <bb3f4a29b5a011895e33aba9f5fc2977c43ed0e5.1290852958.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:36 +1100
Subject: [PATCH 06/46] cifs: dont overwrite dentry name in d_revalidate
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
 fs/cifs/dir.c |   43 ++++++++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 3840edd..521d841 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -656,22 +656,34 @@ lookup_out:
 static int
 cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
 {
-	int isValid = 1;
-
 	if (direntry->d_inode) {
 		if (cifs_revalidate_dentry(direntry))
 			return 0;
-	} else {
-		cFYI(1, "neg dentry 0x%p name = %s",
-			 direntry, direntry->d_name.name);
-		if (time_after(jiffies, direntry->d_time + HZ) ||
-			!lookupCacheEnabled) {
-			d_drop(direntry);
-			isValid = 0;
-		}
+		else
+			return 1;
 	}
 
-	return isValid;
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
+
+	if (time_after(jiffies, direntry->d_time + HZ) || !lookupCacheEnabled)
+		return 0;
+
+	return 1;
 }
 
 /* static int cifs_d_delete(struct dentry *direntry)
@@ -709,15 +721,8 @@ static int cifs_ci_compare(struct dentry *dentry, struct qstr *a,
 	struct nls_table *codepage = CIFS_SB(dentry->d_inode->i_sb)->local_nls;
 
 	if ((a->len == b->len) &&
-	    (nls_strnicmp(codepage, a->name, b->name, a->len) == 0)) {
-		/*
-		 * To preserve case, don't let an existing negative dentry's
-		 * case take precedence.  If a is not a negative dentry, this
-		 * should have no side effects
-		 */
-		memcpy((void *)a->name, b->name, a->len);
+	    (nls_strnicmp(codepage, a->name, b->name, a->len) == 0))
 		return 0;
-	}
 	return 1;
 }
 
-- 
1.7.1

