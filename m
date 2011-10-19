Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab1JSWTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:19:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45427 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab1JSWTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:19:39 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 3/4] pinctrl: Don't copy pin names when registering them
Date: Wed, 19 Oct 2011 16:19:27 -0600
Message-Id: <1319062768-26391-3-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319062768-26391-1-git-send-email-swarren@nvidia.com>
References: <1319062768-26391-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pin controller's names array is no longer marked __refdata. Hence, we
can avoid copying a pin's name into the descriptor when registering it.
Instead, just point at the string supplied in the pin array.

This both simplifies and speeds up pin controller initialization, but
also removes the hard-coded maximum pin name length.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/core.c |    5 ++---
 drivers/pinctrl/core.h |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 97a4eeb..15d7e5a 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -168,9 +168,8 @@ static int pinctrl_register_one_pin(struct pinctrl_dev *pctldev,
 	/* Set owner */
 	pindesc->pctldev = pctldev;
 
-	/* Copy optional basic pin info */
-	if (name)
-		strlcpy(pindesc->name, name, sizeof(pindesc->name));
+	/* Copy basic pin info */
+	pindesc->name = name;
 
 	spin_lock(&pctldev->pin_desc_tree_lock);
 	radix_tree_insert(&pctldev->pin_desc_tree, number, pindesc);
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 698221e..a493ba6 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -55,7 +55,7 @@ struct pinctrl_dev {
  */
 struct pin_desc {
 	struct pinctrl_dev *pctldev;
-	char	name[16];
+	const char *name;
 	spinlock_t lock;
 	/* These fields only added when supporting pinmux drivers */
 #ifdef CONFIG_PINMUX
-- 
1.7.0.4

