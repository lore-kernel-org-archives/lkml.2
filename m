Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab0LPPtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:49:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46662 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751969Ab0LPPtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:49:50 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Saravana Kannan <skannan@codeaurora.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: Optimise out noop voltage changes
Date: Thu, 16 Dec 2010 15:49:37 +0000
Message-Id: <1292514577-13144-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292514577-13144-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1292514577-13144-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a consumer sets the same voltage range as is currently configured
for that consumer there's no need to run through setting the voltage
again. This pattern may occur with some CPUfreq implementations where
the same voltage range is used for multiple frequencies.

Reported-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a12cba3..ab419f8 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1697,10 +1697,17 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 {
 	struct regulator_dev *rdev = regulator->rdev;
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&rdev->mutex);
 
+	/* If we're setting the same range as last time the change
+	 * should be a noop (some cpufreq implementations use the same
+	 * voltage for multiple frequencies, for example).
+	 */
+	if (regulator->min_uV == min_uV && regulator->max_uV == max_uV)
+		goto out;
+
 	/* sanity check */
 	if (!rdev->desc->ops->set_voltage &&
 	    !rdev->desc->ops->set_voltage_sel) {
-- 
1.7.1

