Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515Ab2IGLzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:55:36 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54684 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760370Ab2IGLzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:55:32 -0400
From: Jeff Layton <jlayton@redhat.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 9p: don't use __getname/__putname for uname/aname
Date: Fri,  7 Sep 2012 07:55:25 -0400
Message-Id: <1347018925-18582-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are generally very small strings. We don't need an entire 4k
allocation for each. Instead, just free and reallocate them on an
as-needed basis.

Note: This patch is untested since I don't have a 9p server available at
the moment. It's mainly something I noticed while doing some
getname/putname cleanup work.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/9p/v9fs.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index b85efa7..b20af74 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -184,10 +184,20 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 			v9ses->afid = option;
 			break;
 		case Opt_uname:
-			match_strlcpy(v9ses->uname, &args[0], PATH_MAX);
+			kfree(v9ses->uname);
+			v9ses->uname = match_strdup(&args[0]);
+			if (!v9ses->uname) {
+				ret = -ENOMEM;
+				goto free_and_return;
+			}
 			break;
 		case Opt_remotename:
-			match_strlcpy(v9ses->aname, &args[0], PATH_MAX);
+			kfree(v9ses->aname);
+			v9ses->aname = match_strdup(&args[0]);
+			if (!v9ses->aname) {
+				ret = -ENOMEM;
+				goto free_and_return;
+			}
 			break;
 		case Opt_nodevmap:
 			v9ses->nodev = 1;
@@ -287,21 +297,21 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 	struct p9_fid *fid;
 	int rc;
 
-	v9ses->uname = __getname();
+	v9ses->uname = kstrdup(V9FS_DEFUSER, GFP_KERNEL);
 	if (!v9ses->uname)
 		return ERR_PTR(-ENOMEM);
 
-	v9ses->aname = __getname();
+	v9ses->aname = kstrdup(V9FS_DEFANAME, GFP_KERNEL);
 	if (!v9ses->aname) {
-		__putname(v9ses->uname);
+		kfree(v9ses->uname);
 		return ERR_PTR(-ENOMEM);
 	}
 	init_rwsem(&v9ses->rename_sem);
 
 	rc = bdi_setup_and_register(&v9ses->bdi, "9p", BDI_CAP_MAP_COPY);
 	if (rc) {
-		__putname(v9ses->aname);
-		__putname(v9ses->uname);
+		kfree(v9ses->aname);
+		kfree(v9ses->uname);
 		return ERR_PTR(rc);
 	}
 
@@ -309,8 +319,6 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 	list_add(&v9ses->slist, &v9fs_sessionlist);
 	spin_unlock(&v9fs_sessionlist_lock);
 
-	strcpy(v9ses->uname, V9FS_DEFUSER);
-	strcpy(v9ses->aname, V9FS_DEFANAME);
 	v9ses->uid = ~0;
 	v9ses->dfltuid = V9FS_DEFUID;
 	v9ses->dfltgid = V9FS_DEFGID;
@@ -412,8 +420,8 @@ void v9fs_session_close(struct v9fs_session_info *v9ses)
 		kfree(v9ses->cachetag);
 	}
 #endif
-	__putname(v9ses->uname);
-	__putname(v9ses->aname);
+	kfree(v9ses->uname);
+	kfree(v9ses->aname);
 
 	bdi_destroy(&v9ses->bdi);
 
-- 
1.7.11.4

