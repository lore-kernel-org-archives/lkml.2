Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1GZSGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:06:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54059 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751753Ab1GZSGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:06:23 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/5] regmap: Use a local header for API internals
Date: Tue, 26 Jul 2011 19:06:14 +0100
Message-Id: <1311703576-7955-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311703576-7955-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1311703576-7955-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allowing the implementation to be multi-file.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h |   45 ++++++++++++++++++++++++++++++++++++++++
 drivers/base/regmap/regmap.c   |   29 +------------------------
 2 files changed, 46 insertions(+), 28 deletions(-)
 create mode 100644 drivers/base/regmap/internal.h

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
new file mode 100644
index 0000000..7e61504
--- /dev/null
+++ b/drivers/base/regmap/internal.h
@@ -0,0 +1,45 @@
+/*
+ * Register map access API internal header
+ *
+ * Copyright 2011 Wolfson Microelectronics plc
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _REGMAP_INTERNAL_H
+#define _REGMAP_INTERNAL_H
+
+#include <linux/regmap.h>
+
+struct regmap;
+
+struct regmap_format {
+	size_t buf_size;
+	size_t reg_bytes;
+	size_t val_bytes;
+	void (*format_write)(struct regmap *map,
+			     unsigned int reg, unsigned int val);
+	void (*format_reg)(void *buf, unsigned int reg);
+	void (*format_val)(void *buf, unsigned int val);
+	unsigned int (*parse_val)(void *buf);
+};
+
+struct regmap {
+	struct mutex lock;
+
+	struct device *dev; /* Device we do I/O on */
+	void *work_buf;     /* Scratch buffer used to format I/O */
+	struct regmap_format format;  /* Buffer format */
+	const struct regmap_bus *bus;
+
+	unsigned int max_register;
+	bool (*writeable_reg)(struct device *dev, unsigned int reg);
+	bool (*readable_reg)(struct device *dev, unsigned int reg);
+	bool (*volatile_reg)(struct device *dev, unsigned int reg);
+};
+
+#endif
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index e57f10f..f51efeb 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -15,37 +15,10 @@
 #include <linux/mutex.h>
 #include <linux/err.h>
 
-#include <linux/regmap.h>
-
 #define CREATE_TRACE_POINTS
 #include <trace/events/regmap.h>
 
-struct regmap;
-
-struct regmap_format {
-	size_t buf_size;
-	size_t reg_bytes;
-	size_t val_bytes;
-	void (*format_write)(struct regmap *map,
-			     unsigned int reg, unsigned int val);
-	void (*format_reg)(void *buf, unsigned int reg);
-	void (*format_val)(void *buf, unsigned int val);
-	unsigned int (*parse_val)(void *buf);
-};
-
-struct regmap {
-	struct mutex lock;
-
-	struct device *dev; /* Device we do I/O on */
-	void *work_buf;     /* Scratch buffer used to format I/O */
-	struct regmap_format format;  /* Buffer format */
-	const struct regmap_bus *bus;
-
-	unsigned int max_register;
-	bool (*writeable_reg)(struct device *dev, unsigned int reg);
-	bool (*readable_reg)(struct device *dev, unsigned int reg);
-	bool (*volatile_reg)(struct device *dev, unsigned int reg);
-};
+#include "internal.h"
 
 static void regmap_format_4_12_write(struct regmap *map,
 				     unsigned int reg, unsigned int val)
-- 
1.7.5.4

