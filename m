Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974Ab1LFG2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 01:28:11 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:34967 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910Ab1LFG2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 01:28:09 -0500
Date: Mon, 5 Dec 2011 23:28:08 -0700 (MST)
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
In-Reply-To: <alpine.DEB.2.00.1112051706300.6289@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.00.1112052322120.6289@utopia.booyaka.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <1321926047-14211-4-git-send-email-mturquette@linaro.org> <alpine.DEB.2.00.1112051342430.6289@utopia.booyaka.com> <20111205234849.GA14547@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.1112051706300.6289@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011, Paul Walmsley wrote:

> For example, here's a trivial implementation for rate recalculation for a 
> integer divider clock node (that can't be handled with a right shift):
> 
> s64 div(struct clk *clk, u32 div) {
> 	if (clk->flags & CLK_PARENT_RATE_MAX_U32)
> 		return ((u32)(clk->parent->rate & 0xffffffff)) / div;
> 
> 	clk->rate = clk->parent->rate;
> 	do_div(clk->rate, div);
> 	return clk->rate;
> }

(removing some useless cruft from the above function, for clarity's sake)

s64 div(struct clk *clk, u32 div) {
	s64 r;

	if (clk->flags & CLK_PARENT_RATE_MAX_U32)
		return ((u32)clk->parent->rate) / div;

	r = clk->parent->rate;
	do_div(r, div);
	return r;
}

00000000 <div>:
   0:	e92d4010 	push	{r4, lr}
   4:	e1a04001 	mov	r4, r1
   8:	e5d03010 	ldrb	r3, [r0, #16]
   c:	e3130001 	tst	r3, #1
  10:	1a000005 	bne	2c <div+0x2c>

  14:	e5903000 	ldr	r3, [r0]
  18:	e1c300d8 	ldrd	r0, [r3, #8]
  1c:	ebfffffe 	bl	0 <__do_div64>
  20:	e1a00002 	mov	r0, r2
  24:	e1a01003 	mov	r1, r3
  28:	e8bd8010 	pop	{r4, pc}

  2c:	e5900000 	ldr	r0, [r0]
  30:	e5900008 	ldr	r0, [r0, #8]
  34:	ebfffffe 	bl	0 <__aeabi_uidiv>
  38:	e3a01000 	mov	r1, #0
  3c:	e8bd8010 	pop	{r4, pc}


- Paul
