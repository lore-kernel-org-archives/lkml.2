Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab1BBTTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 14:19:06 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:64886 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915Ab1BBTTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 14:19:04 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: Nick Piggin <npiggin@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] fix filp_cachep memory corruption
Date: Thu, 03 Feb 2011 04:18:58 +0900
Message-ID: <12967.1296674338@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit e1ddf5b0dd3e8234581c78c3cadd6e2adfe6e2d4
Author: J. R. Okajima <hooanon05@yahoo.co.jp>
Date:   Thu Feb 3 03:38:12 2011 +0900

    fix filp_cachep memory corruption
    
    By the commit
    	31e6b01 2011-01-07 fs: rcu-walk for path lookup
    the condition "-ESTALE && !LOOKUP_REVAL" is added to "goto reval" in
    do_filp_open(), and it lookup again with LOOKUP_REVAL _after_
    release_open_intent(). Since release_open_intent() is called by
    do_last() and finish_open() too, add the same condition to all of them.
    
    Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>

diff --git a/fs/namei.c b/fs/namei.c
index 084be4d..1f62d6a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2269,7 +2269,8 @@ static struct file *finish_open(struct nameidata *nd,
 	return filp;
 
 exit:
-	if (!IS_ERR(nd->intent.open.file))
+	if (!(error == -ESTALE && !(nd->flags & LOOKUP_REVAL))
+	    && !IS_ERR(nd->intent.open.file))
 		release_open_intent(nd);
 	path_put(&nd->path);
 	return ERR_PTR(error);
@@ -2393,7 +2394,8 @@ exit_mutex_unlock:
 exit_dput:
 	path_put_conditional(path, nd);
 exit:
-	if (!IS_ERR(nd->intent.open.file))
+	if (!(error == -ESTALE && !(nd->flags & LOOKUP_REVAL))
+	    && !IS_ERR(nd->intent.open.file))
 		release_open_intent(nd);
 	path_put(&nd->path);
 	return ERR_PTR(error);
@@ -2564,7 +2566,8 @@ exit_dput:
 out_path:
 	path_put(&nd.path);
 out_filp:
-	if (!IS_ERR(nd.intent.open.file))
+	if (!(error == -ESTALE && !(flags & LOOKUP_REVAL))
+	    && !IS_ERR(nd.intent.open.file))
 		release_open_intent(&nd);
 	filp = ERR_PTR(error);
 	goto out;
