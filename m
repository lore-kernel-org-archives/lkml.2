Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934803Ab0EENP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 09:15:57 -0400
Received: from mail-ew0-f222.google.com ([209.85.219.222]:61180 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934760Ab0EENP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 09:15:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=uLrgcC996jns6T3oPctMtZaQzYYkd24Irccw60a83ZqsK5dLJUjyFbep+Jc94RH/Dn
         nKQu54F8eM0aH0bEVa9ATFq8WHqb0NOVELMNKqvZbinl+TjzK4tDbkQ3eBVWNGCNP64W
         mzdoB9KWdfpExOyh4dL5XavWMBAe0Us5damAo=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Kacur <jkacur@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu
Subject: [PATCH 1/6] coda: BKL ioctl pushdown
Date: Wed,  5 May 2010 15:15:34 +0200
Message-Id: <1273065339-21669-2-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1273065339-21669-1-git-send-email-jkacur@redhat.com>
References: <1273065339-21669-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert coda_pioctl to an unlocked_ioctl pushing down the BKL into it.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 fs/coda/pioctl.c |   41 ++++++++++++++++++++++++-----------------
 1 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/fs/coda/pioctl.c b/fs/coda/pioctl.c
index 773f2ce..96ace2c 100644
--- a/fs/coda/pioctl.c
+++ b/fs/coda/pioctl.c
@@ -23,10 +23,12 @@
 #include <linux/coda_fs_i.h>
 #include <linux/coda_psdev.h>
 
+#include <linux/smp_lock.h>
+
 /* pioctl ops */
 static int coda_ioctl_permission(struct inode *inode, int mask);
-static int coda_pioctl(struct inode * inode, struct file * filp, 
-                       unsigned int cmd, unsigned long user_data);
+static long coda_pioctl(struct file *filp, unsigned int cmd,
+			unsigned long user_data);
 
 /* exported from this file */
 const struct inode_operations coda_ioctl_inode_operations =
@@ -37,7 +39,7 @@ const struct inode_operations coda_ioctl_inode_operations =
 
 const struct file_operations coda_ioctl_operations = {
 	.owner		= THIS_MODULE,
-	.ioctl		= coda_pioctl,
+	.unlocked_ioctl	= coda_pioctl,
 };
 
 /* the coda pioctl inode ops */
@@ -46,40 +48,43 @@ static int coda_ioctl_permission(struct inode *inode, int mask)
 	return (mask & MAY_EXEC) ? -EACCES : 0;
 }
 
-static int coda_pioctl(struct inode * inode, struct file * filp, 
-                       unsigned int cmd, unsigned long user_data)
+static long coda_pioctl(struct file *filp, unsigned int cmd,
+			unsigned long user_data)
 {
 	struct path path;
         int error;
 	struct PioctlData data;
+	struct inode *inode = filp->f_dentry->d_inode;
         struct inode *target_inode = NULL;
         struct coda_inode_info *cnp;
 
+	lock_kernel();
+
         /* get the Pioctl data arguments from user space */
         if (copy_from_user(&data, (void __user *)user_data, sizeof(data))) {
-	    return -EINVAL;
+		error = -EINVAL;
+		goto out;
 	}
        
         /* 
          * Look up the pathname. Note that the pathname is in 
          * user memory, and namei takes care of this
          */
-        if (data.follow) {
+	if (data.follow)
                 error = user_path(data.path, &path);
-	} else {
+	else
 	        error = user_lpath(data.path, &path);
-	}
-		
-	if ( error ) {
-		return error;
-        } else {
+
+	if (error)
+		goto out;
+	else
 		target_inode = path.dentry->d_inode;
-	}
-	
+
 	/* return if it is not a Coda inode */
 	if ( target_inode->i_sb != inode->i_sb ) {
 		path_put(&path);
-	        return  -EINVAL;
+		error = -EINVAL;
+		goto out;
 	}
 
 	/* now proceed to make the upcall */
@@ -88,6 +93,8 @@ static int coda_pioctl(struct inode * inode, struct file * filp,
 	error = venus_pioctl(inode->i_sb, &(cnp->c_fid), cmd, &data);
 
 	path_put(&path);
+
+out:
+	unlock_kernel();
         return error;
 }
-
-- 
1.6.6.1

