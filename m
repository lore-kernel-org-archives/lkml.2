Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab2HOXoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 19:44:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43891 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab2HOXoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 19:44:18 -0400
From: Mike Turquette <mturquette@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <shawn.guo@linaro.org>, <linus.walleij@linaro.org>,
        <rob.herring@calxeda.com>, <pdeschrijver@nvidia.com>,
        <pgaikwad@nvidia.com>, <viresh.kumar@linaro.org>, <rnayak@ti.com>,
        <paul@pwsan.com>, <broonie@opensource.wolfsonmicro.com>,
        <ccross@android.com>, <linux-arm-kernel@lists.infradead.org>,
        <myungjoo.ham@samsung.com>, <rajagopal.venkat@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v2 4/4] [RFC] omap3+: clk: dpll: call clk_prepare directly
Date: Wed, 15 Aug 2012 16:43:34 -0700
Message-ID: <1345074214-17531-5-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345074214-17531-1-git-send-email-mturquette@linaro.org>
References: <1345074214-17531-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the commit titled "clk: new locking scheme for reentrancy" it became
possible for nested calls to the clock api.  The OMAP3+ DPLL .set_rate
callback has been using the __clk_prepare and __clk_unprepare calls as a
way around this limitation, but these calls are no longer needed with
the aforementioned patch.  Convert the .set_rate callback to use
clk_prepare and clk_unprepare directly.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 arch/arm/mach-omap2/dpll3xxx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/dpll3xxx.c b/arch/arm/mach-omap2/dpll3xxx.c
index ee18d00..1cc3ec8 100644
--- a/arch/arm/mach-omap2/dpll3xxx.c
+++ b/arch/arm/mach-omap2/dpll3xxx.c
@@ -436,9 +436,9 @@ int omap3_noncore_dpll_set_rate(struct clk_hw *hw, unsigned long rate,
 	if (!dd)
 		return -EINVAL;
 
-	__clk_prepare(dd->clk_bypass);
+	clk_prepare(dd->clk_bypass);
 	clk_enable(dd->clk_bypass);
-	__clk_prepare(dd->clk_ref);
+	clk_prepare(dd->clk_ref);
 	clk_enable(dd->clk_ref);
 
 	if (__clk_get_rate(dd->clk_bypass) == rate &&
@@ -483,9 +483,9 @@ int omap3_noncore_dpll_set_rate(struct clk_hw *hw, unsigned long rate,
 		__clk_reparent(hw->clk, new_parent);
 
 	clk_disable(dd->clk_ref);
-	__clk_unprepare(dd->clk_ref);
+	clk_unprepare(dd->clk_ref);
 	clk_disable(dd->clk_bypass);
-	__clk_unprepare(dd->clk_bypass);
+	clk_unprepare(dd->clk_bypass);
 
 	return 0;
 }
-- 
1.7.9.5

