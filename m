Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab1ISNer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 09:34:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40224 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756014Ab1ISNeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 09:34:18 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 4/6 v5] regmap: Add the LZO cache support
Date: Mon, 19 Sep 2011 14:34:03 +0100
Message-Id: <1316439245-26221-5-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316439245-26221-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1316439245-26221-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for LZO compression when storing the register
cache.

For a typical device whose register map would normally occupy 25kB or 50kB
by using the LZO compression technique, one can get down to ~5-7kB.  There
might be a performance penalty associated with each individual read/write
due to decompressing/compressing the underlying cache, however that should not
be noticeable.  These memory benefits depend on whether the target architecture
can get rid of the memory occupied by the original register defaults cache
which is marked as __devinitconst.  Nevertheless there will be some memory
gain even if the target architecture can't get rid of the original register
map, this should be around ~30-32kB instead of 50kB.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/Kconfig        |    2 +
 drivers/base/regmap/Makefile       |    2 +-
 drivers/base/regmap/internal.h     |    2 +
 drivers/base/regmap/regcache-lzo.c |  361 ++++++++++++++++++++++++++++++++++++
 drivers/base/regmap/regcache.c     |    1 +
 include/linux/regmap.h             |    1 +
 6 files changed, 368 insertions(+), 1 deletions(-)
 create mode 100644 drivers/base/regmap/regcache-lzo.c

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index fabbf6c..2fc6a66 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -4,6 +4,8 @@
 
 config REGMAP
 	default y if (REGMAP_I2C || REGMAP_SPI)
+	select LZO_COMPRESS
+	select LZO_DECOMPRESS
 	bool
 
 config REGMAP_I2C
diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index 20cd650..0573c8a 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_REGMAP) += regmap.o regcache.o regcache-indexed.o regcache-rbtree.o
+obj-$(CONFIG_REGMAP) += regmap.o regcache.o regcache-indexed.o regcache-rbtree.o regcache-lzo.o
 obj-$(CONFIG_DEBUG_FS) += regmap-debugfs.o
 obj-$(CONFIG_REGMAP_I2C) += regmap-i2c.o
 obj-$(CONFIG_REGMAP_SPI) += regmap-spi.o
diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 7ef8afc..2d51b1b 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -120,4 +120,6 @@ int regcache_insert_reg(struct regmap *map, unsigned int reg,
 
 extern struct regcache_ops regcache_indexed_ops;
 extern struct regcache_ops regcache_rbtree_ops;
+extern struct regcache_ops regcache_lzo_ops;
+
 #endif
diff --git a/drivers/base/regmap/regcache-lzo.c b/drivers/base/regmap/regcache-lzo.c
new file mode 100644
index 0000000..9079cb5
--- /dev/null
+++ b/drivers/base/regmap/regcache-lzo.c
@@ -0,0 +1,361 @@
+/*
+ * Register cache access API - LZO caching support
+ *
+ * Copyright 2011 Wolfson Microelectronics plc
+ *
+ * Author: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/slab.h>
+#include <linux/lzo.h>
+
+#include "internal.h"
+
+struct regcache_lzo_ctx {
+	void *wmem;
+	void *dst;
+	const void *src;
+	size_t src_len;
+	size_t dst_len;
+	size_t decompressed_size;
+	unsigned long *sync_bmp;
+	int sync_bmp_nbits;
+};
+
+#define LZO_BLOCK_NUM 8
+static int regcache_lzo_block_count(void)
+{
+	return LZO_BLOCK_NUM;
+}
+
+static int regcache_lzo_prepare(struct regcache_lzo_ctx *lzo_ctx)
+{
+	lzo_ctx->wmem = kmalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+	if (!lzo_ctx->wmem)
+		return -ENOMEM;
+	return 0;
+}
+
+static int regcache_lzo_compress(struct regcache_lzo_ctx *lzo_ctx)
+{
+	size_t compress_size;
+	int ret;
+
+	ret = lzo1x_1_compress(lzo_ctx->src, lzo_ctx->src_len,
+			       lzo_ctx->dst, &compress_size, lzo_ctx->wmem);
+	if (ret != LZO_E_OK || compress_size > lzo_ctx->dst_len)
+		return -EINVAL;
+	lzo_ctx->dst_len = compress_size;
+	return 0;
+}
+
+static int regcache_lzo_decompress(struct regcache_lzo_ctx *lzo_ctx)
+{
+	size_t dst_len;
+	int ret;
+
+	dst_len = lzo_ctx->dst_len;
+	ret = lzo1x_decompress_safe(lzo_ctx->src, lzo_ctx->src_len,
+				    lzo_ctx->dst, &dst_len);
+	if (ret != LZO_E_OK || dst_len != lzo_ctx->dst_len)
+		return -EINVAL;
+	return 0;
+}
+
+static int regcache_lzo_compress_cache_block(struct regmap *map,
+		struct regcache_lzo_ctx *lzo_ctx)
+{
+	int ret;
+
+	lzo_ctx->dst_len = lzo1x_worst_compress(PAGE_SIZE);
+	lzo_ctx->dst = kmalloc(lzo_ctx->dst_len, GFP_KERNEL);
+	if (!lzo_ctx->dst) {
+		lzo_ctx->dst_len = 0;
+		return -ENOMEM;
+	}
+
+	ret = regcache_lzo_compress(lzo_ctx);
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+static int regcache_lzo_decompress_cache_block(struct regmap *map,
+		struct regcache_lzo_ctx *lzo_ctx)
+{
+	int ret;
+
+	lzo_ctx->dst_len = lzo_ctx->decompressed_size;
+	lzo_ctx->dst = kmalloc(lzo_ctx->dst_len, GFP_KERNEL);
+	if (!lzo_ctx->dst) {
+		lzo_ctx->dst_len = 0;
+		return -ENOMEM;
+	}
+
+	ret = regcache_lzo_decompress(lzo_ctx);
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+static inline int regcache_lzo_get_blkindex(struct regmap *map,
+					    unsigned int reg)
+{
+	return (reg * map->cache_word_size) /
+		DIV_ROUND_UP(map->cache_size_raw, regcache_lzo_block_count());
+}
+
+static inline int regcache_lzo_get_blkpos(struct regmap *map,
+					  unsigned int reg)
+{
+	return reg % (DIV_ROUND_UP(map->cache_size_raw, regcache_lzo_block_count()) /
+		      map->cache_word_size);
+}
+
+static inline int regcache_lzo_get_blksize(struct regmap *map)
+{
+	return DIV_ROUND_UP(map->cache_size_raw, regcache_lzo_block_count());
+}
+
+static int regcache_lzo_init(struct regmap *map)
+{
+	struct regcache_lzo_ctx **lzo_blocks;
+	size_t bmp_size;
+	int ret, i, blksize, blkcount;
+	const char *p, *end;
+	unsigned long *sync_bmp;
+
+	ret = 0;
+
+	blkcount = regcache_lzo_block_count();
+	map->cache = kzalloc(blkcount * sizeof *lzo_blocks,
+			     GFP_KERNEL);
+	if (!map->cache)
+		return -ENOMEM;
+	lzo_blocks = map->cache;
+
+	/*
+	 * allocate a bitmap to be used when syncing the cache with
+	 * the hardware.  Each time a register is modified, the corresponding
+	 * bit is set in the bitmap, so we know that we have to sync
+	 * that register.
+	 */
+	bmp_size = map->num_reg_defaults_raw;
+	sync_bmp = kmalloc(BITS_TO_LONGS(bmp_size) * sizeof(long),
+			   GFP_KERNEL);
+	if (!sync_bmp) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	bitmap_zero(sync_bmp, bmp_size);
+
+	/* allocate the lzo blocks and initialize them */
+	for (i = 0; i < blkcount; i++) {
+		lzo_blocks[i] = kzalloc(sizeof **lzo_blocks,
+					GFP_KERNEL);
+		if (!lzo_blocks[i]) {
+			kfree(sync_bmp);
+			ret = -ENOMEM;
+			goto err;
+		}
+		lzo_blocks[i]->sync_bmp = sync_bmp;
+		lzo_blocks[i]->sync_bmp_nbits = bmp_size;
+		/* alloc the working space for the compressed block */
+		ret = regcache_lzo_prepare(lzo_blocks[i]);
+		if (ret < 0)
+			goto err;
+	}
+
+	blksize = regcache_lzo_get_blksize(map);
+	p = map->reg_defaults_raw;
+	end = map->reg_defaults_raw + map->cache_size_raw;
+	/* compress the register map and fill the lzo blocks */
+	for (i = 0; i < blkcount; i++, p += blksize) {
+		lzo_blocks[i]->src = p;
+		if (p + blksize > end)
+			lzo_blocks[i]->src_len = end - p;
+		else
+			lzo_blocks[i]->src_len = blksize;
+		ret = regcache_lzo_compress_cache_block(map,
+						       lzo_blocks[i]);
+		if (ret < 0)
+			goto err;
+		lzo_blocks[i]->decompressed_size =
+			lzo_blocks[i]->src_len;
+	}
+
+	return 0;
+err:
+	regcache_exit(map);
+	return ret;
+}
+
+static int regcache_lzo_exit(struct regmap *map)
+{
+	struct regcache_lzo_ctx **lzo_blocks;
+	int i, blkcount;
+
+	lzo_blocks = map->cache;
+	if (!lzo_blocks)
+		return 0;
+
+	blkcount = regcache_lzo_block_count();
+	/*
+	 * the pointer to the bitmap used for syncing the cache
+	 * is shared amongst all lzo_blocks.  Ensure it is freed
+	 * only once.
+	 */
+	if (lzo_blocks[0])
+		kfree(lzo_blocks[0]->sync_bmp);
+	for (i = 0; i < blkcount; i++) {
+		if (lzo_blocks[i]) {
+			kfree(lzo_blocks[i]->wmem);
+			kfree(lzo_blocks[i]->dst);
+		}
+		/* each lzo_block is a pointer returned by kmalloc or NULL */
+		kfree(lzo_blocks[i]);
+	}
+	kfree(lzo_blocks);
+	map->cache = NULL;
+	return 0;
+}
+
+static int regcache_lzo_read(struct regmap *map,
+			     unsigned int reg, unsigned int *value)
+{
+	struct regcache_lzo_ctx *lzo_block, **lzo_blocks;
+	int ret, blkindex, blkpos;
+	size_t blksize, tmp_dst_len;
+	void *tmp_dst;
+
+	*value = 0;
+	/* index of the compressed lzo block */
+	blkindex = regcache_lzo_get_blkindex(map, reg);
+	/* register index within the decompressed block */
+	blkpos = regcache_lzo_get_blkpos(map, reg);
+	/* size of the compressed block */
+	blksize = regcache_lzo_get_blksize(map);
+	lzo_blocks = map->cache;
+	lzo_block = lzo_blocks[blkindex];
+
+	/* save the pointer and length of the compressed block */
+	tmp_dst = lzo_block->dst;
+	tmp_dst_len = lzo_block->dst_len;
+
+	/* prepare the source to be the compressed block */
+	lzo_block->src = lzo_block->dst;
+	lzo_block->src_len = lzo_block->dst_len;
+
+	/* decompress the block */
+	ret = regcache_lzo_decompress_cache_block(map, lzo_block);
+	if (ret >= 0)
+		/* fetch the value from the cache */
+		*value = regcache_get_val(lzo_block->dst, blkpos,
+					  map->cache_word_size);
+
+	kfree(lzo_block->dst);
+	/* restore the pointer and length of the compressed block */
+	lzo_block->dst = tmp_dst;
+	lzo_block->dst_len = tmp_dst_len;
+	return 0;
+}
+
+static int regcache_lzo_write(struct regmap *map,
+			      unsigned int reg, unsigned int value)
+{
+	struct regcache_lzo_ctx *lzo_block, **lzo_blocks;
+	int ret, blkindex, blkpos;
+	size_t blksize, tmp_dst_len;
+	void *tmp_dst;
+
+	/* index of the compressed lzo block */
+	blkindex = regcache_lzo_get_blkindex(map, reg);
+	/* register index within the decompressed block */
+	blkpos = regcache_lzo_get_blkpos(map, reg);
+	/* size of the compressed block */
+	blksize = regcache_lzo_get_blksize(map);
+	lzo_blocks = map->cache;
+	lzo_block = lzo_blocks[blkindex];
+
+	/* save the pointer and length of the compressed block */
+	tmp_dst = lzo_block->dst;
+	tmp_dst_len = lzo_block->dst_len;
+
+	/* prepare the source to be the compressed block */
+	lzo_block->src = lzo_block->dst;
+	lzo_block->src_len = lzo_block->dst_len;
+
+	/* decompress the block */
+	ret = regcache_lzo_decompress_cache_block(map, lzo_block);
+	if (ret < 0) {
+		kfree(lzo_block->dst);
+		goto out;
+	}
+
+	/* write the new value to the cache */
+	if (regcache_set_val(lzo_block->dst, blkpos, value,
+			     map->cache_word_size)) {
+		kfree(lzo_block->dst);
+		goto out;
+	}
+
+	/* prepare the source to be the decompressed block */
+	lzo_block->src = lzo_block->dst;
+	lzo_block->src_len = lzo_block->dst_len;
+
+	/* compress the block */
+	ret = regcache_lzo_compress_cache_block(map, lzo_block);
+	if (ret < 0) {
+		kfree(lzo_block->dst);
+		kfree(lzo_block->src);
+		goto out;
+	}
+
+	/* set the bit so we know we have to sync this register */
+	set_bit(reg, lzo_block->sync_bmp);
+	kfree(tmp_dst);
+	kfree(lzo_block->src);
+	return 0;
+out:
+	lzo_block->dst = tmp_dst;
+	lzo_block->dst_len = tmp_dst_len;
+	return ret;
+}
+
+static int regcache_lzo_sync(struct regmap *map)
+{
+	struct regcache_lzo_ctx **lzo_blocks;
+	unsigned int val;
+	int i;
+	int ret;
+
+	lzo_blocks = map->cache;
+	for_each_set_bit(i, lzo_blocks[0]->sync_bmp, lzo_blocks[0]->sync_bmp_nbits) {
+		ret = regcache_read(map, i, &val);
+		if (ret)
+			return ret;
+		map->cache_bypass = 1;
+		ret = regmap_write(map, i, val);
+		map->cache_bypass = 0;
+		if (ret)
+			return ret;
+		dev_dbg(map->dev, "Synced register %#x, value %#x\n",
+			i, val);
+	}
+
+	return 0;
+}
+
+struct regcache_ops regcache_lzo_ops = {
+	.type = REGCACHE_LZO,
+	.name = "lzo",
+	.init = regcache_lzo_init,
+	.exit = regcache_lzo_exit,
+	.read = regcache_lzo_read,
+	.write = regcache_lzo_write,
+	.sync = regcache_lzo_sync
+};
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index cb96968..1e4849b 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -18,6 +18,7 @@
 static const struct regcache_ops *cache_types[] = {
 	&regcache_indexed_ops,
 	&regcache_rbtree_ops,
+	&regcache_lzo_ops,
 };
 
 static int regcache_hw_init(struct regmap *map)
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 63c4a5e..cae69e6 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -25,6 +25,7 @@ enum regcache_type {
 	REGCACHE_NONE,
 	REGCACHE_INDEXED,
 	REGCACHE_RBTREE,
+	REGCACHE_LZO
 };
 
 /**
-- 
1.7.6.1

