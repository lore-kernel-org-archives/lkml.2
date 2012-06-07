Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab2FGHBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 03:01:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44637 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2FGHBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 03:01:54 -0400
Message-ID: <1339052505.5882.2.camel@phoenix>
Subject: [PATCH RFC RESEND 1/3] regulator: core: Handle fixed voltage in
 map_voltage_linear
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Vasut <marek.vasut@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Eric Miao <eric.y.miao@gmail.com>, Mike Rapoport <mike@compulab.co.il>
Date: Thu, 07 Jun 2012 15:01:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed voltage is a kind of linear mapping where n_voltages is 1.
This change allows [list|map]_voltage_linear to be used for fixed voltage.

For fixed voltage, n_voltages is 1 and the only valid selector is 0.
Thus we actually don't care the uV_step setting.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is v2 of 
[PATCH RFC 1/2] regulator: core: Allow uV_step to be 0 for linear mapping if fixed voltage.

I change the subject line because for fixed voltage, we actually don't care the uV_step setting.

 drivers/regulator/core.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 02c1940..45baa72 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2070,6 +2070,15 @@ int regulator_map_voltage_linear(struct regulator_dev *rdev,
 {
 	int ret, voltage;
 
+	/* For fixed voltage, check if voltage falls within specified range */
+	if (rdev->desc->n_voltages == 1) {
+		if (min_uV <= rdev->desc->min_uV &&
+		    rdev->desc->min_uV <= max_uV)
+			return 0;
+		else
+			return -EINVAL;
+	}
+
 	if (!rdev->desc->uV_step) {
 		BUG_ON(!rdev->desc->uV_step);
 		return -EINVAL;
-- 
1.7.9.5



