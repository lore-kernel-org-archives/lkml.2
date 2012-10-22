Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2JVNM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:12:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35858 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334Ab2JVNMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:12:54 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <tony@atomide.com>, <b-cousson@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-input@vger.kernel.org>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Date: Mon, 22 Oct 2012 18:43:00 +0530
Message-ID: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt keypad to use pinctrl framework.

Tested on omap4430 sdp with 3.7-rc1 kernel.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
v1->v2
- Added "PROBE_DEFER" check 
 drivers/input/keyboard/omap4-keypad.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index c05f98c..502b832 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -31,6 +31,7 @@
 #include <linux/input.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/pinctrl/consumer.h>
 
 #include <linux/platform_data/omap4-keypad.h>
 
@@ -76,6 +77,7 @@ enum {
 
 struct omap4_keypad {
 	struct input_dev *input;
+	struct pinctrl	*pins;
 
 	void __iomem *base;
 	unsigned int irq;
@@ -298,6 +300,15 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 		goto err_release_mem;
 	}
 
+	keypad_data->pins = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(keypad_data->pins)) {
+		if (PTR_ERR(keypad_data->pins) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
+		dev_warn(&pdev->dev, "did not get pins for keypad error: %li\n",
+					PTR_ERR(keypad_data->pins));
+		keypad_data->pins = NULL;
+	}
 
 	/*
 	 * Enable clocks for the keypad module so that we can read
-- 
1.7.1

