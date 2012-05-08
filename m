Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab2EHJpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:45:11 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:45989 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820Ab2EHJpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:45:09 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 04/12] pinctrl/nomadik: reuse GPIO debug function for pins
Date: Tue, 8 May 2012 11:44:46 +0200
Message-ID: <1336470286-23589-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Since all pins we can control are GPIOs, match a GPIO range to
each pin in the debug function and call into the GPIO debug
print function to have the per-pin information.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index d9e41c9..750703f 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1332,10 +1332,36 @@ static int nmk_get_group_pins(struct pinctrl_dev *pctldev, unsigned selector,
 	return 0;
 }
 
+static struct pinctrl_gpio_range *
+nmk_match_gpio_range(struct pinctrl_dev *pctldev, unsigned offset)
+{
+	struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
+	int i;
+
+	for (i = 0; i < npct->soc->gpio_num_ranges; i++) {
+		struct pinctrl_gpio_range *range;
+
+		range = &npct->soc->gpio_ranges[i];
+		if (offset >= range->pin_base &&
+		    offset <= (range->pin_base + range->npins - 1))
+			return range;
+	}
+	return NULL;
+}
+
 static void nmk_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
 		   unsigned offset)
 {
-	seq_printf(s, " Nomadik GPIO");
+	struct pinctrl_gpio_range *range;
+	struct gpio_chip *chip;
+
+	range = nmk_match_gpio_range(pctldev, offset);
+	if (!range || !range->gc) {
+		seq_printf(s, "invalid pin offset");
+		return;
+	}
+	chip = range->gc;
+	nmk_gpio_dbg_show_one(s, chip, offset - chip->base, offset);
 }
 
 static struct pinctrl_ops nmk_pinctrl_ops = {
-- 
1.7.9.2

