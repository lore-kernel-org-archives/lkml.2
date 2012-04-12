Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924Ab2DLBJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:09:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47244 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933595Ab2DLBJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:09:06 -0400
From: Mike Turquette <mturquette@linaro.org>
To: <arnd.bergmann@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linaro-dev@lists.linaro.org>, <patches@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Lunn <andrew@lunn.ch>, Rajendra Nayak <rnayak@ti.com>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 04/13] clk: core: enforce clk_ops consistency
Date: Wed, 11 Apr 2012 18:02:42 -0700
Message-ID: <1334192572-12499-5-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/clk.txt has some handsome ASCII art outlining which
clk_ops are mandatory for a given clock, given the capability of the
hardware.  Enforce those mandates with sanity checks in __clk_init.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
Cc: Arnd Bergman <arnd.bergmann@linaro.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Richard Zhao <richard.zhao@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/clk/clk.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index d83a9e0..9924aec 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1202,6 +1202,20 @@ void __clk_init(struct device *dev, struct clk *clk)
 	if (__clk_lookup(clk->name))
 		goto out;
 
+	/* check that clk_ops are sane.  See Documentation/clk.txt */
+	if (clk->ops->set_rate &&
+			!(clk->ops->round_rate && clk->ops->recalc_rate)) {
+		pr_warning("%s: %s must implement .round_rate & .recalc_rate\n",
+				__func__, clk->name);
+		goto out;
+	}
+
+	if (clk->ops->set_parent && !clk->ops->get_parent) {
+		pr_warning("%s: %s must implement .get_parent & .set_parent\n",
+				__func__, clk->name);
+		goto out;
+	}
+
 	/* throw a WARN if any entries in parent_names are NULL */
 	for (i = 0; i < clk->num_parents; i++)
 		WARN(!clk->parent_names[i],
-- 
1.7.5.4

