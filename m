Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab2CCIam (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 03:30:42 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:41059 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858Ab2CCIal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 03:30:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mturquette@ti.com designates 10.101.187.19 as permitted sender) smtp.mail=mturquette@ti.com
MIME-Version: 1.0
From: Mike Turquette <mturquette@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Mike Turquette <mturquette@ti.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v5 1/4] Documentation: common clk API
Date: Sat,  3 Mar 2012 00:28:58 -0800
Message-Id: <1330763341-3437-2-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide documentation for the common clk structures and APIs.  This code
can be found in drivers/clk/ and include/linux/clk*.h.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Mike Turquette <mturquette@ti.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergman <arnd.bergmann@linaro.org>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Richard Zhao <richard.zhao@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Deepak Saxena <dsaxena@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/clk.txt |  201 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 201 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/clk.txt

diff --git a/Documentation/clk.txt b/Documentation/clk.txt
new file mode 100644
index 0000000..d4db278
--- /dev/null
+++ b/Documentation/clk.txt
@@ -0,0 +1,201 @@
+		The Common Clk Framework
+		Mike Turquette <mturquette@ti.com>
+
+This document endeavours to explain the common clk framework details,
+and how to port a platform over to this framework.  It is not yet a
+detailed explanation of the clock api in include/linux/clk.h, but
+perhaps someday it will include that information.
+
+	Part 1 - introduction and interface split
+
+The common clk framework is an interface to control the clock nodes
+available on various devices today.  This may come in the form of clock
+gating, rate adjustment, muxing or other operations.  This framework is
+enabled with the CONFIG_COMMON_CLK option.
+
+The interface itself is divided into two halves, each shielded from the
+details of its counterpart.  First is the common definition of struct
+clk which attempts to unify the framework-level accounting and
+infrastructure that has traditionally been replicated across a variety of
+platforms.  This includes a top-level implementation of the clk.h api,
+defined in drivers/clk/clk.c.  The definition of struct clk_ops, whose
+operations are invoked by the clk api implementation, rounds out the
+first half the interface.
+
+The second half of the interface is comprised of the hardware-specific callbacks
+registered with struct clk_ops and the corresponding hardware-specific
+structures needed to model a particular clock.  For the remainder of this
+document any reference to a callback in struct clk_ops, such as .enable
+or .set_rate, implies the hardware-specific implementation of that code.
+Likewise references to struct clk_foo are a convenient shorthand for the
+hypothetical implementation of the clocks in the wildly popular "foo"
+hardware.
+
+Tying the two halves of this interface together is struct clk_hw, which is
+defined in struct clk_foo and pointed to within struct clk.  This allows easy
+navigaton between the two.
+
+	Part 2 - common data structures and api
+
+Below is the common struct clk definition from include/linux/clk.h, modified for brevity:
+
+	struct clk {
+		const char		*name;
+		const struct clk_ops	*ops;
+		struct clk_hw		*hw;
+		char			**parent_names;
+		struct clk		**parents;
+		struct clk		*parent;
+		struct hlist_head	children;
+		struct hlist_node	child_node;
+		...
+	};
+
+The members above make up the core of the clk tree topology.  The clk
+api itself defines several driver-facing functions which operate on
+struct clk.  That api is documented in include/linux/clk.h.
+
+Platforms and devices utilizing the common struct clk use the struct
+clk_ops pointer in struct clk to perform the hardware-specific parts of
+the operations defined in clk.h:
+
+	struct clk_ops {
+		int		(*prepare)(struct clk_hw *hw);
+		void		(*unprepare)(struct clk_hw *hw);
+		int		(*enable)(struct clk_hw *hw);
+		void		(*disable)(struct clk_hw *hw);
+		unsigned long	(*recalc_rate)(struct clk_hw *hw,
+						unsigned long parent_rate);
+		long		(*round_rate)(struct clk_hw *hw, unsigned long,
+						unsigned long *);
+		int		(*set_parent)(struct clk_hw *hw, u8 index);
+		u8		(*get_parent)(struct clk_hw *hw);
+		int		(*set_rate)(struct clk_hw *hw, unsigned long);
+		void		(*init)(struct clk_hw *hw);
+	};
+
+	Part 3 - hardware clk implementations
+
+The strength of the common struct clk comes from its .ops and .hw pointers
+which abstract the details of struct clk from the hardware-specific bits, and
+vice versa.  To illustrate consider the simple gateable clk implementation in
+drivers/clk/clk-basic.c:
+
+struct clk_gate {
+	struct clk_hw	hw;
+	void __iomem    *reg;
+	u8              bit_idx;
+	...
+};
+
+struct clk_gate contains clk_hw as well as hardware-specific knowledge about
+which register and bit controls this clk's gating.  Nothing about clock
+topology or accounting, such as enable_count or notifier_count, is needed here.
+That is all handled by the common framework code and struct clk.
+
+Let's walk through enabling this clk from driver code:
+
+	struct clk *clk;
+	clk = clk_get(NULL, "my_gateable_clk");
+
+	clk_prepare(clk);
+	clk_enable(clk);
+
+The call graph for clk_enable is very simple:
+
+clk_enable(clk);
+	clk->ops->enable(clk->hw);
+	[which resolves to...]
+		clk_gate_enable(hw);
+		[which resolves struct clk gate with to_clk_gate(hw)]
+			clk_gate_set_bit(gate);
+
+And the definition of clk_gate_set_bit:
+
+static void clk_gate_set_bit(struct clk_gate *gate)
+{
+	u32 reg;
+
+	reg = __raw_readl(gate->reg);
+	reg |= BIT(gate->bit_idx);
+	writel(reg, gate->reg);
+}
+
+Note to_clk_gate is defined as:
+
+#define to_clk_gate(_hw) container_of(_hw, struct clk_gate, clk)
+
+This pattern of abstraction is used for every clock hardware
+representation.
+
+	Part 4 - supporting your own clk hardware
+
+When implementing support for a new type of clock it only necessary to
+include the following header:
+
+#include <linux/clk-provider.h>
+
+include/linux/clk.h is included within that header and clk-private.h
+must never be included from the code which implements the operations for
+a clock.  More on that below in Part 5.
+
+To construct a clk hardware structure for your platform you must define
+the following:
+
+struct clk_foo {
+	struct clk_hw hw;
+	... hardware specific data goes here ...
+};
+
+To take advantage of your data you'll need to support valid operations
+for your clk:
+
+struct clk_ops clk_foo_ops {
+	.enable		= &clk_foo_enable;
+	.disable	= &clk_foo_disable;
+};
+
+Implement the above functions using container_of:
+
+#define to_clk_foo(_hw) container_of(_hw, struct clk_foo, hw)
+
+int clk_foo_enable(struct clk_hw *hw)
+{
+	struct clk_foo *foo;
+
+	foo = to_clk_foo(hw);
+
+	... perform magic on foo ...
+
+	return 0;
+};
+
+Finally, register your clock at run-time with a hardware-specific
+registration function.  This function simply populates struct clk_foo's
+data and then calls:
+
+clk_register(...)
+
+With the appropriate parameters.  See the basic clock types in
+drivers/clk/clk-*.c for examples.
+
+	Part 5 - static initialization of clock data
+
+For platforms with many clocks (often numbering into the hundreds) it
+may be desirable to statically initialize some clock data.  This
+presents a problem since the definition of struct clk should be hidden
+from everyone except for the clock core in drivers/clk/clk.c.
+
+To get around this problem struct clk's definition is exposed in
+include/linux/clk-private.h along with some macros for more easily
+initializing instances of the basic clock types.
+
+clk-private.h must NEVER be included by code which implements struct
+clk_ops callbacks, nor must it be included by any logic which pokes
+around inside of struct clk at run-time.  To do so is a layering
+violation.
+
+To better enforce this policy, always follow this simple rule: any
+statically initialized clock data MUST be defined in a separate file
+from the logic that implements its ops.  Basically separate the logic
+from the data and all is well.
-- 
1.7.5.4

