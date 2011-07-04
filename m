Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1GDE6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 00:58:39 -0400
Received: from mail.southpole.se ([193.12.106.18]:35496 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab1GDE6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 00:58:32 -0400
Subject: Re: [PATCH v2 02/19] OpenRISC: Device tree
From: Jonas Bonn <jonas@southpole.se>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <CACxGe6tFX=EQjaL-4EjSXquY5eh+bca29=d=cE5-YAVCUVRCvA@mail.gmail.com>
References: <1309641352-18714-1-git-send-email-jonas@southpole.se>
	 <1309641352-18714-3-git-send-email-jonas@southpole.se>
	 <CACxGe6tFX=EQjaL-4EjSXquY5eh+bca29=d=cE5-YAVCUVRCvA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole Consulting AB
Date: Mon, 04 Jul 2011 06:58:28 +0200
Message-ID: <1309755508.16393.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2011-07-03 at 14:51 -0600, Grant Likely wrote:
> On Sat, Jul 2, 2011 at 3:15 PM, Jonas Bonn <jonas@southpole.se> wrote:
> Does it really make sense to have an SoC node for this board?  I
> assume this is for a soft CPU system on a Diligent FPGA board.  It is
> best if the device tree structure matches the actual bus layout of the
> chip and/or FPGA design.  If the devices are directly on the CPU bus,
> then it is better to do without an soc node entirely and just put
> everything at the root.

Not sure I quite understand the distinction here.  Yes, it's a soft CPU,
but conceptually it has an internal bus (Wishbone) comparable to the
Avalon bus that the peripherals sit on.  I'd say it's an SoC; but I need
to ask: what constitutes a valid use of the "soc" node?

> > diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
> > index 49342e9..6ce6583 100644
> > --- a/arch/openrisc/kernel/setup.c
> > +++ b/arch/openrisc/kernel/setup.c
> > @@ -173,8 +173,7 @@ void __init setup_cpuinfo(void)
> >        unsigned long iccfgr,dccfgr;
> >        unsigned long cache_set_size, cache_ways;;
> >
> > -       cpu = (struct device_node *) of_find_compatible_node(NULL,
> > -                                       NULL, "opencores,openrisc-1200");
> > +       cpu = of_find_compatible_node(NULL, NULL, "opencores,openrisc-1200");
> 
> This looks odd.  Is it a stale hunk from a previous patch version?
> 

Hmmm... no, it's a hunk that should have been in patch 01/19 of the
series.  That said, there's a bit of devicetree code in that patch too.
Can I just say, "please have a look there, too", or do I need to pull
those bits out into the devicetree patch?

I've pasted in just the relevant parts from patch 01/19 below for ease
of review.

/Jonas

>From arch/openrisc/kernel/setup.c:

+static inline unsigned int fcpu(struct device_node *cpu, char *n)
+{
+        const int *val;
+        return (val = of_get_property(cpu, n, NULL)) ? *val : 0;
+}
+
+void __init setup_cpuinfo(void)
+{
+       struct device_node *cpu = NULL;
+       unsigned long iccfgr,dccfgr;
+       unsigned long cache_set_size, cache_ways;;
+
+       cpu = (struct device_node *) of_find_compatible_node(NULL,
+                                       NULL,
"opencores,openrisc-1200");
+       if (!cpu) {
+               panic("No compatible CPU found in device tree...\n");
+       }
+
+       iccfgr = mfspr(SPR_ICCFGR);
+       cache_ways = 1 << (iccfgr & SPR_ICCFGR_NCW);
+       cache_set_size = 1 << ((iccfgr & SPR_ICCFGR_NCS) >> 3);
+       cpuinfo.icache_block_size = 16 << ((iccfgr & SPR_ICCFGR_CBS) >>
7);
+       cpuinfo.icache_size = cache_set_size * cache_ways *
cpuinfo.icache_block_size;
+
+       dccfgr = mfspr(SPR_DCCFGR);
+       cache_ways = 1 << (dccfgr & SPR_DCCFGR_NCW);
+       cache_set_size = 1 << ((dccfgr & SPR_DCCFGR_NCS) >> 3);
+       cpuinfo.dcache_block_size = 16 << ((dccfgr & SPR_DCCFGR_CBS) >>
7);
+       cpuinfo.dcache_size = cache_set_size * cache_ways *
cpuinfo.dcache_block_size;
+
+       cpuinfo.clock_frequency =  fcpu(cpu, "clock-frequency");
+
+       of_node_put(cpu);
+
+       print_cpuinfo();
+}
+
+/**
+ * or32_early_setup
+ *
+ * Handles the pointer to the device tree that this kernel is to use
+ * for establishing the available platform devices.
+ *
+ * For now, this is limited to using the built-in device tree.  In the
future,
+ * it is intended that this function will take a pointer to the device
tree
+ * that is potentially built-in, but potentially also passed in by the
+ * bootloader, or discovered by some equally clever means...
+ */
+
+void __init or32_early_setup(void) {
+
+       early_init_devtree((void *) __dtb_start);
+
+       printk(KERN_INFO "Compiled-in FDT at 0x%08x\n",
+              (unsigned int) __dtb_start);
+}
+
+const struct of_device_id openrisc_bus_ids[] = {
+        { .type = "soc", },
+        { .compatible = "soc", },
+        {},
+};
+
+static int __init openrisc_device_probe(void)
+{
+        of_platform_bus_probe(NULL, openrisc_bus_ids, NULL);
+        return 0;
+}
+device_initcall(openrisc_device_probe);



