Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab2BTCcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 21:32:31 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49393 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab2BTCca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 21:32:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.227.164 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1329705136.3189.1.camel@phoenix>
Subject: [PATCH] regulator: Simplify regulator_bulk_get and
 regulator_bulk_enable error paths
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Mon, 20 Feb 2012 10:32:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start unwind from the point the error happens instead of iterating over all
consumers, then unwind code can be simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index fecda41..37a84df 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2451,7 +2451,7 @@ int regulator_bulk_get(struct device *dev, int num_consumers,
 	return 0;
 
 err:
-	for (i = 0; i < num_consumers && consumers[i].consumer; i++)
+	while (--i >= 0)
 		regulator_put(consumers[i].consumer);
 
 	return ret;
@@ -2547,12 +2547,9 @@ int regulator_bulk_enable(int num_consumers,
 	return 0;
 
 err:
-	for (i = 0; i < num_consumers; i++)
-		if (consumers[i].ret == 0)
-			regulator_disable(consumers[i].consumer);
-		else
-			pr_err("Failed to enable %s: %d\n",
-			       consumers[i].supply, consumers[i].ret);
+	pr_err("Failed to enable %s: %d\n", consumers[i].supply, ret);
+	while (--i >= 0)
+		regulator_disable(consumers[i].consumer);
 
 	return ret;
 }
-- 
1.7.5.4



