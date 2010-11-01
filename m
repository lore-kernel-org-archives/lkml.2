Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab0KASmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:42:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41592 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab0KASmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:42:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UpAM5vqV9/ZrzLTFeqiEEqg4LBo98dscsjxSyGuCUKLe956g6oJ57aU0XM59BE7qt5
         dJtBvXh2+LuZgKbaleH6XWIvLCsFIIvt4JBH1ql/RhjFihqSaxUp0na/0DZA8xqWwUG/
         ixr7uUnPZ83sDJ1uBITwtg2EcZDq1UTvfApcE=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 17/29] Staging: yaffs2: yaffs_nand: Add files
Date: Mon,  1 Nov 2010 14:41:05 -0400
Message-Id: <1288636877-7964-18-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding files to yaffs2 directory.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/yaffs2/yaffs_nand.c |  140 +++++++++++++++++++++++++++++++++++
 drivers/staging/yaffs2/yaffs_nand.h |   44 +++++++++++
 2 files changed, 184 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/yaffs2/yaffs_nand.c
 create mode 100644 drivers/staging/yaffs2/yaffs_nand.h

diff --git a/drivers/staging/yaffs2/yaffs_nand.c b/drivers/staging/yaffs2/yaffs_nand.c
new file mode 100644
index 0000000..d721fa6
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_nand.c
@@ -0,0 +1,140 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "yaffs_nand.h"
+#include "yaffs_tagscompat.h"
+#include "yaffs_tagsvalidity.h"
+
+#include "yaffs_getblockinfo.h"
+
+int yaffs_rd_chunk_tags_nand(yaffs_dev_t *dev, int nand_chunk,
+					   __u8 *buffer,
+					   yaffs_ext_tags *tags)
+{
+	int result;
+	yaffs_ext_tags local_tags;
+
+	int realigned_chunk = nand_chunk - dev->chunk_offset;
+
+	dev->n_page_reads++;
+
+	/* If there are no tags provided, use local tags to get prioritised gc working */
+	if (!tags)
+		tags = &local_tags;
+
+	if (dev->param.read_chunk_tags_fn)
+		result = dev->param.read_chunk_tags_fn(dev, realigned_chunk, buffer,
+						      tags);
+	else
+		result = yaffs_tags_compat_rd(dev,
+									realigned_chunk,
+									buffer,
+									tags);
+	if (tags &&
+	   tags->ecc_result > YAFFS_ECC_RESULT_NO_ERROR) {
+
+		yaffs_block_info_t *bi;
+		bi = yaffs_get_block_info(dev, nand_chunk/dev->param.chunks_per_block);
+		yaffs_handle_chunk_error(dev, bi);
+	}
+
+	return result;
+}
+
+int yaffs_wr_chunk_tags_nand(yaffs_dev_t *dev,
+						   int nand_chunk,
+						   const __u8 *buffer,
+						   yaffs_ext_tags *tags)
+{
+
+	dev->n_page_writes++;
+
+	nand_chunk -= dev->chunk_offset;
+
+
+	if (tags) {
+		tags->seq_number = dev->seq_number;
+		tags->chunk_used = 1;
+		if (!yaffs_validate_tags(tags)) {
+			T(YAFFS_TRACE_ERROR,
+			  (TSTR("Writing uninitialised tags" TENDSTR)));
+			YBUG();
+		}
+		T(YAFFS_TRACE_WRITE,
+		  (TSTR("Writing chunk %d tags %d %d" TENDSTR), nand_chunk,
+		   tags->obj_id, tags->chunk_id));
+	} else {
+		T(YAFFS_TRACE_ERROR, (TSTR("Writing with no tags" TENDSTR)));
+		YBUG();
+	}
+
+	if (dev->param.write_chunk_tags_fn)
+		return dev->param.write_chunk_tags_fn(dev, nand_chunk, buffer,
+						     tags);
+	else
+		return yaffs_tags_compat_wr(dev,
+								       nand_chunk,
+								       buffer,
+								       tags);
+}
+
+int yaffs_mark_bad(yaffs_dev_t *dev, int block_no)
+{
+	block_no -= dev->block_offset;
+
+
+	if (dev->param.bad_block_fn)
+		return dev->param.bad_block_fn(dev, block_no);
+	else
+		return yaffs_tags_compat_mark_bad(dev, block_no);
+}
+
+int yaffs_query_init_block_state(yaffs_dev_t *dev,
+						 int block_no,
+						 yaffs_block_state_t *state,
+						 __u32 *seq_number)
+{
+	block_no -= dev->block_offset;
+
+	if (dev->param.query_block_fn)
+		return dev->param.query_block_fn(dev, block_no, state, seq_number);
+	else
+		return yaffs_tags_compat_query_block(dev, block_no,
+							     state,
+							     seq_number);
+}
+
+
+int yaffs_erase_block(struct yaffs_dev_s *dev,
+				  int flash_block)
+{
+	int result;
+
+	flash_block -= dev->block_offset;
+
+	dev->n_erasures++;
+
+	result = dev->param.erase_fn(dev, flash_block);
+
+	return result;
+}
+
+int yaffs_init_nand(struct yaffs_dev_s *dev)
+{
+	if(dev->param.initialise_flash_fn)
+		return dev->param.initialise_flash_fn(dev);
+	return YAFFS_OK;
+}
+
+
+
diff --git a/drivers/staging/yaffs2/yaffs_nand.h b/drivers/staging/yaffs2/yaffs_nand.h
new file mode 100644
index 0000000..24cd147
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_nand.h
@@ -0,0 +1,44 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+#ifndef __YAFFS_NAND_H__
+#define __YAFFS_NAND_H__
+#include "yaffs_guts.h"
+
+
+
+int yaffs_rd_chunk_tags_nand(yaffs_dev_t *dev, int nand_chunk,
+					__u8 *buffer,
+					yaffs_ext_tags *tags);
+
+int yaffs_wr_chunk_tags_nand(yaffs_dev_t *dev,
+						int nand_chunk,
+						const __u8 *buffer,
+						yaffs_ext_tags *tags);
+
+int yaffs_mark_bad(yaffs_dev_t *dev, int block_no);
+
+int yaffs_query_init_block_state(yaffs_dev_t *dev,
+						int block_no,
+						yaffs_block_state_t *state,
+						unsigned *seq_number);
+
+int yaffs_erase_block(struct yaffs_dev_s *dev,
+				  int flash_block);
+
+int yaffs_init_nand(struct yaffs_dev_s *dev);
+
+#endif
+
-- 
1.7.3.2.146.gca209

