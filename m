Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab2A3OI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:08:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54799 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab2A3OIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:08:24 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [RFC 2/2] regmap: make use of cached entries in debugfs
Date: Mon, 30 Jan 2012 15:08:17 +0100
Message-Id: <1327932497-28319-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1327932497-28319-1-git-send-email-w.sang@pengutronix.de>
References: <1327932497-28319-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, registers not marked as readable won't be displayed via
debugfs. So, a chip with write-only registers shows nothing because of
no readable registers, although regcache knows the current values. Fix
debugfs to only require the readable-flag when no cache is active,
otherwise try reading the cache.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/base/regmap/regmap-debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 6f39747..c5a57f3 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -58,7 +58,7 @@ static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
 	tot_len = reg_len + val_len + 3;      /* : \n */
 
 	for (i = 0; i < map->max_register + 1; i++) {
-		if (!regmap_readable(map, i))
+		if (map->cache_type == REGCACHE_NONE && !regmap_readable(map, i))
 			continue;
 
 		if (regmap_precious(map, i))
-- 
1.7.8.3

