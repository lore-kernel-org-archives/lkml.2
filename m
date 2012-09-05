Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab2IEJB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:01:56 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:44441 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932515Ab2IEJBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:01:46 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>, Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH 1/2] pinctrl: pinctrl-single: Make sure we do not change bits outside of mask
Date: Wed,  5 Sep 2012 12:01:57 +0300
Message-Id: <1346835718-21325-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com>
References: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the pcs->fmask to make sure that the value is not changing (setting)
bits in areas where it should not.
To avoid situations like this:

pmx_dummy: pinmux@4a100040 {
	compatible = "pinctrl-single";
	reg = <0x4a100040 0x0196>;
	#address-cells = <1>;
	#size-cells = <0>;
	pinctrl-single,register-width = <16>;
	pinctrl-single,function-mask = <0x00ff>;
};

&pmx_dummy {
	pinctrl-names = "default";
	pinctrl-0 = <&board_pins>;

	board_pins: pinmux_board_pins {
		pinctrl-single,pins = <
			0x6c 0xf0f
			0x6e 0x10f
			0x70 0x23f
			0x72 0xa5f
		>;
	};
};

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/pinctrl/pinctrl-single.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 76a4260..3508631 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -337,7 +337,7 @@ static int pcs_enable(struct pinctrl_dev *pctldev, unsigned fselector,
 		vals = &func->vals[i];
 		val = pcs->read(vals->reg);
 		val &= ~pcs->fmask;
-		val |= vals->val;
+		val |= (vals->val & pcs->fmask);
 		pcs->write(val, vals->reg);
 	}
 
-- 
1.7.12

