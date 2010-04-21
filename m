Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab0DUPV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:21:57 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:41020 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab0DUPV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 11:21:56 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Alexander Shishkin <virtuoso@slind.org>, linux-mtd@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH] mtd: Do not corrupt backing device for inode
Date: Wed, 21 Apr 2010 18:21:09 +0300
Message-Id: <1271863269-5423-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100415172300.GF3561@quack.suse.cz>
References: <20100415172300.GF3561@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot modify file->f_mapping->backing_dev_info directly, because it
will corrupt backing device for inode, since inode->i_mapping ==
file->f_mapping (see __dentry_open() in fs/open.c).

So we have to copy f_mapping first.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 drivers/mtd/mtdchar.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 5b081cb..d85be4d 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -88,8 +88,23 @@ static int mtd_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 
-	if (mtd->backing_dev_info)
+	if (mtd->backing_dev_info) {
+		/*
+		 * We assume that file->f_mapping is equal to inode->i_mapping.
+		 */
+		BUG_ON(file->f_mapping != inode->i_mapping);
+
+		/*
+		 * We cannot modify file->f_mapping->backing_dev_info directly,
+		 * because it will corrupt backing device for inode, since
+		 * inode->i_mapping is equal to file->f_mapping. So we have to
+		 * copy f_mapping first.
+		 */
+		file->f_mapping = kmalloc(sizeof(*file->f_mapping), GFP_KERNEL);
+		memcpy(file->f_mapping, inode->i_mapping,
+				sizeof(*file->f_mapping));
 		file->f_mapping->backing_dev_info = mtd->backing_dev_info;
+	}
 
 	/* You can't open it RW if it's not a writeable device */
 	if ((file->f_mode & FMODE_WRITE) && !(mtd->flags & MTD_WRITEABLE)) {
@@ -129,6 +144,11 @@ static int mtd_close(struct inode *inode, struct file *file)
 	file->private_data = NULL;
 	kfree(mfi);
 
+	if (mtd->backing_dev_info) {
+		kfree(file->f_mapping);
+		file->f_mapping = inode->i_mapping;
+	}
+
 	return 0;
 } /* mtd_close */
 
-- 
1.7.0.4

