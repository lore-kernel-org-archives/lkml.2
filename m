Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab2DJEat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 00:30:49 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:50650 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328Ab2DJEas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 00:30:48 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>
Subject: [PATCH v2 1/1] pinctrl: add some error checking for user interfaces
Date: Tue, 10 Apr 2012 12:41:34 +0800
Message-ID: <1334032894-6012-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

This patch can avoid kernel oops in case the mux or config
function is not supported by driver.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
v1-> v2: typo fix
---
 drivers/pinctrl/pinconf.c |    4 ++++
 drivers/pinctrl/pinmux.c  |   15 +++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index eb3a14f..384dcc1 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -448,8 +448,12 @@ static void pinconf_dump_pin(struct pinctrl_dev *pctldev,
 static int pinconf_pins_show(struct seq_file *s, void *what)
 {
 	struct pinctrl_dev *pctldev = s->private;
+	const struct pinconf_ops *ops = pctldev->desc->confops;
 	unsigned i, pin;
 
+	if (!ops || !ops->pin_config_get)
+		return 0;
+
 	seq_puts(s, "Pin config settings per pin\n");
 	seq_puts(s, "Format: pin (name): pinmux setting array\n");
 
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 8849830..c494c37 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -323,6 +323,11 @@ int pinmux_map_to_setting(struct pinctrl_map const *map,
 	const unsigned *pins;
 	unsigned num_pins;
 
+	if (!pmxops) {
+		dev_err(pctldev->dev, "does not support mux function\n");
+		return -EINVAL;
+	}
+
 	setting->data.mux.func =
 		pinmux_func_name_to_selector(pctldev, map->data.mux.function);
 	if (setting->data.mux.func < 0)
@@ -481,11 +486,14 @@ static int pinmux_functions_show(struct seq_file *s, void *what)
 {
 	struct pinctrl_dev *pctldev = s->private;
 	const struct pinmux_ops *pmxops = pctldev->desc->pmxops;
-	unsigned nfuncs = pmxops->get_functions_count(pctldev);
+	unsigned nfuncs;
 	unsigned func_selector = 0;
 
-	mutex_lock(&pinctrl_mutex);
+	if (!pmxops)
+		return 0;
 
+	mutex_lock(&pinctrl_mutex);
+	nfuncs = pmxops->get_functions_count(pctldev);
 	while (func_selector < nfuncs) {
 		const char *func = pmxops->get_function_name(pctldev,
 							  func_selector);
@@ -520,6 +528,9 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 	const struct pinmux_ops *pmxops = pctldev->desc->pmxops;
 	unsigned i, pin;
 
+	if (!pmxops)
+		return 0;
+
 	seq_puts(s, "Pinmux settings per pin\n");
 	seq_puts(s, "Format: pin (name): mux_owner gpio_owner hog?\n");
 
-- 
1.7.0.4


