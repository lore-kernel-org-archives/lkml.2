Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab2KMNdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:33:07 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21240 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2KMNdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:33:04 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-d9-50a24bf0de37
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH v2] mmc: sdhci: apply voltage range check only for non-fixed
 regulators
Date: Tue, 13 Nov 2012 14:32:14 +0100
Message-id: <1352813534-6795-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <87fw4dn030.fsf@octavius.laptop.org>
References: <87fw4dn030.fsf@octavius.laptop.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t9jAd0P3osCDH484LG4vGsOm8WR//2M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX8bYsquMBRsf3dTcYGxoXsXYycHBICJhJ7pqxhgbDF
	JC7cW8/WxcjFISSwiFFicuN/JginnUlizuUXYFVsAoYSXW+7gKo4OEQErCX2LvQFqWEWOM0o
	MWnWdjaQGmGBSIlrl3aDbWARUJX4c+0IWC+vgLvE5Bdr2EF6JQQUJOZMsgEJcwKN3NP/DaxV
	SMBA4kHDG7YJjLwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgR7/pnUDsaVDRaHGAU4
	GJV4eG+4LAwQYk0sK67MPcQowcGsJMJ73m1RgBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeZo+U
	ACGB9MSS1OzU1ILUIpgsEwenVAPj/omBGR/0VNV4C6tSf6jdiZ7z51pv5rbZVjpJMb9Y8roa
	pXQlz7/wOB19L33338at4l4xLxNtbAJKPJtbnwXwPLidtOWDv2Vqfc8WUwn+xh0T+taYJex9
	tFzmmkx3admZtuknLa2PKx89YZGksfuavUT7xYM/860jpzOYzH4XrFW1Lnzer69KLMUZiYZa
	zEXFiQCOyzjh+AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed regulators cannot change their voltage, so disable all voltage
range checking for them, otherwise the driver fails to operate with
fixed regulators. Up to now it worked only by luck, because
regulator_is_supported_voltage() function returned incorrect values.
Commit "regulator: fix voltage check in regulator_is_supported_voltage()"
fixed that function and now additional check is needed for fixed
regulators.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/mmc/host/sdhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index c7851c0..6f6534e 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2923,7 +2923,7 @@ int sdhci_add_host(struct sdhci_host *host)
 		regulator_enable(host->vmmc);
 
 #ifdef CONFIG_REGULATOR
-	if (host->vmmc) {
+	if (host->vmmc && regulator_count_voltages(host->vmmc) > 1) {
 		ret = regulator_is_supported_voltage(host->vmmc, 3300000,
 			3300000);
 		if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))
-- 
1.7.9.5

