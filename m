Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030210Ab2CIVsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:48:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36588 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932444Ab2CIVso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:48:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arnd Bergmann <arnd@arndb.de>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [GIT PULL] Renesas SoC updates for v3.4
Date: Fri, 9 Mar 2012 22:52:47 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>, Rob Herring <robherring2@gmail.com>
References: <201203092155.04731.rjw@sisk.pl> <201203092134.30191.arnd@arndb.de>
In-Reply-To: <201203092134.30191.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203092252.48110.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, March 09, 2012, Arnd Bergmann wrote:
> On Friday 09 March 2012, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > Please pull Renesas SoC updates for v3.4 since commit
> > ce8fea7aa4ad9e3b40999a08622ef27c77159659:
> > 
> >     mmap: EINVAL not ENOMEM when rejecting VM_GROWS
> > 
> > with top-most commit f57fd2100e8273af3a9d2ff67714903d2dfd1eef
> 
> Hi Rafael,
> 
> Please rebase this on an -rc release, otherwise we get a rather
> messy history in the arm-soc tree.

Well, OK, I can rebase it on -rc7 if there is one, unless Paul
has already pulled from clk_ops-rename.  Paul?

> >     ARM: mach-shmobile: default to no earlytimer
> > 
> > from the git repository at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/rafael/renesas.git soc
> > 
> > They include:
> > 
> > * The rename of shmobile struct clk_ops to struct sh_clk_ops to avoid
> >   possible future name space collision with common struct clk code.
> > 
> >   This also affects drivers that are shared with the sh architecture,
> >   so the branch containing this part of the material, clk_ops-rename,
> >   will be merged into the Paul Mundt's sh tree if necessary.
> > 
> > * Introduction of L2 Cache support for r8a7779.
> > 
> > * Conversion of the mach-shmobile subarch to properly use a per-SoC
> >   map_io and separate init_early callback for early serial console
> >   support on platforms where that is possible.
> > 
> > Magnus Damm is the author of all the changes.
> 
> For next time, I think it would be good to make those things separate pull
> requests, since they are all rather big. In particular, the clk rework
> could be a series by itself.

It is a series by itself.  You can readily pull it from clk_ops-rename even. :-)

I'm not sure, though, what exactly the point of this would be.

