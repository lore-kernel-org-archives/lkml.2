Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453Ab2C2Oou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:44:50 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:50182 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759505Ab2C2Omf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:42:35 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v4 02/12] vfs: move ima_file_free before releasing the file
Date: Thu, 29 Mar 2012 10:41:30 -0400
Message-Id: <1333032100-4159-3-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1333032100-4159-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1333032100-4159-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032914-3352-0000-0000-000003AA0929
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ima_file_free(), called on __fput(), currently flags files that have
changed, so that the file is re-measured.  For appraising a files's
integrity, the file's hash must be re-calculated and stored in the
'security.ima' xattr to reflect any changes.

This patch moves the ima_file_free() call to before releasing the file
in preparation of ima-appraisal measuring the file and updating the
'security.ima' xattr.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
Acked-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 fs/file_table.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 20002e3..554161a 100644
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
1.7.6.5

