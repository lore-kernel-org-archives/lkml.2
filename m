Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030408Ab2B1U1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 15:27:43 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8219 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964871Ab2B1U1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 15:27:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 28 Feb 2012 12:27:37 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
CC: Linus Walleij <linus.walleij@linaro.org>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 3/6] pinctrl: Add usecount to pins for muxing
Date: Tue, 28 Feb 2012 13:27:29 -0700
Message-ID: <1330460852-23486-4-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
References: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple mapping table entries could reference the same pin, and hence
"own" it. This would be unusual now that pinctrl_get() represents a single
state for a client device, but in the future when it represents all known
states for a device, this is quite likely. Implement reference counting
for pin ownership to handle this.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
---
v2: Added kerneldoc for @usecount and @owner fields - the latter was missing
from a previous patch.

 drivers/pinctrl/core.h   |   12 +++++++++---
 drivers/pinctrl/pinmux.c |   23 +++++++++++++++++++----
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index de8df86..0bc52ec 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -82,9 +82,14 @@ struct pinctrl_setting {
  * @name: a name for the pin, e.g. the name of the pin/pad/finger on a
  *	datasheet or such
  * @dynamic_name: if the name of this pin was dynamically allocated
- * @mux_requested: whether the pin is already requested by pinmux or not
- * @mux_function: a named muxing function for the pin that will be passed to
- *	subdrivers and shown in debugfs etc
+ * @usecount: If zero, the pin is not claimed, and @owner should be NULL.
+ *	If non-zero, this pin is claimed by @owner. This field is an integer
+ *	rather than a boolean, since pinctrl_get() might process multiple
+ *	mapping table entries that refer to, and hence claim, the same group
+ *	or pin, and each of these will increment the @usecount.
+ * @owner: The name of the entity owning the pin. Typically, this is the name
+ *	of the device that called pinctrl_get(). Alternatively, it may be the
+ *	name of the GPIO passed to pinctrl_request_gpio().
  */
 struct pin_desc {
 	struct pinctrl_dev *pctldev;
@@ -92,6 +97,7 @@ struct pin_desc {
 	bool dynamic_name;
 	/* These fields only added when supporting pinmux drivers */
 #ifdef CONFIG_PINMUX
+	unsigned usecount;
 	const char *owner;
 #endif
 };
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 2318d85..2d1aaf8 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -83,11 +83,16 @@ static int pin_request(struct pinctrl_dev *pctldev,
 		goto out;
 	}
 
-	if (desc->owner && strcmp(desc->owner, owner)) {
+	if (desc->usecount && strcmp(desc->owner, owner)) {
 		dev_err(pctldev->dev,
 			"pin already requested\n");
 		goto out;
 	}
+
+	desc->usecount++;
+	if (desc->usecount > 1)
+		return 0;
+
 	desc->owner = owner;
 
 	/* Let each pin increase references to this module */
@@ -111,12 +116,18 @@ static int pin_request(struct pinctrl_dev *pctldev,
 	else
 		status = 0;
 
-	if (status)
+	if (status) {
 		dev_err(pctldev->dev, "->request on device %s failed for pin %d\n",
 		       pctldev->desc->name, pin);
+		module_put(pctldev->owner);
+	}
+
 out_free_pin:
-	if (status)
-		desc->owner = NULL;
+	if (status) {
+		desc->usecount--;
+		if (!desc->usecount)
+			desc->owner = NULL;
+	}
 out:
 	if (status)
 		dev_err(pctldev->dev, "pin-%d (%s) status %d\n",
@@ -150,6 +161,10 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 		return NULL;
 	}
 
+	desc->usecount--;
+	if (desc->usecount)
+		return NULL;
+
 	/*
 	 * If there is no kind of request function for the pin we just assume
 	 * we got it by default and proceed.
-- 
1.7.0.4

