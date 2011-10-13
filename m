Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab1JMRQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 13:16:40 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:47838 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753793Ab1JMRQj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 13:16:39 -0400
MIME-Version: 1.0
In-Reply-To: <20111013144411.GC21648@n2100.arm.linux.org.uk>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-2-git-send-email-mturquette@ti.com> <20111013144411.GC21648@n2100.arm.linux.org.uk>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Thu, 13 Oct 2011 10:16:17 -0700
Message-ID: <CAJOA=zOTOSaAA=0v3+b2z6E8P-tVR7McSqpgYE6rnfNRx4r-Aw@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, paul@pwsan.com, grant.likely@secretlab.ca,
        sboyd@quiinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 7:44 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Sep 22, 2011 at 03:26:56PM -0700, Mike Turquette wrote:
>>   struct clk_hw_ops {
>>       int             (*prepare)(struct clk_hw *);
>>       void            (*unprepare)(struct clk_hw *);
>>       int             (*enable)(struct clk_hw *);
>>       void            (*disable)(struct clk_hw *);
>>       unsigned long   (*recalc_rate)(struct clk_hw *);
>>       int             (*set_rate)(struct clk_hw *,
>>                                       unsigned long, unsigned long *);
>>       long            (*round_rate)(struct clk_hw *, unsigned long);
>>       int             (*set_parent)(struct clk_hw *, struct clk *);
>>       struct clk *    (*get_parent)(struct clk_hw *);
>>   };
>>
>> Platform clock code can register a clock through clk_register, passing a
>> set of operations, and a pointer to hardware-specific data:
>>
>>   struct clk_hw_foo {
>>       struct clk_hw clk;
>>       void __iomem *enable_reg;
>>   };
>
> Eww, no, this really isn't going to scale for platforms like OMAP - to
> have all the operations indirected through a set of function pointers
> for every clock just because the enable register (or enable bit) is
> in a different position is completely absurd.

Russel,

I'm porting the OMAP clock framework to common clock right now and it
is going well.

For many clocks near the root of the tree I've been able to re-use
struct clk_hw_fixed & clk_fixed_ops (see patch 3 or 4 in this series),
which actually represents a decrease in memory consumption over the
old OMAP struct clk (which populated many of the operations func
pointers directly, causing duplication).

So far I don't see scalability as an issue.  In fact the design solves
some problems neatly for us.  For now I am creating one "uber clock",
struct clk_hw_omap, which dumps all of the clksel, pll, gate control &
mux crap directly from OMAP's old struct clk.  This is not optimal for
the long-term, but is a reasonable stepping stone which handles 90% of
OMAP clocks.  The new common struct clk makes it much easier for us to
treat PLLs differently from typical dividers, which can be treated
differently from dividers in modules, which can be treated differently
from pure mux clocks, etc.

> I'm not soo concerned about the increase in memory usage (for 100 to 200
> clock definitions its only 4 to 8k) but what worries me the most is
> initializing these damned things.  It's an awful lot of initializers,
> which means the potential for an awful lot of conflicts should something
> change in this structure.

As I stated above, so far memory usage has actually *decreased* due to
removing so many duplicated function pointers for OMAP's old struct
clk.  I wouldn't be surprised if other SoCs experienced the same lift.

Also, in my own tree I've broken out clk_register into clk_init also.
clk_register is still the thing to call if you have dynamically
created clocks, as it handles the malloc, and it then calls clk_init.
clk_init can be used by for static clock data and just handles
initializing the mutex/list/whatever.  Does this allay some of your
concerns?  Are you just trying to avoid allocating all of that memory
dynamically?

Regards,
Mike
