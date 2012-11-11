Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2KKNqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 08:46:16 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57174 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab2KKNqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 08:46:15 -0500
Message-ID: <1352641569.3113.2.camel@phoenix>
Subject: [PATCH RFT 2/2] pinctrl: dove: Checking valid config in
 dove_audio1_ctrl_set
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sun, 11 Nov 2012 21:46:09 +0800
In-Reply-To: <1352641495.3113.1.camel@phoenix>
References: <1352641495.3113.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the code checking valid config to dove_audio1_ctrl_set(), this ensures we
always set valid config. And then dove_audio1_ctrl_get() always returns correct
config.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/mvebu/pinctrl-dove.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index e5cc694..a393790 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -217,12 +217,6 @@ static int dove_audio1_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 	if (gcfg2 & DOVE_TWSI_OPTION3_GPIO)
 		*config |= BIT(0);
 
-	/* SSP/TWSI only if I2S1 not set*/
-	if ((*config & BIT(3)) == 0)
-		*config &= ~(BIT(2) | BIT(0));
-	/* TWSI only if SPDIFO not set*/
-	if ((*config & BIT(1)) == 0)
-		*config &= ~BIT(0);
 	return 0;
 }
 
@@ -234,6 +228,13 @@ static int dove_audio1_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 	unsigned long gmpp = readl(DOVE_MPP_GENERAL_VIRT_BASE);
 	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
 
+	/* SSP/TWSI only if I2S1 not set*/
+	if ((config & BIT(3)) == 0)
+		config &= ~(BIT(2) | BIT(0));
+	/* TWSI only if SPDIFO not set*/
+	if ((config & BIT(1)) == 0)
+		config &= ~BIT(0);
+
 	if (config & BIT(0))
 		gcfg2 |= DOVE_TWSI_OPTION3_GPIO;
 	else
-- 
1.7.9.5



