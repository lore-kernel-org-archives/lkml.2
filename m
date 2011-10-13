Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab1JMOoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:44:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49701 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab1JMOom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:44:42 -0400
Date: Thu, 13 Oct 2011 15:44:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, paul@pwsan.com, grant.likely@secretlab.ca,
        sboyd@quiinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Message-ID: <20111013144411.GC21648@n2100.arm.linux.org.uk>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com> <1316730422-20027-2-git-send-email-mturquette@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316730422-20027-2-git-send-email-mturquette@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 03:26:56PM -0700, Mike Turquette wrote:
>   struct clk_hw_ops {
>   	int		(*prepare)(struct clk_hw *);
>   	void		(*unprepare)(struct clk_hw *);
>   	int		(*enable)(struct clk_hw *);
>   	void		(*disable)(struct clk_hw *);
>   	unsigned long	(*recalc_rate)(struct clk_hw *);
>   	int		(*set_rate)(struct clk_hw *,
>   					unsigned long, unsigned long *);
>   	long		(*round_rate)(struct clk_hw *, unsigned long);
>   	int		(*set_parent)(struct clk_hw *, struct clk *);
>   	struct clk *	(*get_parent)(struct clk_hw *);
>   };
> 
> Platform clock code can register a clock through clk_register, passing a
> set of operations, and a pointer to hardware-specific data:
> 
>   struct clk_hw_foo {
>   	struct clk_hw clk;
>   	void __iomem *enable_reg;
>   };

Eww, no, this really isn't going to scale for platforms like OMAP - to
have all the operations indirected through a set of function pointers
for every clock just because the enable register (or enable bit) is
in a different position is completely absurd.

I'm not soo concerned about the increase in memory usage (for 100 to 200
clock definitions its only 4 to 8k) but what worries me the most is
initializing these damned things.  It's an awful lot of initializers,
which means the potential for an awful lot of conflicts should something
change in this structure.
