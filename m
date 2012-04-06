Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab2DFMHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 08:07:19 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:24260 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141Ab2DFMHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 08:07:18 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>
Subject: [PATCH 1/1] pinctrl: fix pinmux_check_ops error checking
Date: Fri, 6 Apr 2012 20:18:09 +0800
Message-ID: <1333714689-22450-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Do not use get_functions_count before checking.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 drivers/pinctrl/pinmux.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 375b214..8849830 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -33,11 +33,12 @@
 int pinmux_check_ops(struct pinctrl_dev *pctldev)
 {
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
-	unsigned nfuncs = ops->get_functions_count(pctldev);
+	unsigned nfuncs;
 	unsigned selector = 0;
 
 	/* Check that we implement required operations */
-	if (!ops->get_functions_count ||
+	if (!ops ||
+	    !ops->get_functions_count ||
 	    !ops->get_function_name ||
 	    !ops->get_function_groups ||
 	    !ops->enable ||
@@ -45,11 +46,12 @@ int pinmux_check_ops(struct pinctrl_dev *pctldev)
 		return -EINVAL;
 
 	/* Check that all functions registered have names */
+	nfuncs = ops->get_functions_count(pctldev);
 	while (selector < nfuncs) {
 		const char *fname = ops->get_function_name(pctldev,
 							   selector);
 		if (!fname) {
-			pr_err("pinmux ops has no name for function%u\n",
+			dev_err(pctldev->dev, "pinmux ops has no name for function%u\n",
 				selector);
 			return -EINVAL;
 		}
-- 
1.7.0.4


