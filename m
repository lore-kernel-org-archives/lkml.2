Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965017Ab2CFTAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 14:00:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34278 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab2CFTAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 14:00:53 -0500
Date: Tue, 6 Mar 2012 20:00:39 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Paul Walmsley <paul@pwsan.com>,
        linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 3/4] clk: introduce the common clock framework
Message-ID: <20120306190039.GJ3852@pengutronix.de>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-4-git-send-email-mturquette@linaro.org>
 <20120303133158.GA26882@pengutronix.de>
 <CAJOA=zNFNEHxBDhRDdvm7DYR83R0LJjsp_AT3BoG+nL+iN5_tw@mail.gmail.com>
 <20120304115201.GB26882@pengutronix.de>
 <CAJOA=zP8d8wm==7=svOzh03Ft-1_LV71q0mA6Pncrh5vQSWGEA@mail.gmail.com>
 <20120305073836.GU3852@pengutronix.de>
 <CAJOA=zMs75ZQ24g5PXpSLV3AJzWEo12g86G8+4+ryQR_cTYpzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJOA=zMs75ZQ24g5PXpSLV3AJzWEo12g86G8+4+ryQR_cTYpzA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:09:37 up 115 days, 56 min, 66 users,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 12:03:15PM -0800, Turquette, Mike wrote:
> On Sun, Mar 4, 2012 at 11:38 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Sun, Mar 04, 2012 at 04:12:21PM -0800, Turquette, Mike wrote:
> >> >>
> >> >> I believe this patch already does what you suggest, but I might be
> >> >> missing your point.
> >> >
> >> > In include/linux/clk-private.h you expose struct clk outside the core.
> >> > This has to be done to make static initializers possible. There is a big
> >> > warning in this file that it must not be included from files implementing
> >> > struct clk_ops. You can simply avoid this warning by declaring struct clk
> >> > with only a single member:
> >> >
> >> > include/linux/clk.h:
> >> >
> >> > struct clk {
> >> >        struct clk_internal *internal;
> >> > };
> >> >
> >> > This way everybody knows struct clk (thus can embed it in their static
> >> > initializers), but doesn't know anything about the internal members. Now
> >> > in drivers/clk/clk.c you declare struct clk_internal exactly like struct
> >> > clk was declared before:
> >> >
> >> > struct clk_internal {
> >> >        const char              *name;
> >> >        const struct clk_ops    *ops;
> >> >        struct clk_hw           *hw;
> >> >        struct clk              *parent;
> >> >        char                    **parent_names;
> >> >        struct clk              **parents;
> >> >        u8                      num_parents;
> >> >        unsigned long           rate;
> >> >        unsigned long           flags;
> >> >        unsigned int            enable_count;
> >> >        unsigned int            prepare_count;
> >> >        struct hlist_head       children;
> >> >        struct hlist_node       child_node;
> >> >        unsigned int            notifier_count;
> >> > #ifdef CONFIG_COMMON_CLK_DEBUG
> >> >        struct dentry           *dentry;
> >> > #endif
> >> > };
> >> >
> >> > An instance of struct clk_internal will be allocated in
> >> > __clk_init/clk_register. Now the private data stays completely inside
> >> > the core and noone can abuse it.
> >>
> >> Hi Sascha,
> >>
> >> I see the disconnect here.  For OMAP (and possibly other platforms) at
> >> least some clock data is necessary during early boot, before the
> >> regular allocation methods are available (timers for instance).
> >
> > We had this problem on i.MX aswell. It turned out that the timer clock
> > is the only clock that is needed so early. We solved this by moving the
> > clock init to the system timer init function.
> 
> When you say "mov[ed] the clock init to the system timer init
> function" do you mean that you statically allocated struct clk and
> used the clk framework api, or instead you just did some direct
> register writes to initialize things properly?

I meant that on i.MX we do the clock tree initialization when kmalloc is
available, see the attached patch for omap4 based on your branch which
does the same for Omap. The first clock you need is the one for the
timer, so you can initialize the clocktree at the beginning of
time_init() and don't need statically initialized clocks anymore.

