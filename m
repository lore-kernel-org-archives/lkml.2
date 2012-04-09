Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab2DITkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:40:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41267 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab2DITkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:40:32 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2] regmap: implement register striding
Date: Mon,  9 Apr 2012 13:40:24 -0600
Message-Id: <1334000424-19916-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

regmap_config.reg_stride is introduced. All extant register addresses
are a multiple of this value. Users of serial-oriented regmap busses will
typically set this to 1. Users of the MMIO regmap bus will typically set
this based on the value size of their registers, in bytes, so 4 for a
32-bit register.

Throughout the regmap code, actual register addresses are used. Wherever
the register address is used to index some array of values, the address
is divided by the stride to determine the index, or vice-versa. Error-
checking is added to all entry-points for register address data to ensure
that register addresses actually satisfy the specified stride. The MMIO
bus ensures that the specified stride is large enough for the register
size.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Replace ternary operator when setting map->reg_stride.
Also, briefly tested regcache-lzo.c

 drivers/base/regmap/internal.h        |    1 +
 drivers/base/regmap/regcache-lzo.c    |   11 +++++----
 drivers/base/regmap/regcache-rbtree.c |   40 +++++++++++++++++++--------------
 drivers/base/regmap/regcache.c        |   14 +++++++++--
 drivers/base/regmap/regmap-debugfs.c  |    4 +-
 drivers/base/regmap/regmap-irq.c      |   34 +++++++++++++++++++---------
 drivers/base/regmap/regmap-mmio.c     |   13 ++++++++++
 drivers/base/regmap/regmap.c          |   30 +++++++++++++++++++++---
 include/linux/regmap.h                |    4 +++
 9 files changed, 109 insertions(+), 42 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 99b28ff..d92e9b1 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -62,6 +62,7 @@ struct regmap {
 
 	/* number of bits to (left) shift the reg value when formatting*/
 	int reg_shift;
+	int reg_stride;
 
 	/* regcache specific members */
 	const struct regcache_ops *cache_ops;
diff --git a/drivers/base/regmap/regcache-lzo.c b/drivers/base/regmap/regcache-lzo.c
index 483b06d..afd6aa9 100644
--- a/drivers/base/regmap/regcache-lzo.c
+++ b/drivers/base/regmap/regcache-lzo.c
@@ -108,7 +108,7 @@ static int regcache_lzo_decompress_cache_block(struct regmap *map,
 static inline int regcache_lzo_get_blkindex(struct regmap *map,
 					    unsigned int reg)
 {
-	return (reg * map->cache_word_size) /
+	return ((reg / map->reg_stride) * map->cache_word_size) /
 		DIV_ROUND_UP(map->cache_size_raw,
 			     regcache_lzo_block_count(map));
 }
@@ -116,9 +116,10 @@ static inline int regcache_lzo_get_blkindex(struct regmap *map,
 static inline int regcache_lzo_get_blkpos(struct regmap *map,
 					  unsigned int reg)
 {
-	return reg % (DIV_ROUND_UP(map->cache_size_raw,
-				   regcache_lzo_block_count(map)) /
-		      map->cache_word_size);
+	return (reg / map->reg_stride) %
+		    (DIV_ROUND_UP(map->cache_size_raw,
+				  regcache_lzo_block_count(map)) /
+		     map->cache_word_size);
 }
 
 static inline int regcache_lzo_get_blksize(struct regmap *map)
@@ -322,7 +323,7 @@ static int regcache_lzo_write(struct regmap *map,
 	}
 
 	/* set the bit so we know we have to sync this register */
-	set_bit(reg, lzo_block->sync_bmp);
+	set_bit(reg / map->reg_stride, lzo_block->sync_bmp);
 	kfree(tmp_dst);
 	kfree(lzo_block->src);
 	return 0;
diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index e49e71f..e6732cf 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -39,11 +39,12 @@ struct regcache_rbtree_ctx {
 };
 
 static inline void regcache_rbtree_get_base_top_reg(
+	struct regmap *map,
 	struct regcache_rbtree_node *rbnode,
 	unsigned int *base, unsigned int *top)
 {
 	*base = rbnode->base_reg;
-	*top = rbnode->base_reg + rbnode->blklen - 1;
+	*top = rbnode->base_reg + ((rbnode->blklen - 1) * map->reg_stride);
 }
 
 static unsigned int regcache_rbtree_get_register(
@@ -70,7 +71,8 @@ static struct regcache_rbtree_node *regcache_rbtree_lookup(struct regmap *map,
 
 	rbnode = rbtree_ctx->cached_rbnode;
 	if (rbnode) {
-		regcache_rbtree_get_base_top_reg(rbnode, &base_reg, &top_reg);
+		regcache_rbtree_get_base_top_reg(map, rbnode, &base_reg,
+						 &top_reg);
 		if (reg >= base_reg && reg <= top_reg)
 			return rbnode;
 	}
@@ -78,7 +80,8 @@ static struct regcache_rbtree_node *regcache_rbtree_lookup(struct regmap *map,
 	node = rbtree_ctx->root.rb_node;
 	while (node) {
 		rbnode = container_of(node, struct regcache_rbtree_node, node);
-		regcache_rbtree_get_base_top_reg(rbnode, &base_reg, &top_reg);
+		regcache_rbtree_get_base_top_reg(map, rbnode, &base_reg,
+						 &top_reg);
 		if (reg >= base_reg && reg <= top_reg) {
 			rbtree_ctx->cached_rbnode = rbnode;
 			return rbnode;
@@ -92,7 +95,7 @@ static struct regcache_rbtree_node *regcache_rbtree_lookup(struct regmap *map,
 	return NULL;
 }
 
-static int regcache_rbtree_insert(struct rb_root *root,
+static int regcache_rbtree_insert(struct regmap *map, struct rb_root *root,
 				  struct regcache_rbtree_node *rbnode)
 {
 	struct rb_node **new, *parent;
@@ -106,7 +109,7 @@ static int regcache_rbtree_insert(struct rb_root *root,
 		rbnode_tmp = container_of(*new, struct regcache_rbtree_node,
 					  node);
 		/* base and top registers of the current rbnode */
-		regcache_rbtree_get_base_top_reg(rbnode_tmp, &base_reg_tmp,
+		regcache_rbtree_get_base_top_reg(map, rbnode_tmp, &base_reg_tmp,
 						 &top_reg_tmp);
 		/* base register of the rbnode to be added */
 		base_reg = rbnode->base_reg;
@@ -138,7 +141,7 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	unsigned int base, top;
 	int nodes = 0;
 	int registers = 0;
-	int average;
+	int this_registers, average;
 
 	map->lock(map);
 
@@ -146,11 +149,12 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	     node = rb_next(node)) {
 		n = container_of(node, struct regcache_rbtree_node, node);
 
-		regcache_rbtree_get_base_top_reg(n, &base, &top);
-		seq_printf(s, "%x-%x (%d)\n", base, top, top - base + 1);
+		regcache_rbtree_get_base_top_reg(map, n, &base, &top);
+		this_registers = ((top - base) / map->reg_stride) + 1;
+		seq_printf(s, "%x-%x (%d)\n", base, top, this_registers);
 
 		nodes++;
-		registers += top - base + 1;
+		registers += this_registers;
 	}
 
 	if (nodes)
@@ -255,7 +259,7 @@ static int regcache_rbtree_read(struct regmap *map,
 
 	rbnode = regcache_rbtree_lookup(map, reg);
 	if (rbnode) {
-		reg_tmp = reg - rbnode->base_reg;
+		reg_tmp = (reg - rbnode->base_reg) / map->reg_stride;
 		*value = regcache_rbtree_get_register(rbnode, reg_tmp,
 						      map->cache_word_size);
 	} else {
@@ -310,7 +314,7 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 	 */
 	rbnode = regcache_rbtree_lookup(map, reg);
 	if (rbnode) {
-		reg_tmp = reg - rbnode->base_reg;
+		reg_tmp = (reg - rbnode->base_reg) / map->reg_stride;
 		val = regcache_rbtree_get_register(rbnode, reg_tmp,
 						   map->cache_word_size);
 		if (val == value)
@@ -321,13 +325,15 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 		/* look for an adjacent register to the one we are about to add */
 		for (node = rb_first(&rbtree_ctx->root); node;
 		     node = rb_next(node)) {
-			rbnode_tmp = rb_entry(node, struct regcache_rbtree_node, node);
+			rbnode_tmp = rb_entry(node, struct regcache_rbtree_node,
+					      node);
 			for (i = 0; i < rbnode_tmp->blklen; i++) {
-				reg_tmp = rbnode_tmp->base_reg + i;
-				if (abs(reg_tmp - reg) != 1)
+				reg_tmp = rbnode_tmp->base_reg +
+						(i * map->reg_stride);
+				if (abs(reg_tmp - reg) != map->reg_stride)
 					continue;
 				/* decide where in the block to place our register */
-				if (reg_tmp + 1 == reg)
+				if (reg_tmp + map->reg_stride == reg)
 					pos = i + 1;
 				else
 					pos = i;
@@ -357,7 +363,7 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 			return -ENOMEM;
 		}
 		regcache_rbtree_set_register(rbnode, 0, value, map->cache_word_size);
-		regcache_rbtree_insert(&rbtree_ctx->root, rbnode);
+		regcache_rbtree_insert(map, &rbtree_ctx->root, rbnode);
 		rbtree_ctx->cached_rbnode = rbnode;
 	}
 
@@ -397,7 +403,7 @@ static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
 			end = rbnode->blklen;
 
 		for (i = base; i < end; i++) {
-			regtmp = rbnode->base_reg + i;
+			regtmp = rbnode->base_reg + (i * map->reg_stride);
 			val = regcache_rbtree_get_register(rbnode, i,
 							   map->cache_word_size);
 
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index d4368e8..835883b 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -59,7 +59,7 @@ static int regcache_hw_init(struct regmap *map)
 	for (count = 0, i = 0; i < map->num_reg_defaults_raw; i++) {
 		val = regcache_get_val(map->reg_defaults_raw,
 				       i, map->cache_word_size);
-		if (regmap_volatile(map, i))
+		if (regmap_volatile(map, i * map->reg_stride))
 			continue;
 		count++;
 	}
@@ -76,9 +76,9 @@ static int regcache_hw_init(struct regmap *map)
 	for (i = 0, j = 0; i < map->num_reg_defaults_raw; i++) {
 		val = regcache_get_val(map->reg_defaults_raw,
 				       i, map->cache_word_size);
-		if (regmap_volatile(map, i))
+		if (regmap_volatile(map, i * map->reg_stride))
 			continue;
-		map->reg_defaults[j].reg = i;
+		map->reg_defaults[j].reg = i * map->reg_stride;
 		map->reg_defaults[j].def = val;
 		j++;
 	}
@@ -98,6 +98,10 @@ int regcache_init(struct regmap *map, const struct regmap_config *config)
 	int i;
 	void *tmp_buf;
 
+	for (i = 0; i < config->num_reg_defaults; i++)
+		if (config->reg_defaults[i].reg % map->reg_stride)
+			return -EINVAL;
+
 	if (map->cache_type == REGCACHE_NONE) {
 		map->cache_bypass = true;
 		return 0;
@@ -278,6 +282,10 @@ int regcache_sync(struct regmap *map)
 	/* Apply any patch first */
 	map->cache_bypass = 1;
 	for (i = 0; i < map->patch_regs; i++) {
+		if (map->patch[i].reg % map->reg_stride) {
+			ret = -EINVAL;
+			goto out;
+		}
 		ret = _regmap_write(map, map->patch[i].reg, map->patch[i].def);
 		if (ret != 0) {
 			dev_err(map->dev, "Failed to write %x = %x: %d\n",
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index df97c93..bb1ff17 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -80,7 +80,7 @@ static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
 	val_len = 2 * map->format.val_bytes;
 	tot_len = reg_len + val_len + 3;      /* : \n */
 
-	for (i = 0; i < map->max_register + 1; i++) {
+	for (i = 0; i <= map->max_register; i += map->reg_stride) {
 		if (!regmap_readable(map, i))
 			continue;
 
@@ -197,7 +197,7 @@ static ssize_t regmap_access_read_file(struct file *file,
 	reg_len = regmap_calc_reg_len(map->max_register, buf, count);
 	tot_len = reg_len + 10; /* ': R W V P\n' */
 
-	for (i = 0; i < map->max_register + 1; i++) {
+	for (i = 0; i <= map->max_register; i += map->reg_stride) {
 		/* Ignore registers which are neither readable nor writable */
 		if (!regmap_readable(map, i) && !regmap_writeable(map, i))
 			continue;
diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 1befaa7..56b8136 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -58,11 +58,12 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 	 * suppress pointless writes.
 	 */
 	for (i = 0; i < d->chip->num_regs; i++) {
-		ret = regmap_update_bits(d->map, d->chip->mask_base + i,
+		ret = regmap_update_bits(d->map, d->chip->mask_base +
+						(i * map->map->reg_stride),
 					 d->mask_buf_def[i], d->mask_buf[i]);
 		if (ret != 0)
 			dev_err(d->map->dev, "Failed to sync masks in %x\n",
-				d->chip->mask_base + i);
+				d->chip->mask_base + (i * map->reg_stride));
 	}
 
 	mutex_unlock(&d->lock);
@@ -73,7 +74,7 @@ static void regmap_irq_enable(struct irq_data *data)
 	struct regmap_irq_chip_data *d = irq_data_get_irq_chip_data(data);
 	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->irq);
 
-	d->mask_buf[irq_data->reg_offset] &= ~irq_data->mask;
+	d->mask_buf[irq_data->reg_offset / map->reg_stride] &= ~irq_data->mask;
 }
 
 static void regmap_irq_disable(struct irq_data *data)
@@ -81,7 +82,7 @@ static void regmap_irq_disable(struct irq_data *data)
 	struct regmap_irq_chip_data *d = irq_data_get_irq_chip_data(data);
 	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->irq);
 
-	d->mask_buf[irq_data->reg_offset] |= irq_data->mask;
+	d->mask_buf[irq_data->reg_offset / map->reg_stride] |= irq_data->mask;
 }
 
 static struct irq_chip regmap_irq_chip = {
@@ -136,17 +137,19 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 		data->status_buf[i] &= ~data->mask_buf[i];
 
 		if (data->status_buf[i] && chip->ack_base) {
-			ret = regmap_write(map, chip->ack_base + i,
+			ret = regmap_write(map, chip->ack_base +
+						(i * map->reg_stride),
 					   data->status_buf[i]);
 			if (ret != 0)
 				dev_err(map->dev, "Failed to ack 0x%x: %d\n",
-					chip->ack_base + i, ret);
+					chip->ack_base + (i * map->reg_stride),
+					ret);
 		}
 	}
 
 	for (i = 0; i < chip->num_irqs; i++) {
-		if (data->status_buf[chip->irqs[i].reg_offset] &
-		    chip->irqs[i].mask) {
+		if (data->status_buf[chip->irqs[i].reg_offset /
+				     map->reg_stride] & chip->irqs[i].mask) {
 			handle_nested_irq(data->irq_base + i);
 			handled = true;
 		}
@@ -181,6 +184,14 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	int cur_irq, i;
 	int ret = -ENOMEM;
 
+	for (i = 0; i < chip->num_irqs; i++) {
+		if (chip->irqs[i].reg_offset % map->reg_stride)
+			return -EINVAL;
+		if (chip->irqs[i].reg_offset / map->reg_stride >=
+		    chip->num_regs)
+			return -EINVAL;
+	}
+
 	irq_base = irq_alloc_descs(irq_base, 0, chip->num_irqs, 0);
 	if (irq_base < 0) {
 		dev_warn(map->dev, "Failed to allocate IRQs: %d\n",
@@ -218,16 +229,17 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	mutex_init(&d->lock);
 
 	for (i = 0; i < chip->num_irqs; i++)
-		d->mask_buf_def[chip->irqs[i].reg_offset]
+		d->mask_buf_def[chip->irqs[i].reg_offset / map->reg_stride]
 			|= chip->irqs[i].mask;
 
 	/* Mask all the interrupts by default */
 	for (i = 0; i < chip->num_regs; i++) {
 		d->mask_buf[i] = d->mask_buf_def[i];
-		ret = regmap_write(map, chip->mask_base + i, d->mask_buf[i]);
+		ret = regmap_write(map, chip->mask_base + (i * map->reg_stride),
+				   d->mask_buf[i]);
 		if (ret != 0) {
 			dev_err(map->dev, "Failed to set masks in 0x%x: %d\n",
-				chip->mask_base + i, ret);
+				chip->mask_base + (i * map->reg_stride), ret);
 			goto err_alloc;
 		}
 	}
diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index bdf4dc8..febd6de 100644
--- a/drivers/base/regmap/regmap-mmio.c
+++ b/drivers/base/regmap/regmap-mmio.c
@@ -130,6 +130,7 @@ struct regmap_mmio_context *regmap_mmio_gen_context(void __iomem *regs,
 					const struct regmap_config *config)
 {
 	struct regmap_mmio_context *ctx;
+	int min_stride;
 
 	if (config->reg_bits != 32)
 		return ERR_PTR(-EINVAL);
@@ -139,16 +140,28 @@ struct regmap_mmio_context *regmap_mmio_gen_context(void __iomem *regs,
 
 	switch (config->val_bits) {
 	case 8:
+		/* The core treats 0 as 1 */
+		min_stride = 0;
+		break;
 	case 16:
+		min_stride = 2;
+		break;
 	case 32:
+		min_stride = 4;
+		break;
 #ifdef CONFIG_64BIT
 	case 64:
+		min_stride = 8;
+		break;
 #endif
 		break;
 	default:
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (config->reg_stride < min_stride)
+		return ERR_PTR(-EINVAL);
+
 	ctx = kzalloc(GFP_KERNEL, sizeof(*ctx));
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 40f9101..8a25006 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -243,6 +243,10 @@ struct regmap *regmap_init(struct device *dev,
 	map->format.val_bytes = DIV_ROUND_UP(config->val_bits, 8);
 	map->format.buf_size += map->format.pad_bytes;
 	map->reg_shift = config->pad_bits % 8;
+	if (config->reg_stride)
+		map->reg_stride = config->reg_stride;
+	else
+		map->reg_stride = 1;
 	map->dev = dev;
 	map->bus = bus;
 	map->bus_context = bus_context;
@@ -469,7 +473,8 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	/* Check for unwritable registers before we start */
 	if (map->writeable_reg)
 		for (i = 0; i < val_len / map->format.val_bytes; i++)
-			if (!map->writeable_reg(map->dev, reg + i))
+			if (!map->writeable_reg(map->dev,
+						reg + (i * map->reg_stride)))
 				return -EINVAL;
 
 	if (!map->cache_bypass && map->format.parse_val) {
@@ -478,7 +483,8 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 		for (i = 0; i < val_len / val_bytes; i++) {
 			memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
 			ival = map->format.parse_val(map->work_buf);
-			ret = regcache_write(map, reg + i, ival);
+			ret = regcache_write(map, reg + (i * map->reg_stride),
+					     ival);
 			if (ret) {
 				dev_err(map->dev,
 				   "Error in caching of register: %u ret: %d\n",
@@ -590,6 +596,9 @@ int regmap_write(struct regmap *map, unsigned int reg, unsigned int val)
 {
 	int ret;
 
+	if (reg % map->reg_stride)
+		return -EINVAL;
+
 	map->lock(map);
 
 	ret = _regmap_write(map, reg, val);
@@ -623,6 +632,8 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 
 	if (val_len % map->format.val_bytes)
 		return -EINVAL;
+	if (reg % map->reg_stride)
+		return -EINVAL;
 
 	map->lock(map);
 
@@ -657,6 +668,8 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 
 	if (!map->format.parse_val)
 		return -EINVAL;
+	if (reg % map->reg_stride)
+		return -EINVAL;
 
 	map->lock(map);
 
@@ -753,6 +766,9 @@ int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val)
 {
 	int ret;
 
+	if (reg % map->reg_stride)
+		return -EINVAL;
+
 	map->lock(map);
 
 	ret = _regmap_read(map, reg, val);
@@ -784,6 +800,8 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 
 	if (val_len % map->format.val_bytes)
 		return -EINVAL;
+	if (reg % map->reg_stride)
+		return -EINVAL;
 
 	map->lock(map);
 
@@ -797,7 +815,8 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 		 * cost as we expect to hit the cache.
 		 */
 		for (i = 0; i < val_count; i++) {
-			ret = _regmap_read(map, reg + i, &v);
+			ret = _regmap_read(map, reg + (i * map->reg_stride),
+					   &v);
 			if (ret != 0)
 				goto out;
 
@@ -832,6 +851,8 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 
 	if (!map->format.parse_val)
 		return -EINVAL;
+	if (reg % map->reg_stride)
+		return -EINVAL;
 
 	if (vol || map->cache_type == REGCACHE_NONE) {
 		ret = regmap_raw_read(map, reg, val, val_bytes * val_count);
@@ -842,7 +863,8 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 			map->format.parse_val(val + i);
 	} else {
 		for (i = 0; i < val_count; i++) {
-			ret = regmap_read(map, reg + i, val + (i * val_bytes));
+			ret = regmap_read(map, reg + (i * map->reg_stride),
+					  val + (i * val_bytes));
 			if (ret != 0)
 				return ret;
 		}
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 680ddd7..0258bcd 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -50,6 +50,9 @@ struct reg_default {
  *        register regions.
  *
  * @reg_bits: Number of bits in a register address, mandatory.
+ * @reg_stride: The register address stride. Valid register addresses are a
+ *              multiple of this value. If set to 0, a value of 1 will be
+ *              used.
  * @pad_bits: Number of bits of padding between register and value.
  * @val_bits: Number of bits in a register value, mandatory.
  *
@@ -83,6 +86,7 @@ struct regmap_config {
 	const char *name;
 
 	int reg_bits;
+	int reg_stride;
 	int pad_bits;
 	int val_bits;
 
-- 
1.7.0.4

