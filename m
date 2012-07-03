Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab2GCHmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 03:42:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45052 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab2GCHmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 03:42:42 -0400
Message-ID: <1341301353.12050.1.camel@phoenix>
Subject: [PATCH v2] regulator: ad5398: Fix min/max current limit boundary
 checking
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>
Date: Tue, 03 Jul 2012 15:42:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is ok to request current limit with min_uA < chip->min_uA and
max_uA > chip->max_uA.

We need to set min_uA = chip->min_uA if (min_uA < chip->min_uA),
this ensures the equation to calcuate selator does not return negative number.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
~
---
 drivers/regulator/ad5398.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
index 46d05f3..84fdcda 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -89,9 +89,10 @@ static int ad5398_set_current_limit(struct regulator_dev *rdev, int min_uA, int
 	unsigned short data;
 	int ret;
 
-	if (min_uA > chip->max_uA || min_uA < chip->min_uA)
-		return -EINVAL;
-	if (max_uA > chip->max_uA || max_uA < chip->min_uA)
+	if (min_uA < chip->min_uA)
+		min_uA = chip->min_uA;
+
+	if (min_uA > chip->max_uA || max_uA < chip->min_uA)
 		return -EINVAL;
 
 	selector = DIV_ROUND_UP((min_uA - chip->min_uA) * chip->current_level,
-- 
1.7.9.5



