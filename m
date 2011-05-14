Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988Ab1ENUmf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 16:42:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42006 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754340Ab1ENUme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 16:42:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        David Collins <collinsd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Only apply voltage constraints from consumers that set them
Date: Sat, 14 May 2011 13:42:34 -0700
Message-Id: <1305405754-23256-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When applying the set_voltage() requests from consumers skip over those
consumers that haven't set anything, otherwise we'll come out with a
maximum voltage of zero.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 051a45d..60ae920 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -161,6 +161,13 @@ static int regulator_check_consumers(struct regulator_dev *rdev,
 	struct regulator *regulator;
 
 	list_for_each_entry(regulator, &rdev->consumer_list, list) {
+		/*
+		 * Assume consumers that didn't say anything are OK
+		 * with anything in the constraint range.
+		 */
+		if (!regulator->min_uV && !regulator->max_uV)
+			continue;
+
 		if (*max_uV > regulator->max_uV)
 			*max_uV = regulator->max_uV;
 		if (*min_uV < regulator->min_uV)
-- 
1.7.5.1

