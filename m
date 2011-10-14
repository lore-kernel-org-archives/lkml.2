Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab1JNSOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:14:41 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:59003 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751Ab1JNSOk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:14:40 -0400
MIME-Version: 1.0
In-Reply-To: <1316730422-20027-2-git-send-email-mturquette@ti.com>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com> <1316730422-20027-2-git-send-email-mturquette@ti.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Fri, 14 Oct 2011 11:14:19 -0700
Message-ID: <CAJOA=zM9k7_z_PUoF0tZ_OrgdDTgMjZLftqtW0ra3G9C08Th7g@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        paul@pwsan.com, grant.likely@secretlab.ca, sboyd@quicinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk, eric.miao@linaro.org,
        richard.zhao@linaro.org, Mike Turquette <mturquette@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 3:26 PM, Mike Turquette <mturquette@ti.com> wrote:
> From: Jeremy Kerr <jeremy.kerr@canonical.com>
>  struct clk_hw_ops {
>        int             (*prepare)(struct clk_hw *);
>        void            (*unprepare)(struct clk_hw *);
>        int             (*enable)(struct clk_hw *);
>        void            (*disable)(struct clk_hw *);
>        unsigned long   (*recalc_rate)(struct clk_hw *);

In implementing recalc for divider clocks, I started to wonder, "why
not just pass struct clk *clk into the clk_hw_ops func ptrs?".

recalc is an obvious example whereby we need access to parent->rate.
The code usually ends up looking something like:

unsigned long omap_recalc_rate(struct clk_hw *hw)
{
        struct clk *parent;
        struct clk_hw_omap *oclk;

        parent = hw->clk->parent;
        oclk = to_clk_omap(hw);
        ...
}

That's a bit of a song and dance to have to do in almost every op, and
often these ops will need access to stuff like clk->rate also.   Is
there any opposition to just passing in struct clk?  e.g:

unsigned long omap_recalc_rate(struct clk *clk)
{
        struct clk *parent;
        struct clk_hw_omap *oclk;

        parent = clk->parent;
        oclk = to_clk_omap(clk->hw);
        ...
}

It is a small nitpick, but it affects the API for everybody so best to
get it right now before folks start migrating over to it.

Thanks,
Mike

>        int             (*set_rate)(struct clk_hw *,
>                                        unsigned long, unsigned long *);
>        long            (*round_rate)(struct clk_hw *, unsigned long);
>        int             (*set_parent)(struct clk_hw *, struct clk *);
>        struct clk *    (*get_parent)(struct clk_hw *);
>  };
