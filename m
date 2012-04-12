Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663Ab2DLBIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:08:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40130 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933615Ab2DLBIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:08:47 -0400
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
Subject: [PATCH 13/13] clk: basic: improve parent_names & return errors
Date: Wed, 11 Apr 2012 18:02:51 -0700
Message-ID: <1334192572-12499-14-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is the basic clk version of 'clk: core: copy parent_names &
return error codes'.

The registration functions are changed to allow the core code to copy
the array of strings and allow platforms to declare those arrays as
__initdata.

This patch also converts all of the basic clk registration functions to
return error codes which better aligns them with the existing clk.h api.

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
 drivers/clk/clk-divider.c    |   46 ++++++++++++++++++++++++++---------
 drivers/clk/clk-fixed-rate.c |   54 ++++++++++++++++++++++++++---------------
 drivers/clk/clk-gate.c       |   48 +++++++++++++++++++++++++++----------
 drivers/clk/clk-mux.c        |    8 +++++-
 include/linux/clk-provider.h |    2 -
 5 files changed, 110 insertions(+), 48 deletions(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index b1c4b02..add784b 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -153,16 +153,29 @@ const struct clk_ops clk_divider_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_divider_ops);
 
+/**
+ * clk_register_divider - register a divider clock with the clock framework
+ * @dev: device registering this clock
+ * @name: name of this clock
+ * @parent_name: name of clock's parent
+ * @flags: framework-specific flags
+ * @reg: register address to adjust divider
+ * @shift: number of bits to shift the bitfield
+ * @width: width of the bitfield
+ * @clk_divider_flags: divider-specific flags for this clock
+ * @lock: shared register lock for this clock
+ */
 struct clk *clk_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_divider_flags, spinlock_t *lock)
 {
 	struct clk_divider *div;
-	struct clk *clk;
+	struct clk *clk = ERR_PTR(-ENOMEM);
+	const char *parent_names[1];
 
+	/* allocate the divider */
 	div = kzalloc(sizeof(struct clk_divider), GFP_KERNEL);
-
 	if (!div) {
 		pr_err("%s: could not allocate divider clk\n", __func__);
 		return NULL;
@@ -175,23 +188,32 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
 	div->flags = clk_divider_flags;
 	div->lock = lock;
 
+	/* allocate the temporary parent_names */
 	if (parent_name) {
-		div->parent[0] = kstrdup(parent_name, GFP_KERNEL);
-		if (!div->parent[0])
-			goto out;
+		parent_names[0] = kstrdup(parent_name, GFP_KERNEL);
+		if (!parent_names[0]) {
+			pr_err("%s: could not allocate parent_names\n",
+					__func__);
+			goto fail_parent_names;
+		}
 	}
 
+	/* register the clock */
 	clk = clk_register(dev, name,
 			&clk_divider_ops, &div->hw,
-			div->parent,
+			(parent_name ? parent_names: NULL),
 			(parent_name ? 1 : 0),
 			flags);
-	if (clk)
-		return clk;
 
-out:
-	kfree(div->parent[0]);
-	kfree(div);
+	/* free the temporary parent_names */
+	if (parent_name)
+		kfree(parent_names[0]);
+
+	if (!IS_ERR(clk))
+		goto out;
 
-	return NULL;
+fail_parent_names:
+	kfree(div);
+out:
+	return clk;
 }
diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index 027e477..ecd20ae 100644
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -38,44 +38,58 @@ const struct clk_ops clk_fixed_rate_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_fixed_rate_ops);
 
+/**
+ * clk_register_fixed_rate - register fixed-rate clock with the clock framework
+ * @dev: device that is registering this clock
+ * @name: name of this clock
+ * @parent_name: name of clock's parent
+ * @flags: framework-specific flags
+ * @fixed_rate: non-adjustable clock rate
+ */
 struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		unsigned long fixed_rate)
 {
 	struct clk_fixed_rate *fixed;
-	char **parent_names = NULL;
-	u8 len;
+	struct clk *clk = ERR_PTR(-ENOMEM);
+	const char *parent_names[1];
 
+	/* allocate fixed-rate clock */
 	fixed = kzalloc(sizeof(struct clk_fixed_rate), GFP_KERNEL);
-
 	if (!fixed) {
 		pr_err("%s: could not allocate fixed clk\n", __func__);
-		return ERR_PTR(-ENOMEM);
+		goto out;
 	}
 
 	/* struct clk_fixed_rate assignments */
 	fixed->fixed_rate = fixed_rate;
 
+	/* allocate the temporary parent_names */
 	if (parent_name) {
-		parent_names = kmalloc(sizeof(char *), GFP_KERNEL);
-
-		if (! parent_names)
-			goto out;
-
-		len = sizeof(char) * strlen(parent_name);
-
-		parent_names[0] = kmalloc(len, GFP_KERNEL);
-
-		if (!parent_names[0])
-			goto out;
-
-		strncpy(parent_names[0], parent_name, len);
+		parent_names[0] = kstrdup(parent_name, GFP_KERNEL);
+		if (!parent_names[0]) {
+			pr_err("%s: could not allocate parent_names\n",
+					__func__);
+			goto fail_parent_names;
+		}
 	}
 
-out:
-	return clk_register(dev, name,
+	/* register the clock */
+	clk = clk_register(dev, name,
 			&clk_fixed_rate_ops, &fixed->hw,
-			parent_names,
+			(parent_name ? parent_names : NULL),
 			(parent_name ? 1 : 0),
 			flags);
+
+	/* free the temporary parent_names */
+	if (parent_name)
+		kfree(parent_names[0]);
+
+	if (!IS_ERR(clk))
+		goto out;
+
+fail_parent_names:
+	kfree(fixed);
+out:
+	return clk;
 }
diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
index fe2ff9e..288fb5e 100644
--- a/drivers/clk/clk-gate.c
+++ b/drivers/clk/clk-gate.c
@@ -105,19 +105,31 @@ const struct clk_ops clk_gate_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_gate_ops);
 
