Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab0GLO26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 10:28:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49560 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab0GLO24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 10:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=MMPozgnmC+t9EoJbMq1AVGL/WmFYpTfLDzCO9ew7H+yTlvcExuiW8a+CRHXPFr28fd
         7qwuNXa5nDlHcQi4jbgcguqEOj6hXH8/f9rX4twdRjf+Ie+8TDOF2Dx6rgTSP+/7JcRI
         7PiBixA6zXwu4ATN9fLZbGnc9sF8gPevDXtlU=
Date: Mon, 12 Jul 2010 22:29:09 +0800
From: "crosslonelyover" <crosslonelyover@gmail.com>
To: "linux-ext4" <linux-ext4@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "kernel-janitors" <kernel-janitors@vger.kernel.org>
Subject: [PATCH] check name_len before down_read xattr_sem and sb_read in ext2_xattr_get
Message-ID: <201007122229025316610@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
       I walked through ext2_xattr_get, and felt that we can
do some optimization on it. For name_len check, it's done
after down xattr_sem and sb_read, both of which are time
consuming operation compared with strlen:
         down_read(&EXT2_I(inode)->xattr_sem);
 ...
         bh = sb_bread(inode->i_sb, EXT2_I(inode)->i_file_acl);
 ...
         /* find named attribute */
         name_len = strlen(name);

         error = -ERANGE;
         if (name_len > 255)
                 goto cleanup;

       Most of the case, you'll get one valid block, but if the
name len > 255, then the xattr_sem down and sb_bread operation
can be seen as a waste of time. So I think we'd better do
name len check as early as possible.
       Following is my patch, and it's against 2.6.35-rc4.
Please check it.

Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
---
 fs/ext2/xattr.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 7c39157..0b94d61 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -161,6 +161,13 @@ ext2_xattr_get(struct inode *inode, int name_index, const char *name,
 
 	if (name == NULL)
 		return -EINVAL;
+
+	/* find named attribute */
+	name_len = strlen(name);
+	error = -ERANGE;
+	if (name_len > 255)
+		goto cleanup;
+
 	down_read(&EXT2_I(inode)->xattr_sem);
 	error = -ENODATA;
 	if (!EXT2_I(inode)->i_file_acl)
@@ -181,12 +188,7 @@ bad_block:	ext2_error(inode->i_sb, "ext2_xattr_get",
 		error = -EIO;
 		goto cleanup;
 	}
-	/* find named attribute */
-	name_len = strlen(name);
 
-	error = -ERANGE;
-	if (name_len > 255)
-		goto cleanup;
 	entry = FIRST_ENTRY(bh);
 	while (!IS_LAST_ENTRY(entry)) {
 		struct ext2_xattr_entry *next =
-- 
1.7.1.1






