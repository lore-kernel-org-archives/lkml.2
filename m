Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab2ACHsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 02:48:02 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17504 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab2ACHrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 02:47:36 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-1c-4f02b29636de
From: Chanho Park <chanho61.park@samsung.com>
To: linus.walleij@linaro.org, swarren@nvidia.com, Baohua.Song@csr.com
Cc: linux-kernel@vger.kernel.org, Chanho Park <chanho61.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/2] pinctrl: correct a offset while enumerating pins
Date: Tue, 03 Jan 2012 16:47:50 +0900
Message-id: <1325576871-9397-2-git-send-email-chanho61.park@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-reply-to: <1325576871-9397-1-git-send-email-chanho61.park@samsung.com>
References: <1325576871-9397-1-git-send-email-chanho61.park@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies a offset while enumerating pins to support a
partial pin space. If we use a pin number for enumerating pins,
the pin space always starts with zero base. Indeed, we always check
the pin is in the pin space. An extreme example, there is only two pins.
One is 0. Another is 1000. We always enumerate whole offsets until 1000.
For solving this problem, we use the offset of the pin array instead
of the zero-based pin number.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/pinctrl/core.c    |   18 ++++++++++--------
 drivers/pinctrl/pinconf.c |    9 +++++----
 drivers/pinctrl/pinmux.c  |    9 +++++----
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 4a65d83..03a1dd6 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -102,14 +102,15 @@ struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, unsigned int pin)
  */
 int pin_get_from_name(struct pinctrl_dev *pctldev, const char *name)
 {
-	unsigned pin;
+	unsigned i, pin;
 
-	/* The highest pin number need to be included in the loop, thus <= */
-	for (pin = 0; pin <= pctldev->desc->maxpin; pin++) {
+	/* The pin number can be retrived from the pin controller descriptor */
+	for (i = 0; i < pctldev->desc->npins; i++) {
 		struct pin_desc *desc;
 
+		pin = pctldev->desc->pins[i].number;
 		desc = pin_desc_get(pctldev, pin);
-		/* Pin space may be sparse */
+		/* Skip if we cannot search the pin */
 		if (desc == NULL)
 			continue;
 		if (desc->name && !strcmp(name, desc->name))
@@ -378,17 +379,18 @@ static int pinctrl_pins_show(struct seq_file *s, void *what)
 {
 	struct pinctrl_dev *pctldev = s->private;
 	const struct pinctrl_ops *ops = pctldev->desc->pctlops;
-	unsigned pin;
+	unsigned i, pin;
 
 	seq_printf(s, "registered pins: %d\n", pctldev->desc->npins);
 	seq_printf(s, "max pin number: %d\n", pctldev->desc->maxpin);
 
-	/* The highest pin number need to be included in the loop, thus <= */
-	for (pin = 0; pin <= pctldev->desc->maxpin; pin++) {
+	/* The pin number can be retrived from the pin controller descriptor */
+	for (i = 0; i < pctldev->desc->npins; i++) {
 		struct pin_desc *desc;
 
+		pin = pctldev->desc->pins[i].number;
 		desc = pin_desc_get(pctldev, pin);
-		/* Pin space may be sparse */
+		/* Skip if we cannot search the pin */
 		if (desc == NULL)
 			continue;
 
diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 950b3cb..cd6647e 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -232,17 +232,18 @@ static void pinconf_dump_pin(struct pinctrl_dev *pctldev,
 static int pinconf_pins_show(struct seq_file *s, void *what)
 {
 	struct pinctrl_dev *pctldev = s->private;
-	unsigned pin;
+	unsigned i, pin;
 
 	seq_puts(s, "Pin config settings per pin\n");
 	seq_puts(s, "Format: pin (name): pinmux setting array\n");
 
-	/* The highest pin number need to be included in the loop, thus <= */
-	for (pin = 0; pin <= pctldev->desc->maxpin; pin++) {
+	/* The pin number can be retrived from the pin controller descriptor */
+	for (i = 0; pin < pctldev->desc->npins; i++) {
 		struct pin_desc *desc;
 
+		pin = pctldev->desc->pins[i].number;
 		desc = pin_desc_get(pctldev, pin);
-		/* Pin space may be sparse */
+		/* Skip if we cannot search the pin */
 		if (desc == NULL)
 			continue;
 
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index f29a9d2..59bdf90 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -1097,18 +1097,19 @@ static int pinmux_functions_show(struct seq_file *s, void *what)
 static int pinmux_pins_show(struct seq_file *s, void *what)
 {
 	struct pinctrl_dev *pctldev = s->private;
-	unsigned pin;
+	unsigned i, pin;
 
 	seq_puts(s, "Pinmux settings per pin\n");
 	seq_puts(s, "Format: pin (name): pinmuxfunction\n");
 
-	/* The highest pin number need to be included in the loop, thus <= */
-	for (pin = 0; pin <= pctldev->desc->maxpin; pin++) {
+	/* The pin number can be retrived from the pin controller descriptor */
+	for (i = 0; i < pctldev->desc->npins; i++) {
 
 		struct pin_desc *desc;
 
+		pin = pctldev->desc->pins[i].number;
 		desc = pin_desc_get(pctldev, pin);
-		/* Pin space may be sparse */
+		/* Skip if we cannot search the pin */
 		if (desc == NULL)
 			continue;
 
-- 
1.7.5.4

