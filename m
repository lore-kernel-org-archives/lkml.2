Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab2KJNxb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 08:53:31 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:56898 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab2KJNx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 08:53:29 -0500
Message-ID: <1352555600.4945.2.camel@phoenix>
Subject: [PATCH] pinctrl: pinmux: Release all taken pins in
 pinmux_enable_setting error paths
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 10 Nov 2012 21:53:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently pinmux_enable_setting does not release all taken pins if
ops->enable() returns error. This patch ensures all taken pins are
released in any error paths.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinmux.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 0ef01ee..1a00658 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -409,11 +409,7 @@ int pinmux_enable_setting(struct pinctrl_setting const *setting)
 			dev_err(pctldev->dev,
 				"could not request pin %d on device %s\n",
 				pins[i], pinctrl_dev_get_name(pctldev));
-			/* On error release all taken pins */
-			i--; /* this pin just failed */
-			for (; i >= 0; i--)
-				pin_free(pctldev, pins[i], NULL);
-			return -ENODEV;
+			goto err_pin_request;
 		}
 	}
 
@@ -429,8 +425,26 @@ int pinmux_enable_setting(struct pinctrl_setting const *setting)
 		desc->mux_setting = &(setting->data.mux);
 	}
 
-	return ops->enable(pctldev, setting->data.mux.func,
-			   setting->data.mux.group);
+	ret = ops->enable(pctldev, setting->data.mux.func,
+			  setting->data.mux.group);
+
+	if (ret)
+		goto err_enable;
+
+	return 0;
+
+err_enable:
+	for (i = 0; i < num_pins; i++) {
+		desc = pin_desc_get(pctldev, pins[i]);
+		if (desc)
+			desc->mux_setting = NULL;
+	}
+err_pin_request:
+	/* On error release all taken pins */
+	while (--i >= 0)
+		pin_free(pctldev, pins[i], NULL);
+
+	return ret;
 }
 
 void pinmux_disable_setting(struct pinctrl_setting const *setting)
-- 
1.7.9.5



