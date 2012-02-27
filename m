Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2B0WXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:23:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38799 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab2B0WXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:23:41 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 1/7] AppArmor: Retrieve the dentry_path for error reporting when path lookup fails
Date: Mon, 27 Feb 2012 14:23:11 -0800
Message-Id: <1330381397-5352-2-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330381397-5352-1-git-send-email-john.johansen@canonical.com>
References: <1330381397-5352-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When __d_path and d_absolute_path fail due to the name being outside of
the current namespace no name is reported.  Use dentry_path to provide
some hint as to which file was being accessed.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Acked-by: Kees Cook <kees@ubuntu.com>
---
 security/apparmor/path.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/security/apparmor/path.c b/security/apparmor/path.c
index c31ce83..b3cf4cd 100644
--- a/security/apparmor/path.c
+++ b/security/apparmor/path.c
@@ -94,18 +94,21 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
 	} else
 		res = d_absolute_path(path, buf, buflen);
 
-	*name = res;
 	/* handle error conditions - and still allow a partial path to
 	 * be returned.
 	 */
 	if (IS_ERR(res)) {
-		error = PTR_ERR(res);
-		*name = buf;
-		goto out;
-	}
-	if (!our_mnt(path->mnt))
+		res = dentry_path_raw(path->dentry, buf, buflen);
+		if (IS_ERR(res)) {
+			error = PTR_ERR(res);
+			*name = buf;
+			goto out;
+		};
+	} else if (!our_mnt(path->mnt))
 		connected = 0;
 
+	*name = res;
+
 ok:
 	/* Handle two cases:
 	 * 1. A deleted dentry && profile is not allowing mediation of deleted
-- 
1.7.9

