Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab2BPACn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 19:02:43 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34721 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab2BPACl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 19:02:41 -0500
From: Alex Hornung <alex@alexhornung.com>
To: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Hornung <alex@alexhornung.com>
Subject: [PATCH 1/1] mmc_spi - Fix endianess issue with voltage-ranges
Date: Thu, 16 Feb 2012 00:01:47 +0000
Message-Id: <1329350507-22528-1-git-send-email-alex@alexhornung.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * The voltage-ranges values from the device tree were used as-is,
   without first (potentially) swapping the bytes to the target CPU's
   endianess.

Signed-off-by: Alex Hornung <alex@alexhornung.com>
---
 drivers/mmc/host/of_mmc_spi.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/of_mmc_spi.c b/drivers/mmc/host/of_mmc_spi.c
index ab66f24..4bfd3e8 100644
--- a/drivers/mmc/host/of_mmc_spi.c
+++ b/drivers/mmc/host/of_mmc_spi.c
@@ -112,9 +112,10 @@ struct mmc_spi_platform_data *mmc_spi_get_pdata(struct spi_device *spi)
 	for (i = 0; i < num_ranges; i++) {
 		const int j = i * 2;
 		u32 mask;
+		u32 vdd_min = be32_to_cpu(voltage_ranges[j]);
+		u32 vdd_max = be32_to_cpu(voltage_ranges[j + 1]);
 
-		mask = mmc_vddrange_to_ocrmask(voltage_ranges[j],
-					       voltage_ranges[j + 1]);
+		mask = mmc_vddrange_to_ocrmask(vdd_min, vdd_max);
 		if (!mask) {
 			ret = -EINVAL;
 			dev_err(dev, "OF: voltage-range #%d is invalid\n", i);
-- 
1.7.3.4

