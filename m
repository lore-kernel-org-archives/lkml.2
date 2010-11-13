Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab0KMO4L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 09:56:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38111 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab0KMO4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 09:56:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=dsrFBe1J9h4jQieS/1apJnZ6IS7keN73jWYuuwtQWkSiv7+4M9z1wiMBeWlWwbcobn
         V78saloxch7yNe8qtB85/8q4UUS6mt8dI/YwOEjiuO5ACVrCp5UC+LmjbLEkERaG5gDr
         uBbTkCh5u7Xs2rf9Jus2P0Z2OA9/GlbZ42dZ0=
Message-ID: <4CDEA645.3090901@gmail.com>
Date: Sat, 13 Nov 2010 15:52:53 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 10/16 v3] pramfs: XIP operations
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

XIP operations.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff -Nurp linux-2.6.36-orig/fs/pramfs/xip.c linux-2.6.36/fs/pramfs/xip.c
--- linux-2.6.36-orig/fs/pramfs/xip.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.36/fs/pramfs/xip.c	2010-09-14 18:49:52.000000000 +0200
@@ -0,0 +1,90 @@
+/*
+ * FILE NAME fs/pramfs/xip.c
+ *
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
+
+static int __pram_get_block(struct inode *inode, pgoff_t pgoff, int create,
+		   sector_t *result)
+{
+	int rc = 0;
+	sector_t iblock;
+
+	/* find starting block number to access */
+	iblock = (sector_t)pgoff << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+
+	rc = pram_find_and_alloc_blocks(inode, iblock, result, create);
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
diff -Nurp linux-2.6.36-orig/fs/pramfs/xip.h linux-2.6.36/fs/pramfs/xip.h
--- linux-2.6.36-orig/fs/pramfs/xip.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.36/fs/pramfs/xip.h	2010-09-14 18:49:52.000000000 +0200
@@ -0,0 +1,24 @@
+/*
+ * FILE NAME fs/pramfs/xip.h
+ *
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
+
+int pram_get_xip_mem(struct address_space *, pgoff_t, int, void **,
+							      unsigned long *);
+
+#else
+
+#define pram_get_xip_mem NULL
+
+#endif
+
 
