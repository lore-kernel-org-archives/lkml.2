Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab2EGLlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:41:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40445 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756452Ab2EGLlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:41:10 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Actually free the regulator in devm_regulator_put()
Date: Mon,  7 May 2012 12:41:02 +0100
Message-Id: <1336390862-22479-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that (quite surprisingly) devres_destroy() only undoes the
devres mapping, it doesn't destroy the underlying resource, meaning that
anything using devm_regulator_put() would leak. While we wait for the new
devres_release() which does what we want to get merged open code it in
devm_regulator_put().

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e70dd38..046fb1b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1431,7 +1431,10 @@ void devm_regulator_put(struct regulator *regulator)
 
 	rc = devres_destroy(regulator->dev, devm_regulator_release,
 			    devm_regulator_match, regulator);
-	WARN_ON(rc);
+	if (rc == 0)
+		regulator_put(regulator);
+	else
+		WARN_ON(rc);
 }
 EXPORT_SYMBOL_GPL(devm_regulator_put);
 
-- 
1.7.10

