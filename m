Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422717Ab2KNL6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:58:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55407 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422673Ab2KNL6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:58:39 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Roland Stigge <stigge@antcom.de>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH 1/3] pwm: lpc32xx - Fix the PWM polarity
Date: Wed, 14 Nov 2012 12:58:13 +0100
Message-Id: <1352894295-14339-2-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352894295-14339-1-git-send-email-alban.bedel@avionic-design.de>
References: <1352894295-14339-1-git-send-email-alban.bedel@avionic-design.de>
X-Provags-ID: V02:K0:N046lOseb4jjLF5KjQlST/8DYzGgA0TxO0sLZ35lO4X
 nxBdDxcbTyDQjDHk4A3uY4NO2MH06qz8nKX5exGnEkv80KHQKn
 OFofZA9clKUxVxQ+bvbU69CAxqZRhFHmTfu23mLFg4nXJa3WFU
 b0IUu80znx1ihV0KnjLeT76DZdaP8z3JD2iVinMIR+BOw5kZMW
 ek1DtJHzKpNjcz6RWKWl/NRppH23ii5uYnCK6Xrv3XmZ78x7qK
 Wwp30OD12y4zz59Tj17i2KjwbE6bSRCZsfj3pGmcdw+A1za6aV
 WwrNCsMBydT1+XA/lETqC9oGJZ9Yesvxk/CphHIeyj/ho9j0cy
 H5p40DZj4Q09QtX4QhiFQInuZn0XU3UI9UBA+B0Hm85hBAblih
 /6VHKG2RBTzaImOsgBhY9R6kqs+BsA4sjJVZyjl5MBCwlP+KOC
 7iFzU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The duty cycles value goes from 1 (99% HIGH) to 256 (0% HIGH) but it
is stored modulo 256 in the register as it is only 8 bits wide.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 drivers/pwm/pwm-lpc32xx.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
index adb87f0..03ec3ff 100644
--- a/drivers/pwm/pwm-lpc32xx.c
+++ b/drivers/pwm/pwm-lpc32xx.c
@@ -49,9 +49,24 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 		c = 0; /* 0 set division by 256 */
 	period_cycles = c;
 
+	/* The duty value is a follow:
+	 *
+	 *  DUTY     HIGH LEVEL
+	 *   1         99.9%
+	 *   25        90.0%
+	 *   128       50.0%
+	 *   220       10.0%
+	 *   255        0.1%
+	 *   0          0.0%
+	 *
+	 * In other word the in-register value is duty % 256 with duty
+	 * in the range 1-256.
+	 */
 	c = 256 * duty_ns;
 	do_div(c, period_ns);
-	duty_cycles = c;
+	if (c > 255)
+		c = 255;
+	duty_cycles = 256 - c;
 
 	writel(PWM_ENABLE | PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles),
 		lpc32xx->base + (pwm->hwpwm << 2));
-- 
1.7.0.4

