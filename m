Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab2HXE3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 00:29:25 -0400
Received: from mta04.xtra.co.nz ([210.54.141.251]:26364 "EHLO mta01.xtra.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753015Ab2HXE3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 00:29:23 -0400
Message-ID: <1345782559.20538.22.camel@gitbox>
Subject: Re: [PATCH 1/1] clk: add DT support for clock gating control
From: Tony Prisk <linux@prisktech.co.nz>
To: Mike Turquette <mturquette@ti.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 24 Aug 2012 16:29:19 +1200
In-Reply-To: <20120824023135.4547.2534@nucleus>
References: <1341767726-25630-1-git-send-email-sebastian.hesselbarth@googlemail.com>
	 <20120824023135.4547.2534@nucleus>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 19:31 -0700, Mike Turquette wrote:
> Quoting Sebastian Hesselbarth (2012-07-08 10:15:26)
> > This patch adds support for using clock gates (clk-gate) from DT based
> > on Rob Herrings DT clk binding support for 3.6.
> > 
> > It adds a helper function to clk-gate to allocate all resources required by
> > a set of individual clock gates, i.e. register base address and lock. Each
> > clock gate is described as a child of the clock-gating-control in DT and
> > also created by the helper function.
> > 
> 
> Hi Sebastian,
> 
> Thanks for submitting this.  I'd prefer for Rob or someone with a more vested
> interest in DT to review your binding.  I have some comments on the code below.
> 
> <snip>
> > diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
> > index 578465e..1e88907 100644
> > --- a/drivers/clk/clk-gate.c
> > +++ b/drivers/clk/clk-gate.c
> > @@ -15,6 +15,9 @@
> >  #include <linux/io.h>
> >  #include <linux/err.h>
> >  #include <linux/string.h>
> > +#include <linux/of.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_platform.h>
> >  
> >  /**
> >   * DOC: basic gatable clock which can gate and ungate it's ouput
> > @@ -148,3 +151,84 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
> >  
> >         return clk;
> >  }
> > +
> > +#ifdef CONFIG_OF
> > +/**
> > + * of_clock_gating_control_setup() - Setup function for clock gate control
> > + *   This is a helper for using clk-gate from OF device tree. It allocates
> > + *   a common lock for a base register and creates the individual clk-gates.
> > + */
> > +void __init of_clock_gating_control_setup(struct device_node *np)
> > +{
> > +       struct device_node *child;
> > +       const char *pclk_name;
> > +       void __iomem *base;
> > +       spinlock_t *lockp;
> > +       unsigned int rnum;
> > +       u64 addr;
> > +
> > +       pclk_name = of_clk_get_parent_name(np, 0);
> > +       if (!pclk_name) {
> > +               pr_debug("%s: unable to get parent clock for %s\n",
> > +                       __func__, np->full_name);
> > +               return;
> > +       }
> > +
> > +       lockp = kzalloc(sizeof(spinlock_t), GFP_KERNEL);
> > +       if (!lockp) {
> > +               pr_debug("%s: unable to allocate spinlock for %s\n",
> > +                        __func__, np->full_name);
> > +               return;
> > +       }
> > +
> > +       spin_lock_init(lockp);
> 
> The spinlocks for the basic clock types have always been optional.  This
> code should reflect that and not assume the spinlock.
> 
> Also I wonder if the assumption is true that a single spinlock
> corresponding to a device_node is always the right thing for every
> platform.  What about a 32-bit register that contains some gating bits
> and a 3-bit wide field for a mux which we perform read-modify-write
> operations on?
> 
> You'll have to pardon my DT ignorance.  My concerns above may be totally
> crazy with respect to DT.

This also requires you to split your gated clocks in seperate nodes by
register if you don't want unrelated clocks locking each other out.
Also, you need a method of 'sharing' the lock outside of the gated-clock
for use by other clock types that may share the same register.

> 
> > +       base = of_iomap(np, 0);
> > +       rnum = sizeof(resource_size_t) * 8;
> > +       addr = of_translate_address(np, of_get_property(np, "reg", NULL));
> > +
> > +       pr_debug("create clock gate control %s\n", np->full_name);
> 
> There are some inconsistent prints here.  How about leading this trace
> with a __func__ like you do below for the error messages?
> 
> > +
> > +       for_each_child_of_node(np, child) {
> > +               struct clk *cg;
> > +               const char *cg_name;
> > +               const char *cg_pclk_name;
> > +               u32 propval[2];
> > +               unsigned int rbit;
> > +
> > +               if (of_property_read_u32_array(child, "reg", propval, 2)) {
> > +                       pr_debug("%s: wrong #reg on %s\n",
> > +                                __func__, child->full_name);
> > +                       continue;
> > +               }
Are you assuming that all gated-clocks will be contained within a parent
node with:
#address-cells = <1>;
#size-cells = <1>;
with no other types of clocks? This generally isn't how people are
writing their device tree files.

Looking through the current dts files, the platforms that are using
clocks to any real degree are using address=1, size=0.
The only ones I see with 1/1 are only defining a fixed-clock and don't
use the reg property anyway so could just as well be 1/0.

It might be better to pass the bit field as a separate property rather
than requiring people change their reg property to suit.

myclock {
	reg = <0x0120>;
	enable-bit = <22>;
};


Regards

Tony Prisk

