Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422741Ab2KNL6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:58:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422719Ab2KNL6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:58:42 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Roland Stigge <stigge@antcom.de>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH 2/3] pwm: lpc32xx - Properly disable the clock on device remove
Date: Wed, 14 Nov 2012 12:58:14 +0100
Message-Id: <1352894295-14339-3-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352894295-14339-1-git-send-email-alban.bedel@avionic-design.de>
References: <1352894295-14339-1-git-send-email-alban.bedel@avionic-design.de>
X-Provags-ID: V02:K0:hI0t13B2gw9nKZ8E7cUCHsPzXokAeC5cKFM/C+pUQXL
 4IrEBkQhVymo/a2rCYZWuGRHKhfttn689UvVdzqwKniRHX5APe
 9lbeu3RMWONRiemU1A9H88BKo+wYNQwJRd9wak2P6u3/kaypBk
 oShDMIbeg4wli+5UWui1QlPhhdzciWHkUNreiOzy4oXM8MI8iH
 zWYIX0t//UYUJUgX2ZQbs89Pw7JOA4N4hNFCZHT2cI7OYLFKr2
 KVSp0m4Rs6N9mqClqQQmxU+EAo6wgothEkECtAMfMW8clVZxpP
 HkMipFxQS0loEF22ffSJlnpgzQ3A90b+iNGR1tJ9q4LNS2iCoV
 vjH3KhESYSfp62EPeaMEUWF8ccRiFPMAb8D41a907WOb+GH5Qs
 JRQfBHZuRXVkop4aLLVTCuBWSj43OJn7AB0IVyLtTEuVXgwYXP
 8vBNN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A single clock is used for all PWMs meaning the clock ref count might
be between 0 and N when remove() is called. Instead of a single
clk_disable() call pwm_disable() on each PWM, that ensure that
clk_disable() is called for each PWM that were still enabled.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 drivers/pwm/pwm-lpc32xx.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
index 03ec3ff..f45ce2c 100644
--- a/drivers/pwm/pwm-lpc32xx.c
+++ b/drivers/pwm/pwm-lpc32xx.c
@@ -136,8 +136,11 @@ static int lpc32xx_pwm_probe(struct platform_device *pdev)
 static int __devexit lpc32xx_pwm_remove(struct platform_device *pdev)
 {
 	struct lpc32xx_pwm_chip *lpc32xx = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0 ; i < lpc32xx->chip.npwm ; i += 1)
+		pwm_disable(&lpc32xx->chip.pwms[i]);
 
-	clk_disable(lpc32xx->clk);
 	return pwmchip_remove(&lpc32xx->chip);
 }
 
-- 
1.7.0.4

