Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab2DIKT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 06:19:26 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:25282
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201Ab2DIKTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 06:19:25 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>
Subject: [PATCH 1/1] pinctrl: add some error checking for user interfaces
Date: Mon, 9 Apr 2012 18:30:09 +0800
Message-ID: <1333967409-8168-1-git-send-email-b29396@freescale.com>
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
index 8849830..ade661d 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -323,6 +323,11 @@ int pinmux_map_to_setting(struct pinctrl_map const *map,
 	const unsigned *pins;
 	unsigned num_pins;
 
+	if (!pmxops) {
+		dev_err(pctldev->dev, "dose not support mux functron\n");
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