+/**
+ * clk_register_gate - register a gate clock with the clock framework
+ * @dev: device that is registering this clock
+ * @name: name of this clock
+ * @parent_name: name of this clock's parent
+ * @flags: framework-specific flags for this clock
+ * @reg: register address to control gating of this clock
+ * @bit_idx: which bit in the register controls gating of this clock
+ * @clk_gate_flags: gate-specific flags for this clock
+ * @lock: shared register lock for this clock
+ */
 struct clk *clk_register_gate(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 bit_idx,
 		u8 clk_gate_flags, spinlock_t *lock)
 {
 	struct clk_gate *gate;
-	struct clk *clk;
+	struct clk *clk = ERR_PTR(-ENOMEM);
+	const char *parent_names[1];
 
+	/* allocate the gate */
 	gate = kzalloc(sizeof(struct clk_gate), GFP_KERNEL);
-
 	if (!gate) {
 		pr_err("%s: could not allocate gated clk\n", __func__);
-		return NULL;
+		goto out;
 	}
 
 	/* struct clk_gate assignments */
@@ -126,22 +138,32 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
 	gate->flags = clk_gate_flags;
 	gate->lock = lock;
 
+	/* allocate the temporary parent_names */
 	if (parent_name) {
-		gate->parent[0] = kstrdup(parent_name, GFP_KERNEL);
-		if (!gate->parent[0])
-			goto out;
+		parent_names[0] = kstrdup(parent_name, GFP_KERNEL);
+		if (!parent_names[0]) {
+			pr_err("%s: could not allocate parent_names\n",
+					__func__);
+			goto fail_parent_names;
+		}
 	}
 
+	/* register the clock */
 	clk = clk_register(dev, name,
 			&clk_gate_ops, &gate->hw,
-			gate->parent,
+			(parent_name ? parent_names : NULL),
 			(parent_name ? 1 : 0),
 			flags);
-	if (clk)
-		return clk;
-out:
-	kfree(gate->parent[0]);
-	kfree(gate);
 
-	return NULL;
+	/* free the temporary parent_names */
+	if (parent_name)
+		kfree(parent_names[0]);
+
+	if (!IS_ERR(clk))
+		goto out;
+
+fail_parent_names:
+	kfree(gate);
+out:
+	return clk;
 }
diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index bd5e598..5b237b6 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -94,6 +94,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
 		u8 clk_mux_flags, spinlock_t *lock)
 {
 	struct clk_mux *mux;
+	struct clk *clk;
 
 	mux = kzalloc(sizeof(struct clk_mux), GFP_KERNEL);
 
@@ -109,6 +110,11 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
 	mux->flags = clk_mux_flags;
 	mux->lock = lock;
 
-	return clk_register(dev, name, &clk_mux_ops, &mux->hw,
+	clk = clk_register(dev, name, &clk_mux_ops, &mux->hw,
 			parent_names, num_parents, flags);
+
+	if (IS_ERR(clk))
+		kfree(mux);
+
+	return clk;
 }
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 97f9fab..3323d24 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -176,7 +176,6 @@ struct clk_gate {
 	u8		bit_idx;
 	u8		flags;
 	spinlock_t	*lock;
-	const char	*parent[1];
 };
 
 #define CLK_GATE_SET_TO_DISABLE		BIT(0)
@@ -214,7 +213,6 @@ struct clk_divider {
 	u8		width;
 	u8		flags;
 	spinlock_t	*lock;
-	const char	*parent[1];
 };
 
 #define CLK_DIVIDER_ONE_BASED		BIT(0)
-- 
1.7.5.4

