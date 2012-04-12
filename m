Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933956Ab2DLBJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:09:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47237 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933252Ab2DLBI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:08:56 -0400
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
Subject: [PATCH 01/13] clk: core: correct clk_set_rate kerneldoc
Date: Wed, 11 Apr 2012 18:02:39 -0700
Message-ID: <1334192572-12499-2-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove old and misleading documentation from the previous clk_set_rate
implementaion.

Reported-by: Shawn Guo <shawn.guo@linaro.org>
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
 drivers/clk/clk.c |   41 +++++++++++------------------------------
 1 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 9cf6f59..3ed36d3 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -859,38 +859,19 @@ static void clk_change_rate(struct clk *clk)
  * @clk: the clk whose rate is being changed
  * @rate: the new rate for clk
  *
- * In the simplest case clk_set_rate will only change the rate of clk.
+ * In the simplest case clk_set_rate will only adjust the rate of clk.
  *
- * If clk has the CLK_SET_RATE_GATE flag set and it is enabled this call
- * will fail; only when the clk is disabled will it be able to change
- * its rate.
+ * Setting the CLK_SET_RATE_PARENT flag allows the rate change operation to
+ * propagate up to clk's parent; whether or not this happens depends on the
+ * outcome of clk's .round_rate implementation.  If *parent_rate is unchanged
+ * after calling .round_rate then upstream parent propagation is ignored.  If
+ * *parent_rate comes back with a new rate for clk's parent then we propagate
+ * up to clk's parent and set it's rate.  Upward propagation will continue
+ * until either a clk does not support the CLK_SET_RATE_PARENT flag or
+ * .round_rate stops requesting changes to clk's parent_rate.
  *
- * Setting the CLK_SET_RATE_PARENT flag allows clk_set_rate to
- * recursively propagate up to clk's parent; whether or not this happens
- * depends on the outcome of clk's .round_rate implementation.  If
- * *parent_rate is 0 after calling .round_rate then upstream parent
- * propagation is ignored.  If *parent_rate comes back with a new rate
- * for clk's parent then we propagate up to clk's parent and set it's
- * rate.  Upward propagation will continue until either a clk does not
- * support the CLK_SET_RATE_PARENT flag or .round_rate stops requesting
- * changes to clk's parent_rate.  If there is a failure during upstream
- * propagation then clk_set_rate will unwind and restore each clk's rate
- * that had been successfully changed.  Afterwards a rate change abort
- * notification will be propagated downstream, starting from the clk
- * that failed.
- *
- * At the end of all of the rate setting, clk_set_rate internally calls
- * __clk_recalc_rates and propagates the rate changes downstream,
- * starting from the highest clk whose rate was changed.  This has the
- * added benefit of propagating post-rate change notifiers.
- *
- * Note that while post-rate change and rate change abort notifications
- * are guaranteed to be sent to a clk only once per call to
- * clk_set_rate, pre-change notifications will be sent for every clk
- * whose rate is changed.  Stacking pre-change notifications is noisy
- * for the drivers subscribed to them, but this allows drivers to react
- * to intermediate clk rate changes up until the point where the final
- * rate is achieved at the end of upstream propagation.
+ * Rate changes are accomplished via tree traversal that also recalculates the
+ * rates for the clocks and fires off POST_RATE_CHANGE notifiers.
  *
  * Returns 0 on success, -EERROR otherwise.
  */
-- 
1.7.5.4

