Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab2A3OIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:08:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54798 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2A3OIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:08:24 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [RFC 1/2] regmap: if format_write is used, declare all registers as "unreadable"
Date: Mon, 30 Jan 2012 15:08:16 +0100
Message-Id: <1327932497-28319-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.8.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using .format_write means, we have a custom function to write to the
chip, but not to read back. Also, mark registers as "not precious" and
"not volatile" which is implicit because we cannot read them. Make those
functions use 'regmap_readable' to reuse the checks done there.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/base/regmap/regmap.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index fb3c132..c7b95c3 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -36,6 +36,9 @@ bool regmap_readable(struct regmap *map, unsigned int reg)
 	if (map->max_register && reg > map->max_register)
 		return false;
 
+	if (map->format.format_write)
+		return false;
+
 	if (map->readable_reg)
 		return map->readable_reg(map->dev, reg);
 
@@ -44,7 +47,7 @@ bool regmap_readable(struct regmap *map, unsigned int reg)
 
 bool regmap_volatile(struct regmap *map, unsigned int reg)
 {
-	if (map->max_register && reg > map->max_register)
+	if (!regmap_readable(map, reg))
 		return false;
 
 	if (map->volatile_reg)
@@ -55,7 +58,7 @@ bool regmap_volatile(struct regmap *map, unsigned int reg)
 
 bool regmap_precious(struct regmap *map, unsigned int reg)
 {
-	if (map->max_register && reg > map->max_register)
+	if (!regmap_readable(map, reg))
 		return false;
 
 	if (map->precious_reg)
-- 
1.7.8.3

