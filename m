Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab1LFBhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:37:20 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:38487 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab1LFBhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:37:18 -0500
Date: Mon, 5 Dec 2011 18:37:17 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, grant.likely@secretlab.ca,
        sboyd@quicinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
In-Reply-To: <20111205234849.GA14547@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1112051706300.6289@utopia.booyaka.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <1321926047-14211-4-git-send-email-mturquette@linaro.org> <alpine.DEB.2.00.1112051342430.6289@utopia.booyaka.com> <20111205234849.GA14547@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011, Russell King - ARM Linux wrote:

> On Mon, Dec 05, 2011 at 02:15:56PM -0700, Paul Walmsley wrote:
>
> > But I'd propose that we instead increase the size of struct clk.rate to be 
> > s64:
> > 
> > s64 clk_round_rate(struct clk *clk, s64 desired_rate);
> > int clk_set_rate(struct clk *clk, s64 rate);
> > s64 clk_get_rate(struct clk *clk);
> > 
> > struct clk {
> > ...
> >      s64 rate;
> > ...
> > };
> > 
> > That way the clock framework can accommodate current clock rates, as well 
> > as any conceivable future clock rate.  (Some production CPUs are already 
> > running at clock rates greater than 4 GiHZ[1].  RF devices with 4 GiHz+ 
> > clock rates are also common, such as 802.11a devices running in the 5.8 
> > GHz band, and drivers for those may eventually wish to use the clock 
> > framework.)
> 
> Yuck.  You are aware that 64-bit math on 32-bit CPUs sucks? So burdening 
> _everything_ with 64-bit rate quantities is absurd.  As for making then 
> 64-bit signed quantities, that's asking for horrid code from gcc for the 
> majority of cases.

64-bit divides would be the only real issue in the clock framework 
context.  And those are easily avoided on clock hardware where the parent 
rate can never exceed 32 bits.

For example, here's a trivial implementation for rate recalculation for a 
integer divider clock node (that can't be handled with a right shift):

s64 div(struct clk *clk, u32 div) {
	if (clk->flags & CLK_PARENT_RATE_MAX_U32)
		return ((u32)(clk->parent->rate & 0xffffffff)) / div;

	clk->rate = clk->parent->rate;
	do_div(clk->rate, div);
	return clk->rate;
}

gcc generates this for ARMv6:

00000010 <div>:
  10:	e92d4038 	push	{r3, r4, r5, lr}
  14:	e1a05000 	mov	r5, r0         
  18:	e5d03010 	ldrb	r3, [r0, #16]  @ clk->flags
  1c:	e1a04001 	mov	r4, r1
  20:	e3130001 	tst	r3, #1         @ 32-bit parent rate?
  24:	1a000007 	bne	48 <div+0x38>  @ do 32-bit divide 

/* 64-bit divide by 32-bit follows */

  28:	e5903000 	ldr	r3, [r0]
  2c:	e1c300d8 	ldrd	r0, [r3, #8]
  30:	ebfffffe 	bl	0 <__do_div64>
  34:	e1a00002 	mov	r0, r2
  38:	e1a01003 	mov	r1, r3
  3c:	e5852008 	str	r2, [r5, #8]
  40:	e585300c 	str	r3, [r5, #12]
  44:	e8bd8038 	pop	{r3, r4, r5, pc}

/* 32-bit divide follows */

  48:	e5900000 	ldr	r0, [r0]
  4c:	e5900008 	ldr	r0, [r0, #8]
  50:	ebfffffe 	bl	0 <__aeabi_uidiv>
  54:	e3a01000 	mov	r1, #0
  58:	e8bd8038 	pop	{r3, r4, r5, pc}


Not bad at all, and this isn't even optimized.  (The conditional could be 
avoided completely with a little work during clock init.)  What little 
overhead there is seems quite trivial if it means that the clock framework 
will be useful for present and future devices.


- Paul
