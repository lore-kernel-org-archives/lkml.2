Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031350Ab2COAwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:52:16 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:56717 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031266Ab2COAwM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:52:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120313120507.GS3852@pengutronix.de>
References: <1331366064-1273-1-git-send-email-mturquette@linaro.org>
 <1331366064-1273-3-git-send-email-mturquette@linaro.org> <20120311113414.GM3852@pengutronix.de>
 <CAJOA=zMdkLB-DCPOk=kz5mn6BK6A_swocyCHJHeGE6H7FxBbmQ@mail.gmail.com>
 <20120312115117.GN3852@pengutronix.de> <CAJOA=zPx0ARsoO4ueSTMe_z2Gs4xG4P2qn1=-vHFf7_k=+K6hQ@mail.gmail.com>
 <20120313120507.GS3852@pengutronix.de>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Wed, 14 Mar 2012 17:51:48 -0700
Message-ID: <CAJOA=zMT4vK7WPF7iEH9kN6GHHAv-LChHoadzieqV-Wd3Qj=WQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] clk: introduce the common clock framework
To: Sascha Hauer <s.hauer@pengutronix.de>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 5:05 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Mon, Mar 12, 2012 at 08:16:36PM -0700, Turquette, Mike wrote:
>> On Mon, Mar 12, 2012 at 4:51 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>> > I tried another
>> > approach on the weekend which basically does not try to do all in a
>> > single recursion but instead sets the rate in multiple steps:
>> >
>> > 1) call a function which calculates all new rates of affected clocks
>> >   in a rate change and safes the value in a clk->new_rate field. This
>> >   function returns the topmost clock which has to be changed.
>> > 2) starting from the topmost clock notify all clients. This walks the
>> >   whole subtree even if a notfifier refuses the change. If necessary
>> >   we can walk the whole subtree again to abort the change.
>> > 3) actually change rates starting from the topmost clocks and notify
>> >   all clients on the way. I changed the set_rate callback to void.
>> >   Instead of failing (what is failing in case of set_rate? The clock
>> >   will still have some rate) I check for the result with
>> >   clk_ops->recalc_rate.
>
> The way described above works for me now, see this branch:
>
> git://git.pengutronix.de/git/imx/linux-2.6.git v3.3-rc6-clkv6-fixup
>
> You may not necessarily like it as it changes quite a lot in the rate
> changing code.

I tried that code and I really like it!  It is much more readable and
feels less "fragile" than the previous recursive __clk_set_rate.  I
did quite a bit of testing with this code today.  One of the tests
looks like this:

    pll         (adjustable to anything)
     |
clk_divider     (5 bits wide)
     |
   dummy        (no clk_ops)

The new code did a fine job arbitrating rates for the PLL and the
intermediate divider even if I put weird constraints on the PLL.  For
instance if I artificially limited it to a minimum of 600MHz and then
ran clk_set_rate(dummy, 300MHz) it would lock at 600MHz and set
clk_divider to divide-by-2.  Setting to 600MHz or more set the divider
back to 1 and relocked the PLL appropriately.  Pretty cool.

I also tested the notifiers with this code and they seem to function
properly.  I'll take this code in for v7.  Thanks a lot for this
helpful contribution.

I did find that MULT_ROUND_UP caused trouble for my PLL's round_rate
implementation.  Maybe my PLL code is fragile but a quick fix was to
make sure that we send the exact value we want to the round_rate code.
 I also feel this is more correct.  Let me know what you think:

8<---------------------------------------------------------------

commit 189fecedb175d0366759246c4192f45b0bc39a50
Author: Mike Turquette <mturquette@linaro.org>
Date:   Wed Mar 14 17:29:51 2012 -0700

    clk-divider.c: round the actual rate we care about

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 86ca9cd..06ef4a0 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -47,12 +47,6 @@ static unsigned long clk_divider_recalc_rate(struct
clk_hw *hw,
 }
 EXPORT_SYMBOL_GPL(clk_divider_recalc_rate);

-/*
- * The reverse of DIV_ROUND_UP: The maximum number which
- * divided by m is r
- */
-#define MULT_ROUND_UP(r, m) ((r) * (m) + (m) - 1)
-
 static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 		unsigned long *best_parent_rate)
 {
@@ -84,9 +78,9 @@ static int clk_divider_bestdiv(struct clk_hw *hw,
unsigned long rate,

 	for (i = 1; i <= maxdiv; i++) {
 		parent_rate = __clk_round_rate(__clk_get_parent(hw->clk),
-				MULT_ROUND_UP(rate, i));
+				(rate * i));
 		now = parent_rate / i;
-		if (now <= rate && now >= best) {
+		if (now <= rate && now > best) {
 			bestdiv = i;
 			best = now;
 			*best_parent_rate = parent_rate;
