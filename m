Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab2HVGFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:05:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55273 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194Ab2HVGFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:05:38 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv2 2/3] spi: omap2-mcspi: Remove the macro MOD_REG_BIT
Date: Wed, 22 Aug 2012 11:35:13 +0530
Message-ID: <1345615515-26745-3-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345615515-26745-1-git-send-email-shubhrajyoti@ti.com>
References: <1345615515-26745-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the macro MOD_REG_BIT instead make the bit field modifications
directly. This deletes a branch operation in cases where the the set
is predecided. While at it optimise two sequential bit clear in one step.

Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index f542f3d..8a5e2c0 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -140,13 +140,6 @@ struct omap2_mcspi_cs {
 	u32			chconf0;
 };
 
-#define MOD_REG_BIT(val, mask, set) do { \
-	if (set) \
-		val |= mask; \
-	else \
-		val &= ~mask; \
-} while (0)
-
 static inline void mcspi_write_reg(struct spi_master *master,
 		int idx, u32 val)
 {
@@ -205,7 +198,11 @@ static void omap2_mcspi_set_dma_req(const struct spi_device *spi,
 	else
 		rw = OMAP2_MCSPI_CHCONF_DMAW;
 
-	MOD_REG_BIT(l, rw, enable);
+	if (enable)
+		l |= rw;
+	else
+		l &= ~rw;
+
 	mcspi_write_chconf0(spi, l);
 }
 
@@ -224,7 +221,11 @@ static void omap2_mcspi_force_cs(struct spi_device *spi, int cs_active)
 	u32 l;
 
 	l = mcspi_cached_chconf0(spi);
-	MOD_REG_BIT(l, OMAP2_MCSPI_CHCONF_FORCE, cs_active);
+	if (cs_active)
+		l |= OMAP2_MCSPI_CHCONF_FORCE;
+	else
+		l &= ~OMAP2_MCSPI_CHCONF_FORCE;
+
 	mcspi_write_chconf0(spi, l);
 }
 
@@ -239,9 +240,8 @@ static void omap2_mcspi_set_master_mode(struct spi_master *master)
 	 * to single-channel master mode
 	 */
 	l = mcspi_read_reg(master, OMAP2_MCSPI_MODULCTRL);
-	MOD_REG_BIT(l, OMAP2_MCSPI_MODULCTRL_STEST, 0);
-	MOD_REG_BIT(l, OMAP2_MCSPI_MODULCTRL_MS, 0);
-	MOD_REG_BIT(l, OMAP2_MCSPI_MODULCTRL_SINGLE, 1);
+	l &= ~(OMAP2_MCSPI_MODULCTRL_STEST | OMAP2_MCSPI_MODULCTRL_MS);
+	l |= OMAP2_MCSPI_MODULCTRL_SINGLE;
 	mcspi_write_reg(master, OMAP2_MCSPI_MODULCTRL, l);
 
 	ctx->modulctrl = l;
@@ -1278,9 +1278,9 @@ static int omap2_mcspi_resume(struct device *dev)
 			 * We need to toggle CS state for OMAP take this
 			 * change in account.
 			 */
-			MOD_REG_BIT(cs->chconf0, OMAP2_MCSPI_CHCONF_FORCE, 1);
+			cs->chconf0 |= OMAP2_MCSPI_CHCONF_FORCE;
 			__raw_writel(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
-			MOD_REG_BIT(cs->chconf0, OMAP2_MCSPI_CHCONF_FORCE, 0);
+			cs->chconf0 &= ~OMAP2_MCSPI_CHCONF_FORCE;
 			__raw_writel(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
 		}
 	}
-- 
1.7.5.4

