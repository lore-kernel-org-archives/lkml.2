Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab1BBGVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 01:21:19 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58543 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab1BBGVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 01:21:18 -0500
Date: Tue, 1 Feb 2011 23:21:11 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: John Linn <John.Linn@xilinx.com>
Cc: nicolas.pitre@linaro.org, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        buytenh@wantstofly.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: FW: [PATCH v2 4/6] arm/dt: probe for platforms via the device
 tree
Message-ID: <20110202062111.GC16543@angua.secretlab.ca>
References: <fba2dfb3-3d84-4db0-a765-ad252bdab3ea@VA3EHSMHS021.ehs.local>
 <AANLkTim=+Oa=JjrvzR+XYgNm_YSjGVtwP76W_TNODJ5M@mail.gmail.com>
 <7f92c231-05d4-4b3c-a8e2-8cf241d0c17b@VA3EHSMHS028.ehs.local>
 <AANLkTi=O6zOO+nx3gdVoDB2Q6rD+gRMyrvO04XdgxXtW@mail.gmail.com>
 <c55eb92d-bca0-4047-bbf9-7d532e37154d@VA3EHSMHS029.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Description: evicetree-discuss@lists.ozlabs.org,evicetree-discuss@lists.ozlabs.org,
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c55eb92d-bca0-4047-bbf9-7d532e37154d@VA3EHSMHS029.ehs.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[restored cc: list]

On Tue, Feb 01, 2011 at 08:11:15AM -0700, John Linn wrote:
> OK, I see your changes don't really help the problem with device
> trees up higher.
> 
> The problem is that in setup_machine_fdt the kernel can't get to the
> memory where the device tree is located if it's up higher.

No, there is another patch to solve that problem from Rob Herring.
I've not yet picked it up into my tree, but I will be doing so soon.
For now the dtb needs to be located inside the first 16k of ram.

However, it can no longer be based at 0 either.  I discovered that if
the dt is based at zero, then the kernel is unable to tell the
different between no atags/dtb passed and a dtb passed at physical
address 0.  At the very least it needs to be offset about 16 bytes.
Since it is common to put atags at address 0x100, it is also
reasonable to use 0x100 as the dtb base address too.

This problem doesn't exist for machines with ram based at physical
address != 0.

Sorry I wasn't clear when I posted this.  There is still a bit of flux
to get the interface correct and I accidentally glossed over this
detail.

> The new stuff you added doesn't run early enough to take care of this problem.

The problem I was trying to solve is that I was seeing device tree
corruption later in the boot process, but it now seems that I might
have misdiagnosed it.  I'm still investigation, but I may end up
reverting the memblock_reserve() change.

> 
> I probably should have reviewed the patches instead of testing as I
> would have realized that.
> 
> I'm looking to see if I can understand how to help the problem.
> 
> Should I really just respond to the mailing list instead of this
> back channel?  I don't know good behavior from bad sometimes.

Yes, please feel totally free to respond on the mailing list (I went
ahead and restored the cc list on this reply).  Just remember to
bottom post when replying on-list.

g.

