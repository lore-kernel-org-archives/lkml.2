Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab2EYRAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:00:36 -0400
Received: from kamaji.grokhost.net ([87.117.218.43]:52230 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330Ab2EYRAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:00:34 -0400
From: Chris Boot <bootc@bootc.net>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Boot <bootc@bootc.net>
Subject: [PATCH] mmc: Fix EINVAL if an mmc_spi controller has no IRQ
Date: Fri, 25 May 2012 18:00:30 +0100
Message-Id: <1337965230-4589-1-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_of_parse_and_map() returns EINVAL if there is no interrupt
information available in device tree, not NO_IRQ. mmc_spi_get_pdata()
doesn't account for error returns, and ends up trying to
request_threaded_irq() with -22 as the IRQ value.

This patch checks for negative returns from irq_of_parse_and_map() as
well as NO_IRQ, and uses polled mode in those cases.

Signed-off-by: Chris Boot <bootc@bootc.net>
---
 drivers/mmc/host/of_mmc_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/of_mmc_spi.c b/drivers/mmc/host/of_mmc_spi.c
index 1534b58..d3e882a 100644
--- a/drivers/mmc/host/of_mmc_spi.c
+++ b/drivers/mmc/host/of_mmc_spi.c
@@ -146,7 +146,7 @@ struct mmc_spi_platform_data *mmc_spi_get_pdata(struct spi_device *spi)
 		oms->pdata.get_ro = of_mmc_spi_get_ro;
 
 	oms->detect_irq = irq_of_parse_and_map(np, 0);
-	if (oms->detect_irq != NO_IRQ) {
+	if (oms->detect_irq != NO_IRQ && oms->detect_irq > 0) {
 		oms->pdata.init = of_mmc_spi_init;
 		oms->pdata.exit = of_mmc_spi_exit;
 	} else {
-- 
1.7.10

