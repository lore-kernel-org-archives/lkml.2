Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab2L0Ost (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:48:49 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9151 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab2L0Osq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:48:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 27 Dec 2012 06:46:28 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@wwwdotorg.org>, <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH v2 09/11] clk: tegra: add dt support
Date: Thu, 27 Dec 2012 20:17:22 +0530
Message-ID: <1356619644-18565-10-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com>
References: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to initialize clock from DT.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 drivers/clk/tegra/clk.c   |   23 +++++++++++++++++++++++
 drivers/clk/tegra/clk.h   |    2 ++
 include/linux/clk/tegra.h |    1 +
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index cf023a9..314d5bd 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -67,3 +67,26 @@ void __init tegra_init_from_table(struct tegra_clk_init_table *tbl,
 			}
 	}
 }
+
+static const struct of_device_id tegra_dt_clk_match[] = {
+	{ .compatible = "nvidia,tegra20-car", .data = tegra20_clock_init },
+	{ .compatible = "nvidia,tegra30-car", .data = tegra30_clock_init },
+	{ }
+};
+
+void __init tegra_dt_init_clk(void)
+{
+	struct device_node *np;
+	const struct of_device_id *match;
+	of_tegra_clk_init_func_t clk_init_func;
+
+	np = of_find_matching_node(NULL, tegra_dt_clk_match);
+	if (!np)
+		return;
+
+	match = of_match_node(tegra_dt_clk_match, np);
+
+	clk_init_func = match->data;
+
+	clk_init_func(np);
+}
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index f1ed1d0..ca1f0e4 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -20,6 +20,8 @@
 #include <linux/clk-provider.h>
 #include <linux/clkdev.h>
 
+typedef void (*of_tegra_clk_init_func_t)(struct device_node *);
+
 /**
  * struct tegra_clk_sync_source - external clock source from codec
  *
diff --git a/include/linux/clk/tegra.h b/include/linux/clk/tegra.h
index 0977f2a..a97e241 100644
--- a/include/linux/clk/tegra.h
+++ b/include/linux/clk/tegra.h
@@ -118,6 +118,7 @@ static inline void tegra_cpu_clock_resume(void)
 }
 #endif
 
+void tegra_dt_init_clk(void);
 void tegra20_cpu_car_ops_init(void);
 void tegra30_cpu_car_ops_init(void);
 
-- 
1.7.4.1

