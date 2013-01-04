Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab3ADFwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 00:52:25 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13123 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3ADFwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 00:52:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 03 Jan 2013 21:49:45 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <mturquette@linaro.org>, <swarren@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 2/2] clk: tegra30: Convert clk out to composite clk
Date: Fri, 4 Jan 2013 11:21:46 +0530
Message-ID: <1357278706-28149-2-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357278706-28149-1-git-send-email-pgaikwad@nvidia.com>
References: <1357278706-28149-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert clk out to composite clock type which removes
the mux clock.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
This patch is rebased on ccf-rework for Tegra patch series. It is just to show
how clk-composite can be used, not to be merged. If patch 1 is accepted then
I would like to merge this patch to ccf-rework series.
---
 drivers/clk/tegra/clk-tegra30.c |   51 +++++++++++++-------------------------
 drivers/clk/tegra/clk.h         |   49 +++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 33 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index 30fb743..4c16c11 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1191,43 +1191,28 @@ static void __init tegra30_audio_clk_init(void)
 	clks[spdif_2x] = clk;
 }
 
+static struct tegra_clk_out_init_data tegra_clk_out_list[] = {
+	TEGRA_CLK_OUT_INIT_DATA("clk_out_1", "extern1", "clk_out_1", clk_out1_parents, PMC_CLK_OUT_CNTRL, 6, 3, 0, 2, 0, &clk_out_lock, clk_out_1),
+	TEGRA_CLK_OUT_INIT_DATA("clk_out_2", "extern2", "clk_out_2", clk_out2_parents, PMC_CLK_OUT_CNTRL, 14, 3, 0, 10, 0, &clk_out_lock, clk_out_2),
+	TEGRA_CLK_OUT_INIT_DATA("clk_out_3", "extern3", "clk_out_3", clk_out3_parents, PMC_CLK_OUT_CNTRL, 22, 3, 0, 18, 0, &clk_out_lock, clk_out_3),
+};
+
 static void __init tegra30_pmc_clk_init(void)
 {
 	struct clk *clk;
+	int i;
 
-	/* clk_out_1 */
-	clk = clk_register_mux(NULL, "clk_out_1_mux", clk_out1_parents,
-			       ARRAY_SIZE(clk_out1_parents), 0,
-			       pmc_base + PMC_CLK_OUT_CNTRL, 6, 3, 0,
-			       &clk_out_lock);
-	clks[clk_out_1_mux] = clk;
-	clk = clk_register_gate(NULL, "clk_out_1", "clk_out_1_mux", 0,
-				pmc_base + PMC_CLK_OUT_CNTRL, 2, 0,
-				&clk_out_lock);
-	clk_register_clkdev(clk, "extern1", "clk_out_1");
-	clks[clk_out_1] = clk;
-
-	/* clk_out_2 */
-	clk = clk_register_mux(NULL, "clk_out_2_mux", clk_out2_parents,
-			       ARRAY_SIZE(clk_out1_parents), 0,
-			       pmc_base + PMC_CLK_OUT_CNTRL, 14, 3, 0,
-			       &clk_out_lock);
-	clk = clk_register_gate(NULL, "clk_out_2", "clk_out_2_mux", 0,
-				pmc_base + PMC_CLK_OUT_CNTRL, 10, 0,
-				&clk_out_lock);
-	clk_register_clkdev(clk, "extern2", "clk_out_2");
-	clks[clk_out_2] = clk;
-
-	/* clk_out_3 */
-	clk = clk_register_mux(NULL, "clk_out_3_mux", clk_out3_parents,
-			       ARRAY_SIZE(clk_out1_parents), 0,
-			       pmc_base + PMC_CLK_OUT_CNTRL, 22, 3, 0,
-			       &clk_out_lock);
-	clk = clk_register_gate(NULL, "clk_out_3", "clk_out_3_mux", 0,
-				pmc_base + PMC_CLK_OUT_CNTRL, 18, 0,
-				&clk_out_lock);
-	clk_register_clkdev(clk, "extern3", "clk_out_3");
-	clks[clk_out_3] = clk;
+	for (i = 0; i < ARRAY_SIZE(tegra_clk_out_list); i++) {
+		struct tegra_clk_out_init_data *out = &tegra_clk_out_list[i];
+
+		out->out.mux.reg = pmc_base + out->offset;
+		out->out.gate.reg = pmc_base + out->offset;
+
+		clk = clk_register_composite(NULL, out->name, out->parent_names,
+			out->num_parents, &out->out.mux.hw, &clk_mux_ops,
+			NULL, NULL, &out->out.gate.hw, &clk_gate_ops, 0);
+		clks[out->clk_id] = clk;
+	}
 
 	/* blink */
 	clk = clk_register_gate(NULL, "blink_override", "clk_32k", 0,
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index f1ed1d0..47c536d 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -437,6 +437,55 @@ struct clk *tegra_clk_super_mux(const char *name, const char **parent_names,
 				u8 width, u8 pllx_index, u8 div2_index,
 				spinlock_t *lock);
 
+struct tegra_clk_out {
+	struct clk_hw	hw;
+	struct clk_mux	mux;
+	struct clk_gate	gate;
+};
+
+#define TEGRA_CLK_OUT(_mux_shift, _mux_width, _mux_flags,	\
+			_gate_bit_idx, _gate_flags, _lock)	\
+	{							\
+		.mux = {					\
+			.shift = _mux_shift,			\
+			.width = _mux_width,			\
+			.flags = _mux_flags,			\
+			.lock = _lock,				\
+		},						\
+		.gate = {					\
+			.bit_idx = _gate_bit_idx,		\
+			.flags = _gate_flags,			\
+			.lock = _lock,				\
+		},						\
+	}
+
+struct tegra_clk_out_init_data {
+	const char *name;
+	int clk_id;
+	const char **parent_names;
+	int num_parents;
+	struct tegra_clk_out out;
+	u32 offset;
+	const char *con_id;
+	const char *dev_id;
+};
+
+#define TEGRA_CLK_OUT_INIT_DATA(_name, _con_id, _dev_id, _parent_names,	\
+			_offset, _mux_shift, _mux_width, _mux_flags,	\
+			_gate_bit_idx, _gate_flags, _lock, _clk_id)	\
+	{								\
+		.name = _name,						\
+		.clk_id = _clk_id,					\
+		.parent_names = _parent_names,				\
+		.num_parents = ARRAY_SIZE(_parent_names),		\
+		.out = TEGRA_CLK_OUT(_mux_shift, _mux_width,		\
+			 	     _mux_flags, _gate_bit_idx,		\
+				     _gate_flags, _lock),		\
+		.offset = _offset,					\
+		.con_id = _con_id,					\
+		.dev_id = _dev_id,					\
+	}
+
 /**
  * struct clk_init_tabel - clock initialization table
  * @clk_id:	clock id as mentioned in device tree bindings
-- 
1.7.4.1

