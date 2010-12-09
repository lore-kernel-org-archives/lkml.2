Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0LIGIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 01:08:51 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:49939 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321Ab0LIGIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 01:08:50 -0500
Message-ID: <4D00726D.3080503@lougher.demon.co.uk>
Date: Thu, 09 Dec 2010 06:08:45 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Linux Embedded Maillist <linux-embedded@vger.kernel.org>
CC: Lasse Collin <lasse.collin@tukaani.org>
Subject: [PATCH 1/2] Squashfs: add XZ compression support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add XZ decompressor wrapper code.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/squashfs_fs.h |    1 +
  fs/squashfs/xz_wrapper.c  |  153 +++++++++++++++++++++++++++++++++++++++++++++
  2 files changed, 154 insertions(+), 0 deletions(-)
  create mode 100644 fs/squashfs/xz_wrapper.c

diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
index c5137fc..39533fe 100644
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -238,6 +238,7 @@ struct meta_index {
  #define ZLIB_COMPRESSION	1
  #define LZMA_COMPRESSION	2
  #define LZO_COMPRESSION		3
+#define XZ_COMPRESSION		4

  struct squashfs_super_block {
  	__le32			s_magic;
diff --git a/fs/squashfs/xz_wrapper.c b/fs/squashfs/xz_wrapper.c
new file mode 100644
index 0000000..053fe35
--- /dev/null
+++ b/fs/squashfs/xz_wrapper.c
@@ -0,0 +1,153 @@
+/*
+ * Squashfs - a compressed read only filesystem for Linux
+ *
+ * Copyright (c) 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010
+ * Phillip Lougher <phillip@lougher.demon.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2,
+ * or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ *
+ * xz_wrapper.c
+ */
+
+
+#include <linux/mutex.h>
+#include <linux/buffer_head.h>
+#include <linux/slab.h>
+#include <linux/xz.h>
+
+#include "squashfs_fs.h"
+#include "squashfs_fs_sb.h"
+#include "squashfs_fs_i.h"
+#include "squashfs.h"
+#include "decompressor.h"
+
+struct squashfs_xz {
+	struct xz_dec *state;
+	struct xz_buf buf;
+};
+
+static void *squashfs_xz_init(struct squashfs_sb_info *msblk)
+{
+        int block_size = max_t(int, msblk->block_size, SQUASHFS_METADATA_SIZE);
+
+        struct squashfs_xz *stream = kmalloc(sizeof(*stream), GFP_KERNEL);
+        if (stream == NULL)
+                goto failed;
+	stream->state = xz_dec_init(XZ_PREALLOC, block_size);
+	if (stream->state == NULL)
+		goto failed;
+
+	return stream;
+
+failed:
+	ERROR("Failed to allocate xz workspace\n");
+	kfree(stream);
+	return NULL;
+}
+
+
+static void squashfs_xz_free(void *strm)
+{
+	struct squashfs_xz *stream = strm;
+
+	if (stream) {
+		xz_dec_end(stream->state);
+		kfree(stream);
+	}
+}
+
+
+static int squashfs_xz_uncompress(struct squashfs_sb_info *msblk, void **buffer,
+	struct buffer_head **bh, int b, int offset, int length, int srclength,
+	int pages)
+{
+	enum xz_ret xz_err;
+	int avail, total = 0, k = 0, page = 0;
+	struct squashfs_xz *stream = msblk->stream;
+
+	mutex_lock(&msblk->read_data_mutex);
+
+	xz_dec_reset(stream->state);
+	stream->buf.in_pos = 0;
+	stream->buf.in_size = 0;
+	stream->buf.out_pos = 0;
+	stream->buf.out_size = PAGE_CACHE_SIZE;
+	stream->buf.out = buffer[page++];
+
+	do {
+		if (stream->buf.in_pos == stream->buf.in_size && k < b) {
+			avail = min(length, msblk->devblksize - offset);
+			length -= avail;
+			wait_on_buffer(bh[k]);
+			if (!buffer_uptodate(bh[k]))
+				goto release_mutex;
+
+			if (avail == 0) {
+				offset = 0;
+				put_bh(bh[k++]);
+				continue;
+			}
+
+			stream->buf.in = bh[k]->b_data + offset;
+			stream->buf.in_size = avail;
+			stream->buf.in_pos = 0;
+			offset = 0;
+		}
+
+		if (stream->buf.out_pos == stream->buf.out_size
+							&& page < pages) {
+			stream->buf.out = buffer[page++];
+			stream->buf.out_pos = 0;
+			total += PAGE_CACHE_SIZE;
+		}
+
+		xz_err = xz_dec_run(stream->state, &stream->buf);
+
+		if (stream->buf.in_pos == stream->buf.in_size && k < b)
+			put_bh(bh[k++]);
+	} while (xz_err == XZ_OK);
+
+	if (xz_err != XZ_STREAM_END) {
+		ERROR("xz_dec_run error, data probably corrupt\n");
+		goto release_mutex;
+	}
+
+	if (k < b) {
+		ERROR("xz_uncompress error, input remaining\n");
+		goto release_mutex;
+	}
+
+	total += stream->buf.out_pos;
+	mutex_unlock(&msblk->read_data_mutex);
+	return total;
+
+release_mutex:
+	mutex_unlock(&msblk->read_data_mutex);
+
+	for (; k < b; k++)
+		put_bh(bh[k]);
+
+	return -EIO;
+}
+
+const struct squashfs_decompressor squashfs_xz_comp_ops = {
+	.init = squashfs_xz_init,
+	.free = squashfs_xz_free,
+	.decompress = squashfs_xz_uncompress,
+	.id = XZ_COMPRESSION,
+	.name = "xz",
+	.supported = 1
+};
+
-- 
1.6.3.3

