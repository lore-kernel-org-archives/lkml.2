Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab2B2R7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:59:22 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:45845 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532Ab2B2R7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:59:21 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2] pinctrl: make the pinmux-pins more helpful
Date: Wed, 29 Feb 2012 18:58:52 +0100
Message-ID: <1330538332-16088-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The debugfs file pinmux-pins used to tell which function was
enabled but now states simply which device owns the pin. Being
owned by the pinctrl driver itself means just that it's hogged
so be a bit more helpful by printing that.

ChangeLog v1->v2:
- Preserve the self-referential owner field, just clarify that
  when the pin controller states itself as owner this means
  that it's hogged.

Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinmux.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 98b89d6..2a40561 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -626,8 +626,8 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 
 	/* The pin number can be retrived from the pin controller descriptor */
 	for (i = 0; i < pctldev->desc->npins; i++) {
-
 		struct pin_desc *desc;
+		bool is_hog = false;
 
 		pin = pctldev->desc->pins[i].number;
 		desc = pin_desc_get(pctldev, pin);
@@ -635,9 +635,14 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 		if (desc == NULL)
 			continue;
 
-		seq_printf(s, "pin %d (%s): %s\n", pin,
+		if (desc->owner &&
+		    !strcmp(desc->owner, pinctrl_dev_get_name(pctldev)))
+			is_hog = true;
+
+		seq_printf(s, "pin %d (%s): %s%s\n", pin,
 			   desc->name ? desc->name : "unnamed",
-			   desc->owner ? desc->owner : "UNCLAIMED");
+			   desc->owner ? desc->owner : "UNCLAIMED",
+			   is_hog ? " (HOG)" : "");
 	}
 
 	return 0;
-- 
1.7.8

