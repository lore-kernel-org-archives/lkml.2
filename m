Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab1JSWTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:19:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47554 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab1JSWTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:19:36 -0400
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
Subject: [PATCH 1/4] pinctrl: get_group_pins() const fixes
Date: Wed, 19 Oct 2011 16:19:25 -0600
Message-Id: <1319062768-26391-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_group_pins() "returns" a pointer to an array of const objects, through
a pointer parameter. Fix the prototype so what's pointed at by the returned
pointer is const, rather than the function parameter being const.

This also allows the removal of a cast in each of the two current pinmux
drivers.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/core.c          |    2 +-
 drivers/pinctrl/pinmux-sirf.c   |    6 +++---
 drivers/pinctrl/pinmux-u300.c   |    6 +++---
 drivers/pinctrl/pinmux.c        |    4 ++--
 include/linux/pinctrl/pinctrl.h |    4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 623afbd..97a4eeb 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -332,7 +332,7 @@ static int pinctrl_groups_show(struct seq_file *s, void *what)
 
 	seq_puts(s, "registered pin groups:\n");
 	while (ops->list_groups(pctldev, selector) >= 0) {
-		unsigned *pins;
+		const unsigned *pins;
 		unsigned num_pins;
 		const char *gname = ops->get_group_name(pctldev, selector);
 		int ret;
diff --git a/drivers/pinctrl/pinmux-sirf.c b/drivers/pinctrl/pinmux-sirf.c
index de5c78a..cad4f5d 100644
--- a/drivers/pinctrl/pinmux-sirf.c
+++ b/drivers/pinctrl/pinmux-sirf.c
@@ -869,12 +869,12 @@ static const char *sirfsoc_get_group_name(struct pinctrl_dev *pctldev,
 }
 
 static int sirfsoc_get_group_pins(struct pinctrl_dev *pctldev, unsigned selector,
-			       unsigned ** const pins,
-			       unsigned * const num_pins)
+			       const unsigned **pins,
+			       const unsigned *num_pins)
 {
 	if (selector >= ARRAY_SIZE(sirfsoc_pin_groups))
 		return -EINVAL;
-	*pins = (unsigned *) sirfsoc_pin_groups[selector].pins;
+	*pins = sirfsoc_pin_groups[selector].pins;
 	*num_pins = sirfsoc_pin_groups[selector].num_pins;
 	return 0;
 }
diff --git a/drivers/pinctrl/pinmux-u300.c b/drivers/pinctrl/pinmux-u300.c
index 23f082f..be6e04d 100644
--- a/drivers/pinctrl/pinmux-u300.c
+++ b/drivers/pinctrl/pinmux-u300.c
@@ -849,12 +849,12 @@ static const char *u300_get_group_name(struct pinctrl_dev *pctldev,
 }
 
 static int u300_get_group_pins(struct pinctrl_dev *pctldev, unsigned selector,
-			       unsigned ** const pins,
-			       unsigned * const num_pins)
+			       const unsigned **pins,
+			       unsigned *num_pins)
 {
 	if (selector >= ARRAY_SIZE(u300_pin_groups))
 		return -EINVAL;
-	*pins = (unsigned *) u300_pin_groups[selector].pins;
+	*pins = u300_pin_groups[selector].pins;
 	*num_pins = u300_pin_groups[selector].num_pins;
 	return 0;
 }
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 08e7b0f..4679ae6 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -326,7 +326,7 @@ static int acquire_pins(struct pinctrl_dev *pctldev,
 	const struct pinmux_ops *pmxops = pctldev->desc->pmxops;
 	const char *func = pmxops->get_function_name(pctldev,
 						     func_selector);
-	unsigned *pins;
+	const unsigned *pins;
 	unsigned num_pins;
 	int ret;
 	int i;
@@ -367,7 +367,7 @@ static void release_pins(struct pinctrl_dev *pctldev,
 			 unsigned group_selector)
 {
 	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
-	unsigned *pins;
+	const unsigned *pins;
 	unsigned num_pins;
 	int ret;
 	int i;
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 1e6f67e..be9f537 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -75,8 +75,8 @@ struct pinctrl_ops {
 				       unsigned selector);
 	int (*get_group_pins) (struct pinctrl_dev *pctldev,
 			       unsigned selector,
-			       unsigned ** const pins,
-			       unsigned * const num_pins);
+			       const unsigned **pins,
+			       unsigned *num_pins);
 	void (*pin_dbg_show) (struct pinctrl_dev *pctldev, struct seq_file *s,
 			  unsigned offset);
 };
-- 
1.7.0.4

