Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab0KEJgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 05:36:04 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:44200 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307Ab0KEJgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 05:36:03 -0400
X-Greylist: delayed 69007 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Nov 2010 05:36:02 EDT
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-mmc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <akpm@linux-foundation.org>, Ulf Hansson <ulf.hansson@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] mmci: reset voltage after power off.
Date: Fri, 5 Nov 2010 10:35:41 +0100
Message-ID: <1288949741-9712-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulf Hansson <ulf.hansson@stericsson.com>

At power off, reset OCR mask to be the highest possible voltage
supported for the current mmc host.

This solves the re-initialization during the power up sequence.
The voltage may have been decreased due to the card accepts a lower
voltage than the voltage used during the initialization sequence.
We need to reset the voltage to by the host highest possible value
since according to specification the initialization must always be
done at high voltage.

Signed-off-by: Ulf Hansson <ulf.hansson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mmc/core/core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 8f86d70..508ed2b 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -940,6 +940,13 @@ static void mmc_power_off(struct mmc_host *host)
 {
 	host->ios.clock = 0;
 	host->ios.vdd = 0;
+
+	/*
+	 * Reset ocr mask to be the highest possible voltage supported for
+	 * this mmc host. This value will be used at next power up.
+	 */
+	host->ocr = 1 << (fls(host->ocr_avail) - 1);
+
 	if (!mmc_host_is_spi(host)) {
 		host->ios.bus_mode = MMC_BUSMODE_OPENDRAIN;
 		host->ios.chip_select = MMC_CS_DONTCARE;
-- 
1.6.3.3