> One thing I noticed while browsing through the patches was this hunk
> that Rob should know about:
> 
> @@ -242,6 +243,10 @@ static struct platform_device *r8a7779_late_devices[] __initdata = {
>  
>  void __init r8a7779_add_standard_devices(void)
>  {
> +#ifdef CONFIG_CACHE_L2X0
> +       /* Early BRESP enable, Shared attribute override enable, 64K*16way */
> +       l2x0_init(__io(0xf0100000), 0x40470000, 0x82000fff);
> +#endif
>         r8a7779_pm_init();
>  
>         r8a7779_init_pm_domain(&r8a7779_sh4a);
> 
> Here you are abusing the __io() macro rather badly as a typecast. This breaks
> with Rob's series to turn __io(foo) into a NULL pointer for the case where
> PCI is disabled. I found a few more of these, mostly in mach-shmobile but
> also some others:
> 
> arnd@klappe2:~/linux-arm$ git grep -w __io arch/arm/mach-* | grep -v __typesafe
> arch/arm/mach-cns3xxx/core.c:   gic_init(0, 29, __io(CNS3XXX_TC11MP_GIC_DIST_BASE_VIRT),
> arch/arm/mach-cns3xxx/core.c:            __io(CNS3XXX_TC11MP_GIC_CPU_BASE_VIRT));
> arch/arm/mach-cns3xxx/core.c:   u32 __iomem *pm_base = __io(CNS3XXX_PM_BASE_VIRT);
> arch/arm/mach-cns3xxx/core.c:   cns3xxx_tmr1 = __io(CNS3XXX_TIMER1_2_3_BASE_VIRT);
> arch/arm/mach-cns3xxx/devices.c:        u32 __iomem *gpioa = __io(CNS3XXX_MISC_BASE_VIRT + 0x0014);
> arch/arm/mach-netx/generic.c:   vic_init(__io(io_p2v(NETX_PA_VIC)), 0, ~0, 0);
> arch/arm/mach-netx/include/mach/netx-regs.h:#define NETX_SYSTEM_REG(ofs)            __io(NETX_VA_SYSTEM + (ofs))
> arch/arm/mach-netx/include/mach/netx-regs.h:#define NETX_GPIO_REG(ofs)                     __io(NETX_VA_GPIO + (ofs))
> arch/arm/mach-netx/include/mach/netx-regs.h:#define NETX_PIO_REG(ofs)        __io(NETX_VA_PIO + (ofs))
> arch/arm/mach-netx/include/mach/netx-regs.h:#define NETX_MIIMU           __io(NETX_VA_MIIMU)
> arch/arm/mach-netx/include/mach/netx-regs.h:#define NETX_PFIFO_REG(ofs)               __io(NETX_VA_PFIFO + (ofs))
> arch/arm/mach-netx/include/mach/netx-regs.h:#define NETX_MEMCR_REG(ofs)               __io(NETX_VA_MEMCR + (ofs))
> arch/arm/mach-netx/include/mach/netx-regs.h:#define NETX_DPMAS_REG(ofs)               __io(NETX_VA_DPMAS + (ofs))
> arch/arm/mach-netx/include/mach/netx-regs.h:#define NETX_I2C_REG(ofs)   __io(NETX_VA_I2C, (ofs))
> arch/arm/mach-realview/include/mach/hardware.h:#define __io_address(n)          __io(IO_ADDRESS(n))
> arch/arm/mach-shmobile/board-ag5evm.c:  l2x0_init(__io(0xf0100000), 0x00460000, 0xc2000fff);
> arch/arm/mach-shmobile/board-bonito.c:  l2x0_init(__io(0xf0002000), 0x40440000, 0x82000fff);
> arch/arm/mach-shmobile/board-kota2.c:   l2x0_init(__io(0xf0100000), 0x40460000, 0x82000fff);
> arch/arm/mach-shmobile/include/mach/io.h:#define __io(a)                        ((void __iomem *)(a))
> arch/arm/mach-shmobile/intc-r8a7779.c:  void __iomem *gic_dist_base = __io(0xf0001000);
> arch/arm/mach-shmobile/intc-r8a7779.c:  void __iomem *gic_cpu_base = __io(0xf0000100);
> arch/arm/mach-shmobile/intc-sh73a0.c:   void __iomem *gic_dist_base = __io(0xf0001000);
> arch/arm/mach-shmobile/intc-sh73a0.c:   void __iomem *gic_cpu_base = __io(0xf0000100);
> arch/arm/mach-shmobile/smp-r8a7779.c:   __raw_writel(__pa(shmobile_secondary_vector), __io(AVECR));
> arch/arm/mach-shmobile/smp-sh73a0.c:    if (((__raw_readl(__io(PSTR)) >> (4 * cpu)) & 3) == 3)
> arch/arm/mach-shmobile/smp-sh73a0.c:            __raw_writel(1 << cpu, __io(WUPCR));    /* wake up */
> arch/arm/mach-shmobile/smp-sh73a0.c:            __raw_writel(1 << cpu, __io(SRESCR));   /* reset */
> arch/arm/mach-shmobile/smp-sh73a0.c:    __raw_writel(0, __io(APARMBAREA));      /* 4k */
> arch/arm/mach-shmobile/smp-sh73a0.c:    __raw_writel(__pa(shmobile_secondary_vector), __io(SBAR));
> arch/arm/mach-ux500/include/mach/hardware.h:#define __io_address(n)             __io(IO_ADDRESS(n))
> 
> These are all broken and need to be changed to something else before we add the
> global definition for __io.

While I generally agree with that, I think it's not super-urgent, is it?

Rafael
