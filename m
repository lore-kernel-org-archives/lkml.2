Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2KMJtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:49:55 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:12120 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab2KMJtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:49:52 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ab-50a217be0482
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH v3] regulator: treat regulators with constant volatage as fixed
Date: Tue, 13 Nov 2012 10:49:37 +0100
Message-id: <1352800177-16139-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <20121113094255.GW18224@opensource.wolfsonmicro.com>
References: <20121113094255.GW18224@opensource.wolfsonmicro.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t9jQd194osCDI7uFra4vGsOm8WR//2M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXcev+ctWATe8WWFw1sDYyT2boYOTkkBEwkli9exQ5h
	i0lcuLceKM7FISQwnVHi8e05rBBOO5PEkb0rwKrYBAwlut52AVVxcIgIWEvsXegLUsMscJpR
	YtKs7WBThQX8JeYuvM0EYrMIqEp8/LUHzOYV8JBY82s3E0ivhICCxJxJNiAmp4CjxJItuSAV
	QgIOEgsnzGabwMi7gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkaw559J72Bc1WBxiFGA
	g1GJh1fRcmGAEGtiWXFl7iFGCQ5mJRHeiSKLAoR4UxIrq1KL8uOLSnNSiw8xSnOwKInzNnuk
	BAgJpCeWpGanphakFsFkmTg4pRoYDTd9+v1q6atN04NZe5J3ibWumtn8rmfP1g0Pzq9pmC6X
	9T1kf6XIYxbdE3w3tu3p5cw/GFjYovtGioPTpdy5RWGpdtm82v+B2bY3lFfHZgbHlGawtF3l
	uR712+jXjP6XG6bVL5x99ojKL59ZW+1vPNu8pm/qw5CPsS+9T+wULD5fu+7FN8PaE0osxRmJ
	hlrMRcWJALdw2jb4AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers has additional logic for fixed regulators. Let regulator core
to treat regulators which cannot change their voltage due to applied
constraints as fixed.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/regulator/core.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 042c1ff..d07c240 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1872,7 +1872,14 @@ int regulator_count_voltages(struct regulator *regulator)
 {
 	struct regulator_dev	*rdev = regulator->rdev;
 
-	return rdev->desc->n_voltages ? : -EINVAL;
+	if (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE) {
+		if (rdev->desc->n_voltages)
+			return rdev->desc->n_voltages;
+		else
+			return -EINVAL;
+	} else {
+		return 1;
+	}
 }
 EXPORT_SYMBOL_GPL(regulator_count_voltages);
 
-- 
1.7.9.5

