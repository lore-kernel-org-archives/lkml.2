Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab0LMWhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 17:37:01 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21988 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab0LMWg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 17:36:59 -0500
Date: Mon, 13 Dec 2010 23:30:36 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH] Don't leak memory in failure paths of gfs2_acl_get()
Message-ID: <alpine.LNX.2.00.1012132324550.26491@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In fs/gfs2/acl.c::gfs2_acl_get() we may leak memory in failure scenarios.
gfs2_xattr_acl_get() may return <=0 after having dynamically allocated 
memory for its last argument ('data' in the gfs2_acl_get() caller) and in 
that case the caller leaks the memory.
This patch initializes 'data' to NULL and calls kfree() on 'data' in the 
the failure paths. This ensures that we always free the memory on failure 
or that we just call kfree(NULL) on failures where no memory has actually 
been allocated yet.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 acl.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index 48171f4..e7e45ab 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -42,7 +42,7 @@ static struct posix_acl *gfs2_acl_get(struct gfs2_inode *ip, int type)
 {
 	struct posix_acl *acl;
 	const char *name;
-	char *data;
+	char *data = NULL;
 	int len;
 
 	if (!ip->i_eattr)
@@ -57,10 +57,14 @@ static struct posix_acl *gfs2_acl_get(struct gfs2_inode *ip, int type)
 		return ERR_PTR(-EINVAL);
 
 	len = gfs2_xattr_acl_get(ip, name, &data);
-	if (len < 0)
+	if (len < 0) {
+		kfree(data);
 		return ERR_PTR(len);
-	if (len == 0)
+	}
+	if (len == 0) {
+		kfree(data);
 		return NULL;
+	}
 
 	acl = posix_acl_from_xattr(data, len);
 	kfree(data);



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

