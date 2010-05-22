Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab0EVIW1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:22:27 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:34876 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab0EVIWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:22:23 -0400
Date: Sat, 22 May 2010 10:22:17 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Ian Kent <raven@themaw.net>, autofs@linux.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 13/27] fs/autofs4: Use memdup_user
Message-ID: <Pine.LNX.4.64.1005221022010.13021@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use memdup_user when user data is immediately copied into the allocated
region.  Elimination of the variable ads, which is no longer useful.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
position p;
identifier l1,l2;
@@

-  to = \(kmalloc@p\|kzalloc@p\)(size,flag);
+  to = memdup_user(from,size);
   if (
-      to==NULL
+      IS_ERR(to)
                 || ...) {
   <+... when != goto l1;
-  -ENOMEM
+  PTR_ERR(to)
   ...+>
   }
-  if (copy_from_user(to, from, size) != 0) {
-    <+... when != goto l2;
-    -EFAULT
-    ...+>
-  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/autofs4/dev-ioctl.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index d29b7f6..33d8fc6 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -95,7 +95,7 @@ static int check_dev_ioctl_version(int cmd, struct autofs_dev_ioctl *param)
  */
 static struct autofs_dev_ioctl *copy_dev_ioctl(struct autofs_dev_ioctl __user *in)
 {
-	struct autofs_dev_ioctl tmp, *ads;
+	struct autofs_dev_ioctl tmp;
 
 	if (copy_from_user(&tmp, in, sizeof(tmp)))
 		return ERR_PTR(-EFAULT);
@@ -103,16 +103,7 @@ static struct autofs_dev_ioctl *copy_dev_ioctl(struct autofs_dev_ioctl __user *i
 	if (tmp.size < sizeof(tmp))
 		return ERR_PTR(-EINVAL);
 
-	ads = kmalloc(tmp.size, GFP_KERNEL);
-	if (!ads)
-		return ERR_PTR(-ENOMEM);
-
-	if (copy_from_user(ads, in, tmp.size)) {
-		kfree(ads);
-		return ERR_PTR(-EFAULT);
-	}
-
-	return ads;
+	return memdup_user(in, tmp.size);
 }
 
 static inline void free_dev_ioctl(struct autofs_dev_ioctl *param)
