Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767708Ab2KOMrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 07:47:25 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:49429 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423250Ab2KOMrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:47:19 -0500
From: ciminaghi@gnudd.com
To: broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH RESEND] regmap: introduce tables for readable/writeable/volatile/precious checks
Date: Thu, 15 Nov 2012 13:46:52 +0100
Message-Id: <1352983612-3474-1-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

Many of the regmap enabled drivers implementing one or more of the
readable, writeable, volatile and precious methods use the same code
pattern:

	return ((reg >= X && reg <= Y) || (reg >= W && reg <= Z) || ...)

Switch to a data driven approach, using tables to describe
readable/writeable/volatile and precious registers ranges instead.
The table based check can still be overridden by passing the usual function
pointers via struct regmap_config.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---

I haven't seen any reply up to now, so I'm just resending the original patch
(see https://lkml.org/lkml/2012/10/25/224).
I just applied it to today's next and did a quick re-test.

 drivers/base/regmap/internal.h |    4 +++
 drivers/base/regmap/regmap.c   |   50 +++++++++++++++++++++++++++
 include/linux/regmap.h         |   73 ++++++++++++++++++++++++++++++++++------
 3 files changed, 116 insertions(+), 11 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 2cd01b5..c6e64e0 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -55,6 +55,10 @@ struct regmap {
 	bool (*readable_reg)(struct device *dev, unsigned int reg);
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);
 	bool (*precious_reg)(struct device *dev, unsigned int reg);
+	const struct regmap_range_table *wr_table;
+	const struct regmap_range_table *rd_table;
+	const struct regmap_range_table *volatile_table;
+	const struct regmap_range_table *precious_table;
 
 	u8 read_flag_mask;
 	u8 write_flag_mask;
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 273bf30..054b3c4 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -34,6 +34,40 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 			       unsigned int mask, unsigned int val,
 			       bool *change);
 
+static inline bool _reg_in_range(unsigned int reg,
+				 const struct regmap_range *range)
+{
+	return reg >= range->range_min && reg <= range->range_max;
+}
+
+static inline bool _reg_in_ranges(unsigned int reg,
+				  const struct regmap_range *ranges,
+				  unsigned int nranges)
+{
+	const struct regmap_range *r;
+	int i;
+
+	for (i = 0, r = ranges; i < nranges; i++, r++)
+		if (_reg_in_range(reg, r))
+			return true;
+	return false;
+}
+
+static bool _regmap_check_range_table(struct regmap *map,
+				      unsigned int reg,
+				      const struct regmap_range_table *table)
+{
+	/* Check "no ranges" first */
+	if (_reg_in_ranges(reg, table->no_ranges, table->n_no_ranges))
+		return false;
+
+	/* In case zero "yes ranges" are supplied, any reg is OK */
+	if (!table->n_yes_ranges)
+		return true;
+
+	return _reg_in_ranges(reg, table->yes_ranges, table->n_yes_ranges);
+}
+
 bool regmap_writeable(struct regmap *map, unsigned int reg)
 {
 	if (map->max_register && reg > map->max_register)
@@ -42,6 +76,9 @@ bool regmap_writeable(struct regmap *map, unsigned int reg)
 	if (map->writeable_reg)
 		return map->writeable_reg(map->dev, reg);
 
+	if (map->wr_table)
+		return _regmap_check_range_table(map, reg, map->wr_table);
+
 	return true;
 }
 
@@ -56,6 +93,9 @@ bool regmap_readable(struct regmap *map, unsigned int reg)
 	if (map->readable_reg)
 		return map->readable_reg(map->dev, reg);
 
+	if (map->rd_table)
+		return _regmap_check_range_table(map, reg, map->rd_table);
+
 	return true;
 }
 
@@ -67,6 +107,9 @@ bool regmap_volatile(struct regmap *map, unsigned int reg)
 	if (map->volatile_reg)
 		return map->volatile_reg(map->dev, reg);
 
+	if (map->volatile_table)
+		return _regmap_check_range_table(map, reg, map->volatile_table);
+
 	return true;
 }
 
@@ -78,6 +121,9 @@ bool regmap_precious(struct regmap *map, unsigned int reg)
 	if (map->precious_reg)
 		return map->precious_reg(map->dev, reg);
 
+	if (map->precious_table)
+		return _regmap_check_range_table(map, reg, map->precious_table);
+
 	return false;
 }
 
