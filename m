Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab1GOQoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:44:03 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35835 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab1GOQoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:44:01 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 12/15] gma500@ Fix backlight range error
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 15 Jul 2011 17:35:12 +0100
Message-ID: <20110715163508.28759.6997.stgit@localhost.localdomain>
In-Reply-To: <20110715163117.28759.14946.stgit@localhost.localdomain>
References: <20110715163117.28759.14946.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

If we go out of range we break the pm counts on the error path

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mrst_device.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/gma500/mrst_device.c b/drivers/staging/gma500/mrst_device.c
index 573142f..6707faf 100644
--- a/drivers/staging/gma500/mrst_device.c
+++ b/drivers/staging/gma500/mrst_device.c
@@ -157,14 +157,12 @@ static int device_backlight_init(struct drm_device *dev)
 	value /= bl_max_freq;
 	value /= blc_pwm_precision_factor;
 
+	if (value > (unsigned long long)MRST_BLC_MAX_PWM_REG_FREQ)
+			return -ERANGE;
+
 	if (gma_power_begin(dev, false)) {
-		if (value > (unsigned long long)MRST_BLC_MAX_PWM_REG_FREQ)
-				return -ERANGE;
-		else {
-			REG_WRITE(BLC_PWM_CTL2,
-					(0x80000000 | REG_READ(BLC_PWM_CTL2)));
-			REG_WRITE(BLC_PWM_CTL, value | (value << 16));
-		}
+		REG_WRITE(BLC_PWM_CTL2, (0x80000000 | REG_READ(BLC_PWM_CTL2)));
+		REG_WRITE(BLC_PWM_CTL, value | (value << 16));
 		gma_power_end(dev);
 	}
 	return 0;

