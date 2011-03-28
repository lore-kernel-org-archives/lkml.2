Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab1C1QlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:41:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50218 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959Ab1C1QlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:41:13 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v4 05/11] ima: move ima_file_free before releasing the file
Date: Mon, 28 Mar 2011 12:39:36 -0400
Message-Id: <1301330382-17745-6-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301330382-17745-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1301330382-17745-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrity appraisal measures files on file_free and stores the file
measurement as an xattr.  Measure the file before releasing it.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
---
 fs/file_table.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 01e4c1e..33f54a1 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -243,10 +243,10 @@ static void __fput(struct file *file)
 		if (file->f_op && file->f_op->fasync)
 			file->f_op->fasync(-1, file, 0);
 	}
+	ima_file_free(file);
 	if (file->f_op && file->f_op->release)
 		file->f_op->release(inode, file);
 	security_file_free(file);
-	ima_file_free(file);
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL &&
 		     !(file->f_mode & FMODE_PATH))) {
 		cdev_put(inode->i_cdev);
-- 
1.7.3.4

