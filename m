Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1B0QB7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 11:01:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:58569 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab1B0QB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 11:01:56 -0500
From: Guan Xuetao <epip@hera.kernel.org>
To: arnd@arndb.de
Cc: GuanXuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
Subject: [PATCH 10/17] unicore32 i8042: adjust io funcs of i8042-unicore32io.h
Date: Sun, 27 Feb 2011 15:59:38 +0000
Message-Id: <1e4c0d1ca5ed18944ed5de2ba756663dfd85de44.1298821856.git.epip@hera.kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 27 Feb 2011 16:01:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GuanXuetao <gxt@mprc.pku.edu.cn>

replace inb/outb with readb/writeb in i8042-unicore32io.h
and correct typecasting of register and region macros
  -- by advice with Arnd Bergmann

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 drivers/input/serio/i8042-unicore32io.h |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/input/serio/i8042-unicore32io.h b/drivers/input/serio/i8042-unicore32io.h
index 6a7e8b3..2cdd872 100644
--- a/drivers/input/serio/i8042-unicore32io.h
+++ b/drivers/input/serio/i8042-unicore32io.h
@@ -29,33 +29,36 @@
 /*
  * Register numbers.
  */
-#define I8042_COMMAND_REG	((unsigned long)&PS2_COMMAND)
-#define I8042_STATUS_REG	((unsigned long)&PS2_STATUS)
-#define I8042_DATA_REG		((unsigned long)&PS2_DATA)
+#define I8042_COMMAND_REG	((volatile void __iomem *)&PS2_COMMAND)
+#define I8042_STATUS_REG	((volatile void __iomem *)&PS2_STATUS)
+#define I8042_DATA_REG		((volatile void __iomem *)&PS2_DATA)
+
+#define I8042_REGION_START	(resource_size_t)(&PS2_DATA)
+#define I8042_REGION_SIZE	(resource_size_t)(16)
 
 static inline int i8042_read_data(void)
 {
-	return inb(I8042_DATA_REG);
+	return readb(I8042_DATA_REG);
 }
 
 static inline int i8042_read_status(void)
 {
-	return inb(I8042_STATUS_REG);
+	return readb(I8042_STATUS_REG);
 }
 
 static inline void i8042_write_data(int val)
 {
-	outb(val, I8042_DATA_REG);
+	writeb(val, I8042_DATA_REG);
 }
 
 static inline void i8042_write_command(int val)
 {
-	outb(val, I8042_COMMAND_REG);
+	writeb(val, I8042_COMMAND_REG);
 }
 
 static inline int i8042_platform_init(void)
 {
-	if (!request_region(I8042_DATA_REG, 16, "i8042"))
+	if (!request_region(I8042_REGION_START, I8042_REGION_SIZE, "i8042"))
 		return -EBUSY;
 
 	i8042_reset = 1;
@@ -64,7 +67,7 @@ static inline int i8042_platform_init(void)
 
 static inline void i8042_platform_exit(void)
 {
-	release_region(I8042_DATA_REG, 16);
+	release_region(I8042_REGION_START, I8042_REGION_SIZE);
 }
 
 #endif /* _I8042_UNICORE32_H */
-- 
1.7.4.1

