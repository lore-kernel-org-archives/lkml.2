Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030192Ab1FPVI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:08:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:20285 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758297Ab1FPVIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:08:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,377,1304319600"; 
   d="scan'208";a="17215406"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/5] VFS: Add generic_file_llseek_size
Date: Thu, 16 Jun 2011 14:07:20 -0700
Message-Id: <1308258442-19804-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308258442-19804-1-git-send-email-andi@firstfloor.org>
References: <1308258442-19804-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a generic_file_llseek variant to the VFS that allows passing in
the current file size, instead of always using inode->i_size.
This can be used to eliminate some cut'n'paste seek code in ext4.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/read_write.c    |   20 ++++++++++++++++++++
 include/linux/fs.h |    2 ++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 0b1d4ca..4924602 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -99,6 +99,26 @@ generic_file_llseek(struct file *file, loff_t offset, int origin)
 EXPORT_SYMBOL(generic_file_llseek);
 
 /**
+ * generic_file_llseek_size - generic llseek implementation for regular files
+ * @file:	file structure to seek on
+ * @offset:	file offset to seek to
+ * @origin:	type of seek
+ * 
+ * Variant of generic_file_llseek_size that allows passing in a custom
+ * file size.
+ */
+loff_t generic_file_llseek_size(struct file *file, loff_t offset, int origin, 
+				loff_t size)
+{
+	struct inode *inode = file->f_mapping->host;
+
+	if (origin == SEEK_END)
+		return lseek_execute(file, inode, offset + size);
+	return generic_file_llseek(file, offset, origin);
+}
+EXPORT_SYMBOL(generic_file_llseek_size);
+
+/**
  * noop_llseek - No Operation Performed llseek implementation
  * @file:	file structure to seek on
  * @offset:	file offset to seek to
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a19d164..0642821 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2336,6 +2336,8 @@ file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
 extern loff_t noop_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
+extern loff_t generic_file_llseek_size(struct file *file, loff_t offset, int origin, 
+				       loff_t size);
 extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
 
-- 
1.7.4.4

