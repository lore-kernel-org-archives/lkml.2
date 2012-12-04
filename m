Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab2LDOBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:01:41 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:13802 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab2LDOBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:01:37 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d2-50be023f2388
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>,
        Kevin Liu <keyuan.liu@gmail.com>
Subject: [PATCH 2/3] mmc: use regulator_can_change_voltage() instead of
 regulator_count_voltages() hacks
Date: Tue, 04 Dec 2012 15:01:02 +0100
Message-id: <1354629663-29091-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1354629663-29091-1-git-send-email-m.szyprowski@samsung.com>
References: <1354629663-29091-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t9jQV17pn0BBu/vGVtc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDL+LNnFXHCSo2L6n93MDYwT2bsYOTkkBEwkzh3fzQxh
	i0lcuLeerYuRi0NIYDqjRP/HdSwQTjuTxKo1U1hBqtgEDCW63nYBVXFwiAhYS+xd6AtSwyzw
	llFi+a3tLCA1wgJZEncOHWUEsVkEVCWuTZrOBGLzCnhIfGieywjSKyGgIDFnkg2IySngKfH2
	J1i1EFDFveXrGCcw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEez5Z9I7GFc1WBxi
	FOBgVOLhXfBiT4AQa2JZcWXuIUYJDmYlEV6FD3sDhHhTEiurUovy44tKc1KLDzFKc7AoifM2
	e6QECAmkJ5akZqemFqQWwWSZODilGhh1j0zbbHrptsGTi8vPfdi9gCdh+hYDJo2N4uwGcpnX
	jD6/uO1129zIYkLZ/5j55a2loZ5+d6/6qXVxOTx9U3n3QMErNk7ubfZHSitfqL1W/XOmryDn
	k0/Yes9H5Uru2wysn9S6GLw/W/f06K7GPZNeVn1WSUwolDReVdA+TUhsZ3sQz/T1fg+VWIoz
	Eg21mIuKEwFTe3k0+AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmc_regulator_set_ocr() depends on the ability of regulator to change the
voltage value. When regulator cannot change its voltage output, some code is
skipped to avoid reporting false errors on some boards, which use MMC hosts
with fixed regulators (example: Samsung Goni and UniversalC210 boards).

This patch replaces a hacky workaround based on regulator_count_voltages()
value with the correct call to recently introduced
regulator_can_change_voltage() function in regulators core.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/mmc/core/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index aaed768..f5a0493 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1137,7 +1137,7 @@ int mmc_regulator_set_ocr(struct mmc_host *mmc,
 		 */
 		voltage = regulator_get_voltage(supply);
 
-		if (regulator_count_voltages(supply) == 1)
+		if (!regulator_can_change_voltage(supply))
 			min_uV = max_uV = voltage;
 
 		if (voltage < 0)
-- 
1.7.9.5

