Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab2DUVBA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 17:01:00 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22580 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2DUVA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 17:00:59 -0400
Date: Sat, 21 Apr 2012 23:00:57 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] GFS2: Fix mem leak in gfs2_get_acl()
Message-ID: <alpine.LNX.2.00.1204212258130.25551@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If gfs2_xattr_acl_get() returns 0 - which, as far as I can tell, it
may do independently of having allocated memory for its third argument
('data' in this case) - then we may leak the memory allocated to data.

This patch initializes 'data' to NULL so that it will be safe to call
kfree() on it even if we do not allocate anything and also makes sure
that we kfree(data) in the 'len == 0' case.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/gfs2/acl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

 Note: I have tested that this change compiles. It has seen no other 
       testing than that.

diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index 230eb0f..d254d98 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -43,7 +43,7 @@ struct posix_acl *gfs2_get_acl(struct inode *inode, int type)
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct posix_acl *acl;
 	const char *name;
-	char *data;
+	char *data = NULL;
 	int len;
 
 	if (!ip->i_eattr)
@@ -60,8 +60,10 @@ struct posix_acl *gfs2_get_acl(struct inode *inode, int type)
 	len = gfs2_xattr_acl_get(ip, name, &data);
 	if (len < 0)
 		return ERR_PTR(len);
-	if (len == 0)
+	if (len == 0) {
+		kfree(data);
 		return NULL;
+	}
 
 	acl = posix_acl_from_xattr(data, len);
 	kfree(data);
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

