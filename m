Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab2KOE4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:56:14 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:35143 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab2KOE4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:56:12 -0500
Message-ID: <1352955365.6793.6.camel@phoenix>
Subject: [PATCH 4/4] pinctrl: nomadik: Prevent NULL dereference if
 of_match_device returns NULL
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Patrice Chotard <patrice.chotard@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Thu, 15 Nov 2012 12:56:05 +0800
In-Reply-To: <1352955096.6793.1.camel@phoenix>
References: <1352955096.6793.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_match_device() may return NULL.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-nomadik.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 238060e..40bd1b3 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1863,9 +1863,14 @@ static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
 
 	if (platid)
 		version = platid->driver_data;
-	else if (np)
-		version = (unsigned int)
-			of_match_device(nmk_pinctrl_match, &pdev->dev)->data;
+	else if (np) {
+		const struct of_device_id *match;
+
+		match = of_match_device(nmk_pinctrl_match, &pdev->dev);
+		if (!match)
+			return -ENODEV;
+		version = (unsigned int) match->data;
+	}
 
 	/* Poke in other ASIC variants here */
 	if (version == PINCTRL_NMK_STN8815)
-- 
1.7.9.5



