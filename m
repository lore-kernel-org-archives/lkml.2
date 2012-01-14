Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab2ANT7E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 14:59:04 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:48709 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756578Ab2ANT7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 14:59:00 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RESEND 2/2] MFD: twl6040-codec: Avoid PLL reconfiguration when not needed
Date: Sat, 14 Jan 2012 20:58:44 +0100
Message-Id: <1326571124-11436-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1326571124-11436-1-git-send-email-peter.ujfalusi@ti.com>
References: <1326571124-11436-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not reconfigure the PLL in case it has been configured already
with the requested parameters.
In case of different PLL configuration do only the needed changes.
This can save considerable amount of time since we can avoid the
defined protocol (with delays) for the PLL configuration.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c |  125 ++++++++++++++++++++++++++------------------
 1 files changed, 74 insertions(+), 51 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index c2088f4..b2d8e51 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -326,23 +326,38 @@ int twl6040_set_pll(struct twl6040 *twl6040, int pll_id,
 	hppllctl = twl6040_reg_read(twl6040, TWL6040_REG_HPPLLCTL);
 	lppllctl = twl6040_reg_read(twl6040, TWL6040_REG_LPPLLCTL);
 
+	/* Force full reconfiguration when switching between PLL */
+	if (pll_id != twl6040->pll) {
+		twl6040->sysclk = 0;
+		twl6040->mclk = 0;
+	}
+
 	switch (pll_id) {
 	case TWL6040_SYSCLK_SEL_LPPLL:
 		/* low-power PLL divider */
-		switch (freq_out) {
-		case 17640000:
-			lppllctl |= TWL6040_LPLLFIN;
-			break;
-		case 19200000:
-			lppllctl &= ~TWL6040_LPLLFIN;
-			break;
-		default:
-			dev_err(twl6040->dev,
-				"freq_out %d not supported\n", freq_out);
-			ret = -EINVAL;
-			goto pll_out;
+		/* Change the sysclk configuration only if it has been canged */
+		if (twl6040->sysclk != freq_out) {
+			switch (freq_out) {
+			case 17640000:
+				lppllctl |= TWL6040_LPLLFIN;
+				break;
+			case 19200000:
+				lppllctl &= ~TWL6040_LPLLFIN;
+				break;
+			default:
+				dev_err(twl6040->dev,
+					"freq_out %d not supported\n",
+					freq_out);
+				ret = -EINVAL;
+				goto pll_out;
+			}
+			twl6040_reg_write(twl6040, TWL6040_REG_LPPLLCTL,
+					  lppllctl);
 		}
-		twl6040_reg_write(twl6040, TWL6040_REG_LPPLLCTL, lppllctl);
+
+		/* The PLL in use has not been change, we can exit */
+		if (twl6040->pll == pll_id)
+			break;
 
 		switch (freq_in) {
 		case 32768:
@@ -373,48 +388,56 @@ int twl6040_set_pll(struct twl6040 *twl6040, int pll_id,
 			goto pll_out;
 		}
 
-		hppllctl &= ~TWL6040_MCLK_MSK;
+		if (twl6040->mclk != freq_in) {
+			hppllctl &= ~TWL6040_MCLK_MSK;
+
+			switch (freq_in) {
+			case 12000000:
+				/* PLL enabled, active mode */
+				hppllctl |= TWL6040_MCLK_12000KHZ |
+					    TWL6040_HPLLENA;
+				break;
+			case 19200000:
+				/*
+				* PLL disabled
+				* (enable PLL if MCLK jitter quality
+				*  doesn't meet specification)
+				*/
+				hppllctl |= TWL6040_MCLK_19200KHZ;
+				break;
+			case 26000000:
+				/* PLL enabled, active mode */
+				hppllctl |= TWL6040_MCLK_26000KHZ |
+					    TWL6040_HPLLENA;
+				break;
+			case 38400000:
+				/* PLL enabled, active mode */
+				hppllctl |= TWL6040_MCLK_38400KHZ |
+					    TWL6040_HPLLENA;
+				break;
+			default:
+				dev_err(twl6040->dev,
+					"freq_in %d not supported\n", freq_in);
+				ret = -EINVAL;
+				goto pll_out;
+			}
 
-		switch (freq_in) {
-		case 12000000:
-			/* PLL enabled, active mode */
-			hppllctl |= TWL6040_MCLK_12000KHZ |
-				    TWL6040_HPLLENA;
-			break;
-		case 19200000:
 			/*
-			 * PLL disabled
-			 * (enable PLL if MCLK jitter quality
-			 *  doesn't meet specification)
+			 * enable clock slicer to ensure input waveform is
+			 * square
 			 */
-			hppllctl |= TWL6040_MCLK_19200KHZ;
-			break;
-		case 26000000:
-			/* PLL enabled, active mode */
-			hppllctl |= TWL6040_MCLK_26000KHZ |
-				    TWL6040_HPLLENA;
-			break;
-		case 38400000:
-			/* PLL enabled, active mode */
-			hppllctl |= TWL6040_MCLK_38400KHZ |
-				    TWL6040_HPLLENA;
-			break;
-		default:
-			dev_err(twl6040->dev,
-				"freq_in %d not supported\n", freq_in);
-			ret = -EINVAL;
-			goto pll_out;
-		}
+			hppllctl |= TWL6040_HPLLSQRENA;
 
-		/* enable clock slicer to ensure input waveform is square */
-		hppllctl |= TWL6040_HPLLSQRENA;
-
-		twl6040_reg_write(twl6040, TWL6040_REG_HPPLLCTL, hppllctl);
-		usleep_range(500, 700);
-		lppllctl |= TWL6040_HPLLSEL;
-		twl6040_reg_write(twl6040, TWL6040_REG_LPPLLCTL, lppllctl);
-		lppllctl &= ~TWL6040_LPLLENA;
-		twl6040_reg_write(twl6040, TWL6040_REG_LPPLLCTL, lppllctl);
+			twl6040_reg_write(twl6040, TWL6040_REG_HPPLLCTL,
+					  hppllctl);
+			usleep_range(500, 700);
+			lppllctl |= TWL6040_HPLLSEL;
+			twl6040_reg_write(twl6040, TWL6040_REG_LPPLLCTL,
+					  lppllctl);
+			lppllctl &= ~TWL6040_LPLLENA;
+			twl6040_reg_write(twl6040, TWL6040_REG_LPPLLCTL,
+					  lppllctl);
+		}
 		break;
 	default:
 		dev_err(twl6040->dev, "unknown pll id %d\n", pll_id);
-- 
1.7.8.3

