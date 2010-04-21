Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab0DUVxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:53:15 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58861 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab0DUVvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:51:04 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 05/14] ima: move ima_file_free before releasing the file
Date: Wed, 21 Apr 2010 17:49:45 -0400
Message-Id: <1271886594-3719-6-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrity appraisal measures files on file_free and stores the file
measurement as an xattr.  Measure the file before releasing it.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>

diff --git a/fs/file_table.c b/fs/file_table.c
index 32d12b7..fac3e43 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -250,10 +250,10 @@ void __fput(struct file *file)
 		if (file->f_op && file->f_op->fasync)
 			file->f_op->fasync(-1, file, 0);
 	}
+	ima_file_free(file);
 	if (file->f_op && file->f_op->release)
 		file->f_op->release(inode, file);
 	security_file_free(file);
-	ima_file_free(file);
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
-- 
1.6.6.1

