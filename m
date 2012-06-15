Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab2FOMHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:07:36 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:60971 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756267Ab2FOMHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:07:35 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/nomadik: document Alt-C glitch
Date: Fri, 15 Jun 2012 14:06:51 +0200
Message-ID: <1339762011-28159-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This documentation comment existed in an earlier patch set for
GPIO consolidation, so I'm saving it for maintainability of the
code.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index e8937e7..3e7e47d 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1438,7 +1438,27 @@ static int nmk_pmx_enable(struct pinctrl_dev *pctldev, unsigned function,
 
 	dev_dbg(npct->dev, "enable group %s, %u pins\n", g->name, g->npins);
 
-	/* Handle this special glitch on altfunction C */
+	/*
+	 * If we're setting altfunc C by setting both AFSLA and AFSLB to 1,
+	 * we may pass through an undesired state. In this case we take
+	 * some extra care.
+	 *
+	 * Safe sequence used to switch IOs between GPIO and Alternate-C mode:
+	 *  - Save SLPM registers (since we have a shadow register in the
+	 *    nmk_chip we're using that as backup)
+	 *  - Set SLPM=0 for the IOs you want to switch and others to 1
+	 *  - Configure the GPIO registers for the IOs that are being switched
+	 *  - Set IOFORCE=1
+	 *  - Modify the AFLSA/B registers for the IOs that are being switched
+	 *  - Set IOFORCE=0
+	 *  - Restore SLPM registers
+	 *  - Any spurious wake up event during switch sequence to be ignored
+	 *    and cleared
+	 *
+	 * We REALLY need to save ALL slpm registers, because the external
+	 * IOFORCE will switch *all* ports to their sleepmode setting to as
+	 * to avoid glitches. (Not just one port!)
+	 */
 	glitch = (g->altsetting == NMK_GPIO_ALT_C);
 
 	if (glitch) {
-- 
1.7.9.2

