Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab1JLI6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 04:58:21 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:43198 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957Ab1JLI6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 04:58:15 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <samuel.ortiz@intel.com>,
        Dmitry Torokhov <dtor@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        alsa-devel@alsa-project.org, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH v3 2/5] MFD: twl6040: Cache the vibra control registers
Date: Wed, 12 Oct 2011 11:57:54 +0300
Message-Id: <1318409877-21681-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1318409877-21681-1-git-send-email-peter.ujfalusi@ti.com>
References: <1318409877-21681-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vibra control register will be used from the ASoC codec driver as well.
In order to avoid latency issues caused by I2C read access, cache the two
control register within the core driver, so we do not need to reach out
to the chip to read it back.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
 drivers/mfd/twl6040-core.c  |   19 +++++++++++++++----
 include/linux/mfd/twl6040.h |    1 +
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 7dc8c47..75987c8 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -34,16 +34,24 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/twl6040.h>
 
+#define VIBRACTRL_MEMBER(reg) ((reg == TWL6040_REG_VIBCTLL) ? 0 : 1)
+
 int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg)
 {
 	int ret;
 	u8 val = 0;
 
 	mutex_lock(&twl6040->io_mutex);
-	ret = twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &val, reg);
-	if (ret < 0) {
-		mutex_unlock(&twl6040->io_mutex);
-		return ret;
+	/* Vibra control registers from cache */
+	if (unlikely(reg == TWL6040_REG_VIBCTLL ||
+		     reg == TWL6040_REG_VIBCTLR)) {
+		val = twl6040->vibra_ctrl_cache[VIBRACTRL_MEMBER(reg)];
+	} else {
+		ret = twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &val, reg);
+		if (ret < 0) {
+			mutex_unlock(&twl6040->io_mutex);
+			return ret;
+		}
 	}
 	mutex_unlock(&twl6040->io_mutex);
 
@@ -57,6 +65,9 @@ int twl6040_reg_write(struct twl6040 *twl6040, unsigned int reg, u8 val)
 
 	mutex_lock(&twl6040->io_mutex);
 	ret = twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE, val, reg);
+	/* Cache the vibra control registers */
+	if (reg == TWL6040_REG_VIBCTLL || reg == TWL6040_REG_VIBCTLR)
+		twl6040->vibra_ctrl_cache[VIBRACTRL_MEMBER(reg)] = val;
 	mutex_unlock(&twl6040->io_mutex);
 
 	return ret;
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index e6c755d..2f8585a 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -184,6 +184,7 @@ struct twl6040 {
 	int audpwron;
 	int power_count;
 	int rev;
+	u8 vibra_ctrl_cache[2];
 
 	int pll;
 	unsigned int sysclk;
-- 
1.7.7

