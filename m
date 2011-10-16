Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab1JPS07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 14:26:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60456 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab1JPS06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 14:26:58 -0400
Date: Sun, 16 Oct 2011 20:26:49 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Richard Zhao <richard.zhao@freescale.com>, jeremy.kerr@canonical.com,
        paul@pwsan.com, linaro-dev@lists.linaro.org,
        linus.walleij@stericsson.com, patches@linaro.org,
        broonie@opensource.wolfsonmicro.com, magnus.damm@gmail.com,
        linux-kernel@vger.kernel.org, eric.miao@linaro.org,
        linux@arm.linux.org.uk, grant.likely@secretlab.ca, dsaxena@linaro.org,
        tglx@linutronix.de, amit.kucheria@linaro.org, skannan@quicinc.com,
        Jamie Iles <jamie@jamieiles.com>, arnd.bergmann@linaro.org,
        sboyd@quiinc.com, richard.zhao@linaro.org, shawn.guo@freescale.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/7] clk: Add simple gated clock
Message-ID: <20111016182649.GB13565@pengutronix.de>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-5-git-send-email-mturquette@ti.com>
 <20111012064646.GA31037@b20223-02.ap.freescale.net>
 <CAJOA=zPw7BF1iNFaG9js2k6++qPnXz5S3dq4rsPmUWOcUztL0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJOA=zPw7BF1iNFaG9js2k6++qPnXz5S3dq4rsPmUWOcUztL0g@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:17:56 up 6 days,  7:09,  9 users,  load average: 0.08, 0.08, 0.13
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 07:59:19AM -0700, Turquette, Mike wrote:
> On Tue, Oct 11, 2011 at 11:46 PM, Richard Zhao
> <richard.zhao@freescale.com> wrote:
> > On Thu, Sep 22, 2011 at 03:26:59PM -0700, Mike Turquette wrote:
> >> From: Jeremy Kerr <jeremy.kerr@canonical.com>
> >>
> >> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> >> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> >> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> >> Signed-off-by: Mike Turquette <mturquette@ti.com>
> >> ---
> >> Changes since v1:
> >> Add copyright header
> >> Fold in Jamie's patch for set-to-disable clks
> >> Use BIT macro instead of shift
> >>
> >>  drivers/clk/Kconfig    |    4 ++
> >>  drivers/clk/Makefile   |    1 +
> >>  drivers/clk/clk-gate.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++
> >>  include/linux/clk.h    |   13 ++++++++
> >>  4 files changed, 96 insertions(+), 0 deletions(-)
> >>  create mode 100644 drivers/clk/clk-gate.c
> >
> > I feel hard to tell the tree the clk parent, at register/init time. For the
> > simple gate clk, the only way is to set .get_parent. But normally, for clk
> > without any divider we set .get_parent to NULL. Maybe we can put .parent to
> > struct clk_hw?
> 
> For non-mux clocks, whose parent is *always* going to be the same, you
> should create a duplicate .parent in the clk_hw_* structure and then
> have .get_parent return clk_hw_*->parent.

Maybe I do not understand what you mean here, but I think there is
something missing in the gate.

> 
> This is analogous to the way clk_hw_fixed returns clk_hw_fixed->rate
> when .recalc is called on it.
> 
> >> +
> >> +static unsigned long clk_gate_get_rate(struct clk_hw *clk)
> >> +{
> >> +     return clk_get_rate(clk_get_parent(clk->clk));
> >> +}

clk_get_parent goes down to clk_gate_set_enable_ops.get_parent below...

> >> +
> >> +
> >> +struct clk_hw_ops clk_gate_set_enable_ops = {
> >> +     .recalc_rate = clk_gate_get_rate,
> >> +     .enable = clk_gate_enable_set,
> >> +     .disable = clk_gate_disable_clear,
> >> +};

...but this does not have a get_parent pointer, so clk_get_parent()
for a gate always returns NULL which means that a gate never has
a valid rate.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