> 
> > -----Original Message-----
> > From: John Linn
> > Sent: Monday, January 31, 2011 5:53 PM
> > To: John Linn; 'Grant Likely'
> > Subject: RE: FW: [PATCH v2 4/6] arm/dt: probe for platforms via the device tree
> > 
> > Weird, got it to work with dtb at 0x1000, but not anywhere else. Have tried 0x1000000 and 0x600000
> > without success.
> > 
> > Seems to be stopped in exceptions when I look at PC, haven't tried to debug yet, but looks like the
> > same problem to me.
> > 
> > Did you have luck with your testing, maybe I'm doing something wrong.
> > 
> > > -----Original Message-----
> > > From: John Linn
> > > Sent: Monday, January 31, 2011 5:28 PM
> > > To: John Linn; 'Grant Likely'
> > > Subject: RE: FW: [PATCH v2 4/6] arm/dt: probe for platforms via the device tree
> > >
> > > You forgot to tell me that I can no longer have a device tree at address 0 which was previously
> > > working.
> > >
> > > That new check for a value of 0 for the address make it's not work anymore.
> > >
> > > Is there a reason for that?  Seems overkill since there's a magic value already. Maybe someone made
> > > you add that.
> > >
> > > Anyway, now it's starting to work again after I hacked out that check. I'll put it back in and test
> > at
> > > non-zero locations.
> > >
> > >
> > > > -----Original Message-----
> > > > From: John Linn
> > > > Sent: Monday, January 31, 2011 4:50 PM
> > > > To: 'Grant Likely'
> > > > Subject: RE: FW: [PATCH v2 4/6] arm/dt: probe for platforms via the device tree
> > > >
> > > > Very odd, it's not finding the device tree at all when it boots.
> > > >
> > > > Have you seen anything like that?
> > > >
> > > > Still debugging it.
> > > >
> > > > > -----Original Message-----
> > > > > From: glikely@secretlab.ca [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
> > > > > Sent: Monday, January 31, 2011 2:58 PM
> > > > > To: John Linn
> > > > > Subject: Re: FW: [PATCH v2 4/6] arm/dt: probe for platforms via the device tree
> > > > >
> > > > > On Mon, Jan 31, 2011 at 2:42 PM, John Linn <John.Linn@xilinx.com> wrote:
> > > > > >> -----Original Message-----
> > > > > >> From: glikely@secretlab.ca [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
> > > > > >> Sent: Monday, January 31, 2011 2:11 PM
> > > > > >> To: John Linn
> > > > > >> Subject: Re: FW: [PATCH v2 4/6] arm/dt: probe for platforms via the device tree
> > > > > >>
> > > > > >> On Mon, Jan 31, 2011 at 2:08 PM, John Linn <John.Linn@xilinx.com> wrote:
> > > > > >> > I'm trying to think what's the easiest way for me to retest.
> > > > > >> >
> > > > > >> > I have a branch with 2.6.38-rc1 then your tree merged, then a couple commits of my own on
> > > top.
> > > > > >> >
> > > > > >> > Are these all in your tree?
> > > > > >>
> > > > > >> If you're based on devicetree/arm, then you should be able to just
> > > > > >> merge it again to get the changes.  I haven't rebased that branch.  In
> > > > > >> fact, the top commit on devicetree/arm will show you the exact diff
> > > > > >> between this series and the previous version.
> > > > > >
> > > > > > Unfortunately moving to 2.6.38-rc2 breaks some stuff. I was surprised but there's still quite
> > a
> > > > bit
> > > > > > of change from rc1 to rc2.
> > > > > >
> > > > > > Still trying to see what all is broken. They moved serial drivers under tty for one thing.
> > > > >
> > > > > You could also directly apply the patches on top of 2.6.38-rc1.  That
> > > > > should work too.
> > > > >
> > > > > g.
> > > > >
> > > > > >
> > > > > > -- John
> > > > > >
> > > > > >>
> > > > > >> > Should I retest the whole set of v2 patches or just the one the one that was problem?
> > > > > >>
> > > > > >> The whole tree.
> > > > > >>
> > > > > >> Thanks,
> > > > > >> g.
> > > > > >>
> > > > > >> >
> > > > > >> >> -----Original Message-----
> > > > > >> >> From: Grant Likely [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
> > > > > >> >> Sent: Monday, January 31, 2011 2:04 PM
> > > > > >> >> To: nicolas.pitre@linaro.org; Russell King; Catalin Marinas; devicetree-
> > > > > discuss@lists.ozlabs.org;
> > > > > >> >> linux-kernel@vger.kernel.org; buytenh@wantstofly.org; Olof Johansson; John Linn; linux-
> > arm-
> > > > > >> >> kernel@lists.infradead.org
> > > > > >> >> Subject: [PATCH v2 4/6] arm/dt: probe for platforms via the device tree
> > > > > >> >>
> > > > > >> >> If a dtb is passed to the kernel then the kernel needs to iterate
> > > > > >> >> through compiled-in mdescs looking for one that matches and move the
> > > > > >> >> dtb data to a safe location before it gets accidentally overwritten by
> > > > > >> >> the kernel.
> > > > > >> >>
> > > > > >> >> This patch creates a new function, setup_machine_fdt() which is
> > > > > >> >> analogous to the setup_machine_atags() created in the previous patch.
> > > > > >> >> It does all the early setup needed to use a device tree machine
> > > > > >> >> description.  It also creates arm_unflatten_device_tree() which copies
> > > > > >> >> the dtb into an allocated buffer and unflattens it into the live-tree
> > > > > >> >> representation.
> > > > > >> >>
> > > > > >> >> v2: Changed to save the dtb by copying into an allocated buffer.
> > > > > >> >>     - Since the dtb will very likely be passed in the first 16k of ram
> > > > > >> >>       where the interrupt vectors live, memblock_reserve() is
> > > > > >> >>       insufficient to protect the dtb data.
> > > > > >> >> [based on work originally written by Jeremy Kerr <jeremy.kerr@canonical.com>]
> > > > > >> >> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > > > > >> >> ---
> > > > > >> >>  arch/arm/include/asm/mach/arch.h |    2 +
> > > > > >> >>  arch/arm/include/asm/prom.h      |   11 +++++
> > > > > >> >>  arch/arm/include/asm/setup.h     |    1
> > > > > >> >>  arch/arm/kernel/devtree.c        |   87 ++++++++++++++++++++++++++++++++++++++
> > > > > >> >>  arch/arm/kernel/setup.c          |   10 +++-
> > > > > >> >>  arch/arm/mm/init.c               |    8 +++
> > > > > >> >>  6 files changed, 117 insertions(+), 2 deletions(-)
> > > > > >> >>
> > > > > >> >> diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
> > > > > >> >> index 3a0893a..2ed24e7 100644
> > > > > >> >> --- a/arch/arm/include/asm/mach/arch.h
> > > > > >> >> +++ b/arch/arm/include/asm/mach/arch.h
> > > > > >> >> @@ -22,6 +22,8 @@ struct machine_desc {
> > > > > >> >>       unsigned int            nr;             /* architecture number  */
> > > > > >> >>       const char              *name;          /* architecture name    */
> > > > > >> >>       unsigned long           boot_params;    /* tagged list          */
> > > > > >> >> +     const char              **dt_compat;    /* array of device tree
> > > > > >> >> +                                              * 'compatible' strings */
> > > > > >> >>
> > > > > >> >>       unsigned int            nr_irqs;        /* number of IRQs */
> > > > > >> >>
> > > > > >> >> diff --git a/arch/arm/include/asm/prom.h b/arch/arm/include/asm/prom.h
> > > > > >> >> index 8f1037f..6ba62a8 100644
> > > > > >> >> --- a/arch/arm/include/asm/prom.h
> > > > > >> >> +++ b/arch/arm/include/asm/prom.h
> > > > > >> >> @@ -21,5 +21,16 @@ static inline void irq_dispose_mapping(unsigned int virq)
> > > > > >> >>       return;
> > > > > >> >>  }
> > > > > >> >>
> > > > > >> >> +extern void arm_unflatten_device_tree(void);
> > > > > >> >> +extern struct machine_desc *setup_machine_fdt(unsigned int dt_phys);
> > > > > >> >> +
> > > > > >> >> +#else /* CONFIG_OF */
> > > > > >> >> +
> > > > > >> >> +static void arm_unflatten_device_tree(void) { }
> > > > > >> >> +static inline struct machine_desc *setup_machine_fdt(unsigned int dt_phys)
> > > > > >> >> +{
> > > > > >> >> +     return NULL;
> > > > > >> >> +}
> > > > > >> >> +
> > > > > >> >>  #endif /* CONFIG_OF */
> > > > > >> >>  #endif /* ASMARM_PROM_H */
> > > > > >> >> diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
> > > > > >> >> index 06c4d0e..1cec82a 100644
> > > > > >> >> --- a/arch/arm/include/asm/setup.h
> > > > > >> >> +++ b/arch/arm/include/asm/setup.h
> > > > > >> >> @@ -222,6 +222,7 @@ extern struct meminfo meminfo;
> > > > > >> >>  #define bank_phys_size(bank) (bank)->size
> > > > > >> >>
> > > > > >> >>  extern int arm_add_memory(unsigned long start, unsigned long size);
> > > > > >> >> +extern char cmd_line[COMMAND_LINE_SIZE];
> > > > > >> >>
> > > > > >> >>  #endif  /*  __KERNEL__  */
> > > > > >> >>
> > > > > >> >> diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
> > > > > >> >> index ac48da2..07b75bb 100644
> > > > > >> >> --- a/arch/arm/kernel/devtree.c
> > > > > >> >> +++ b/arch/arm/kernel/devtree.c
> > > > > >> >> @@ -21,6 +21,7 @@
> > > > > >> >>
> > > > > >> >>  #include <asm/setup.h>
> > > > > >> >>  #include <asm/page.h>
> > > > > >> >> +#include <asm/mach/arch.h>
> > > > > >> >>
> > > > > >> >>  void __init early_init_dt_add_memory_arch(u64 base, u64 size)
> > > > > >> >>  {
> > > > > >> >> @@ -45,3 +46,89 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
> > > > > >> >>       return intspec[0];
> > > > > >> >>  }
> > > > > >> >>  EXPORT_SYMBOL_GPL(irq_create_of_mapping);
> > > > > >> >> +
> > > > > >> >> +extern struct machine_desc __arch_info_begin, __arch_info_end;
> > > > > >> >> +
> > > > > >> >> +/**
> > > > > >> >> + * arm_unflatten_device_tree - Copy dtb into a safe area and unflatten it.
> > > > > >> >> + *
> > > > > >> >> + * Copies the dtb out of initial memory and into an allocated block so that
> > > > > >> >> + * it doesn't get overwritten by the kernel and then unflatten it into the
> > > > > >> >> + * live tree representation.
> > > > > >> >> + */
> > > > > >> >> +void __init arm_unflatten_device_tree(void)
> > > > > >> >> +{
> > > > > >> >> +     struct boot_param_header *devtree;
> > > > > >> >> +     u32 dtb_size;
> > > > > >> >> +
> > > > > >> >> +     if (!initial_boot_params)
> > > > > >> >> +             return;
> > > > > >> >> +
> > > > > >> >> +     /* Save the dtb to an allocated buffer */
> > > > > >> >> +     dtb_size = be32_to_cpu(initial_boot_params->totalsize);
> > > > > >> >> +     devtree = early_init_dt_alloc_memory_arch(dtb_size, SZ_4K);
> > > > > >> >> +     if (!devtree) {
> > > > > >> >> +             printk("Unable to allocate memory for device tree\n");
> > > > > >> >> +             while(1);
> > > > > >> >> +     }
> > > > > >> >> +     pr_info("relocating device tree from 0x%p to 0x%p, length 0x%x\n",
> > > > > >> >> +             initial_boot_params, devtree, dtb_size);
> > > > > >> >> +     memmove(devtree, initial_boot_params, dtb_size);
> > > > > >> >> +     initial_boot_params = devtree;
> > > > > >> >> +
> > > > > >> >> +     unflatten_device_tree();
> > > > > >> >> +}
> > > > > >> >> +
> > > > > >> >> +/**
> > > > > >> >> + * setup_machine_fdt - Machine setup when an dtb was passed to the kernel
> > > > > >> >> + * @dt_phys: physical address of dt blob
> > > > > >> >> + *
> > > > > >> >> + * If a dtb was passed to the kernel in r2, then use it to choose the
> > > > > >> >> + * correct machine_desc and to setup the system.
> > > > > >> >> + */
> > > > > >> >> +struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
> > > > > >> >> +{
> > > > > >> >> +     struct boot_param_header *devtree = phys_to_virt(dt_phys);
> > > > > >> >> +     struct machine_desc *mdesc, *mdesc_best = NULL;
> > > > > >> >> +     unsigned int score, mdesc_score = ~1;
> > > > > >> >> +     unsigned long dt_root;
> > > > > >> >> +     const char *model;
> > > > > >> >> +
> > > > > >> >> +     /* check device tree validity */
> > > > > >> >> +     if (!dt_phys || be32_to_cpu(devtree->magic) != OF_DT_HEADER)
> > > > > >> >> +             return NULL;
> > > > > >> >> +
> > > > > >> >> +     /* Search the mdescs for the 'best' compatible value match */
> > > > > >> >> +     initial_boot_params = devtree;
> > > > > >> >> +
> > > > > >> >> +     dt_root = of_get_flat_dt_root();
> > > > > >> >> +     for (mdesc = &__arch_info_begin; mdesc < &__arch_info_end; mdesc++) {
> > > > > >> >> +             score = of_flat_dt_match(dt_root, mdesc->dt_compat);
> > > > > >> >> +             if (score > 0 && score < mdesc_score) {
> > > > > >> >> +                     mdesc_best = mdesc;
> > > > > >> >> +                     mdesc_score = score;
> > > > > >> >> +             }
> > > > > >> >> +     }
> > > > > >> >> +     if (!mdesc_best) {
> > > > > >> >> +             printk("Machine not supported, unable to continue.\n");
> > > > > >> >> +             while (1);
> > > > > >> >> +     }
> > > > > >> >> +
> > > > > >> >> +     model = of_get_flat_dt_prop(dt_root, "model", NULL);
> > > > > >> >> +     if (!model)
> > > > > >> >> +             model = of_get_flat_dt_prop(dt_root, "compatible", NULL);
> > > > > >> >> +     if (!model)
> > > > > >> >> +             model = "<unknown>";
> > > > > >> >> +     pr_info("Machine: %s, model: %s\n", mdesc_best->name, model);
> > > > > >> >> +
> > > > > >> >> +     /* Retrieve various information from the /chosen node */
> > > > > >> >> +     of_scan_flat_dt(early_init_dt_scan_chosen, NULL);
> > > > > >> >> +     /* Initialize {size,address}-cells info */
> > > > > >> >> +     of_scan_flat_dt(early_init_dt_scan_root, NULL);
> > > > > >> >> +     /* Setup memory, calling early_init_dt_add_memory_arch */
> > > > > >> >> +     of_scan_flat_dt(early_init_dt_scan_memory, NULL);
> > > > > >> >> +     /* Save command line for /proc/cmdline  */
> > > > > >> >> +     strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
> > > > > >> >> +
> > > > > >> >> +     return mdesc_best;
> > > > > >> >> +}
> > > > > >> >> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> > > > > >> >> index cbc1836..68e0204 100644
> > > > > >> >> --- a/arch/arm/kernel/setup.c
> > > > > >> >> +++ b/arch/arm/kernel/setup.c
> > > > > >> >> @@ -20,6 +20,7 @@
> > > > > >> >>  #include <linux/screen_info.h>
> > > > > >> >>  #include <linux/init.h>
> > > > > >> >>  #include <linux/kexec.h>
> > > > > >> >> +#include <linux/of_fdt.h>
> > > > > >> >>  #include <linux/crash_dump.h>
> > > > > >> >>  #include <linux/root_dev.h>
> > > > > >> >>  #include <linux/cpu.h>
> > > > > >> >> @@ -42,6 +43,7 @@
> > > > > >> >>  #include <asm/cachetype.h>
> > > > > >> >>  #include <asm/tlbflush.h>
> > > > > >> >>
> > > > > >> >> +#include <asm/prom.h>
> > > > > >> >>  #include <asm/mach/arch.h>
> > > > > >> >>  #include <asm/mach/irq.h>
> > > > > >> >>  #include <asm/mach/time.h>
> > > > > >> >> @@ -125,7 +127,7 @@ EXPORT_SYMBOL(elf_platform);
> > > > > >> >>
> > > > > >> >>  static const char *cpu_name;
> > > > > >> >>  static const char *machine_name;
> > > > > >> >> -static char __initdata cmd_line[COMMAND_LINE_SIZE];
> > > > > >> >> +char cmd_line[COMMAND_LINE_SIZE];
> > > > > >> >>  struct machine_desc *machine_desc __initdata;
> > > > > >> >>
> > > > > >> >>  static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
> > > > > >> >> @@ -838,7 +840,9 @@ void __init setup_arch(char **cmdline_p)
> > > > > >> >>       unwind_init();
> > > > > >> >>
> > > > > >> >>       setup_processor();
> > > > > >> >> -     mdesc = setup_machine_tags(machine_arch_type);
> > > > > >> >> +     mdesc = setup_machine_fdt(__atags_pointer);
> > > > > >> >> +     if (!mdesc)
> > > > > >> >> +             mdesc = setup_machine_tags(machine_arch_type);
> > > > > >> >>       machine_desc = mdesc;
> > > > > >> >>       machine_name = mdesc->name;
> > > > > >> >>
> > > > > >> >> @@ -859,6 +863,8 @@ void __init setup_arch(char **cmdline_p)
> > > > > >> >>       paging_init(mdesc);
> > > > > >> >>       request_standard_resources(mdesc);
> > > > > >> >>
> > > > > >> >> +     arm_unflatten_device_tree();
> > > > > >> >> +
> > > > > >> >>  #ifdef CONFIG_SMP
> > > > > >> >>       if (is_smp())
> > > > > >> >>               smp_init_cpus();
> > > > > >> >> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> > > > > >> >> index 5164069..62ff2e8 100644
> > > > > >> >> --- a/arch/arm/mm/init.c
> > > > > >> >> +++ b/arch/arm/mm/init.c
> > > > > >> >> @@ -71,6 +71,14 @@ static int __init parse_tag_initrd2(const struct tag *tag)
> > > > > >> >>
> > > > > >> >>  __tagtable(ATAG_INITRD2, parse_tag_initrd2);
> > > > > >> >>
> > > > > >> >> +#ifdef CONFIG_OF_FLATTREE
> > > > > >> >> +void __init early_init_dt_setup_initrd_arch(unsigned long start, unsigned long end)
> > > > > >> >> +{
> > > > > >> >> +     phys_initrd_start = start;
> > > > > >> >> +     phys_initrd_size = end - start + 1;
> > > > > >> >> +}
> > > > > >> >> +#endif /* CONFIG_OF_FLATTREE */
> > > > > >> >> +
> > > > > >> >>  /*
> > > > > >> >>   * This keeps memory configuration data used by a couple memory
> > > > > >> >>   * initialization functions, as well as show_mem() for the skipping
> > > > > >> >>
> > > > > >> >
> > > > > >> >
> > > > > >> > This email and any attachments are intended for the sole use of the named recipient(s) and
> > > > > >> contain(s) confidential information that may be proprietary, privileged or copyrighted under
> > > > > >> applicable law. If you are not the intended recipient, do not read, copy, or forward this
> > email
> > > > > >> message or any attachments. Delete this email message and any attachments immediately.
> > > > > >> >
> > > > > >>
> > > > > >>
> > > > > >>
> > > > > >> --
> > > > > >> Grant Likely, B.Sc., P.Eng.
> > > > > >> Secret Lab Technologies Ltd.
> > > > > >
> > > > > >
> > > > > > This email and any attachments are intended for the sole use of the named recipient(s) and
> > > > > contain(s) confidential information that may be proprietary, privileged or copyrighted under
> > > > > applicable law. If you are not the intended recipient, do not read, copy, or forward this email
> > > > > message or any attachments. Delete this email message and any attachments immediately.
> > > > > >
> > > > > >
> > > > > >
> > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Grant Likely, B.Sc., P.Eng.
> > > > > Secret Lab Technologies Ltd.
> 
> 
> This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
> 
> 
