Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab2KMJfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:35:54 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:62538 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab2KMJfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:35:51 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-e4-50a2147602a9
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH v2] regulator: treat regulators with constant volatage as fixed
Date: Tue, 13 Nov 2012 10:35:34 +0100
Message-id: <1352799334-13898-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <20121113090007.GS18224@opensource.wolfsonmicro.com>
References: <20121113090007.GS18224@opensource.wolfsonmicro.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t9jAd0ykUUBBpMaxS0u75rDZnHkfz+j
	A5PH501yAYxRXDYpqTmZZalF+nYJXBmdTU1sBZPZKy7cW87YwPiHtYuRk0NCwERi97yPLBC2
	mMSFe+vZuhi5OIQEFjFKfP/4kAXCaWeSmL71KhtIFZuAoUTX2y4gm4NDRMBaYu9CX5AaZoHT
	jBKTZm0HqxEW8JfouPqMCcRmEVCVWHxqApjNK+Ah0ff0OVivhICCxJxJNiBhTgFHiVcXe8FK
	hAQcJE7vm8U+gZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYxg3z+T2sG4ssHiEKMA
	B6MSD+8Nl4UBQqyJZcWVuYcYJTiYlUR4f3AsChDiTUmsrEotyo8vKs1JLT7EKM3BoiTO2+yR
	EiAkkJ5YkpqdmlqQWgSTZeLglGpgbJ34LGFmUOhOY78fTR+sdv6s/aTA/L5V0p3fy+uNjbrv
	oYhVsf/3T2GUkHr43WDFjOM70zZzTVh3T69zgZVsnvx3zh+Lj8VO4zbXZHozJfCRyJfGZ4fr
	d3lPV1u8/pHzLf4Ih9op6nts8pbddFSsu1t7Zf6EAwd6rP2iIxk+XIx8dtRIem/8AyWW4oxE
	Qy3mouJEANaTyID5AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers has additional logic for fixed regulators. Let regulator core
to treat regulators which cannot change their voltage due to applied
constraints as fixed.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/regulator/core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 042c1ff..78b34b7 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1872,7 +1872,11 @@ int regulator_count_voltages(struct regulator *regulator)
 {
 	struct regulator_dev	*rdev = regulator->rdev;
 
-	return rdev->desc->n_voltages ? : -EINVAL;
+	if (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)
+		return rdev->desc->n_voltages ? rdev->desc->n_voltages :
+		       -EINVAL;
+	else
+		return 1;
 }
 EXPORT_SYMBOL_GPL(regulator_count_voltages);
 
-- 
1.7.9.5

