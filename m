Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab2DQGuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 02:50:14 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:29653
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987Ab2DQGuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 02:50:11 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>
Subject: [PATCH v2 2/2] pinctrl: show pin name for pingroups in sysfs
Date: Tue, 17 Apr 2012 15:00:46 +0800
Message-ID: <1334646046-467-2-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1334646046-467-1-git-send-email-b29396@freescale.com>
References: <1334646046-467-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Pin name is more useful to users.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

---
Changes v1->v2:
1) add WARN_ON if no pin name found.
2) separate pin request change in another patch

After change, when cat pingroups in sysfs, it becomes:
root@freescale /sys/kernel/debug/pinctrl/20e0000.iomuxc$ cat pingroups
registered pin groups:
group: uart4grp-1
pin 219 (MX6Q_PAD_KEY_ROW0)
pin 218 (MX6Q_PAD_KEY_COL0)

group: usdhc4grp-1
pin 305 (MX6Q_PAD_SD4_CMD)
pin 306 (MX6Q_PAD_SD4_CLK)
pin 315 (MX6Q_PAD_SD4_DAT0)
pin 316 (MX6Q_PAD_SD4_DAT1)
pin 317 (MX6Q_PAD_SD4_DAT2)
pin 318 (MX6Q_PAD_SD4_DAT3)
pin 319 (MX6Q_PAD_SD4_DAT4)
pin 320 (MX6Q_PAD_SD4_DAT5)
pin 321 (MX6Q_PAD_SD4_DAT6)
pin 322 (MX6Q_PAD_SD4_DAT7)
---
 drivers/pinctrl/core.c |   32 ++++++++++++++++++++++++++++----
 drivers/pinctrl/core.h |    1 +
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 59027ab..3530e58 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -125,6 +125,25 @@ int pin_get_from_name(struct pinctrl_dev *pctldev, const char *name)
 }
 
 /**
+ * pin_get_name_from_id() - look up a pin name from a pin id
+ * @pctldev: the pin control device to lookup the pin on
+ * @name: the name of the pin to look up
+ */
+const char *pin_get_name(struct pinctrl_dev *pctldev, const unsigned pin)
+{
+	const struct pin_desc *desc;
+
+	desc = pin_desc_get(pctldev, pin);
+	if (desc == NULL) {
+		dev_err(pctldev->dev, "failed to get pin(%d) name\n",
+			pin);
+		return NULL;
+	}
+
+	return desc->name;
+}
+
+/**
  * pin_is_valid() - check if pin exists on controller
  * @pctldev: the pin control device to check the pin on
  * @pin: pin to check, use the local pin controller index number
@@ -955,6 +974,7 @@ static int pinctrl_groups_show(struct seq_file *s, void *what)
 		const unsigned *pins;
 		unsigned num_pins;
 		const char *gname = ops->get_group_name(pctldev, selector);
+		const char *pname;
 		int ret;
 		int i;
 
@@ -964,10 +984,14 @@ static int pinctrl_groups_show(struct seq_file *s, void *what)
 			seq_printf(s, "%s [ERROR GETTING PINS]\n",
 				   gname);
 		else {
-			seq_printf(s, "group: %s, pins = [ ", gname);
-			for (i = 0; i < num_pins; i++)
-				seq_printf(s, "%d ", pins[i]);
-			seq_puts(s, "]\n");
+			seq_printf(s, "group: %s\n", gname);
+			for (i = 0; i < num_pins; i++) {
+				pname = pin_get_name(pctldev, pins[i]);
+				if (WARN_ON(!pname))
+					return -EINVAL;
+				seq_printf(s, "pin %d (%s)\n", pins[i], pname);
+			}
+			seq_puts(s, "\n");
 		}
 		selector++;
 	}
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 98ae808..1f40ff6 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -148,6 +148,7 @@ struct pin_desc {
 
 struct pinctrl_dev *get_pinctrl_dev_from_devname(const char *dev_name);
 int pin_get_from_name(struct pinctrl_dev *pctldev, const char *name);
+const char *pin_get_name(struct pinctrl_dev *pctldev, const unsigned pin);
 int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
 			       const char *pin_group);
 
-- 
1.7.0.4


