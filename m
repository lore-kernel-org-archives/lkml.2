Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab1KOGlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 01:41:45 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46992 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab1KOGlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 01:41:44 -0500
From: Rajendra Nayak <rnayak@ti.com>
To: <linus.walleij@linaro.org>, <linus.walleij@stericsson.com>
CC: <linux-kernel@vger.kernel.org>, <linaro-dev@lists.linaro.org>,
        Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH] pinctrl: Iterate over u300_pmx_mask's in u300_pmx_endisable
Date: Tue, 15 Nov 2011 12:10:26 +0530
Message-ID: <1321339226-29968-1-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix u300_pmx_endisable() to iterate over the list of 'bits' and
'mask' populated as part of u300_pmx_functions.mask[]

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
---
Linus W,
I am not sure if this is a right fix. I just stumbled
upon this while looking at the u300 pinmux driver
while I was writing one for OMAP. Maybe I am reading
the code completely wrong, and I don't even have a
way to test this, so its just compile tested with
u300_defconfig.

 drivers/pinctrl/pinmux-u300.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinmux-u300.c b/drivers/pinctrl/pinmux-u300.c
index 4858a64..145a84d 100644
--- a/drivers/pinctrl/pinmux-u300.c
+++ b/drivers/pinctrl/pinmux-u300.c
@@ -940,20 +940,23 @@ static void u300_pmx_endisable(struct u300_pmx *upmx, unsigned selector,
 {
 	u16 regval, val, mask;
 	int i;
+	const struct u300_pmx_mask *upmx_mask;
 
+	upmx_mask = u300_pmx_functions[selector].mask;
 	for (i = 0; i < ARRAY_SIZE(u300_pmx_registers); i++) {
 		if (enable)
-			val = u300_pmx_functions[selector].mask->bits;
+			val = upmx_mask->bits;
 		else
 			val = 0;
 
-		mask = u300_pmx_functions[selector].mask->mask;
+		mask = upmx_mask->mask;
 		if (mask != 0) {
 			regval = readw(upmx->virtbase + u300_pmx_registers[i]);
 			regval &= ~mask;
 			regval |= val;
 			writew(regval, upmx->virtbase + u300_pmx_registers[i]);
 		}
+		upmx_mask++;
 	}
 }
 
-- 
1.7.1

