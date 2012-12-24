Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab2LXJwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 04:52:24 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5546 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2LXJwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 04:52:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 24 Dec 2012 01:49:54 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <a.zummo@towertech.it>
CC: <akpm@linuxfoundation.org>, <broonie@opensource.wolfsonmicro.com>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 4/4] rtc: tps65910: set irq flag to IRQF_EARLY_RESUME during irq request
Date: Mon, 24 Dec 2012 15:21:27 +0530
Message-ID: <1356342687-3432-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1356342687-3432-1-git-send-email-ldewangan@nvidia.com>
References: <1356342687-3432-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All interrupt get disabled during system suspend and enabled during
system resume. The enabling/disabling of interrupt happen in sequence
of interrupt registration with framework.

Therefore, in resume, the parent interrupt of this device enabled before
the RTC irq interrupt enabled. If RTC is enabled for alarm wake and if
system wake by alarm then there is interrupt pending for RTC. In resume,
the parent interrupt get enabled before the rtc interrupt and hence ISR
get served. In ISR, it founds that rtc interrupt is disabled and so it does
not call the rtc isr handler and hence it misses the interrupt.

Setting flag for early resume so that rtc interrupt get enabled before
parent interrupt  and so rtc interrupt get enabled when parent interrupt
handler check for interrupt of device and call the rtc handler if it is there.
This way it will not miss the interrupt.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/rtc/rtc-tps65910.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index ff98e18..d2e1c08 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -267,7 +267,7 @@ static int __devinit tps65910_rtc_probe(struct platform_device *pdev)
 	}
 
 	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
-		tps65910_rtc_interrupt, IRQF_TRIGGER_LOW,
+		tps65910_rtc_interrupt, IRQF_TRIGGER_LOW | IRQF_EARLY_RESUME,
 		dev_name(&pdev->dev), &pdev->dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "IRQ is not free.\n");
-- 
1.7.1.1