> >
> > Well, the file is work in progress, you probably fix this before sending
> > it out, but I bet people will include clk-private.h and nobody else
> > notices it.
> 
> clock44xx_data.c does not violate that rule.  None of the logic that
> implements ops for those clocks is present clock44xx_data.c.

Indeed, I missed that. It only has the ops but not the individual
functions.

> All of
> the code in that file is simply initialization and registration of
> OMAP4 clocks.  Many of the clocks are basic clock types (divider,
> multiplexer and fixed-rate are used in that file) with protected code
> drivers/clk/clk-*.c and the remaining clocks are of the struct
> clk_hw_omap variety, which has code spread across several files:
> 
> arch/arm/mach-omap2/clock.c
> arch/arm/mach-omap2/clock.h
> arch/arm/mach-omap2/clkt_dpll.c
> arch/arm/mach-omap2/clkt_clksel.c
> arch/arm/mach-omap2/dpll3xxx.c
> arch/arm/mach-omap2/dpll4xxx.c
> 
> All of the above files include linux/clk-provider.h, not
> linux/clk-private.h.  That code makes heavy use of the
> __clk_get_whatever helpers and shows how a platform might honor the
> layer of separation between struct clk and stuct clk_ops/struct
> clk_foo.  You are correct that the code is a work-in-progress, but
> there are no layering violations that I can see.
> 
> I also think we are talking past each other to some degree.  One point
> I would like to make (and maybe you already know this from code
> review) is that it is unnecessary to have pointers to your parent
> struct clk*'s when either initializing or registering your clocks.  In
> fact the existing clk_register_foo functions don't even allow you to
> pass in parent pointers and rely wholly on string name matching.  I
> just wanted to point that out in case it went unnoticed, as it is a
> new way of doing things from the previous series and was born out of
> Thomas' review of V4 and multi-parent handling.  This also keeps
> device-tree in mind where we might not know the struct clk *pointer at
> compile time for "connecting" discrete devices.

Yes, I've seen this and I really like it. Also the change that
multiplexers return an index to an array instead of the parent
clock is very nice.

Sascha


8<-----------------------------------------------------

ARM omap4: move clocktree init to timer init time so we don't need static clocks

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/mach-omap2/clock44xx_data.c |    4 +++-
 arch/arm/mach-omap2/io.c             |    1 -
 arch/arm/mach-omap2/timer.c          |    3 +++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/clock44xx_data.c b/arch/arm/mach-omap2/clock44xx_data.c
index 7f833a7..5aa8dd2 100644
--- a/arch/arm/mach-omap2/clock44xx_data.c
+++ b/arch/arm/mach-omap2/clock44xx_data.c
@@ -6032,7 +6032,9 @@ int __init omap4xxx_clk_init(void)
 		}
 # else
 		clkdev_add(c);
-		__clk_init(NULL, c->clk);
+
+		clk_register(NULL, c->clk->name, c->clk->ops, c->clk->hw,
+			c->clk->parent_names, c->clk->num_parents, c->clk->flags);
 #endif
 	}
 
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index eb50c29..8db4380 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -476,7 +476,6 @@ void __init omap4430_init_early(void)
 	omap44xx_clockdomains_init();
 	omap44xx_hwmod_init();
 	omap_hwmod_init_postsetup();
-	omap4xxx_clk_init();
 }
 #endif
 
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 5c9acea..2cca796 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -323,9 +323,12 @@ OMAP_SYS_TIMER_INIT(3_secure, OMAP3_SECURE_TIMER, OMAP3_CLKEV_SOURCE,
 OMAP_SYS_TIMER(3_secure)
 #endif
 
+int __init omap4xxx_clk_init(void);
+
 #ifdef CONFIG_ARCH_OMAP4
 static void __init omap4_timer_init(void)
 {
+	omap4xxx_clk_init();
 #ifdef CONFIG_LOCAL_TIMERS
 	twd_base = ioremap(OMAP44XX_LOCAL_TWD_BASE, SZ_256);
 	BUG_ON(!twd_base);
-- 
1.7.9.1

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
