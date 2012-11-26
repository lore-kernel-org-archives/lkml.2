Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab2KZTRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:17:00 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60323 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab2KZTQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:16:58 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Axel Lin <axel.lin@ingics.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 2/2] pinctrl: mvebu: make pdma clock on dove mandatory
Date: Mon, 26 Nov 2012 20:16:39 +0100
Message-Id: <1353957399-28799-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353957399-28799-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1353921525-25163-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1353957399-28799-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the ability to pass clocks through DT, now make the pdma
clock of dove pinctrl mandatory. Otherwise, pinctrl will hang
the system when accessing some registers.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
v1->v2:
- propagate error of devm_clk_get as suggested by Baruch Siach

Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/pinctrl/mvebu/pinctrl-dove.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 40c9c3e..9cc219f 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -595,8 +595,11 @@ static int __devinit dove_pinctrl_probe(struct platform_device *pdev)
 	 * grab clk to make sure it is ticking.
 	 */
 	clk = devm_clk_get(&pdev->dev, NULL);
-	if (!IS_ERR(clk))
-		clk_prepare_enable(clk);
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "Unable to get pdma clock");
+		return PTR_RET(clk);
+	}
+	clk_prepare_enable(clk);
 
 	return mvebu_pinctrl_probe(pdev);
 }
-- 
1.7.10.4

