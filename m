Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab2J2Jdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:33:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42175 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675Ab2J2Jde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:33:34 -0400
Date: Mon, 29 Oct 2012 09:33:33 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@opensource.wolfsonmicro.com, lrg@ti.com
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH] regulator: core: Move regulator release to avoid deadlock
Message-ID: <20121029093333.GA17941@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_put function was called whilst holding the
regulator_list_mutex, which is also locked from regulator_put. This
causes deadlock when failing to register a regulator.

This patch adds a second exit point for the regulator_register function
which releases the mutex and then cleans up the supply.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5c4829c..e68754c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3444,15 +3444,18 @@ unset_supplies:
 	unset_regulator_supplies(rdev);
 
 scrub:
-	if (rdev->supply)
-		regulator_put(rdev->supply);
 	if (rdev->ena_gpio)
 		gpio_free(rdev->ena_gpio);
 	kfree(rdev->constraints);
 	device_unregister(&rdev->dev);
+
+	mutex_unlock(&regulator_list_mutex);
+	if (rdev->supply)
+		regulator_put(rdev->supply);
+
 	/* device core frees rdev */
 	rdev = ERR_PTR(ret);
-	goto out;
+	return rdev;
 
 clean:
 	kfree(rdev);
-- 
1.7.2.5

