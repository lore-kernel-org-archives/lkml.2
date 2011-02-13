Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1BMJnG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 04:43:06 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9856 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab1BMJm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 04:42:59 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/21] ARM: tegra: clock: Add shared bus clock type
Date: Sun, 13 Feb 2011 01:40:24 -0800
Message-Id: <1297590033-15035-13-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297590033-15035-1-git-send-email-ccross@android.com>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
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
 arch/arm/mach-tegra/clock.h         |    8 ++++
 arch/arm/mach-tegra/tegra2_clocks.c |   80 +++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/clock.h b/arch/arm/mach-tegra/clock.h
index dd5c029..b460f17 100644
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
index a1c86d8..10b9f63 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -1188,6 +1188,74 @@ static struct clk_ops tegra_cdev_clk_ops = {
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
+static void tegra_clk_shared_bus_update(struct clk *bus)
+{
+	struct clk *c;
+	unsigned long rate = bus->min_rate;
+
+	list_for_each_entry(c, &bus->shared_bus_list, u.shared_bus_user.node)
+		if (c->u.shared_bus_user.enabled)
+			rate = max(c->u.shared_bus_user.rate, rate);
+
+	if (rate != clk_get_rate(bus))
+		clk_set_rate(bus, rate);
+};
+
+static void tegra_clk_shared_bus_init(struct clk *c)
+{
+	c->max_rate = c->parent->max_rate;
+	c->u.shared_bus_user.rate = c->parent->max_rate;
+	c->state = OFF;
+#ifdef CONFIG_DEBUG_FS
+	c->set = 1;
+#endif
+
+	list_add_tail(&c->u.shared_bus_user.node,
+		&c->parent->shared_bus_list);
+}
+
+static int tegra_clk_shared_bus_set_rate(struct clk *c, unsigned long rate)
+{
+	c->u.shared_bus_user.rate = rate;
+	tegra_clk_shared_bus_update(c->parent);
+	return 0;
+}
+
+static long tegra_clk_shared_bus_round_rate(struct clk *c, unsigned long rate)
+{
+	return clk_round_rate(c->parent, rate);
+}
+
+static int tegra_clk_shared_bus_enable(struct clk *c)
+{
+	c->u.shared_bus_user.enabled = true;
+	tegra_clk_shared_bus_update(c->parent);
+	return 0;
+}
+
+static void tegra_clk_shared_bus_disable(struct clk *c)
+{
+	c->u.shared_bus_user.enabled = false;
+	tegra_clk_shared_bus_update(c->parent);
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
@@ -1858,6 +1926,17 @@ static struct clk_mux_sel mux_clk_32k[] = {
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
@@ -2001,6 +2080,7 @@ struct clk *tegra_ptr_clks[] = {
 static void tegra2_init_one_clock(struct clk *c)
 {
 	clk_init(c);
+	INIT_LIST_HEAD(&c->shared_bus_list);
 	if (!c->lookup.dev_id && !c->lookup.con_id)
 		c->lookup.con_id = c->name;
 	c->lookup.clk = c;
-- 
1.7.3.1

