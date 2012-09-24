Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab2IXOoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:44:07 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:50368 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778Ab2IXOoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:44:03 -0400
From: Ulf Hansson <ulf.hansson@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 2/3] clk: ux500: Support prcmu ape opp voltage clock
Date: Mon, 24 Sep 2012 16:43:18 +0200
Message-ID: <1348497799-32143-3-git-send-email-ulf.hansson@stericsson.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1348497799-32143-1-git-send-email-ulf.hansson@stericsson.com>
References: <1348497799-32143-1-git-send-email-ulf.hansson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

Some scalable prcmu clocks needs to be handled in conjuction with the
ape opp 100 voltage. A new prcmu clock type clk_prcmu_opp_volt_scalable
is implemented to handle this.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/clk/ux500/clk-prcmu.c |   55 +++++++++++++++++++++++++++++++++++++++++
 drivers/clk/ux500/clk.h       |    6 +++++
 2 files changed, 61 insertions(+)

diff --git a/drivers/clk/ux500/clk-prcmu.c b/drivers/clk/ux500/clk-prcmu.c
index 930cdfe..04577ca 100644
--- a/drivers/clk/ux500/clk-prcmu.c
+++ b/drivers/clk/ux500/clk-prcmu.c
@@ -133,6 +133,40 @@ out_error:
 		hw->init->name);
 }
 
+static int clk_prcmu_opp_volt_prepare(struct clk_hw *hw)
+{
+	int err;
+	struct clk_prcmu *clk = to_clk_prcmu(hw);
+
+	err = prcmu_request_ape_opp_100_voltage(true);
+	if (err) {
+		pr_err("clk_prcmu: %s failed to request APE OPP VOLT for %s.\n",
+			__func__, hw->init->name);
+		return err;
+	}
+
+	err = prcmu_request_clock(clk->cg_sel, true);
+	if (err)
+		prcmu_request_ape_opp_100_voltage(false);
+
+	return err;
+}
+
+static void clk_prcmu_opp_volt_unprepare(struct clk_hw *hw)
+{
+	struct clk_prcmu *clk = to_clk_prcmu(hw);
+
+	if (prcmu_request_clock(clk->cg_sel, false))
+		goto out_error;
+	if (prcmu_request_ape_opp_100_voltage(false))
+		goto out_error;
+	return;
+
+out_error:
+	pr_err("clk_prcmu: %s failed to disable %s.\n", __func__,
+		hw->init->name);
+}
+
 static struct clk_ops clk_prcmu_scalable_ops = {
 	.prepare = clk_prcmu_prepare,
 	.unprepare = clk_prcmu_unprepare,
@@ -167,6 +201,17 @@ static struct clk_ops clk_prcmu_opp_gate_ops = {
 	.recalc_rate = clk_prcmu_recalc_rate,
 };
 
+static struct clk_ops clk_prcmu_opp_volt_scalable_ops = {
+	.prepare = clk_prcmu_opp_volt_prepare,
+	.unprepare = clk_prcmu_opp_volt_unprepare,
+	.enable = clk_prcmu_enable,
+	.disable = clk_prcmu_disable,
+	.is_enabled = clk_prcmu_is_enabled,
+	.recalc_rate = clk_prcmu_recalc_rate,
+	.round_rate = clk_prcmu_round_rate,
+	.set_rate = clk_prcmu_set_rate,
+};
+
 static struct clk *clk_reg_prcmu(const char *name,
 				 const char *parent_name,
 				 u8 cg_sel,
@@ -250,3 +295,13 @@ struct clk *clk_reg_prcmu_opp_gate(const char *name,
 	return clk_reg_prcmu(name, parent_name, cg_sel, 0, flags,
 			&clk_prcmu_opp_gate_ops);
 }
+
+struct clk *clk_reg_prcmu_opp_volt_scalable(const char *name,
+					    const char *parent_name,
+					    u8 cg_sel,
+					    unsigned long rate,
+					    unsigned long flags)
+{
+	return clk_reg_prcmu(name, parent_name, cg_sel, rate, flags,
+			&clk_prcmu_opp_volt_scalable_ops);
+}
diff --git a/drivers/clk/ux500/clk.h b/drivers/clk/ux500/clk.h
index 836d7d1..f36eeed 100644
--- a/drivers/clk/ux500/clk.h
+++ b/drivers/clk/ux500/clk.h
@@ -45,4 +45,10 @@ struct clk *clk_reg_prcmu_opp_gate(const char *name,
 				   u8 cg_sel,
 				   unsigned long flags);
 
+struct clk *clk_reg_prcmu_opp_volt_scalable(const char *name,
+					    const char *parent_name,
+					    u8 cg_sel,
+					    unsigned long rate,
+					    unsigned long flags);
+
 #endif /* __UX500_CLK_H */
-- 
1.7.10

