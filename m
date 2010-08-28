Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab0H1Bdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 21:33:39 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46578 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab0H1Bdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 21:33:38 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 1/4] AppArmor: Drop hack to remove appended " (deleted)" string
Date: Fri, 27 Aug 2010 18:33:26 -0700
Message-Id: <1282959209-5431-2-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282959209-5431-1-git-send-email-john.johansen@canonical.com>
References: <1282959209-5431-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 2.6.36 kernel has refactored __d_path() so that it no longer appends
" (deleted)" to unlinked paths.  So drop the hack that was used to detect
and remove the appended string.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/path.c |   38 +++++++++++---------------------------
 1 files changed, 11 insertions(+), 27 deletions(-)

diff --git a/security/apparmor/path.c b/security/apparmor/path.c
index 19358dc..8239605 100644
--- a/security/apparmor/path.c
+++ b/security/apparmor/path.c
@@ -59,8 +59,7 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
 {
 	struct path root, tmp;
 	char *res;
-	int deleted, connected;
-	int error = 0;
+	int connected, error = 0;
 
 	/* Get the root we want to resolve too, released below */
 	if (flags & PATH_CHROOT_REL) {
@@ -74,19 +73,8 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
 	}
 
 	spin_lock(&dcache_lock);
-	/* There is a race window between path lookup here and the
-	 * need to strip the " (deleted) string that __d_path applies
-	 * Detect the race and relookup the path
-	 *
-	 * The stripping of (deleted) is a hack that could be removed
-	 * with an updated __d_path
-	 */
-	do {
-		tmp = root;
-		deleted = d_unlinked(path->dentry);
-		res = __d_path(path, &tmp, buf, buflen);
-
-	} while (deleted != d_unlinked(path->dentry));
+	tmp = root;
+	res = __d_path(path, &tmp, buf, buflen);
 	spin_unlock(&dcache_lock);
 
 	*name = res;
@@ -98,21 +86,17 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
 		*name = buf;
 		goto out;
 	}
-	if (deleted) {
-		/* On some filesystems, newly allocated dentries appear to the
-		 * security_path hooks as a deleted dentry except without an
-		 * inode allocated.
-		 *
-		 * Remove the appended deleted text and return as string for
-		 * normal mediation, or auditing.  The (deleted) string is
-		 * guaranteed to be added in this case, so just strip it.
-		 */
-		buf[buflen - 11] = 0;	/* - (len(" (deleted)") +\0) */
 
-		if (path->dentry->d_inode && !(flags & PATH_MEDIATE_DELETED)) {
+	/* Handle two cases:
+	 * 1. A deleted dentry && profile is not allowing mediation of deleted
+	 * 2. On some filesystems, newly allocated dentries appear to the
+	 *    security_path hooks as a deleted dentry except without an inode
+	 *    allocated.
+	 */
+	if (d_unlinked(path->dentry) && path->dentry->d_inode &&
+	    !(flags & PATH_MEDIATE_DELETED)) {
 			error = -ENOENT;
 			goto out;
-		}
 	}
 
 	/* Determine if the path is connected to the expected root */
-- 
1.7.0.4

