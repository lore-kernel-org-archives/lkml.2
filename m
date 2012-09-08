Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741Ab2IHBXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 21:23:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43634 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759270Ab2IHBXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 21:23:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1346581273-7041-5-git-send-email-thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org
References: <1346581273-7041-1-git-send-email-thierry.reding@avionic-design.de>
 <1346581273-7041-5-git-send-email-thierry.reding@avionic-design.de>
Message-ID: <20120908012258.20289.98563@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH 4/6] unicore32: Add common clock support
Date: Fri, 07 Sep 2012 18:22:58 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Thierry Reding (2012-09-02 03:21:11)
> diff --git a/arch/unicore32/kernel/clock.c b/arch/unicore32/kernel/clock.c
<snip>
> +struct clk_uc {
> +       struct clk_hw hw;
>  };

This looks ugly.  Normally register addresses, masks and the like would
go here.  Instead you duplicate some functions below (which should be
common) and hard-code the addresses in those functions.  Below I'll use
your recalc_rate as an example...

<snip>
> +static inline struct clk_uc *to_clk_uc(struct clk_hw *hw)
>  {
> +       return container_of(hw, struct clk_uc, hw);
>  }

This is never used.  It should be, but it is not.  I'll address that
more below.

<snip>
> +static struct clk *clk_register_uc(const char *name, const char *parent,
> +                                  const struct clk_ops *ops)
>  {
> -       if (clk == &clk_vga_clk) {
> -               unsigned long pll_vgacfg, pll_vgadiv;
> -               int ret, i;
> -
> -               /* lookup vga_clk_table */
> -               ret = -EINVAL;
> -               for (i = 0; i < ARRAY_SIZE(vga_clk_table); i++) {
> -                       if (rate == vga_clk_table[i].rate) {
> -                               pll_vgacfg = vga_clk_table[i].cfg;
> -                               pll_vgadiv = vga_clk_table[i].div;
> -                               ret = 0;
> -                               break;
> -                       }
> -               }
> -
> -               if (ret)
> -                       return ret;
> -
> -               if (readl(PM_PLLVGACFG) == pll_vgacfg)
> -                       return 0;
> +       struct clk_init_data init;
> +       struct clk_uc *uc;
> +       struct clk *clk;
>  
> -               /* set pll vga cfg reg. */
> -               writel(pll_vgacfg, PM_PLLVGACFG);
> +       uc = kzalloc(sizeof(*uc), GFP_KERNEL);
> +       if (!uc)
> +               return NULL;

-ENOMEM?

<snip>
> +static unsigned long clk_vga_recalc_rate(struct clk_hw *hw,
> +                                        unsigned long parent_rate)
> +{
> +       unsigned long pllrate = readl(PM_PLLVGASTATUS);
> +       unsigned long divstatus = readl(PM_DIVSTATUS);
> +       unsigned long rate = 0;
> +       unsigned int i;
> +
> +       /* lookup pvga_table */
> +       for (i = 0; i < ARRAY_SIZE(pllrate_table); i++) {
> +               if (pllrate == pllrate_table[i].prate) {
> +                       rate = pllrate_table[i].rate;
> +                       break;
> +               }
> +       }
> +
> +       if (rate)
> +               rate = rate / (((divstatus & 0x00f00000) >> 20) + 1);
> +
> +       return rate;
> +}

This vga recalc_rate code seems very similar to the mclk and ddr
recalc_rate functions (found further down below).  It would be better to
do something like this:

		struct clk_uc *uc = to_clk_uc(hw);
		unsigned long pllrate = readl(uc->pll_status);
		...

This means that you can reuse the same function for vga, mclk and ddr
clocks.  The same logic can be extrapolated to apply to some other bits
of code in here as well, I think.

<snip>
> +static unsigned long clk_mclk_recalc_rate(struct clk_hw *hw,
> +                                         unsigned long parent_rate)
> +{
> +#ifndef CONFIG_ARCH_FPGA
> +       unsigned long pllrate = readl(PM_PLLSYSSTATUS);
> +       unsigned long rate = 0;
> +       unsigned int i;
> +
> +       /* lookup pllrate_table */
> +       for (i = 0; i < ARRAY_SIZE(pllrate_table); i++) {
> +               if (pllrate == pllrate_table[i].prate) {
> +                       rate = pllrate_table[i].rate;
> +                       break;
> +               }
> +       }
> +
> +       return rate;
> +#else
> +       return 33000000;
> +#endif
> +}

If ARCH_FPGA is defined then register a fixed-rate clock (see
drivers/clk/clk-fixed-rate.c).  Then you won't need ifdefs in these
functions and it will help you consolidate (as mentioned above).  This
same pattern repeats a few times throughout the code.

Regards,
Mike
