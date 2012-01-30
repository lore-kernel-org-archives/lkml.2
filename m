Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab2A3WRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:17:22 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41852 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901Ab2A3WRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:17:19 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, David Safford <safford@watson.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [RFC][PATCH v1 2/9] vfs: move ima_file_free before releasing the file
Date: Mon, 30 Jan 2012 17:13:57 -0500
Message-Id: <1327961644-6886-3-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1327961644-6886-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1327961644-6886-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12013022-7182-0000-0000-0000009B3042
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ima_file_free(), called on __fput(), currently flags files that have
changed, so that the file is re-measured.  For appraising a files's
integrity, flagging the file is not enough.  The file's hash must be
re-calculated and stored in the 'security.ima' xattr to reflect any
changes.

This patch moves the ima_file_free() call to before releasing the file
in preparation of ima-appraisal measuring the file and updating the
'security.ima' xattr.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
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

