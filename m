Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab2HWHQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:16:06 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43273 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593Ab2HWHQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:16:03 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH] pwm: pwm-tiecap: Disable APWM mode after configure
Date: Thu, 23 Aug 2012 12:29:46 +0530
Message-ID: <1345705186-10543-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APWM mode is enabled while configuring PWM device. This was done to
handle shadow & immediate mode update of period and compare registers.
However, leaving it enabled after configuring will cause APWM output on
PWM pin even before enabling PWM device.
Fix the same by disabling APWM mode after configuring if PWM device is
not running.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
:100644 100644 0b66d0f... 4b66889... M	drivers/pwm/pwm-tiecap.c
 drivers/pwm/pwm-tiecap.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index 0b66d0f..4b66889 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -100,6 +100,13 @@ static int ecap_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 		writel(period_cycles, pc->mmio_base + CAP3);
 	}
 
+	if (!test_bit(PWMF_ENABLED, &pwm->flags)) {
+		reg_val = readw(pc->mmio_base + ECCTL2);
+		/* Disable APWM mode to put APWM output Low */
+		reg_val &= ~ECCTL2_APWM_MODE;
+		writew(reg_val, pc->mmio_base + ECCTL2);
+	}
+
 	pm_runtime_put_sync(pc->chip.dev);
 	return 0;
 }
-- 
1.7.1

