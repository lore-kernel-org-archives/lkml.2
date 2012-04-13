Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935008Ab2DMBaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 21:30:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62967 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab2DMBaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 21:30:16 -0400
Message-ID: <1334280605.6755.1.camel@phoenix>
Subject: [PATCH] regulator: s5m8767: Use DIV_ROUND_UP to calculate selector
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 13 Apr 2012 09:30:05 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integer division may truncate the result.
Use DIV_ROUND_UP to ensure new voltage setting falls within specified range.

Also properly handle the case min_vol < desc->min to ensure we don't return
negative value for selector.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/s5m8767.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index cb53187..ebe72d0 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -347,7 +347,10 @@ static int s5m8767_convert_voltage_to_sel(
 	if (max_vol < desc->min || min_vol > desc->max)
 		return -EINVAL;
 
-	selector = (min_vol - desc->min) / desc->step;
+	if (min_vol < desc->min)
+		min_vol = desc->min;
+
+	selector = DIV_ROUND_UP(min_vol - desc->min, desc->step);
 
 	if (desc->min + desc->step * selector > max_vol)
 		return -EINVAL;
-- 
1.7.5.4



