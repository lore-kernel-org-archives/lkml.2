Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1GDFf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 01:35:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32860 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab1GDFf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 01:35:56 -0400
Date: Sun, 3 Jul 2011 23:35:52 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2 02/19] OpenRISC: Device tree
Message-ID: <20110704053552.GA15152@ponder.secretlab.ca>
References: <1309641352-18714-1-git-send-email-jonas@southpole.se>
 <1309641352-18714-3-git-send-email-jonas@southpole.se>
 <CACxGe6tFX=EQjaL-4EjSXquY5eh+bca29=d=cE5-YAVCUVRCvA@mail.gmail.com>
 <1309755508.16393.18.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309755508.16393.18.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 06:58:28AM +0200, Jonas Bonn wrote:
> 
> On Sun, 2011-07-03 at 14:51 -0600, Grant Likely wrote:
> > On Sat, Jul 2, 2011 at 3:15 PM, Jonas Bonn <jonas@southpole.se> wrote:
> > Does it really make sense to have an SoC node for this board?  I
> > assume this is for a soft CPU system on a Diligent FPGA board.  It is
> > best if the device tree structure matches the actual bus layout of the
> > chip and/or FPGA design.  If the devices are directly on the CPU bus,
> > then it is better to do without an soc node entirely and just put
> > everything at the root.
> 
> Not sure I quite understand the distinction here.  Yes, it's a soft CPU,
> but conceptually it has an internal bus (Wishbone) comparable to the
> Avalon bus that the peripherals sit on.  I'd say it's an SoC; but I need
> to ask: what constitutes a valid use of the "soc" node?

An soc node is really just a convenient collection node for devices on
an SoC.  It can be used, or not, depending on the SoC and whoever is
writing the bindings for it.

Regardless, the device tree hierarchy should reflect the actual layout
of the buses, and devices on the same bus segment should be siblings
in the tree.  Often when I work on an FPGA system, I don't even bother
with an soc node because it is kind of meaningless, and I just start
with knowing that the root of the tree represents the CPU local bus,
and then creating nodes for each bridge to another bus.  If all the
devices are on the same bus segment, then it looks pretty much like
what you wrote except that the node name for the bridge would probably
be something like "wishbone-bus".

Basically, I'm suggesting to make the DT model as representative of
the FPGA design as possible.

> > > diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
> > > index 49342e9..6ce6583 100644
> > > --- a/arch/openrisc/kernel/setup.c
> > > +++ b/arch/openrisc/kernel/setup.c
> > > @@ -173,8 +173,7 @@ void __init setup_cpuinfo(void)
> > >        unsigned long iccfgr,dccfgr;
> > >        unsigned long cache_set_size, cache_ways;;
> > >
> > > -       cpu = (struct device_node *) of_find_compatible_node(NULL,
> > > -                                       NULL, "opencores,openrisc-1200");
> > > +       cpu = of_find_compatible_node(NULL, NULL, "opencores,openrisc-1200");
> > 
> > This looks odd.  Is it a stale hunk from a previous patch version?
> > 
> 
> Hmmm... no, it's a hunk that should have been in patch 01/19 of the
> series.  That said, there's a bit of devicetree code in that patch too.
> Can I just say, "please have a look there, too", or do I need to pull
> those bits out into the devicetree patch?

No, you don't need to pull it out into this patch, but when you respin
you should fix the series to not include this hunk in patch 2.

> 
> I've pasted in just the relevant parts from patch 01/19 below for ease
> of review.
> 
> /Jonas
> 
> From arch/openrisc/kernel/setup.c:
> 
> +static inline unsigned int fcpu(struct device_node *cpu, char *n)
> +{
> +        const int *val;
> +        return (val = of_get_property(cpu, n, NULL)) ? *val : 0;

be32_to_cpup(val) should be used here.

However, of_property_read_u32() is now available to be used with the
correct data size checking.

> +}
> +
> +void __init setup_cpuinfo(void)
> +{
> +       struct device_node *cpu = NULL;

No need to initialize this to NULL, it is immediately set at the start
of the function.

> +       unsigned long iccfgr,dccfgr;
> +       unsigned long cache_set_size, cache_ways;;
> +
> +       cpu = (struct device_node *) of_find_compatible_node(NULL,
> +                                       NULL,
> "opencores,openrisc-1200");

Why the cast?  I looks like it can be dropped.

> +       if (!cpu) {
> +               panic("No compatible CPU found in device tree...\n");
> +       }
> +
> +       iccfgr = mfspr(SPR_ICCFGR);
> +       cache_ways = 1 << (iccfgr & SPR_ICCFGR_NCW);
> +       cache_set_size = 1 << ((iccfgr & SPR_ICCFGR_NCS) >> 3);
> +       cpuinfo.icache_block_size = 16 << ((iccfgr & SPR_ICCFGR_CBS) >>
> 7);
> +       cpuinfo.icache_size = cache_set_size * cache_ways *
> cpuinfo.icache_block_size;
> +
> +       dccfgr = mfspr(SPR_DCCFGR);
> +       cache_ways = 1 << (dccfgr & SPR_DCCFGR_NCW);
> +       cache_set_size = 1 << ((dccfgr & SPR_DCCFGR_NCS) >> 3);
> +       cpuinfo.dcache_block_size = 16 << ((dccfgr & SPR_DCCFGR_CBS) >>
> 7);
> +       cpuinfo.dcache_size = cache_set_size * cache_ways *
> cpuinfo.dcache_block_size;
> +
> +       cpuinfo.clock_frequency =  fcpu(cpu, "clock-frequency");
> +
> +       of_node_put(cpu);
> +
> +       print_cpuinfo();
> +}
> +
> +/**
> + * or32_early_setup
> + *
> + * Handles the pointer to the device tree that this kernel is to use
> + * for establishing the available platform devices.
> + *
> + * For now, this is limited to using the built-in device tree.  In the
> future,
> + * it is intended that this function will take a pointer to the device
> tree
> + * that is potentially built-in, but potentially also passed in by the
> + * bootloader, or discovered by some equally clever means...
> + */
> +
> +void __init or32_early_setup(void) {
> +
> +       early_init_devtree((void *) __dtb_start);

Isn't __dtb_start already a void*?

> +
> +       printk(KERN_INFO "Compiled-in FDT at 0x%08x\n",

pr_info()

use %p for pointers.

> +              (unsigned int) __dtb_start);
> +}
> +
> +const struct of_device_id openrisc_bus_ids[] = {
> +        { .type = "soc", },

Never use .type for new code.  Only .compatible should be checked.

> +        { .compatible = "soc", },

Use "simple-bus".  "soc" isn't defined to mean anything (see the ePAPR
spec).

> +        {},
> +};
> +
> +static int __init openrisc_device_probe(void)
> +{
> +        of_platform_bus_probe(NULL, openrisc_bus_ids, NULL);

Use of_platform_populate() instead (in linux-next, or the
devicetree/next branch at git://git.secretlab.ca/git/linux-2.6).
of_platform_populate() is better at handling devices at the root of
the device tree, and it properly ignores nodes that don't have a
compatible property.

g.
