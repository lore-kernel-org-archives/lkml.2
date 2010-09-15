Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab0IOJHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 05:07:41 -0400
Received: from relay.atmel.no ([194.19.124.36]:60791 "EHLO relay.atmel.no"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751284Ab0IOJHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 05:07:40 -0400
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Sep 2010 05:07:39 EDT
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: linux-mmc@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] mmc: Reduce fOD to 200 kHz if possible
Date: Wed, 15 Sep 2010 10:59:00 +0200
Message-Id: <1284541140-7328-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the identification frequency was increased to 400 kHz, my
ATSTK1000 board has not been able to initialize any MMC or SD cards.
Reducing the identification mode frequency to 200 kHz fixes the problem.

This is definitely a board-specific issue, probably due to weak pull-up
resistor values, but this is the simplest fix I could come up with.
Alternatively, we could try to pass some "maximum fOD" parameter from
the board code somehow.

Different boards using the same controller (AVR32 AP7000) and the same
cards have no problems at 400 kHz, but I believe reducing fOD a bit
allows a bit more tolerance for poor board designs, which can only be a
good thing. Also, using too strong pull-ups might cause problems at high
speeds, which is IMO worse.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
Sorry about bringing this up again, but it's been a pretty longstanding
issue on at least one board, and selecting correct pull-ups requires
careful reading of several specification documents, so selecting a
minimum frequency which is the maximum that the spec allows seems like
asking for trouble.

Both the MMC and SD specs allow frequencies from 100 kHz to 400 kHz. 200
kHz seems like a good compromise to me.

 drivers/mmc/core/core.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 5db49b1..b4d9e8b 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -911,8 +911,11 @@ static void mmc_power_up(struct mmc_host *host)
 		pr_warning("%s: Minimum clock frequency too high for "
 				"identification mode\n", mmc_hostname(host));
 		host->ios.clock = host->f_min;
-	} else
-		host->ios.clock = 400000;
+	} else if (host->f_min > 200000) {
+		host->ios.clock = host->f_min;
+	} else {
+		host->ios.clock = 200000;
+	}
 
 	host->ios.power_mode = MMC_POWER_ON;
 	mmc_set_ios(host);
-- 
1.7.0.4

