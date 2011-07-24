Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab1GXUcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 16:32:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35128 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751849Ab1GXUcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 16:32:14 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Add basic tracepoints
Date: Sun, 24 Jul 2011 21:32:07 +0100
Message-Id: <1311539527-18996-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace single register reads and writes, plus start/stop tracepoints for
the actual I/O to see where we're spending time. This makes it easy to
have always on logging without overwhelming the logs and also lets us take
advantage of all the context and time information that the trace subsystem
collects for us.

We don't currently trace register values for bulk operations as this would
add complexity and overhead parsing the cooked data that's being worked
with.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c  |   34 +++++++++++--
 include/trace/events/regmap.h |  112 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 141 insertions(+), 5 deletions(-)
 create mode 100644 include/trace/events/regmap.h

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 18d4b07..de0334b 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -15,6 +15,9 @@
 #include <linux/mutex.h>
 #include <linux/err.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/regmap.h>
+
 #include "internal.h"
 
 static void regmap_format_4_12_write(struct regmap *map,
@@ -194,6 +197,9 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 
 	map->format.format_reg(map->work_buf, reg);
 
+	trace_regmap_hw_write_start(map->dev, reg,
+				    val_len / map->format.val_bytes);
+
 	/* If we're doing a single register write we can probably just
 	 * send the work_buf directly, otherwise try to do a gather
 	 * write.
@@ -220,19 +226,31 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 		kfree(buf);
 	}
 
+	trace_regmap_hw_write_done(map->dev, reg,
+				   val_len / map->format.val_bytes);
+
 	return ret;
 }
 
 static int _regmap_write(struct regmap *map, unsigned int reg,
 			 unsigned int val)
 {
+	int ret;
 	BUG_ON(!map->format.format_write && !map->format.format_val);
 
+	trace_regmap_reg_write(map->dev, reg, val);
+
 	if (map->format.format_write) {
 		map->format.format_write(map, reg, val);
 
-		return map->bus->write(map->dev, map->work_buf,
-				       map->format.buf_size);
+		trace_regmap_hw_write_start(map->dev, reg, 1);
+
+		ret = map->bus->write(map->dev, map->work_buf,
+				      map->format.buf_size);
+
+		trace_regmap_hw_write_done(map->dev, reg, 1);
+
+		return ret;
 	} else {
 		map->format.format_val(map->work_buf + map->format.reg_bytes,
 				       val);
@@ -314,10 +332,14 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	if (map->bus->read_flag_mask)
 		u8[0] |= map->bus->read_flag_mask;
 
+	trace_regmap_hw_read_start(map->dev, reg,
+				   val_len / map->format.val_bytes);
+
 	ret = map->bus->read(map->dev, map->work_buf, map->format.reg_bytes,
 			     val, map->format.val_bytes);
-	if (ret != 0)
-		return ret;
+
+	trace_regmap_hw_read_done(map->dev, reg,
+				  val_len / map->format.val_bytes);
 
 	return 0;
 }
@@ -331,8 +353,10 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 		return -EINVAL;
 
 	ret = _regmap_raw_read(map, reg, map->work_buf, map->format.val_bytes);
-	if (ret == 0)
+	if (ret == 0) {
 		*val = map->format.parse_val(map->work_buf);
+		trace_regmap_reg_read(map->dev, reg, *val);
+	}
 
 	return ret;
 }
diff --git a/include/trace/events/regmap.h b/include/trace/events/regmap.h
new file mode 100644
index 0000000..1c76f40
--- /dev/null
+++ b/include/trace/events/regmap.h
@@ -0,0 +1,112 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM regmap
+
+#if !defined(_TRACE_REGMAP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_REGMAP_H
+
+#include <linux/device.h>
+#include <linux/ktime.h>
+#include <linux/tracepoint.h>
+
+struct regmap;
+
+/*
+ * Log register events
+ */
+DECLARE_EVENT_CLASS(regmap_reg,
+
+	TP_PROTO(struct device *dev, unsigned int reg,
+		 unsigned int val),
+
+	TP_ARGS(dev, reg, val),
+
+	TP_STRUCT__entry(
+		__string(	name,		dev_name(dev)	)
+		__field(	unsigned int,	reg		)
+		__field(	unsigned int,	val		)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, dev_name(dev));
+		__entry->reg = reg;
+		__entry->val = val;
+	),
+
+	TP_printk("%s reg=%x val=%x", __get_str(name),
+		  (unsigned int)__entry->reg,
+		  (unsigned int)__entry->val)
+);
+
+DEFINE_EVENT(regmap_reg, regmap_reg_write,
+
+	TP_PROTO(struct device *dev, unsigned int reg,
+		 unsigned int val),
+
+	TP_ARGS(dev, reg, val)
+
+);
+
+DEFINE_EVENT(regmap_reg, regmap_reg_read,
+
+	TP_PROTO(struct device *dev, unsigned int reg,
+		 unsigned int val),
+
+	TP_ARGS(dev, reg, val)
+
+);
+
+DECLARE_EVENT_CLASS(regmap_block,
+
+	TP_PROTO(struct device *dev, unsigned int reg, size_t count),
+
+	TP_ARGS(dev, reg, count),
+
+	TP_STRUCT__entry(
+		__string(	name,		dev_name(dev)	)
+		__field(	unsigned int,	reg		)
+		__field(	size_t,		count		)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, dev_name(dev));
+		__entry->reg = reg;
+		__entry->count = count;
+	),
+
+	TP_printk("%s reg=%x count=%d", __get_str(name),
+		  (unsigned int)__entry->reg,
+		  (size_t)__entry->count)
+);
+
+DEFINE_EVENT(regmap_block, regmap_hw_read_start,
+
+	TP_PROTO(struct device *dev, unsigned int reg, size_t count),
+
+	TP_ARGS(dev, reg, count)
+);
+
+DEFINE_EVENT(regmap_block, regmap_hw_read_done,
+
+	TP_PROTO(struct device *dev, unsigned int reg, size_t count),
+
+	TP_ARGS(dev, reg, count)
+);
+
+DEFINE_EVENT(regmap_block, regmap_hw_write_start,
+
+	TP_PROTO(struct device *dev, unsigned int reg, size_t count),
+
+	TP_ARGS(dev, reg, count)
+);
+
+DEFINE_EVENT(regmap_block, regmap_hw_write_done,
+
+	TP_PROTO(struct device *dev, unsigned int reg, size_t count),
+
+	TP_ARGS(dev, reg, count)
+);
+
+#endif /* _TRACE_REGMAP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.5.4

