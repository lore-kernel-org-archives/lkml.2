Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab2B0WXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:23:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38800 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab2B0WXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:23:43 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 2/7] AppArmor: Minor cleanup of d_namespace_path to consolidate error handling
Date: Mon, 27 Feb 2012 14:23:12 -0800
Message-Id: <1330381397-5352-3-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330381397-5352-1-git-send-email-john.johansen@canonical.com>
References: <1330381397-5352-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Johansen <john.johansen@canonical.com>
Acked-by: Kees Cook <kees@ubuntu.com>
---
 security/apparmor/path.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/security/apparmor/path.c b/security/apparmor/path.c
index b3cf4cd..95a589e 100644
--- a/security/apparmor/path.c
+++ b/security/apparmor/path.c
@@ -83,21 +83,18 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
 		struct path root;
 		get_fs_root(current->fs, &root);
 		res = __d_path(path, &root, buf, buflen);
-		if (res && !IS_ERR(res)) {
-			/* everything's fine */
-			*name = res;
-			path_put(&root);
-			goto ok;
-		}
 		path_put(&root);
-		connected = 0;
-	} else
+	} else {
 		res = d_absolute_path(path, buf, buflen);
+		if (!our_mnt(path->mnt))
+			connected = 0;
+	}
 
 	/* handle error conditions - and still allow a partial path to
 	 * be returned.
 	 */
-	if (IS_ERR(res)) {
+	if (!res || IS_ERR(res)) {
+		connected = 0;
 		res = dentry_path_raw(path->dentry, buf, buflen);
 		if (IS_ERR(res)) {
 			error = PTR_ERR(res);
@@ -109,7 +106,6 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
 
 	*name = res;
 
-ok:
 	/* Handle two cases:
 	 * 1. A deleted dentry && profile is not allowing mediation of deleted
 	 * 2. On some filesystems, newly allocated dentries appear to the
-- 
1.7.9

