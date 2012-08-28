Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2H1Ltj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:49:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38685 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab2H1Lsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:48:42 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 6/9] pwm i.MX: use per clock unconditionally
Date: Tue, 28 Aug 2012 13:48:21 +0200
Message-Id: <1346154504-5623-7-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346154504-5623-1-git-send-email-s.hauer@pengutronix.de>
References: <1346154504-5623-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i.MX pwm core has two clocks: The ipg clock and the ipg highfreq
(peripheral) clock. The ipg clock has to be enabled for this hardware
to work. The actual pwm output can either be driven by the ipg clock
or the ipg highfreq. The ipg highfreq has the advantage that it runs
even when the SoC is in low power modes.
Use the always running clock also on i.MX25.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/pwm/pwm-imx.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index dfc1bae..3834f475 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -132,16 +132,11 @@ static int imx_pwm_config_v2(struct pwm_chip *chip,
 
 	cr = MX3_PWMCR_PRESCALER(prescale) |
 		MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN |
-		MX3_PWMCR_DBGEN;
+		MX3_PWMCR_DBGEN | MX3_PWMCR_CLKSRC_IPG_HIGH;
 
 	if (imx->enabled)
 		cr |= MX3_PWMCR_EN;
 
-	if (cpu_is_mx25())
-		cr |= MX3_PWMCR_CLKSRC_IPG;
-	else
-		cr |= MX3_PWMCR_CLKSRC_IPG_HIGH;
-
 	writel(cr, imx->mmio_base + MX3_PWMCR);
 
 	return 0;
-- 
1.7.10.4

