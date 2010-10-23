Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab0JWLiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 07:38:11 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:63037 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab0JWLiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 07:38:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=RJqyqA3EcIG+gqBOk58mVLfiLTcoqXBULB2ZnQ8ooBCy2WWTKkLumPeTc5DTX+Fu1P
         /u74MfHtvYdf5oxe4CYgmdGEktdOuRETY8GEKp3p1U2Mu6ZNsK0JxHlkW5JhnM/Gm4b2
         a8CmGoCFQQn6zJmzR+K+oYhk+SuPTs3YN5rkE=
From: Alessio Igor Bogani <abogani@texware.it>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 5/6] udf: Remove BKL
Date: Sat, 23 Oct 2010 13:37:32 +0200
Message-Id: <1287833853-4175-5-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1287833853-4175-1-git-send-email-abogani@texware.it>
References: <1287833853-4175-1-git-send-email-abogani@texware.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the udf_ioctl function replace the bkl with s_lock only for udf_relocate_blocks
function invoked from the first one.

In the udf_release_file function the data should be already protected by use
of i_mutex.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/udf/file.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index 66b9e7e..75a9e99 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -32,7 +32,7 @@
 #include <linux/string.h> /* memset */
 #include <linux/capability.h>
 #include <linux/errno.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
 #include <linux/aio.h>
@@ -149,8 +149,6 @@ long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	long old_block, new_block;
 	int result = -EINVAL;
 
-	lock_kernel();
-
 	if (file_permission(filp, MAY_READ) != 0) {
 		udf_debug("no permission to access inode %lu\n", inode->i_ino);
 		result = -EPERM;
@@ -180,8 +178,10 @@ long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			result = -EFAULT;
 			goto out;
 		}
+		mutex_lock(&inode->i_sb->s_lock);
 		result = udf_relocate_blocks(inode->i_sb,
 						old_block, &new_block);
+		mutex_unlock(&inode->i_sb->s_lock);
 		if (result == 0)
 			result = put_user(new_block, (long __user *)arg);
 		goto out;
@@ -196,7 +196,6 @@ long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 
 out:
-	unlock_kernel();
 	return result;
 }
 
@@ -204,10 +203,8 @@ static int udf_release_file(struct inode *inode, struct file *filp)
 {
 	if (filp->f_mode & FMODE_WRITE) {
 		mutex_lock(&inode->i_mutex);
-		lock_kernel();
 		udf_discard_prealloc(inode);
 		udf_truncate_tail_extent(inode);
-		unlock_kernel();
 		mutex_unlock(&inode->i_mutex);
 	}
 	return 0;
-- 
1.7.0.4

