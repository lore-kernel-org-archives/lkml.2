Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab1BSW1g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 17:27:36 -0500
Received: from smtp-out.google.com ([74.125.121.67]:52479 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab1BSW0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 17:26:42 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>, sboyd@codeaurora.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/21] ARM: tegra: clock: Add shared bus clock type
Date: Sat, 19 Feb 2011 14:25:48 -0800
Message-Id: <1298154371-5641-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
To: linux-tegra@vger.kernel.org
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some clocks may have multiple downstream users that need to request a
higher clock rate.  Shared bus clocks provide a unique shared_bus_user
clock to each user.  The frequency of the bus is set to the highest
enabled shared_bus_user clock, with a minimum value set by the
shared bus.  Drivers can use clk_enable and clk_disable to enable
or disable their requirement, and clk_set_rate to set the minimum rate.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/clock.h         |    8 +++
 arch/arm/mach-tegra/tegra2_clocks.c |  116 +++++++++++++++++++++++++++++++++++
 2 files changed, 124 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/clock.h b/arch/arm/mach-tegra/clock.h
index a63dbf9..bb755c2 100644
--- a/arch/arm/mach-tegra/clock.h
+++ b/arch/arm/mach-tegra/clock.h
@@ -85,6 +85,7 @@ struct clk {
 	struct clk_ops		*ops;
 	unsigned long		rate;
 	unsigned long		max_rate;
+	unsigned long		min_rate;
 	u32			flags;
 	const char		*name;
 
@@ -98,6 +99,8 @@ struct clk {
 	u32				reg;
 	u32				reg_shift;
 
+	struct list_head		shared_bus_list;
+
 	union {
 		struct {
 			unsigned int			clk_num;
@@ -120,6 +123,11 @@ struct clk {
 			struct clk			*main;
 			struct clk			*backup;
 		} cpu;
+		struct {
+			struct list_head		node;
+			bool				enabled;
+			unsigned long			rate;
+		} shared_bus_user;
 	} u;
 
 	spinlock_t spinlock;
diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index a1c86d8..dd53af3 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -1188,6 +1188,110 @@ static struct clk_ops tegra_cdev_clk_ops = {
 	.disable		= &tegra2_cdev_clk_disable,
 };
 
+/* shared bus ops */
+/*
+ * Some clocks may have multiple downstream users that need to request a
+ * higher clock rate.  Shared bus clocks provide a unique shared_bus_user
+ * clock to each user.  The frequency of the bus is set to the highest
+ * enabled shared_bus_user clock, with a minimum value set by the
+ * shared bus.
+ */
+static int tegra_clk_shared_bus_update(struct clk *bus)
+{
+	struct clk *c;
+	unsigned long rate = bus->min_rate;
+
+	list_for_each_entry(c, &bus->shared_bus_list, u.shared_bus_user.node)
+		if (c->u.shared_bus_user.enabled)
+			rate = max(c->u.shared_bus_user.rate, rate);
+
+	if (rate == clk_get_rate_locked(bus))
+		return 0;
+
+	return clk_set_rate_locked(bus, rate);
+};
+
+static void tegra_clk_shared_bus_init(struct clk *c)
+{
+	unsigned long flags;
+
+	c->max_rate = c->parent->max_rate;
+	c->u.shared_bus_user.rate = c->parent->max_rate;
+	c->state = OFF;
+#ifdef CONFIG_DEBUG_FS
+	c->set = 1;
+#endif
+
+	spin_lock_irqsave(&c->parent->spinlock, flags);
+
+	list_add_tail(&c->u.shared_bus_user.node,
+		&c->parent->shared_bus_list);
+
+	spin_unlock_irqrestore(&c->parent->spinlock, flags);
+}
+
+static int tegra_clk_shared_bus_set_rate(struct clk *c, unsigned long rate)
+{
+	unsigned long flags;
+	int ret;
+
+	rate = clk_round_rate(c->parent, rate);
+	if (rate < 0)
+		return rate;
+
+	spin_lock_irqsave(&c->parent->spinlock, flags);
+
+	c->u.shared_bus_user.rate = rate;
+	ret = tegra_clk_shared_bus_update(c->parent);
+
+	spin_unlock_irqrestore(&c->parent->spinlock, flags);
+
+	return ret;
+}
+
+static long tegra_clk_shared_bus_round_rate(struct clk *c, unsigned long rate)
+{
+	return clk_round_rate(c->parent, rate);
+}
+
+static int tegra_clk_shared_bus_enable(struct clk *c)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&c->parent->spinlock, flags);
+
+	c->u.shared_bus_user.enabled = true;
+	ret = tegra_clk_shared_bus_update(c->parent);
+
+	spin_unlock_irqrestore(&c->parent->spinlock, flags);
+
+	return ret;
+}
+
+static void tegra_clk_shared_bus_disable(struct clk *c)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&c->parent->spinlock, flags);
+
+	c->u.shared_bus_user.enabled = false;
+	ret = tegra_clk_shared_bus_update(c->parent);
+	WARN_ON_ONCE(ret);
+
+	spin_unlock_irqrestore(&c->parent->spinlock, flags);
+}
+
+static struct clk_ops tegra_clk_shared_bus_ops = {
+	.init = tegra_clk_shared_bus_init,
+	.enable = tegra_clk_shared_bus_enable,
+	.disable = tegra_clk_shared_bus_disable,
+	.set_rate = tegra_clk_shared_bus_set_rate,
+	.round_rate = tegra_clk_shared_bus_round_rate,
+};
+
+
 /* Clock definitions */
 static struct clk tegra_clk_32k = {
 	.name = "clk_32k",
@@ -1858,6 +1962,17 @@ static struct clk_mux_sel mux_clk_32k[] = {
 		},					\
 	}
 
+#define SHARED_CLK(_name, _dev, _con, _parent)		\
+	{						\
+		.name      = _name,			\
+		.lookup    = {				\
+			.dev_id    = _dev,		\
+			.con_id    = _con,		\
+		},					\
+		.ops       = &tegra_clk_shared_bus_ops,	\
+		.parent = _parent,			\
+	}
+
 struct clk tegra_list_clks[] = {
 	PERIPH_CLK("rtc",	"rtc-tegra",		NULL,	4,	0,	32768,     mux_clk_32k,			PERIPH_NO_RESET),
 	PERIPH_CLK("timer",	"timer",		NULL,	5,	0,	26000000,  mux_clk_m,			0),
@@ -2001,6 +2116,7 @@ struct clk *tegra_ptr_clks[] = {
 static void tegra2_init_one_clock(struct clk *c)
 {
 	clk_init(c);
+	INIT_LIST_HEAD(&c->shared_bus_list);
 	if (!c->lookup.dev_id && !c->lookup.con_id)
 		c->lookup.con_id = c->name;
 	c->lookup.clk = c;
-- 
1.7.3.1

