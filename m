Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab1KVBnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:43:50 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:47623 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755079Ab1KVBnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:43:47 -0500
From: Mike Turquette <mturquette@ti.com>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        aul@pwsan.com, grant.likely@secretlab.ca, sboyd@quicinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, mturquette@ti.com,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v3 2/5] Documentation: common clk API
Date: Mon, 21 Nov 2011 17:40:44 -0800
Message-Id: <1321926047-14211-3-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide documentation for the common clk structures and APIs.  This code
can be found in drivers/clk/ and include/linux/clk.h.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 Documentation/clk.txt |  312 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 312 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/clk.txt

diff --git a/Documentation/clk.txt b/Documentation/clk.txt
new file mode 100644
index 0000000..ef4333d
--- /dev/null
+++ b/Documentation/clk.txt
@@ -0,0 +1,312 @@
+		The Common Clk Framework
+		Mike Turquette <mturquette@ti.com>
+
+	Part 1 - common data structures and API
+
+The common clk framework is a combination of a common definition of
+struct clk which can be used across most platforms as well as a set of
+driver-facing APIs which operate on those clks.  Platforms can enable it
+by selecting CONFIG_GENERIC_CLK.
+
+Below is the common struct clk definition from include/linux.clk.h.  It
+is modified slightly for brevity:
+
+struct clk {
+	const char              *name;
+	const struct clk_hw_ops *ops;
+	struct clk              *parent;
+	unsigned long           rate;
+	unsigned long           flags;
+	unsigned int            enable_count;
+	unsigned int            prepare_count;
+	struct hlist_head       children;
+	struct hlist_node       child_node;
+};
+
+The .name, .parent and .children members make up the core of the clk
+tree topology which can be visualized by enabling
+CONFIG_COMMON_CLK_SYSFS.  The ops member points to an instance of struct
+clk_hw_ops:
+
+	struct clk_hw_ops {
+		int             (*prepare)(struct clk *clk);
+		void            (*unprepare)(struct clk *clk);
+		int             (*enable)(struct clk *clk);
+		void            (*disable)(struct clk *clk);
+		unsigned long   (*recalc_rate)(struct clk *clk);
+		long            (*round_rate)(struct clk *clk, unsigned long,
+				unsigned long *);
+		int             (*set_parent)(struct clk *clk, struct clk *);
+		struct clk *    (*get_parent)(struct clk *clk);
+		int             (*set_rate)(struct clk *clk, unsigned long);
+	};
+
+These callbacks correspond to the clk API that has existed in
+include/linux/clk.h for a while.  Below is a quick summary of the
+operations in that header, as implemented in drivers/clk/clk.c.  These
+comprise the driver-facing API:
+
+clk_prepare - does everything needed to get a clock ready to generate a
+proper signal which may include ungating the clk and actually generating
+that signal.  clk_prepare MUST be called before clk_enable.  This call
+holds the global prepare_mutex, which also prevents clk rates and
+topology from changing while held.  This API is meant to be the "slow"
+part of a clk enable sequence, if applicable.  This function must not be
+called in an interrupt context.
+
+clk_unprepare - the opposite of clk_prepare: does everything needed to
+make a clk no longer ready to generate a proper signal, which may
+include gating an active clk.  clk_disable must be called before
+clk_unprepare.  All of the same rules for clk_prepare apply.
+
+clk_enable - ungate a clock and immediately start generating a valid clk
+signal.  This is the "fast" part of a clk enable sequence, and maybe the
+only functional part of that sequence.  Regardless clk_prepare must be
+called BEFORE clk_enable.  The enable_spinlock is held across this call,
+which means that clk_enable must not sleep.
+
+clk_disable - the opposite of clk_enable: gates a clock immediately.
+clk_disable must be called before calling clk_unprepare.  All of the
+same rules for clk_enable apply.
+
+clk_get_rate - Returns the cached rate for the clk.  Does NOT query the
+hardware state.  No lock is held.
+
+clk_get_parent - Returns the cached parent for the clk.  Does NOT query
+the hardware state.  No lock is held.
+
+clk_set_rate - Attempts to change the clk rate to the one specified.
+Depending on a variety of common flags it may fail to maintain system
+stability or result in a variety of other clk rates changing.  Holds the
+same prepare_mutex held by clk_prepare/clk_unprepare and clk_set_parent.
+
+clk_set_parent - Switches the input source for a clk.  This only applies
+to mux clks with multiple parents.  Holds the same prepare_mutex held by
+clk_prepare/clk_unprepare and clk_set_rate.
+
+	Part 2 - hardware clk implementations
+
+The strength of the common struct clk comes from its .ops pointer and
+the ability for platform and driver code to wrap the struct clk instance
+with hardware-specific data which the operations in the .ops pointer
+have knowledge of.  To illustrate consider the simple gateable clk
+implementation in drivers/clk/clk-basic.c:
+
+struct clk_hw_gate {
+	struct clk      clk;
+	struct clk      *fixed_parent;
+	void __iomem    *reg;
+	u8              bit_idx;
+};
+
+struct clk_hw_gate contains the clk as well as hardware-specific
+knowledge about which register and bit controls this clk's gating.  The
+fixed-parent member is also there as a way to initialize the topology.
+
+Let's walk through enabling this clk from driver code:
+
+	struct clk *clk;
+	clk = clk_get(NULL, "my_gateable_clk");
+
+	clk_prepare(clk);
+	clk_enable(clk);
+
+Note that clk_prepare MUST be called before clk_enable even if
+clk_prepare does nothing (which in this case is true).
+
+The call graph for clk_enable is very simple:
+
+clk_enable(clk);
+	clk->enable(clk);
+			clk_hw_gate_enable_set(clk);
+				clk_hw_gate_set_bit(clk);
+
+And the definition of clk_hw_gate_set_bit:
+
+static void clk_hw_gate_set_bit(struct clk *clk)
+{
+	struct clk_hw_gate *gate = to_clk_hw_gate(clk);
+	u32 reg;
+
+	reg = __raw_readl(gate->reg);
+	reg |= BIT(gate->bit_idx);
+	__raw_writel(reg, gate->reg);
+}
+
+Note that in the final call to clk_hw_gate_set_bit there is use of
+to_clk_hw_gate, which is defined as:
+
+#define to_clk_hw_gate(ck) container_of(ck, struct clk_hw_gate, clk)
+
+This simple abstration is what allows the common clk framework to scale
+across many platforms.  The struct clk definition remains the same while
+the hardware operations in the .ops pointer know the details of the clk
+hardware.  A little pointer arithmetic to get to the data is all that
+the ops need.
+
+	Part 3 - Supporting your own clk hardware
+
+To construct a clk hardware structure for your platform you simply need
+to define the following:
+
+struct clk_hw_your_clk {
+	struct clk;
+	unsigned long some_data;
+	struct your_struct *some_more_data;
+};
+
+To take advantage of your data you'll need to support valid operations
+for your clk:
+
+struct clk_hw_ops clk_hw_ops_your_clk {
+	.enable		= &clk_hw_your_clk_enable;
+	.disable	= &clk_hw_your_clk_disable;
+};
+
+Implement the above functions using container_of:
+
+int clk_hw_your_clk_enable(struct clk *clk)
+{
+	struct clk_hw_your_clk *yclk;
+
+	yclk = container_of(clk, struct clk_hw_your_clk, clk);
+
+	magic(yclk);
+};
+
+If you are statically allocating all of your clk_hw_your_clk instances
+then you will still need to initialize some stuff in struct clk with the
+clk_init function from include/linux/clk.h:
+
+clk_init(&yclk->clk);
+
+If you are dynamically creating clks or using device tree then you might
+want a hardware-specific register function:
+
+int clk_hw_your_clk_register(const char *name, unsigned long flags,
+		unsigned long some_data,
+		struct your_struct *some_more_data)
+{
+	struct clk_hw_your_clk *yclk;
+
+	yclk = kmalloc(sizeof(struct clk_hw_your_clk), GFP_KERNEL);
+
+	yclk->some_data = some_data;
+	yclk->some_more_data = some_more_data;
+
+	yclk->clk.name = name;
+	yclk->clk.flags = flags;
+
+	clk_init(&yclk->clk);
+
+	return 0;
+}
+
+	Part 4 - clk_set_rate
+
+clk_set_rate deserves a special mention because it is more complex than
+the other operations.  There are three key concepts to the common
+clk_set_rate implementation:
+
+1) recursively traversing up the clk tree and changing clk rates, one
+parent at a time, if each clk allows it
+2) failing to change rate if the clk is enabled and must only change
+rates while disabled
+2) using clk rate change notifiers to allow devices to handle dynamic
+rate changes for clks which do support changing rates while enabled
+
+For the simple, non-recursive case the call graph looks like:
+
+clk_set_rate(clk, rate);
+	__clk_set_rate(clk, rate);
+		clk->round_rate(clk, rate *parent_rate);
+		clk->set_rate(clk, rate);
+
+You might be wondering what that third paramater in .round_rate is.  If
+a clk supports the CLK_PARENT_SET_RATE flag then that enables it's
+hardware-specific .round_rate function to provide a new rate that the
+parent should transition to.  For example, imagine a rate-adjustable clk
+A that is the parent of clk B, which has a fixed divider of 2.
+
+	clk A	(rate = 10MHz) (possible rates = 5MHz, 10MHz, 20MHz)
+	  |
+	  |
+	  |
+	clk B	(rate = 5MHz) (fixed divider of 2)
+
+In the above scenario clk B will always have half the rate of clk A.  If
+clk B is to generate a 10MHz clk then clk A must generate 20MHz in turn.
+The driver writer could hack in knowledge of clk A, but in reality clk B
+drives the devices operation and the driver shouldn't know the details
+of the clk tree topology.  In this case it would be nice for clk B to
+propagate it's request up to clk A.
+
+Here the call graph for our above example:
+
+clk_set_rate(clk, rate);
+	__clk_set_rate(clk, rate);
+		clk->round_rate(clk, rate *parent_rate);
+		clk->set_rate(clk, rate);
+		__clk_set_rate(clk->parent, parent_rate);
+			clk->round_rate(clk, rate *parent_rate);
+			clk->set_rate(clk, rate);
+
+Note that the burden of figuring out whether to recurse upwards falls on
+the hardware-specific .round_rate function.  The common clk framework
+does not have the context to make such complicated decisions in a
+generic way for all platforms.
+
+Another caveat is that child clks might run at weird intermediate
+frequencies during a complex upwards propagation, as illustrated below:
+
+	clk A  (pll 100MHz - 300MHz)	(currently locked at 200MHz)
+	  |
+	  |
+	  |
+	clk B  (divide by 1 or 2)	(currently divide by 2, 100MHz)
+	  |
+	  |
+	  |
+	clk C  (divide by 1 or 2)	(currently divide by 1, 100MHz)
+
+The call graph below, with some bracketed annotations, describes how
+this might work with some clever .round_rate callbacks when trying to
+set clk C to run at 26MHz:
+
+clk_set_rate(C, 26MHz);
+	__clk_set_rate(C, 26MHz);
+		clk->round_rate(C, 26MHz, *parent_rate);
+		[ round_rate returns 50MHz ]
+		[ &parent_rate is 52MHz ]
+		clk->set_rate(C, 50Mhz);
+		[ clk C is set to 50MHz, which sets divider to 2 ]
+		__clk_set_rate(clk->parent, parent_rate);
+			clk->round_rate(B, 52MHz, *parent_rate);
+			[ round_rate returns 100MHz ]
+			[ &parent_rate is 104MHz ]
+			clk->set_rate(B, 100MHz);
+			[ clk B stays at 100MHz, divider stays at 2 ]
+			__clk_set_rate(clk->parent, parent_rate);
+				[ round_rate returns 104MHz ]
+				[ &parent_rate is ignored ]
+				clk->set_rate(A, 104MHz);
+				[ clk A is set to 104MHz]
+
+The end result is that clk C runs at 26MHz.  Each .set_rate callback
+actually sets the intermediate rate, which nicely reflects reality.
+Once clk rate change notifiers are supported then it is expected that
+PRECHANGE notifiers will "stack" in situations with recursive
+clk_set_rate calls.
+
+Thus a driver X which subcribes to rate-change notifers for clk C would
+have received 2 PRECHANGE notifiers in the above example.  The first
+would have notified the driver that clk C was changing from 100MHz to
+50MHz.  The second PRECHANGE notifier would have told driver X that clk
+C had changed from 50MHz to 26MHz.  There would not be a PRECHANGE
+notifier corresponding to __clk_set_rate(B, 50MHz) since B is already
+running at that rate and the notification would be unnecessary.
+
+clk_set_rate is written in such a way that POSTCHANGE notifiers and
+ABORTCHANGE notifiers will only be sent once.  Each will start
+propagation from the highest point in the tree which was affected by the
+operation.
-- 
1.7.4.1

