Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab0C3OU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 10:20:59 -0400
Received: from rs22.lvs.iif.hu ([193.225.14.172]:44927 "EHLO rs22.lvs.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144Ab0C3OU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:20:57 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Phillip Lougher <phillip@lougher.demon.co.uk>,
       Phillip Lougher <phillip.lougher@gmail.com>,
       linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Cc: Ferenc Wagner <wferi@niif.hu>
Subject: [PATCH 1/3] squashfs: parametrize decompressors on buffer_head operations
Date: Tue, 30 Mar 2010 15:32:47 +0200
Message-Id: <1269955969-26123-2-git-send-email-wferi@niif.hu>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <87mxxxltk6.fsf@tac.ki.iif.hu>
References: <87mxxxltk6.fsf@tac.ki.iif.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/squashfs/block.c        |    9 ++++++++-
 fs/squashfs/decompressor.h |    8 +++++---
 fs/squashfs/lzma_wrapper.c |   11 ++++++-----
 fs/squashfs/zlib_wrapper.c |   13 +++++++------
 4 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 6f9914d..c7e5881 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -37,6 +37,13 @@
 #include "squashfs_fs_i.h"
 #include "squashfs.h"
 #include "decompressor.h"
+
+static int update_buffer(struct buffer_head *bh)
+{
+	wait_on_buffer(bh);
+	return buffer_uptodate(bh);
+}
+
 /*
  * Read the metadata block length, this is stored in the first two
  * bytes of the metadata block.
@@ -152,7 +159,7 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 
 	if (compressed) {
 		length = squashfs_decompress(msblk, buffer, bh, b, offset,
-			length, srclength, pages);
+			length, srclength, pages, update_buffer, put_bh);
 		if (length < 0)
 			goto read_failure;
 	} else {
diff --git a/fs/squashfs/decompressor.h b/fs/squashfs/decompressor.h
index 7425f80..7de948b 100644
--- a/fs/squashfs/decompressor.h
+++ b/fs/squashfs/decompressor.h
@@ -27,7 +27,8 @@ struct squashfs_decompressor {
 	void	*(*init)(struct squashfs_sb_info *);
 	void	(*free)(void *);
 	int	(*decompress)(struct squashfs_sb_info *, void **,
-		struct buffer_head **, int, int, int, int, int);
+		struct buffer_head **, int, int, int, int, int,
+		int (*)(struct buffer_head *), void (*)(struct buffer_head *));
 	int	id;
 	char	*name;
 	int	supported;
@@ -47,9 +48,10 @@ static inline void squashfs_decompressor_free(struct squashfs_sb_info *msblk,
 
 static inline int squashfs_decompress(struct squashfs_sb_info *msblk,
 	void **buffer, struct buffer_head **bh, int b, int offset, int length,
-	int srclength, int pages)
+	int srclength, int pages,
+	int (*update_buffer)(struct buffer_head *), void (*put_buffer)(struct buffer_head *))
 {
 	return msblk->decompressor->decompress(msblk, buffer, bh, b, offset,
-		length, srclength, pages);
+		length, srclength, pages, update_buffer, put_buffer);
 }
 #endif
diff --git a/fs/squashfs/lzma_wrapper.c b/fs/squashfs/lzma_wrapper.c
index 9fa617d..994c37e 100644
--- a/fs/squashfs/lzma_wrapper.c
+++ b/fs/squashfs/lzma_wrapper.c
@@ -88,7 +88,9 @@ static void lzma_free(void *strm)
 
 static int lzma_uncompress(struct squashfs_sb_info *msblk, void **buffer,
 	struct buffer_head **bh, int b, int offset, int length, int srclength,
-	int pages)
+	int pages,
+	int (*update_buffer)(struct buffer_head *),
+	void (*put_buffer)(struct buffer_head *))
 {
 	struct squashfs_lzma *stream = msblk->stream;
 	void *buff = stream->input;
@@ -97,8 +99,7 @@ static int lzma_uncompress(struct squashfs_sb_info *msblk, void **buffer,
 	mutex_lock(&lzma_mutex);
 
 	for (i = 0; i < b; i++) {
-		wait_on_buffer(bh[i]);
-		if (!buffer_uptodate(bh[i]))
+		if (!update_buffer(bh[i]))
 			goto block_release;
 
 		avail = min(bytes, msblk->devblksize - offset);
@@ -106,7 +107,7 @@ static int lzma_uncompress(struct squashfs_sb_info *msblk, void **buffer,
 		buff += avail;
 		bytes -= avail;
 		offset = 0;
-		put_bh(bh[i]);
+		put_buffer(bh[i]);
 	}
 
 	lzma_error = 0;
@@ -131,7 +132,7 @@ static int lzma_uncompress(struct squashfs_sb_info *msblk, void **buffer,
 
 block_release:
 	for (; i < b; i++)
-		put_bh(bh[i]);
+		put_buffer(bh[i]);
 
 failed:
 	mutex_unlock(&lzma_mutex);
diff --git a/fs/squashfs/zlib_wrapper.c b/fs/squashfs/zlib_wrapper.c
index 4dd70e0..09cdcc1 100644
--- a/fs/squashfs/zlib_wrapper.c
+++ b/fs/squashfs/zlib_wrapper.c
@@ -63,7 +63,9 @@ static void zlib_free(void *strm)
 
 static int zlib_uncompress(struct squashfs_sb_info *msblk, void **buffer,
 	struct buffer_head **bh, int b, int offset, int length, int srclength,
-	int pages)
+	int pages,
+	int (*update_buffer)(struct buffer_head *),
+	void (*put_buffer)(struct buffer_head *))
 {
 	int zlib_err = 0, zlib_init = 0;
 	int avail, bytes, k = 0, page = 0;
@@ -79,13 +81,12 @@ static int zlib_uncompress(struct squashfs_sb_info *msblk, void **buffer,
 		if (stream->avail_in == 0 && k < b) {
 			avail = min(bytes, msblk->devblksize - offset);
 			bytes -= avail;
-			wait_on_buffer(bh[k]);
-			if (!buffer_uptodate(bh[k]))
+			if (!update_buffer(bh[k]))
 				goto release_mutex;
 
 			if (avail == 0) {
 				offset = 0;
-				put_bh(bh[k++]);
+				put_buffer(bh[k++]);
 				continue;
 			}
 
@@ -113,7 +114,7 @@ static int zlib_uncompress(struct squashfs_sb_info *msblk, void **buffer,
 		zlib_err = zlib_inflate(stream, Z_SYNC_FLUSH);
 
 		if (stream->avail_in == 0 && k < b)
-			put_bh(bh[k++]);
+			put_buffer(bh[k++]);
 	} while (zlib_err == Z_OK);
 
 	if (zlib_err != Z_STREAM_END) {
@@ -134,7 +135,7 @@ release_mutex:
 	mutex_unlock(&msblk->read_data_mutex);
 
 	for (; k < b; k++)
-		put_bh(bh[k]);
+		put_buffer(bh[k]);
 
 	return -EIO;
 }
-- 
1.6.5

