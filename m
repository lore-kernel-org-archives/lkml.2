Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab2DZF7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:59:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44555 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2DZF7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:59:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6692"; a="185047637"
From: Saravana Kannan <skannan@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] clk: Use a separate struct for holding init data.
Date: Wed, 25 Apr 2012 22:58:56 -0700
Message-Id: <1335419936-10881-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a struct clk_init_data to hold all data that needs to be passed from
the platfrom specific driver to the common clock framework during clock
registration. Add a pointer to this struct inside clk_hw.

This has several advantages:
* Completely hides struct clk from many clock platform drivers and static
  clock initialization code that don't care for static initialization of
  the struct clks.
* For platforms that want to do complete static initialization, it removed
  the need to directly mess with the struct clk's fields while still
  allowing to statically allocate struct clk. This keeps the code more
  future proof even if they include clk-private.h.
* Simplifies the generic clk_register() function and allows adding optional
  fields in the future without modifying the function signature.
* Simplifies the static initialization of clocks on all platforms by
  removing the need for forward delcarations or convoluted macros.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergman <arnd.bergmann@linaro.org>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Jamie Iles <jamie@jamieiles.com>
Cc: Richard Zhao <richard.zhao@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Deepak Saxena <dsaxena@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/clk/clk-divider.c    |   14 +++--
 drivers/clk/clk-fixed-rate.c |   14 +++--
 drivers/clk/clk-gate.c       |   15 +++--
 drivers/clk/clk-mux.c        |   10 +++-
 drivers/clk/clk.c            |   91 +++++++++++++++++++------------
 include/linux/clk-private.h  |  121 +-----------------------------------------
 include/linux/clk-provider.h |   59 +++++++++++++-------
 7 files changed, 129 insertions(+), 195 deletions(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 90627e4..8ea11b4 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -167,6 +167,7 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
 {
 	struct clk_divider *div;
 	struct clk *clk;
+	struct clk_init_data init;
 
 	/* allocate the divider */
 	div = kzalloc(sizeof(struct clk_divider), GFP_KERNEL);
@@ -175,19 +176,22 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
 		return ERR_PTR(-ENOMEM);
 	}
 
+	init.name = name;
+	init.ops = &clk_divider_ops;
+	init.flags = flags;
+	init.parent_names = (parent_name ? &parent_name: NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
 	/* struct clk_divider assignments */
 	div->reg = reg;
 	div->shift = shift;
 	div->width = width;
 	div->flags = clk_divider_flags;
 	div->lock = lock;
+	div->hw.init = &init;
 
 	/* register the clock */
-	clk = clk_register(dev, name,
-			&clk_divider_ops, &div->hw,
-			(parent_name ? &parent_name: NULL),
-			(parent_name ? 1 : 0),
-			flags);
+	clk = clk_register(dev, &div->hw);
 
 	if (IS_ERR(clk))
 		kfree(div);
diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index b555a04..cbd2462 100644
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -52,6 +52,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 {
 	struct clk_fixed_rate *fixed;
 	struct clk *clk;
+	struct clk_init_data init;
 
 	/* allocate fixed-rate clock */
 	fixed = kzalloc(sizeof(struct clk_fixed_rate), GFP_KERNEL);
@@ -60,15 +61,18 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 		return ERR_PTR(-ENOMEM);
 	}
 
+	init.name = name;
+	init.ops = &clk_fixed_rate_ops;
+	init.flags = flags;
+	init.parent_names = (parent_name ? &parent_name: NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
 	/* struct clk_fixed_rate assignments */
 	fixed->fixed_rate = fixed_rate;
+	fixed->hw.init = &init;
 
 	/* register the clock */
-	clk = clk_register(dev, name,
-			&clk_fixed_rate_ops, &fixed->hw,
-			(parent_name ? &parent_name : NULL),
-			(parent_name ? 1 : 0),
-			flags);
+	clk = clk_register(dev, &fixed->hw);
 
 	if (IS_ERR(clk))
 		kfree(fixed);
diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
index 0021616..578465e 100644
--- a/drivers/clk/clk-gate.c
+++ b/drivers/clk/clk-gate.c
@@ -119,6 +119,7 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
 {
 	struct clk_gate *gate;
 	struct clk *clk;
+	struct clk_init_data init;
 
 	/* allocate the gate */
 	gate = kzalloc(sizeof(struct clk_gate), GFP_KERNEL);
@@ -127,18 +128,20 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
 		return ERR_PTR(-ENOMEM);
 	}
 
+	init.name = name;
+	init.ops = &clk_gate_ops;
+	init.flags = flags;
+	init.parent_names = (parent_name ? &parent_name: NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
 	/* struct clk_gate assignments */
 	gate->reg = reg;
 	gate->bit_idx = bit_idx;
 	gate->flags = clk_gate_flags;
 	gate->lock = lock;
+	gate->hw.init = &init;
 
-	/* register the clock */
-	clk = clk_register(dev, name,
-			&clk_gate_ops, &gate->hw,
-			(parent_name ? &parent_name : NULL),
-			(parent_name ? 1 : 0),
-			flags);
+	clk = clk_register(dev, &gate->hw);
 
 	if (IS_ERR(clk))
 		kfree(gate);
diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index 6e58f11..8e97491 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -95,6 +95,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
 {
 	struct clk_mux *mux;
 	struct clk *clk;
+	struct clk_init_data init;
 
 	/* allocate the mux */
 	mux = kzalloc(sizeof(struct clk_mux), GFP_KERNEL);
@@ -103,6 +104,12 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
 		return ERR_PTR(-ENOMEM);
 	}
 
+	init.name = name;
+	init.ops = &clk_mux_ops;
+	init.flags = flags;
+	init.parent_names = parent_names;
+	init.num_parents = num_parents;
+
 	/* struct clk_mux assignments */
 	mux->reg = reg;
 	mux->shift = shift;
@@ -110,8 +117,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
 	mux->flags = clk_mux_flags;
 	mux->lock = lock;
 
-	clk = clk_register(dev, name, &clk_mux_ops, &mux->hw,
-			parent_names, num_parents, flags);
+	clk = clk_register(dev, &mux->hw);
 
 	if (IS_ERR(clk))
 		kfree(mux);
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 2dd20c0..97a2c91 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1169,28 +1169,8 @@ EXPORT_SYMBOL_GPL(clk_set_parent);
  *
  * Initializes the lists in struct clk, queries the hardware for the
  * parent and rate and sets them both.
- *
- * Any struct clk passed into __clk_init must have the following members
- * populated:
- * 	.name
- * 	.ops
- * 	.hw
- * 	.parent_names
- * 	.num_parents
- * 	.flags
- *
- * Essentially, everything that would normally be passed into clk_register is
- * assumed to be initialized already in __clk_init.  The other members may be
- * populated, but are optional.
- *
- * __clk_init is only exposed via clk-private.h and is intended for use with
- * very large numbers of clocks that need to be statically initialized.  It is
- * a layering violation to include clk-private.h from any code which implements
- * a clock's .ops; as such any statically initialized clock data MUST be in a
- * separate C file from the logic that implements it's operations.  Returns 0
- * on success, otherwise an error code.
  */
-int __clk_init(struct device *dev, struct clk *clk)
+static int __clk_init(struct device *dev, struct clk *clk)
 {
 	int i, ret = 0;
 	struct clk *orphan;
@@ -1321,14 +1301,47 @@ out:
 }
 
 /**
+ * __clk_register - register a clock and return a cookie.
+ *
+ * Same as clk_register, except that the .clk field inside hw shall point to a
+ * preallocated (generally statically allocated) struct clk. None of the fields
+ * of the struct clk need to be initialized.
+ *
+ * The data pointed to by .init and .clk field shall NOT be marked as init
+ * data.
+ *
+ * __clk_register is only exposed via clk-private.h and is intended for use with
+ * very large numbers of clocks that need to be statically initialized.  It is
+ * a layering violation to include clk-private.h from any code which implements
+ * a clock's .ops; as such any statically initialized clock data MUST be in a
+ * separate C file from the logic that implements it's operations.  Returns 0
+ * on success, otherwise an error code.
+ */
+struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
+{
+	int ret;
+	struct clk *clk;
+
+	clk = hw->clk;
+	clk->name = hw->init->name;
+	clk->ops = hw->init->ops;
+	clk->hw = hw;
+	clk->flags = hw->init->flags;
+	clk->parent_names = hw->init->parent_names;
+	clk->num_parents = hw->init->num_parents;
+
+	ret = __clk_init(dev, clk);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return clk;
+}
+EXPORT_SYMBOL_GPL(__clk_register);
+
+/**
  * clk_register - allocate a new clock, register it and return an opaque cookie
  * @dev: device that is registering this clock
- * @name: clock name
- * @ops: operations this clock supports
  * @hw: link to hardware-specific clock data
- * @parent_names: array of string names for all possible parents
- * @num_parents: number of possible parents
- * @flags: framework-level hints and quirks
  *
  * clk_register is the primary interface for populating the clock tree with new
  * clock nodes.  It returns a pointer to the newly allocated struct clk which
@@ -1336,9 +1349,7 @@ out:
  * rest of the clock API.  In the event of an error clk_register will return an
  * error code; drivers must test for an error code after calling clk_register.
  */
-struct clk *clk_register(struct device *dev, const char *name,
-		const struct clk_ops *ops, struct clk_hw *hw,
-		const char **parent_names, u8 num_parents, unsigned long flags)
+struct clk *clk_register(struct device *dev, struct clk_hw *hw)
 {
 	int i, ret;
 	struct clk *clk;
@@ -1350,15 +1361,20 @@ struct clk *clk_register(struct device *dev, const char *name,
 		goto fail_out;
 	}
 
-	clk->name = name;
-	clk->ops = ops;
+	clk->name = kstrdup(hw->init->name, GFP_KERNEL);
+	if (!clk->name) {
+		pr_err("%s: could not allocate clk->name\n", __func__);
+		ret = -ENOMEM;
+		goto fail_name;
+	}
+	clk->ops = hw->init->ops;
 	clk->hw = hw;
-	clk->flags = flags;
-	clk->num_parents = num_parents;
+	clk->flags = hw->init->flags;
+	clk->num_parents = hw->init->num_parents;
 	hw->clk = clk;
 
 	/* allocate local copy in case parent_names is __initdata */
-	clk->parent_names = kzalloc((sizeof(char*) * num_parents),
+	clk->parent_names = kzalloc((sizeof(char*) * clk->num_parents),
 			GFP_KERNEL);
 
 	if (!clk->parent_names) {
@@ -1369,8 +1385,9 @@ struct clk *clk_register(struct device *dev, const char *name,
 
 
 	/* copy each string name in case parent_names is __initdata */
-	for (i = 0; i < num_parents; i++) {
-		clk->parent_names[i] = kstrdup(parent_names[i], GFP_KERNEL);
+	for (i = 0; i < clk->num_parents; i++) {
+		clk->parent_names[i] = kstrdup(hw->init->parent_names[i],
+						GFP_KERNEL);
 		if (!clk->parent_names[i]) {
 			pr_err("%s: could not copy parent_names\n", __func__);
 			ret = -ENOMEM;
@@ -1387,6 +1404,8 @@ fail_parent_names_copy:
 		kfree(clk->parent_names[i]);
 	kfree(clk->parent_names);
 fail_parent_names:
+	kfree(clk->name);
+fail_name:
 	kfree(clk);
 fail_out:
 	return ERR_PTR(ret);
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index eeae7a3..316bad7 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -46,126 +46,7 @@ struct clk {
 #endif
 };
 
-/*
- * DOC: Basic clock implementations common to many platforms
- *
- * Each basic clock hardware type is comprised of a structure describing the
- * clock hardware, implementations of the relevant callbacks in struct clk_ops,
- * unique flags for that hardware type, a registration function and an
- * alternative macro for static initialization
- */
-
-#define DEFINE_CLK(_name, _ops, _flags, _parent_names,		\
-		_parents)					\
-	static struct clk _name = {				\
-		.name = #_name,					\
-		.ops = &_ops,					\
-		.hw = &_name##_hw.hw,				\
-		.parent_names = _parent_names,			\
-		.num_parents = ARRAY_SIZE(_parent_names),	\
-		.parents = _parents,				\
-		.flags = _flags,				\
-	}
-
-#define DEFINE_CLK_FIXED_RATE(_name, _flags, _rate,		\
-				_fixed_rate_flags)		\
-	static struct clk _name;				\
-	static char *_name##_parent_names[] = {};		\
-	static struct clk_fixed_rate _name##_hw = {		\
-		.hw = {						\
-			.clk = &_name,				\
-		},						\
-		.fixed_rate = _rate,				\
-		.flags = _fixed_rate_flags,			\
-	};							\
-	DEFINE_CLK(_name, clk_fixed_rate_ops, _flags,		\
-			_name##_parent_names, NULL);
-
-#define DEFINE_CLK_GATE(_name, _parent_name, _parent_ptr,	\
-				_flags, _reg, _bit_idx,		\
-				_gate_flags, _lock)		\
-	static struct clk _name;				\
-	static char *_name##_parent_names[] = {			\
-		_parent_name,					\
-	};							\
-	static struct clk *_name##_parents[] = {		\
-		_parent_ptr,					\
-	};							\
-	static struct clk_gate _name##_hw = {			\
-		.hw = {						\
-			.clk = &_name,				\
-		},						\
-		.reg = _reg,					\
-		.bit_idx = _bit_idx,				\
-		.flags = _gate_flags,				\
-		.lock = _lock,					\
-	};							\
-	DEFINE_CLK(_name, clk_gate_ops, _flags,			\
-			_name##_parent_names, _name##_parents);
-
-#define DEFINE_CLK_DIVIDER(_name, _parent_name, _parent_ptr,	\
-				_flags, _reg, _shift, _width,	\
-				_divider_flags, _lock)		\
-	static struct clk _name;				\
-	static char *_name##_parent_names[] = {			\
-		_parent_name,					\
-	};							\
-	static struct clk *_name##_parents[] = {		\
-		_parent_ptr,					\
-	};							\
-	static struct clk_divider _name##_hw = {		\
-		.hw = {						\
-			.clk = &_name,				\
-		},						\
-		.reg = _reg,					\
-		.shift = _shift,				\
-		.width = _width,				\
-		.flags = _divider_flags,			\
-		.lock = _lock,					\
-	};							\
-	DEFINE_CLK(_name, clk_divider_ops, _flags,		\
-			_name##_parent_names, _name##_parents);
-
-#define DEFINE_CLK_MUX(_name, _parent_names, _parents, _flags,	\
-				_reg, _shift, _width,		\
-				_mux_flags, _lock)		\
-	static struct clk _name;				\
-	static struct clk_mux _name##_hw = {			\
-		.hw = {						\
-			.clk = &_name,				\
-		},						\
-		.reg = _reg,					\
-		.shift = _shift,				\
-		.width = _width,				\
-		.flags = _mux_flags,				\
-		.lock = _lock,					\
-	};							\
-	DEFINE_CLK(_name, clk_mux_ops, _flags, _parent_names,	\
-			_parents);
-
-/**
- * __clk_init - initialize the data structures in a struct clk
- * @dev:	device initializing this clk, placeholder for now
- * @clk:	clk being initialized
- *
- * Initializes the lists in struct clk, queries the hardware for the
- * parent and rate and sets them both.
- *
- * Any struct clk passed into __clk_init must have the following members
- * populated:
- * 	.name
- * 	.ops
- * 	.hw
- * 	.parent_names
- * 	.num_parents
- * 	.flags
- *
- * It is not necessary to call clk_register if __clk_init is used directly with
- * statically initialized clock data.
- *
- * Returns 0 on success, otherwise an error code.
- */
-int __clk_init(struct device *dev, struct clk *clk);
+struct clk *__clk_register(struct device *dev, struct clk_hw *hw);
 
 #endif /* CONFIG_COMMON_CLK */
 #endif /* CLK_PRIVATE_H */
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 8f21489..5db3412 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -15,19 +15,6 @@
 
 #ifdef CONFIG_COMMON_CLK
 
-/**
- * struct clk_hw - handle for traversing from a struct clk to its corresponding
- * hardware-specific structure.  struct clk_hw should be declared within struct
- * clk_foo and then referenced by the struct clk instance that uses struct
- * clk_foo's clk_ops
- *
- * clk: pointer to the struct clk instance that points back to this struct
- * clk_hw instance
- */
-struct clk_hw {
-	struct clk *clk;
-};
-
 /*
  * flags used across common struct clk.  these flags should only affect the
  * top-level framework.  custom flags for dealing with hardware specifics
@@ -39,6 +26,8 @@ struct clk_hw {
 #define CLK_IGNORE_UNUSED	BIT(3) /* do not gate even if unused */
 #define CLK_IS_ROOT		BIT(4) /* root clk, has no parent */
 
+struct clk_hw;
+
 /**
  * struct clk_ops -  Callback operations for hardware clocks; these are to
  * be provided by the clock implementation, and will be called by drivers
@@ -122,6 +111,41 @@ struct clk_ops {
 	void		(*init)(struct clk_hw *hw);
 };
 
+/**
+ * struct clk_init_data - holds init data that's common to all clocks and is
+ * shared between the clock provider and the common clock framework.
+ *
+ * @name: clock name
+ * @ops: operations this clock supports
+ * @parent_names: array of string names for all possible parents
+ * @num_parents: number of possible parents
+ * @flags: framework-level hints and quirks
+ */
+struct clk_init_data {
+	const char		*name;
+	const struct clk_ops	*ops;
+	const char		**parent_names;
+	u8			num_parents;
+	unsigned long		flags;
+};
+
+/**
+ * struct clk_hw - handle for traversing from a struct clk to its corresponding
+ * hardware-specific structure.  struct clk_hw should be declared within struct
+ * clk_foo and then referenced by the struct clk instance that uses struct
+ * clk_foo's clk_ops
+ *
+ * @clk: pointer to the struct clk instance that points back to this struct
+ * clk_hw instance
+ *
+ * @init: pointer to struct clk_init_data that contains the init data shared
+ * with the common clock framework.
+ */
+struct clk_hw {
+	struct clk *clk;
+	struct clk_init_data *init;
+};
+
 /*
  * DOC: Basic clock implementations common to many platforms
  *
@@ -255,12 +279,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
 /**
  * clk_register - allocate a new clock, register it and return an opaque cookie
  * @dev: device that is registering this clock
- * @name: clock name
- * @ops: operations this clock supports
  * @hw: link to hardware-specific clock data
- * @parent_names: array of string names for all possible parents
- * @num_parents: number of possible parents
- * @flags: framework-level hints and quirks
  *
  * clk_register is the primary interface for populating the clock tree with new
  * clock nodes.  It returns a pointer to the newly allocated struct clk which
@@ -268,9 +287,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
  * rest of the clock API.  In the event of an error clk_register will return an
  * error code; drivers must test for an error code after calling clk_register.
  */
-struct clk *clk_register(struct device *dev, const char *name,
-		const struct clk_ops *ops, struct clk_hw *hw,
-		const char **parent_names, u8 num_parents, unsigned long flags);
+struct clk *clk_register(struct device *dev, struct clk_hw *hw);
 
 /* helper functions */
 const char *__clk_get_name(struct clk *clk);
-- 
1.7.8.3

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
