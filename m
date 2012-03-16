Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab2CPCJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 22:09:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57337 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab2CPCIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 22:08:37 -0400
From: Marc Reilly <marc@cpdesign.com.au>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Marc Reilly <marc@cpdesign.com.au>
Subject: [PATCH 1/2] regmap: Add support for device with 24 data bits.
Date: Fri, 16 Mar 2012 12:11:42 +1100
Message-Id: <1331860303-9483-1-git-send-email-marc@cpdesign.com.au>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for devices with 24 data bits.

Signed-off-by: Marc Reilly <marc@cpdesign.com.au>
---
 drivers/base/regmap/regmap.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 253882d..9cfe203 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -126,6 +126,15 @@ static void regmap_format_16(void *buf, unsigned int val)
 	b[0] = cpu_to_be16(val);
 }
 
+static void regmap_format_24(void *buf, unsigned int val)
+{
+	u8 *b = buf;
+
+	b[0] = val >> 16;
+	b[1] = val >> 8;
+	b[2] = val;
+}
+
 static void regmap_format_32(void *buf, unsigned int val)
 {
 	__be32 *b = buf;
@@ -149,6 +158,16 @@ static unsigned int regmap_parse_16(void *buf)
 	return b[0];
 }
 
+static unsigned int regmap_parse_24(void *buf)
+{
+	u8 *b = buf;
+	unsigned int ret = b[2];
+	ret |= ((unsigned int)b[1]) << 8;
+	ret |= ((unsigned int)b[0]) << 16;
+
+	return ret;
+}
+
 static unsigned int regmap_parse_32(void *buf)
 {
 	__be32 *b = buf;
@@ -273,6 +292,10 @@ struct regmap *regmap_init(struct device *dev,
 		map->format.format_val = regmap_format_16;
 		map->format.parse_val = regmap_parse_16;
 		break;
+	case 24:
+		map->format.format_val = regmap_format_24;
+		map->format.parse_val = regmap_parse_24;
+		break;
 	case 32:
 		map->format.format_val = regmap_format_32;
 		map->format.parse_val = regmap_parse_32;
-- 
1.7.3.4

