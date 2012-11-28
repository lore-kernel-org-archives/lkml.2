Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2K1JXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 04:23:12 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58694 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab2K1JXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 04:23:10 -0500
From: Mukund Navada <navada@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Mukund Navada <navada@ti.com>
Subject: [PATCH 1/1] regmap: Add support for continously numbered pages across regmap range
Date: Wed, 28 Nov 2012 14:52:57 +0530
Message-ID: <1354094577-14967-1-git-send-email-navada@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <n>
References: <n>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Page number in some devices increases across regmap ranges since the
selector register to choose the page remains the same. So in order to
write correct page number, the start_page_num is stored in
regmap_range_cfg.

Signed-off-by: Mukund Navada <navada@ti.com>
---
 drivers/base/regmap/internal.h |    2 ++
 drivers/base/regmap/regmap.c   |    2 ++
 include/linux/regmap.h         |    5 +++++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 288e135..fd31f5d 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -134,6 +134,8 @@ struct regmap_range_node {
 
 	unsigned int window_start;
 	unsigned int window_len;
+
+	unsigned int start_page_num;
 };
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 42d5cb0..39e37a4 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -645,6 +645,7 @@ struct regmap *regmap_init(struct device *dev,
 		new->selector_shift = range_cfg->selector_shift;
 		new->window_start = range_cfg->window_start;
 		new->window_len = range_cfg->window_len;
+		new->start_page_num = range_cfg->start_page_num;
 
 		if (_regmap_range_add(map, new) == false) {
 			dev_err(map->dev, "Failed to add range %d\n", i);
@@ -833,6 +834,7 @@ static int _regmap_select_page(struct regmap *map, unsigned int *reg,
 
 	win_offset = (*reg - range->range_min) % range->window_len;
 	win_page = (*reg - range->range_min) / range->window_len;
+	win_page += range->start_page_num;
 
 	if (val_num > 1) {
 		/* Bulk write shouldn't cross range boundary */
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index b7e95bf..96f029e 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -217,6 +217,8 @@ struct regmap_config {
  *
  * @window_start: Address of first (lowest) register in data window.
  * @window_len: Number of registers in data window.
+ *
+ * @start_page_num: Start page number for the range
  */
 struct regmap_range_cfg {
 	const char *name;
@@ -233,6 +235,9 @@ struct regmap_range_cfg {
 	/* Data window (per each page) */
 	unsigned int window_start;
 	unsigned int window_len;
+
+	/* Starting page number when it increases across range */
+	unsigned int start_page_num;
 };
 
 typedef int (*regmap_hw_write)(void *context, const void *data,
-- 
1.7.1

