Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2LDOBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:01:49 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:13813 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab2LDOBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:01:40 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d9-50be0243241c
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>,
        Kevin Liu <keyuan.liu@gmail.com>
Subject: [PATCH 3/3] mmc: sdhci: check voltage range only on regulators aware
 of voltage value
Date: Tue, 04 Dec 2012 15:01:03 +0100
Message-id: <1354629663-29091-4-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1354629663-29091-1-git-send-email-m.szyprowski@samsung.com>
References: <1354629663-29091-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t9jQV1npn0BBovOiVhc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDL+7v7FWtDCWTHtHm8D40H2LkZODgkBE4nll86xQdhi
	EhfurQeyuTiEBKYzSsydvZAdwmlnknj7+gNYB5uAoUTX2y6gKg4OEQFrib0LfUFqmAXeMkos
	v7WdBSQuLJAgcXlnKojJIqAq8feSFUgnr4CHxJf2/awgYQkBBYk5k2xATE4BT4m3PxlBKoSA
	Ku4tX8c4gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYxgnz+T3sG4qsHiEKMAB6MS
	D++CF3sChFgTy4orcw8xSnAwK4nwKnzYGyDEm5JYWZValB9fVJqTWnyIUZqDRUmct9kjJUBI
	ID2xJDU7NbUgtQgmy8TBKdXAOOGkTmBokwm701HfGRb+V+fL5r3x1K9w2bPXaP/ilko1J51o
	xs3WKipz9yufvbEk3u3gQ+f9H6veVwgUNoYJvbFolHh3Mf/apR9fqt++n/6lbfOXfdeY27+Z
	uJ6qMf0e/LNl4o3FStrOWxc7SIXpSh6ZXRQkyLxDw6RpUypTAxvD7ImB7tO+K7EUZyQaajEX
	FScCALgYwYT1AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some regulators don't report any voltage values, so checking supported
voltage range results in disabling all SDHCI_CAN_VDD_* flags and
registration failure. This patch finally provides a correct fix for the
registration of SDHCI driver with all possible voltage regulators:
dummy, fixed and regulated without using regulator_count_voltages()
hacks.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/mmc/host/sdhci.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index a9ad2cd..d244dc0 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2930,7 +2930,11 @@ int sdhci_add_host(struct sdhci_host *host)
 	}
 
 #ifdef CONFIG_REGULATOR
-	if (host->vmmc && regulator_count_voltages(host->vmmc) > 1) {
+	/*
+	 * Voltage range check makes sense only if regulator reports
+	 * any voltage value.
+	 */
+	if (host->vmmc && regulator_get_voltage(host->vmmc) > 0) {
 		ret = regulator_is_supported_voltage(host->vmmc, 2700000,
 			3600000);
 		if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))
-- 
1.7.9.5

