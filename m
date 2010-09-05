Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab0IESdD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:33:03 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46186 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab0IESc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:32:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QCaFdGRO6KCikLM6/jHTwszqeGy+3217bzsuNe4wh/YU1sLPO+wxq1Xs0LA69/9tXp
         8hYPqMgQUi17FH+hA67b7JJbEkoA0JJt5SMS7p6D+HLZujtIwCWX36TUfNr/dO6VhxOO
         nzy7WmCaLU25M12ofMBlCUMstKpFvMiJUQLjg=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        David Cross <david.cross@cypress.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] staging: westbridge: improve error path
Date: Sun,  5 Sep 2010 22:32:53 +0400
Message-Id: <1283711573-7460-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

kmalloc() may fail, check for it.
Allocated memory is not freed.
Use IS_ERR() instead of strict checking.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 I couldn't compile this driver at all, so it is not tested.

 .../staging/westbridge/astoria/gadget/cyasgadget.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/westbridge/astoria/gadget/cyasgadget.c b/drivers/staging/westbridge/astoria/gadget/cyasgadget.c
index ced239d..48080b3 100644
--- a/drivers/staging/westbridge/astoria/gadget/cyasgadget.c
+++ b/drivers/staging/westbridge/astoria/gadget/cyasgadget.c
@@ -1123,6 +1123,8 @@ static int cyasgadget_ioctl(
 
 		/* better use fixed size buff*/
 		alloc_filename = kmalloc(k_d.name_length + 1, GFP_KERNEL);
+		if (alloc_filename == NULL)
+			return -ENOMEM;
 
 		/* get the filename */
 		if (copy_from_user(alloc_filename, k_d.file_name,
@@ -1132,12 +1134,13 @@ static int cyasgadget_ioctl(
 				"copy file name from user space failed\n",
 				__func__);
 			#endif
+			kfree(alloc_filename);
 			return -EFAULT;
 		}
 
 		file_to_allocate = filp_open(alloc_filename, O_RDWR, 0);
 
-		if ((int)file_to_allocate != 0xfffffffe) {
+		if (!IS_ERR(file_to_allocate)) {
 
 			struct address_space *mapping =
 				file_to_allocate->f_mapping;
@@ -1379,6 +1382,7 @@ static int cyasgadget_ioctl(
 				__func__, alloc_filename);
 		} /* end if (file_to_allocate)*/
 		#endif
+		kfree(alloc_filename);
 initsoj_safe_exit:
 			ret_stat = 0;
 			retval = __put_user(ret_stat,
@@ -1410,12 +1414,15 @@ initsoj_safe_exit:
 				return -EFAULT;
 
 		map_filename = kmalloc(k_d.name_length + 1, GFP_KERNEL);
+		if (map_filename == NULL)
+			return -ENOMEM;
 		if (copy_from_user(map_filename, k_d.file_name,
 			k_d.name_length + 1)) {
 			#ifndef WESTBRIDGE_NDEBUG
 			cy_as_hal_print_message("%s: copy file name from "
 				"user space failed\n", __func__);
 			#endif
+			kfree(map_filename);
 			return -EFAULT;
 		}
 
@@ -1561,6 +1568,7 @@ initsoj_safe_exit:
 					__func__, map_filename);
 		}
 		#endif
+		kfree(map_filename);
 
 		ret_stat = 0;
 		retval = __put_user(ret_stat, (uint32_t __user *)
-- 
1.7.0.4

