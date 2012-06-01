Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993Ab2FABHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 21:07:51 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37855 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2FABHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 21:07:50 -0400
From: Fabio Estevam <festevam@gmail.com>
To: broonie@opensource.wolfsonmicro.com
Cc: gregkh@linuxfoundation.org, marc@cpdesign.com.au,
        philippe.retornaz@epfl.ch, linux-kernel@vger.kernel.org,
        joe@perches.com, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2] regmap: Fix the size calculation for map->format.buf_size
Date: Thu, 31 May 2012 22:07:35 -0300
Message-Id: <1338512855-26015-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1338509430-24416-1-git-send-email-festevam@gmail.com>
References: <1338509430-24416-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

The word to be transmitted/received via regmap is composed by the following
parts:

config->reg_bits
config->val_bits
config->pad_bits

,so the total size should be calculated by summing up the number of bits of
each element and using a DIV_ROUND_UP to return the number of bytes.

While at it also use BITS_PER_BYTE annotation.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v1:
- Use BITS_PER_BYTE annotation
 drivers/base/regmap/regmap.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 2aa076e..9d6b2f8 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -246,12 +246,12 @@ struct regmap *regmap_init(struct device *dev,
 		map->lock = regmap_lock_mutex;
 		map->unlock = regmap_unlock_mutex;
 	}
-	map->format.buf_size = (config->reg_bits + config->val_bits) / 8;
-	map->format.reg_bytes = DIV_ROUND_UP(config->reg_bits, 8);
-	map->format.pad_bytes = config->pad_bits / 8;
-	map->format.val_bytes = DIV_ROUND_UP(config->val_bits, 8);
-	map->format.buf_size += map->format.pad_bytes;
-	map->reg_shift = config->pad_bits % 8;
+	map->format.reg_bytes = DIV_ROUND_UP(config->reg_bits, BITS_PER_BYTE);
+	map->format.pad_bytes = config->pad_bits / BITS_PER_BYTE;
+	map->format.val_bytes = DIV_ROUND_UP(config->val_bits, BITS_PER_BYTE);
+	map->format.buf_size = DIV_ROUND_UP(config->reg_bits +
+			config->val_bits + config->pad_bits, BITS_PER_BYTE);
+	map->reg_shift = config->pad_bits % BITS_PER_BYTE;
 	if (config->reg_stride)
 		map->reg_stride = config->reg_stride;
 	else
-- 
1.7.1

