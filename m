Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab0DPL5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 07:57:00 -0400
Received: from smtp.nokia.com ([192.100.105.134]:47701 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167Ab0DPL47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 07:56:59 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: Fix fencepost error in reg cache access check
Date: Fri, 16 Apr 2010 15:00:09 +0300
Message-Id: <1271419209-21634-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 16 Apr 2010 11:56:51.0953 (UTC) FILETIME=[E6ECEE10:01CADD5B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Phil Carmody <ext-phil.2.carmody@nokia.com>

Accessing num_reg elements in the interval [reg .. reg+num_regs)
is permitted if (reg+numregs <= array size), so barf when that
excluded upper bound is > array size. The prior -1 would give
access to one too many elements.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 drivers/mfd/wm8400-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index 865ce01..e08aafa 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -118,7 +118,7 @@ static int wm8400_read(struct wm8400 *wm8400, u8 reg, int num_regs, u16 *dest)
 {
 	int i, ret = 0;
 
-	BUG_ON(reg + num_regs - 1 > ARRAY_SIZE(wm8400->reg_cache));
+	BUG_ON(reg + num_regs > ARRAY_SIZE(wm8400->reg_cache));
 
 	/* If there are any volatile reads then read back the entire block */
 	for (i = reg; i < reg + num_regs; i++)
@@ -144,7 +144,7 @@ static int wm8400_write(struct wm8400 *wm8400, u8 reg, int num_regs,
 {
 	int ret, i;
 
-	BUG_ON(reg + num_regs - 1 > ARRAY_SIZE(wm8400->reg_cache));
+	BUG_ON(reg + num_regs > ARRAY_SIZE(wm8400->reg_cache));
 
 	for (i = 0; i < num_regs; i++) {
 		BUG_ON(!reg_data[reg + i].writable);
-- 
1.6.0.4