@@ -370,6 +416,10 @@ struct regmap *regmap_init(struct device *dev,
 	map->bus = bus;
 	map->bus_context = bus_context;
 	map->max_register = config->max_register;
+	map->wr_table = config->wr_table;
+	map->rd_table = config->rd_table;
+	map->volatile_table = config->volatile_table;
+	map->precious_table = config->precious_table;
 	map->writeable_reg = config->writeable_reg;
 	map->readable_reg = config->readable_reg;
 	map->volatile_reg = config->volatile_reg;
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index fedf7ba..e4e0ef6 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -54,6 +54,36 @@ enum regmap_endian {
 	REGMAP_ENDIAN_NATIVE,
 };
 
+/**
+ * A register range, used for access related checks
+ * (readable/writeable/volatile/precious checks)
+ *
+ * @range_min: address of first register
+ * @range_max: address of last register
+ */
+struct regmap_range {
+	unsigned int range_min;
+	unsigned int range_max;
+};
+
+/*
+ * A table of ranges including some yes ranges and some no ranges.
+ * If a register belongs to a no_range, the corresponding check function
+ * will return false. If a register belongs to a yes range, the corresponding
+ * check function will return true. "no_ranges" are searched first.
+ *
+ * @yes_ranges : pointer to an array of regmap ranges used as "yes ranges"
+ * @n_yes_ranges: size of the above array
+ * @no_ranges: pointer to an array of regmap ranges used as "no ranges"
+ * @n_no_ranges: size of the above array
+ */
+struct regmap_range_table {
+	const struct regmap_range *yes_ranges;
+	unsigned int n_yes_ranges;
+	const struct regmap_range *no_ranges;
+	unsigned int n_no_ranges;
+};
+
 typedef void (*regmap_lock)(void *);
 typedef void (*regmap_unlock)(void *);
 
@@ -71,22 +101,39 @@ typedef void (*regmap_unlock)(void *);
  * @val_bits: Number of bits in a register value, mandatory.
  *
  * @writeable_reg: Optional callback returning true if the register
- *                 can be written to.
+ *		   can be written to. If this field is NULL but wr_table
+ *		   (see below) is not, the check is performed on such table
+ *                 (a register is writeable if it belongs to one of the ranges
+ *                  specified by wr_table).
  * @readable_reg: Optional callback returning true if the register
- *                can be read from.
+ *		  can be read from. If this field is NULL but rd_table
+ *		   (see below) is not, the check is performed on such table
+ *                 (a register is readable if it belongs to one of the ranges
+ *                  specified by rd_table).
  * @volatile_reg: Optional callback returning true if the register
- *                value can't be cached.
+ *		  value can't be cached. If this field is NULL but
+ *		  volatile_table (see below) is not, the check is performed on
+ *                such table (a register is volatile if it belongs to one of
+ *                the ranges specified by volatile_table).
  * @precious_reg: Optional callback returning true if the rgister
- *                should not be read outside of a call from the driver
- *                (eg, a clear on read interrupt status register).
- * @lock:         Optional lock callback (overrides regmap's default lock
- *                function, based on spinlock or mutex).
- * @unlock:       As above for unlocking.
- * @lock_arg:     this field is passed as the only argument of lock/unlock
- *                functions (ignored in case regular lock/unlock functions
- *                are not overridden).
+ *		  should not be read outside of a call from the driver
+ *		  (eg, a clear on read interrupt status register). If this
+ *                field is NULL but precious_table (see below) is not, the
+ *                check is performed on such table (a register is precious if
+ *                it belongs to one of the ranges specified by precious_table).
+ * @lock:	  Optional lock callback (overrides regmap's default lock
+ *		  function, based on spinlock or mutex).
+ * @unlock:	  As above for unlocking.
+ * @lock_arg:	  this field is passed as the only argument of lock/unlock
+ *		  functions (ignored in case regular lock/unlock functions
+ *		  are not overridden).
  *
  * @max_register: Optional, specifies the maximum valid register index.
+ * @wr_table:     Optional, points to a struct regmap_range_table specifying
+ *                valid ranges for write access.
+ * @rd_table:     As above, for read access.
+ * @volatile_table: As above, for volatile registers.
+ * @precious_table: As above, for precious registers.
  * @reg_defaults: Power on reset values for registers (for use with
  *                register cache support).
  * @num_reg_defaults: Number of elements in reg_defaults.
@@ -131,6 +178,10 @@ struct regmap_config {
 	void *lock_arg;
 
 	unsigned int max_register;
+	const struct regmap_range_table *wr_table;
+	const struct regmap_range_table *rd_table;
+	const struct regmap_range_table *volatile_table;
+	const struct regmap_range_table *precious_table;
 	const struct reg_default *reg_defaults;
 	unsigned int num_reg_defaults;
 	enum regcache_type cache_type;
-- 
1.7.10.4

