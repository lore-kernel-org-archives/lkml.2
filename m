Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1AFMHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 07:07:25 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48034 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab1AFMHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 07:07:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=SdD6vBRkxEZv7aKXyedF0c/PSHjjJFK9cOiBP8wNaLf+FTKsbg82fSdfpBtplUetOo
         vlfY6bf3WWY1MrzLKY6nC0qROHpoNh1XFeJoG9cQlirwUk3qAe3gOf0z5EYpUz9rvNcZ
         9BGG/LYgHEFtVCk6YiqUi83K2oV5adbfuwEwc=
Message-ID: <4D25AF88.4020204@gmail.com>
Date: Thu, 06 Jan 2011 13:03:20 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 10/17] pramfs: xip operations
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

XIP operations.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff --git a/fs/pramfs/xip.c b/fs/pramfs/xip.c
new file mode 100644
index 0000000..9ad8caf
--- /dev/null
+++ b/fs/pramfs/xip.c
@@ -0,0 +1,83 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * XIP operations.
+ *
+ * Copyright 2009-2010 Marco Stornelli <marco.stornelli@gmail.com>
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/genhd.h>
+#include <linux/buffer_head.h>
+#include "pram.h"
+#include "xip.h"
+
+static int pram_find_and_alloc_blocks(struct inode *inode, sector_t iblock,
+				     sector_t *data_block, int create)
+{
+	int err = -EIO;
+	u64 block;
+
+	mutex_lock(&PRAM_I(inode)->truncate_mutex);
+
+	block = pram_find_data_block(inode, iblock);
+
+	if (!block) {
+		if (!create) {
+			err = -ENODATA;
+			goto err;
+		}
+
+		err = pram_alloc_blocks(inode, iblock, 1);
+		if (err)
+			goto err;
+
+		block = pram_find_data_block(inode, iblock);
+		if (!block) {
+			err = -ENODATA;
+			goto err;
+		}
+	}
+
+	*data_block = block;
+	err = 0;
+
+ err:
+	mutex_unlock(&PRAM_I(inode)->truncate_mutex);
+	return err;
+}
+
+static inline int __pram_get_block(struct inode *inode, pgoff_t pgoff, int create,
+		   sector_t *result)
+{
+	int rc = 0;
+
+	rc = pram_find_and_alloc_blocks(inode, (sector_t)pgoff, result, create);
+
+	if (rc == -ENODATA)
+		BUG_ON(create);
+
+	return rc;
+}
+
+int pram_get_xip_mem(struct address_space *mapping, pgoff_t pgoff, int create,
+				void **kmem, unsigned long *pfn)
+{
+	int rc;
+	sector_t block;
+
+	/* first, retrieve the block */
+	rc = __pram_get_block(mapping->host, pgoff, create, &block);
+	if (rc)
+		goto exit;
+
+	*kmem = pram_get_block(mapping->host->i_sb, block);
+	*pfn = page_to_pfn(virt_to_page((unsigned long)*kmem));
+
+exit:
+	return rc;
+}
diff --git a/fs/pramfs/xip.h b/fs/pramfs/xip.h
new file mode 100644
index 0000000..797f1b0
--- /dev/null
+++ b/fs/pramfs/xip.h
@@ -0,0 +1,28 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * XIP operations.
+ *
+ * Copyright 2009-2010 Marco Stornelli <marco.stornelli@gmail.com>
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifdef CONFIG_PRAMFS_XIP
+int pram_get_xip_mem(struct address_space *, pgoff_t, int, void **,
+							      unsigned long *);
+static inline int pram_use_xip(struct super_block *sb)
+{
+	struct pram_sb_info *sbi = (struct pram_sb_info *)sb->s_fs_info;
+	return sbi->s_mount_opt & PRAM_MOUNT_XIP;
+}
+#define mapping_is_xip(map) unlikely(map->a_ops->get_xip_mem)
+
+#else
+
+#define mapping_is_xip(map)	0
+#define pram_use_xip(sb)	0
+#define pram_get_xip_mem	NULL
+
+#endif
