Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab2DZIGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 04:06:16 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:43938
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671Ab2DZIGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 04:06:08 -0400
X-SpamScore: -2
X-BigFish: VS-2(zz154dMzz1202h1082kzz8275bh8275dhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <s.hauer@pengutronix.de>
Subject: [PATCH v4 1/1] pinctrl: add pinctrl_provide_dummies interface for platforms to use
Date: Thu, 26 Apr 2012 16:15:50 +0800
Message-ID: <1335428150-12629-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Add a interface pinctrl_provide_dummies for platform to indicate
whether it needs use pinctrl dummy state.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
ChangLog v3->v4:
* remove dummy gpio support in pinctrl subsystem.
  Let gpio driver decide whether it wants to use pinctrl gpio mux
  function.
ChangLog v2->v3:
* Also changed the missed pinctrl gpio APIs in v1.
ChangeLog v1->v2:
* Based on sascha's suggestion, drop using kconfig since it will hide
  pinctrl errors on all other boards.
  See: https://lkml.org/lkml/2012/4/18/282
  It seemed both Linus and Stephen agreed with this way, so i'm ok
  with it too.
* add dummy gpio support.
  pinctrl gpio in the same situation as state.
* patch name changed.
  Original is pinctrl: handle dummy state in core.
* split removing old dt dummy interface into a separate patch
---
 drivers/pinctrl/core.c          |   29 +++++++++++++++++++++++++++--
 include/linux/pinctrl/machine.h |    5 ++++-
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index ea2412a..d302fdb 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -43,6 +43,8 @@ struct pinctrl_maps {
 	unsigned num_maps;
 };
 
+static bool pinctrl_dummy_state;
+
 /* Mutex taken by all entry points */
 DEFINE_MUTEX(pinctrl_mutex);
 
@@ -61,6 +63,19 @@ static LIST_HEAD(pinctrl_maps);
 			_i_ < _maps_node_->num_maps; \
 			i++, _map_ = &_maps_node_->maps[_i_])
 
+/**
+ * pinctrl_provide_dummies() - indicate if pinctrl provides dummy state support
+ *
+ * Usually this function is called by platforms without pinctrl driver support
+ * but run with some shared drivers using pinctrl APIs.
+ * After calling this function, the pinctrl core will return successfully
+ * with creating a dummy state for the driver to keep going smoothly.
+ */
+void pinctrl_provide_dummies(void)
+{
+	pinctrl_dummy_state = true;
+}
+
 const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev)
 {
 	/* We're not allowed to register devices without name */
@@ -720,8 +735,18 @@ static struct pinctrl_state *pinctrl_lookup_state_locked(struct pinctrl *p,
 	struct pinctrl_state *state;
 
 	state = find_state(p, name);
-	if (!state)
-		return ERR_PTR(-ENODEV);
+	if (!state) {
+		if (pinctrl_dummy_state) {
+			/* create dummy state */
+			dev_dbg(p->dev, "using pinctrl dummy state (%s)\n",
+				name);
+			state = create_state(p, name);
+			if (IS_ERR(state))
+				return state;
+		} else {
+			return ERR_PTR(-ENODEV);
+		}
+	}
 
 	return state;
 }
diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index e4d1de7..ec61e11 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -154,7 +154,7 @@ struct pinctrl_map {
 
 extern int pinctrl_register_mappings(struct pinctrl_map const *map,
 				unsigned num_maps);
-
+extern void pinctrl_provide_dummies(void);
 #else
 
 static inline int pinctrl_register_mappings(struct pinctrl_map const *map,
@@ -163,5 +163,8 @@ static inline int pinctrl_register_mappings(struct pinctrl_map const *map,
 	return 0;
 }
 
+static inline void pinctrl_provide_dummies(void)
+{
+}
 #endif /* !CONFIG_PINMUX */
 #endif
-- 
1.7.0.4


