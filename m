Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab1B1Xel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:34:41 -0500
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:44350 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753889Ab1B1Xek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:34:40 -0500
Message-ID: <4D6C3118.9030607@lougher.demon.co.uk>
Date: Mon, 28 Feb 2011 23:34:48 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] Squashfs: add compression options support to xz decompressor
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pass the dictionary size used to compress datablocks.  Using a
dictionary size less than the block size saves memory overhead, in many
cases without adversely affecting compression ratio.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/xz_wrapper.c |   49 ++++++++++++++++++++++++++++++++++++++-------
  1 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/fs/squashfs/xz_wrapper.c b/fs/squashfs/xz_wrapper.c
index 397adea..06d0d11 100644
--- a/fs/squashfs/xz_wrapper.c
+++ b/fs/squashfs/xz_wrapper.c
@@ -26,6 +26,7 @@
  #include <linux/buffer_head.h>
  #include <linux/slab.h>
  #include <linux/xz.h>
+#include <linux/bitops.h>

  #include "squashfs_fs.h"
  #include "squashfs_fs_sb.h"
@@ -38,25 +39,57 @@ struct squashfs_xz {
  	struct xz_buf buf;
  };

+struct comp_opts {
+	__le32 dictionary_size;
+	__le32 flags;
+};
+
  static void *squashfs_xz_init(struct squashfs_sb_info *msblk, void *buff,
  	int len)
  {
-	int block_size = max_t(int, msblk->block_size, SQUASHFS_METADATA_SIZE);
+	struct comp_opts *comp_opts = buff;
+	struct squashfs_xz *stream;
+	int dict_size = msblk->block_size;
+	int err, n;
+
+	if (comp_opts) {
+		/* check compressor options are the expected length */
+		if (len < sizeof(*comp_opts)) {
+			err = -EIO;
+			goto failed;
+		}

-	struct squashfs_xz *stream = kmalloc(sizeof(*stream), GFP_KERNEL);
-	if (stream == NULL)
+		dict_size = le32_to_cpu(comp_opts->dictionary_size);
+
+		/* the dictionary size should be 2^n or 2^n+2^(n+1) */
+		n = ffs(dict_size) - 1;
+		if (dict_size != (1 << n) && dict_size != (1 << n) +
+						(1 << (n + 1))) {
+			err = -EIO;
+			goto failed;
+		}
+	}
+
+	dict_size = max_t(int, dict_size, SQUASHFS_METADATA_SIZE);
+
+	stream = kmalloc(sizeof(*stream), GFP_KERNEL);
+	if (stream == NULL) {
+		err = -ENOMEM;
  		goto failed;
+	}

-	stream->state = xz_dec_init(XZ_PREALLOC, block_size);
-	if (stream->state == NULL)
+	stream->state = xz_dec_init(XZ_PREALLOC, dict_size);
+	if (stream->state == NULL) {
+		kfree(stream);
+		err = -ENOMEM;
  		goto failed;
+	}

  	return stream;

  failed:
-	ERROR("Failed to allocate xz workspace\n");
-	kfree(stream);
-	return ERR_PTR(-ENOMEM);
+	ERROR("Failed to initialise xz decompressor\n");
+	return ERR_PTR(err);
  }


-- 
1.7.1

