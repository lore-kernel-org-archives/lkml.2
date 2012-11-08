Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2KHLqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 06:46:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56116 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab2KHLqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 06:46:30 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Roland Stigge <stigge@antcom.de>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH] pwm: lpc32xx - Fix the PWM polarity
Date: Thu,  8 Nov 2012 12:46:24 +0100
Message-Id: <1352375184-4920-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20121108122345.72aa0f6c@avionic-0020.adnet.avionic-design.de>
References: <20121108122345.72aa0f6c@avionic-0020.adnet.avionic-design.de>
X-Provags-ID: V02:K0:lC9ZU0Shq2wQQZZ9VnEToH+zF0uMXqEKNcUAXZiGaqp
 KXYL91exqGvUZDzFArnMw1JMXl5XvILfCDTzKk6rrxoQHm5g90
 iT0d7zhcOm208quDAL+iwaP9fgaKx71MOibTjwErBvNA5M32CC
 NSIjl2rZsovqrsB3Z2YivRS9MgZBWrhpWCuIyVve6QklPn2wxB
 +KsRkRjb9N2IMsDcHSIugdaBZCyqhPnypkaHl7oNTkusmdR34e
 tuHpKsbLU8GKSdfgL/kF1QbnpxN+1ztsycw6FZ+5hmRSVzf4YX
 dWWjEDVlvPmjC+9wpIGOcFgf2unvMLIBu1lV/GX03Za/PMv607
 /W6LD4TsoRBXZrottm/P4jKLRzKdltFGu+N6JtfcPj4TEOr0xz
 sXQkxiXvAEztFMN5yfDgUoLDLNhweMCKjl+zdfPG/gcTuzD4Dx
 nS6z3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The duty cycles value goes from 1 (99% HIGH) to 256 (0% HIGH) but it
is stored modulo 256 in the register as it is only 8 bits wide.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 drivers/pwm/pwm-lpc32xx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
index adb87f0..2590f8d 100644
--- a/drivers/pwm/pwm-lpc32xx.c
+++ b/drivers/pwm/pwm-lpc32xx.c
@@ -51,7 +51,9 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 
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

