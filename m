Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab1JOCZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 22:25:07 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:25958
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751506Ab1JOCZF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 22:25:05 -0400
X-SpamScore: -9
X-BigFish: VS-9(z1039oz9371K1432N98dK4015Lzz1202hzz8275bh8275dhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Sat, 15 Oct 2011 10:24:49 +0800
From: Richard Zhao <richard.zhao@linaro.org>
To: "Turquette, Mike" <mturquette@ti.com>
CC: <linux-kernel@vger.kernel.org>, <paul@pwsan.com>,
        <linaro-dev@lists.linaro.org>, <linus.walleij@stericsson.com>,
        <patches@linaro.org>, <broonie@opensource.wolfsonmicro.com>,
        <magnus.damm@gmail.com>, <amit.kucheria@linaro.org>,
        <linux@arm.linux.org.uk>, <grant.likely@secretlab.ca>,
        <dsaxena@linaro.org>, <eric.miao@linaro.org>,
        <shawn.guo@freescale.com>, <skannan@quicinc.com>, <sboyd@quicinc.com>,
        <jeremy.kerr@canonical.com>, <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <arnd.bergmann@linaro.org>
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Message-ID: <20111015022448.GA17872@b20223-02.ap.freescale.net>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-2-git-send-email-mturquette@ti.com>
 <CAJOA=zM9k7_z_PUoF0tZ_OrgdDTgMjZLftqtW0ra3G9C08Th7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CAJOA=zM9k7_z_PUoF0tZ_OrgdDTgMjZLftqtW0ra3G9C08Th7g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 11:14:19AM -0700, Turquette, Mike wrote:
> On Thu, Sep 22, 2011 at 3:26 PM, Mike Turquette <mturquette@ti.com> wrote:
> > From: Jeremy Kerr <jeremy.kerr@canonical.com>
> >  struct clk_hw_ops {
> >        int             (*prepare)(struct clk_hw *);
> >        void            (*unprepare)(struct clk_hw *);
> >        int             (*enable)(struct clk_hw *);
> >        void            (*disable)(struct clk_hw *);
> >        unsigned long   (*recalc_rate)(struct clk_hw *);
> 
> In implementing recalc for divider clocks, I started to wonder, "why
> not just pass struct clk *clk into the clk_hw_ops func ptrs?".
> 
> recalc is an obvious example whereby we need access to parent->rate.
> The code usually ends up looking something like:
> 
> unsigned long omap_recalc_rate(struct clk_hw *hw)
> {
>         struct clk *parent;
>         struct clk_hw_omap *oclk;
> 
>         parent = hw->clk->parent;
clk drivers can not see struct clk details. I use clk_get_parent.
>         oclk = to_clk_omap(hw);
>         ...
> }
> 
> That's a bit of a song and dance to have to do in almost every op, and
> often these ops will need access to stuff like clk->rate also.   Is
> there any opposition to just passing in struct clk?  e.g:
> 
> unsigned long omap_recalc_rate(struct clk *clk)
> {
>         struct clk *parent;
>         struct clk_hw_omap *oclk;
> 
>         parent = clk->parent;
>         oclk = to_clk_omap(clk->hw);
>         ...
> }
In my understanding, struct clk stores things specific to clk core,
struct clk_hw stores common things needed by clk drivers. For static clk driver
there' some problems:
 - For clocks without mux, I need duplicate a  .parent and set .get_parent.
   Even when we adopt DT and dynamicly create clk, it's still a problem.
   Moving .parent to clk_hw can fix it.
 - When I define a clk array, I don't need to find another place to store .ops.
   It's not problem for dynamic creating clock.
 - As I mentioned in another mail, clk group need no lock version prepare/unprepare
   and enable/disable functions
   Another way is, add a "{struct clk_hw *clks; int count}" in clk_hw, let clk
   core handle it.
   I prefer the second way, but I'm not sure whether it's common enough. It's
   still a problem for dynamic creating clock.

Thanks
Richard
> 
> It is a small nitpick, but it affects the API for everybody so best to
> get it right now before folks start migrating over to it.
> 
> Thanks,
> Mike
> 
> >        int             (*set_rate)(struct clk_hw *,
> >                                        unsigned long, unsigned long *);
> >        long            (*round_rate)(struct clk_hw *, unsigned long);
> >        int             (*set_parent)(struct clk_hw *, struct clk *);
> >        struct clk *    (*get_parent)(struct clk_hw *);
> >  };
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

