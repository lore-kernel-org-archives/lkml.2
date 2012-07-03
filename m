Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab2GCWDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 18:03:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57678 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab2GCWDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:03:40 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] regulator: don't fail to apply_uV for fixed regulators without set_voltage
Date: Tue,  3 Jul 2012 16:03:34 -0600
Message-Id: <1341353014-13005-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

When instantiating a regulator from device tree,
of_get_regulation_constraints() sets apply_uV=true when min_uV==max_uV.
If the regulator only supports that one voltage, it may not implement
set_voltage or set_voltage_sel. If so, the call from
machine_constraints_voltage() to _regulator_do_set_voltage() will fail,
since the latter requires one of those ops to be implemented. Avoid this
problem by avoiding the call to _regulator_do_set_voltage() if the
regulator is already set of the specified voltage.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Are regulators required to implement get_voltage()? If not, this change
would cause a regression.

An alternative might be to just implement set_voltage*() in the relevant
regulator driver, although it seem like it'd intended to be optional.
Would that be preferable? The driver in question is for the MAX8907 which
isn't upstream yet, but I'll be sending patches for it as soon as I have
legal approval; the code is written and working.

 drivers/regulator/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index ef07b62..8196764 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -790,7 +790,8 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 
 	/* do we need to apply the constraint voltage */
 	if (rdev->constraints->apply_uV &&
-	    rdev->constraints->min_uV == rdev->constraints->max_uV) {
+	    rdev->constraints->min_uV == rdev->constraints->max_uV &&
+	    _regulator_get_voltage(rdev) != rdev->constraints->min_uV) {
 		ret = _regulator_do_set_voltage(rdev,
 						rdev->constraints->min_uV,
 						rdev->constraints->max_uV);
-- 
1.7.0.4

