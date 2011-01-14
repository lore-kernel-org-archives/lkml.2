Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab1ANDiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:38:25 -0500
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:38063 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab1ANDiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:38:19 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: Nick Piggin <npiggin@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: vfs-scale, keep the errno
Date: Fri, 14 Jan 2011 12:38:15 +0900
Message-ID: <8406.1294976295@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When open(2) without O_DIRECTORY opens an existing dir, it should return
EISDIR. In do_last(), the variable 'error' is initialized EISDIR, but it
is changed by d_revalidate() which returns any positive to represent
'the target dir is valid.'
Should we keep and return the initialized 'error' in this case.


J. R. Okajima

diff --git a/fs/namei.c b/fs/namei.c
index 5bb7588..26fa823 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2102,17 +2118,20 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	struct file *filp;
 	int error = -EISDIR;
 
 	switch (nd->last_type) {
 	case LAST_DOTDOT:
 		follow_dotdot(nd);
 		dir = nd->path.dentry;
 	case LAST_DOT:
 		if (need_reval_dot(dir)) {
-			error = d_revalidate(nd->path.dentry, nd);
-			if (!error)
+			int e;
+			e = d_revalidate(nd->path.dentry, nd);
+			if (!e)
 				error = -ESTALE;
-			if (error < 0)
+			if (e < 0) {
+				error = e;
 				goto exit;
+			}
 		}
 		/* fallthrough */
 	case LAST_ROOT:

