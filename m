Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab2CMMFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:05:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44212 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab2CMMFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:05:16 -0400
Date: Tue, 13 Mar 2012 13:05:08 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
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
Subject: Re: [PATCH v6 2/3] clk: introduce the common clock framework
Message-ID: <20120313120507.GS3852@pengutronix.de>
References: <1331366064-1273-1-git-send-email-mturquette@linaro.org>
 <1331366064-1273-3-git-send-email-mturquette@linaro.org>
 <20120311113414.GM3852@pengutronix.de>
 <CAJOA=zMdkLB-DCPOk=kz5mn6BK6A_swocyCHJHeGE6H7FxBbmQ@mail.gmail.com>
 <20120312115117.GN3852@pengutronix.de>
 <CAJOA=zPx0ARsoO4ueSTMe_z2Gs4xG4P2qn1=-vHFf7_k=+K6hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJOA=zPx0ARsoO4ueSTMe_z2Gs4xG4P2qn1=-vHFf7_k=+K6hQ@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:46:40 up 121 days, 18:33, 69 users,  load average: 0.07, 0.49,
 0.71
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Mon, Mar 12, 2012 at 08:16:36PM -0700, Turquette, Mike wrote:
> On Mon, Mar 12, 2012 at 4:51 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Sun, Mar 11, 2012 at 02:24:46PM -0700, Turquette, Mike wrote:
> >> On Sun, Mar 11, 2012 at 4:34 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >> > Hi Mike,
> >> >
> >> > I was about to give my tested-by when I decided to test the set_rate
> >> > function. Unfortunately this is broken for several reasons. I'll try
> >> > to come up with a fixup series later the day.
> >>
> >> I haven't tested clk_set_rate since V4, but I also haven't changed the
> >> code appreciably.  I'll retest on my end also.
> >>
> >> > On Fri, Mar 09, 2012 at 11:54:23PM -0800, Mike Turquette wrote:
> >> >> +     /* find the new rate and see if parent rate should change too */
> >> >> +     WARN_ON(!clk->ops->round_rate);
> >> >> +
> >> >> +     new_rate = clk->ops->round_rate(clk->hw, rate, &parent_new_rate);
> >> >
> >> > You don't need a WARN_ON when you derefence clk->ops->round_rate anyway.
> >>
> >> Agreed that the WARN_ON should not be there.
> >>
> >> The v6 Documentation/clk.txt states that .round_rate is mandatory for
> >> clocks that can adjust their rate, but I need to clarify this a bit
> >> more.  Ideally we want to be able to call clk_set_rate on any clock
> >> and get a changed rate (if possible) by either adjusting that clocks
> >> rate direction (e.g. a PLL or an adjustable divider) or by propagating
> >> __clk_set_rate up the parents (assuming of course that
> >> CLK_SET_RATE_PARENT flag is set appropriately).
> >>
> >> > Also, even when the current clock does not have a set_rate function it
> >> > can still change its rate when the CLK_SET_RATE_PARENT is set.
> >>
> >> Correct.  I'll clean this up and make the documentation a bit more
> >> verbose on when .set_rate/.round_rate/.recalc_rate are mandatory.
> >>
> >> >
> >> >> +
> >> >> +     /* NOTE: pre-rate change notifications will stack */
> >> >> +     if (clk->notifier_count)
> >> >> +             ret = __clk_notify(clk, PRE_RATE_CHANGE, clk->rate, new_rate);
> >> >> +
> >> >> +     if (ret == NOTIFY_BAD)
> >> >> +             return clk;
> >> >> +
> >> >> +     /* speculate rate changes down the tree */
> >> >> +     hlist_for_each_entry(child, tmp, &clk->children, child_node) {
> >> >> +             ret = __clk_speculate_rates(child, new_rate);
> >> >> +             if (ret == NOTIFY_BAD)
> >> >> +                     return clk;
> >> >> +     }
> >> >> +
> >> >> +     /* change the rate of this clk */
> >> >> +     if (clk->ops->set_rate)
> >> >> +             ret = clk->ops->set_rate(clk->hw, new_rate);
> >> >
> >> > I don't know the reason why you change the child clock before the parent
> >> > clock, but it cannot work since this clock will change its rate based on
> >> > the old parent rate and not the new one.
> >>
> >> This depends on the .round_rate implementation, which I admit to
> >> having lost some sleep over.  A clever .round_rate will request the
> >> "intermediate" rate for a clock when propagating a request to change
> >> the parent rate later on.  Take for instance the following:
> >>
> >> pll @ 200MHz (locked)
> >>     |
> >> parent @ 100MHz (can divide by 1 or 2; currently divider is 2)
> >>     |
> >> child @ 25MHz (can divide by 2 or 4; currently divider is 4)
> >>
> >> If we want child to run at 100MHz then the desirable configuration
> >> would be to have parent divide-by-1 and child divide-by-2.  When we
> >> call,
> >>
> >> clk_set_rate(child, 100MHz);
> >>
> >> Its .round_rate should return 50MHz, and &parent_new_rate should be
> >> 200MHz.  So 50MHz is an "intermediate" rate, but it gets us the
> >> divider we want.  And in fact 50MHz reflects reality because that will
> >> be the rate of child until the parent propagation completes and we can
> >> adjust parent's dividers.  (this is one reason why I prefer for
> >> pre-rate change notifiers to stack on top of each other).
> >>
> >> So now that &parent_new_rate is > 0, __clk_set_rate will propagate the
> >> request up and parent's .round_rate will simply return 200MHz and
> >> leave it's own &parent_new_rate at 0.  This will change from
> >> divide-by-2 to divide-by-1 and from this highest point in the tree we
> >> will propagate post-rate change notifiers downstream, as part of the
> >> recalc_rate tree walk.
> >>
> >> I have tested this with OMAP4's CPUfreq driver and I think, while
> >> complicated, it is a sound way to approach the problem.  Maybe the API
> >> can be cleaned up, if you have any suggestions.
> >
> > I cannot see all implications this way will have. All this rate
> > propagation is more complex than I thought it would be.
> 
> Hi Sascha,
> 
> Yes it is very complicated.  The solution I have now (recursive
> __clk_set_rate, clever .round_rate which requests parent rate) was not
> something I arrived at immediately.
> 
> I decided to validate the v6 patches more thoroughly today, based on
> your claim that clk_set_rate is broken and here is what I found:
> 
> 1) clk_set_rate works.  I pulled in the latest OMAP4 CPUfreq code into
> my common clk branch and it Just Worked.  This is a dumb
> implementation involving no upwards parent propagation, and the clock
> changing is of type struct clk_hw_omap (relocking a PLL)
> 
> 2) while I was at it I verified the rate change notifiers +
> clk_set_parent, which also work (I had not touched these since v4 and
> wanted to make sure nothing was broken)
> 
> Here is where things get interesting.  I tried the same parent rate
> propagation via CPUfreq that I had done previously in the v4 series
> (http://article.gmane.org/gmane.linux.ports.arm.omap/68225), but this
> time it didn't work.  The difference is that back in v4 all of my
> clocks in that propagation chain were struct clk_hw_omap, none of them
> were any of the basic clock types.  Now in v6, one of the clocks in
> the chain is struct clk_divider.  I started looking at the divider's
> .round_rate code and for the case where CLK_PARENT_SET_RATE flag is
> set the code doesn't make any sense.  I spent some time today trying
> to fix struct clk_divider's .round_rate implementation and came to
> realize that there might not be a sane default for how such code
> should work.  A sane default for the common divider that works
> correctly on OMAP may not be what you want on iMX.
> 
> To illustrate: if CLK_SET_RATE_PARENT flag is set for my clk_divider
> I'd really like to divide by 1 and pass the exact same rate that was
> requested for my clk_divider up to the parent.

I don't understand this. If you use the CLK_SET_RATE_PARENT to force
a divider value to 1 then why do you register a divider at all?

> But the existing
> divider code tries to find the largest div for clk_divider and request
> a faster rate from the parent (well, I assume this is what it is
> supposed to do as the code doesn't quite get this right).

That's indeed different assumptions. When I set CLK_SET_RATE_PARENT I
want to say to the divider that it is allowed to change the parent rate.
So what it does (or should do) is to loop around its divider values and
tries to round the parent rate to (rate * div). This way it can find the
best divider values for this divider and the parent divider to get the
wanted rate. This was done (almost) correctly in the version of the
divider I posted to the list, but indeed the current version is broken.

> 
> Do you have any ideas on this?  Also, can you verify if this is what
> was failing for you, or maybe provide a log if the bug you mentioned
> exists elsewhere?  An extreme solution to the problem would be for
> clk_divider to not support the CLK_SET_PARENT flag if we cannot agree
> on a sane default for this behavior.  I like the idea of the divider
> choosing the smallest div possible and requesting the balance from the
> parent, but I need feedback from others on that point.

As said, the divider tries to get the *best* value for itself and the
parent divider (if exists), not the smallest.
I think the current divider implements something between what I thought
it should should do and what you thought it should do.

> For non-rate
> adjustable clocks (clk_gate in particular) it is very easy to continue
> supporting this flag as the .round_rate implementation should just be
> a "pass through" up to the parent.  In fact this behavior is what some
> of my omap clocks are doing and that is why parent propagation for
> CPUfreq was working for me back in v4.
> 
> > I tried another
> > approach on the weekend which basically does not try to do all in a
> > single recursion but instead sets the rate in multiple steps:
> >
> > 1) call a function which calculates all new rates of affected clocks
> >   in a rate change and safes the value in a clk->new_rate field. This
> >   function returns the topmost clock which has to be changed.
> > 2) starting from the topmost clock notify all clients. This walks the
> >   whole subtree even if a notfifier refuses the change. If necessary
> >   we can walk the whole subtree again to abort the change.
> > 3) actually change rates starting from the topmost clocks and notify
> >   all clients on the way. I changed the set_rate callback to void.
> >   Instead of failing (what is failing in case of set_rate? The clock
> >   will still have some rate) I check for the result with
> >   clk_ops->recalc_rate.
> 
> I've considered something like this for "clock groups", especially
> when the set of clocks changing are all on the same device and the
> permutations are well known ahead of time.  Is this working for you
> now?

The way described above works for me now, see this branch:

git://git.pengutronix.de/git/imx/linux-2.6.git v3.3-rc6-clkv6-fixup

You may not necessarily like it as it changes quite a lot in the rate
changing code.

For the clock groups I plan to drop them at least for i.MX as the concept
of clk groups seems somewhat broken. What we are grouping together are
really different clocks and the driver should know about it and could
even make use of it. We may not want to have more clocks in the driver
though and may need something handling this on the bus layer, but that's
another topic. The clock framework seems to be the wrong place for it.

> 
> >
> > In the end what's more important than the implementation details is that
> > it actually works. I created a little test module which sets up two
> > cascaded dividers, tries to change the rate at the output and checks the
> > result.  We might want to add something like this (and maybe similar
> > tests for reparenting and other stuff) to the generic clock framework
> > later.  It's good to have something generic to test the framework with
> > without depending on some particular SoC.
> 
> Agreed about the generic test.  I'm not taking it into the current
> series, but we can grow the test cases and submit them later on.

Have you tried running it? It's not i.MX specific. I attached an updated
version of the test. It fails with several NULL pointer exceptions,
mostly because it has the CLK_SET_RATE_PARENT flag set for a divider
whose parent is a fixed clock. If I don't set this flag no more NULL
pointer exceptions occur, but the rate is not correct because the
divider has to use DIV_ROUND_UP in its calc_best_div function. Otherwise
it always returns a higher frequency if parentrate/rate is not an
integer.

Apart from these little details we are discussing about here I really
like your patches and can't wait to see them mainline. Thanks for
working on this.

Sascha

8<---------------------------------------------------------------

clk: Add clock test module

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/clk/Makefile   |    2 +-
 drivers/clk/clk-test.c |  218 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 219 insertions(+), 1 deletions(-)
 create mode 100644 drivers/clk/clk-test.c

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 1f736bc..ba9a779 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -1,4 +1,4 @@
 
 obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
 obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-fixed-rate.o clk-gate.o \
-				   clk-mux.o clk-divider.o
+				   clk-mux.o clk-divider.o clk-test.o
diff --git a/drivers/clk/clk-test.c b/drivers/clk/clk-test.c
new file mode 100644
index 0000000..cdee544
--- /dev/null
+++ b/drivers/clk/clk-test.c
@@ -0,0 +1,218 @@
+#include <linux/spinlock.h>
+#include <linux/clk-provider.h>
+#include <linux/clk.h>
+#include <linux/module.h>
+
+/*
+ * We build a fixed rate source clock with two cascaded 2bit dividers:
+ *
+ * f1 -> div1 -> div2
+ *
+ * and try set the rate of div2 from 0Hz to f1 + 1 Hz.
+ *
+ * Note that we expect the core to divide the dividers one after
+ * another:
+ *
+ * fout = (f1 / div1) / div
+ *
+ * and not like this:
+ *
+ * fout = f1 / (div1 * div2)
+ * This has in some cases different results due to integer maths
+ */
+
+static unsigned long div1_reg, div2_reg;
+static int div1_width = 3;
+static int div2_width = 3;
+
+#define MAX_DIV(x)	(1 << (x))
+
+static struct clk *f1, *div1, *div2;
+
+static DEFINE_SPINLOCK(clk_test_lock);
+
+#define FIXED_RATE 1000
+
+static int check_rounded_rate_div2(unsigned long want, unsigned long rounded)
+{
+	int i, j;
+	unsigned long best = 0, now;
+
+	if (want > FIXED_RATE) {
+		best = FIXED_RATE;
+		goto found;
+	}
+
+	for (i = 1; i <= MAX_DIV(div1_width); i++) {
+		for (j = 1; j <= MAX_DIV(div2_width); j++) {
+			now = FIXED_RATE / i / j;
+			if (now <= want && now > best)
+				best = now;
+		}
+	}
+
+	if (!best)
+		best = (FIXED_RATE / MAX_DIV(div1_width)) / MAX_DIV(div2_width);
+found:
+	if (rounded != best) {
+		printk("clk-test: wanted rate %ld, best result would be %ld,"
+				" but we have %ld\n",
+				want, best, rounded);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int check_real_rate_div2(unsigned long rate)
+{
+	unsigned long realrate;
+
+	realrate = FIXED_RATE / (div1_reg + 1) / (div2_reg + 1);
+
+	if (rate != realrate) {
+		printk("clk-test: divider returns rate %ld, but instead has %ld\n",
+				rate, realrate);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int set_rate_test_div2(void)
+{
+	unsigned long i, rate, rounded;
+	int ret, errors = 0;
+
+	for (i = 0; i < FIXED_RATE + 1; i++) {
+		rounded = clk_round_rate(div2, i);
+		ret = check_rounded_rate_div2(i, rounded);
+		if (ret)
+			errors++;
+		ret = clk_set_rate(div2, i);
+		if (ret) {
+			printk("%s: setting rate of div2 to %ld failed with %d\n",
+					__func__, i, ret);
+			errors++;
+		}
+
+		rate = clk_get_rate(div2);
+
+		if (rounded != rate) {
+			printk("clk_test: wanted %ld, core rounded to %ld, have now: %ld\n",
+					i, rounded, rate);
+			errors++;
+		}
+
+		ret = check_real_rate_div2(rate);
+		if (ret)
+			errors++;
+	}
+
+	return errors;
+}
+
+static int check_rounded_rate_div1(unsigned long want, unsigned long rounded)
+{
+	unsigned long best;
+	int i;
+
+	for (i = 1; i <= MAX_DIV(div1_width); i++)
+		if (FIXED_RATE / i <= want) {
+			best = FIXED_RATE / i;
+			goto found;
+		}
+
+	best = FIXED_RATE / MAX_DIV(div1_width);
+found:
+	if (rounded != best) {
+		printk("clk-test: wanted rate %ld, best result would be %ld,"
+				" but we have %ld\n",
+				want, best, rounded);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int check_real_rate_div1(unsigned long rate)
+{
+	unsigned long realrate;
+
+	realrate = FIXED_RATE / (div1_reg + 1);
+
+	if (rate != realrate) {
+		printk("clk-test: divider returns rate %ld, but instead has %ld\n",
+				rate, realrate);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int set_rate_test_div1(void)
+{
+	unsigned long i, rate, rounded;
+	int ret, errors = 0;
+
+	for (i = 0; i < FIXED_RATE + 1; i++) {
+		rounded = clk_round_rate(div1, i);
+		ret = check_rounded_rate_div1(i, rounded);
+		if (ret)
+			errors++;
+		ret = clk_set_rate(div1, i);
+		if (ret) {
+			printk("%s: setting rate of div2 to %ld failed with %d\n",
+					__func__, i, ret);
+			errors++;
+		}
+
+		rate = clk_get_rate(div1);
+
+		if (rounded != rate) {
+			printk("clk_test: wanted %ld, core rounded to %ld, have now: %ld\n",
+					i, rounded, rate);
+			errors++;
+		}
+
+		ret = check_real_rate_div1(rate);
+		if (ret)
+			errors++;
+	}
+
+	return errors;
+}
+
+/* The core does not like this flag when the parent is not adjustable */
+#define DIV1_FLAGS CLK_SET_RATE_PARENT
+
+static int clk_test_init(void)
+{
+	int errors = 0;
+
+	f1 = clk_register_fixed_rate(NULL, "f1", NULL, CLK_IS_ROOT, FIXED_RATE);
+	div1 = clk_register_divider(NULL, "div1", "f1", DIV1_FLAGS,
+			&div1_reg, 0, div1_width, 0, &clk_test_lock);
+	div2 = clk_register_divider(NULL, "div2", "div1", CLK_SET_RATE_PARENT,
+			&div2_reg, 0, div2_width, 0, &clk_test_lock);
+
+	if (!f1 || !div1 || !div2) {
+		printk("clk-test: failed to register clocks\n");
+		return -EINVAL;
+	}
+
+	/* First pass: no cascaded divider, only f1 -> div1 */
+	errors = set_rate_test_div1();
+	/* Second pass: cascaded divider, f1 -> div1 -> div2 */
+	errors += set_rate_test_div2();
+
+	printk("clk-test: finished with %d errors\n", errors);
+#if 0
+	/* we should be able to unregister clocks */
+	clk_unregister(f1);
+	clk_unregister(div1);
+	clk_unregister(div2);
+#endif
+	return -EINVAL;
+}
+subsys_initcall(clk_test_init);
-- 
1.7.9.1

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
