Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab0G3Pqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 11:46:40 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:38134 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab0G3Pqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 11:46:33 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v3 04/15] ima: move ima_file_free before releasing the file
Date: Fri, 30 Jul 2010 11:45:35 -0400
Message-Id: <1280504746-20256-5-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1280504746-20256-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1280504746-20256-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrity appraisal measures files on file_free and stores the file
measurement as an xattr.  Measure the file before releasing it.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 fs/file_table.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 5c7d10e..6bcb299 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -241,10 +241,10 @@ static void __fput(struct file *file)
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
1.7.1.1

