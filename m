Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab2HPHnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 03:43:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58954 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab2HPHnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 03:43:42 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2012 03:43:42 EDT
MIME-Version: 1.0
In-Reply-To: <201208160717.03707.arnd@arndb.de>
References: <1345086525-12328-1-git-send-email-xiechao.mail@gmail.com>
	<1345086525-12328-4-git-send-email-xiechao.mail@gmail.com>
	<201208160717.03707.arnd@arndb.de>
Date: Thu, 16 Aug 2012 15:37:42 +0800
Message-ID: <CADApbej91_Y84sC9R1b0+LgDTzFUH8CveYsDi4wDWOQxkGnnFg@mail.gmail.com>
Subject: Re: [PATCH V3 3/5] clk: mmp: add clock definition for pxa910
From: Chao Xie <xiechao.mail@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, chao.xie@marvell.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 3:17 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 16 August 2012, Chao Xie wrote:
>
>> +enum {
>> +     clk32, vctcxo, pll1, pll1_2, pll1_4, pll1_8, pll1_16, pll1_6, pll1_12,
>> +     pll1_24, pll1_48, pll1_96, pll1_13, pll1_13_1_5, pll1_2_1_5,
>> +     pll1_3_16, uart_pll, twsi0, twsi1, gpio, kpc, rtc, pwm0, pwm1, pwm2,
>> +     pwm3, uart0_mux, uart0, uart1_mux, uart1, uart2_mux, uart2,
>> +     ssp0_mux, ssp0, ssp1_mux, ssp1, dfc, sdh0_mux, sdh0, sdh1_mux, sdh1,
>> +     usb, sph, disp0_mux, disp0, ccic0_mux, ccic0, ccic0_phy_mux,
>> +     ccic0_phy, ccic0_sphy_div, ccic0_sphy, clk_max
>> +};
>
> I wonder whether you should just get rid of this enum
>
>> +void __init pxa910_clk_init(void)
>> +{
>> +     struct clk *clocks[clk_max];
>
> and this array,
>
>> +     clocks[clk32] =
>> +         clk_register_fixed_rate(NULL, "clk32", NULL, CLK_IS_ROOT, 3200);
>> +     clk_register_clkdev(clocks[clk32], "clk32", NULL);
>> +
>> +     clocks[vctcxo] =
>> +         clk_register_fixed_rate(NULL, "vctcxo", NULL, CLK_IS_ROOT,
>> +                                 26000000);
>> +     clk_register_clkdev(clocks[vctcxo], "vctcxo", NULL);
>
> because now that the "obfuscation" macro is gone, it's clear that each index
> is used only once here and then passed right into the next function. If you
> write it like:
>
>         struct clk *clk;
>
>         clk = clk_register_fixed_rate(NULL, "clk32", NULL, CLK_IS_ROOT, 3200);
>         clk_register_clkdev(clk, "clk32", NULL);
>
> it becomes much shorter, partly because things start fitting into one
> line again. The only exception in this file is
>
>> +     clocks[uart_pll] =
>> +         mmp_clk_register_factor("uart_pll", "pll1_4", 0,
>> +                                 mpmu_base + MPMU_UART_PLL,
>> +                                 &uart_factor_masks, uart_factor_tbl,
>> +                                 ARRAY_SIZE(uart_factor_tbl));
>> +     clk_set_rate(clocks[uart_pll], 14745600);
>> +     clk_register_clkdev(clocks[uart_pll], "uart_pll", NULL);
>
> with
>
>> +     clocks[uart0_mux] =
>> +         clk_register_mux(NULL, "uart0_mux", uart_parent,
>> +                          ARRAY_SIZE(uart_parent), CLK_SET_RATE_PARENT,
>> +                          apbc_base + APBC_UART0, 4, 3, 0, &clk_lock);
>> +     clk_set_parent(clocks[uart0_mux], clocks[uart_pll]);
>> +     clk_register_clkdev(clocks[uart0_mux], "uart_mux.0", NULL);
>> +
>> +     clocks[uart0] =
>> +         mmp_clk_register_apbc("uart0", "uart0_mux", apbc_base + APBC_UART0,
>> +                               10, 0, &clk_lock);
>> +     clk_register_clkdev(clocks[uart0], NULL, "pxa2xx-uart.0");
>
> so just add another
>
>         struct clk *clk_uart;
>
>         clk_uart = mmp_clk_register_factor("uart_pll", "pll1_4", 0,
>                         mpmu_base + MPMU_UART_PLL, &uart_factor_masks, uart_factor_tbl,
>                         ARRAY_SIZE(uart_factor_tbl));
>
>
>
>         Arnd
i can change remove the clocks array, but even make the sentence
shorter, most of them still can not fit in one line.
