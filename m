Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291Ab2ELBUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 21:20:16 -0400
Received: from relay.ihostexchange.net ([66.46.182.53]:3502 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab2ELBUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 21:20:13 -0400
From: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@ScaleMP.com>
To: Ido Yariv <ido@wizery.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 11 May 2012 21:20:08 -0400
Subject: RE: [PATCH v4] vsmp: Fix number of CPUs when vsmp is disabled
Thread-Topic: [PATCH v4] vsmp: Fix number of CPUs when vsmp is disabled
Thread-Index: Ac0vq/5OX9SbOuqSSrep5F3daB/E2wAMViMg
Message-ID: <9B14D1490DDECA4E974F6B9FC9EBAB317D0A62A6AA@VMBX108.ihostexchange.net>
References: <20120509082225.GB5036@NoteStation.colubris.lan>
 <1336552121-6742-1-git-send-email-ido@wizery.com>
 <20120509154448.GD2653@gmail.com> <4FAA938A.1030003@zytor.com>
 <20120511192631.GA13342@NoteStation.colubris.lan>
In-Reply-To: <20120511192631.GA13342@NoteStation.colubris.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good.


--Shai 


> -----Original Message-----
> From: Ido Yariv [mailto:ido@wizery.com]
> Sent: Friday, May 11, 2012 12:27
> To: H. Peter Anvin
> Cc: Ingo Molnar; linux-kernel@vger.kernel.org; Ingo Molnar; Thomas
> Gleixner; Shai Fultheim (Shai@ScaleMP.com)
> Subject: Re: [PATCH v4] vsmp: Fix number of CPUs when vsmp is disabled
> 
> Hi,
> 
> On Wed, May 09, 2012 at 08:55:54AM -0700, H. Peter Anvin wrote:
> > On 05/09/2012 08:44 AM, Ingo Molnar wrote:
> > >
> > > * Ido Yariv <ido@wizery.com> wrote:
> > >
> > >> +static void __init vsmp_cap_cpus(void)
> > >> +{
> > >> +	void __iomem *address;
> > >> +	unsigned int cfg, topology, node_shift, maxcpus;
> > >> +
> > >> +#ifdef CONFIG_X86_VSMP
> > >> +	/* VSMP is enabled, no need to cap cpus */
> > >> +	return;
> > >> +#elif defined(CONFIG_SMP)
> > >> +	/*
> > >> +	 * CONFIG_X86_VSMP is not configured, so limit the number CPUs to
> the
> > >
> > > I suspect this will throw compiler warnings in the
> > > CONFIG_X86_VSMP && !CONFIG_SMP case.
> > >
> >
> > What on Earth is the point of allowing that combination?  Why not make
> > X86_VSMP depend on SMP and reduce the testing matrix?
> 
> CONFIG_X86_VSMP shouldn't be used without CONFIG_SMP, so we can
> safely
> add this dependency.
> Ingo's suggestion will still fix unreferenced variables warnings, so how
> about the following patch?
> 
> Thanks,
> Ido.
> 
> From 6fa023be44749092088618379f13d7a3e086d692 Mon Sep 17 00:00:00
> 2001
> From: Shai Fultheim <shai@scalemp.com>
> Date: Mon, 16 Apr 2012 10:39:35 +0300
> Subject: [PATCH v5] vsmp: Fix number of CPUs when vsmp is disabled
> 
> In case CONFIG_X86_VSMP is not set, limit the number of CPUs to the
> number of CPUs of the first board.
> 
> Also make CONFIG_X86_VSMP depend on CONFIG_SMP, as there's little
> point in having a vsmp machine with a single CPU.
> 
> Signed-off-by: Shai Fultheim <shai@scalemp.com>
> [ido@wizery.com: rebased, fixed minor coding-style issues]
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---
>  arch/x86/Kconfig          |    1 +
>  arch/x86/kernel/vsmp_64.c |   40
> ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 41 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index c9866b0..b1e98c9 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -374,6 +374,7 @@ config X86_VSMP
>  	select PARAVIRT
>  	depends on X86_64 && PCI
>  	depends on X86_EXTENDED_PLATFORM
> +	depends on SMP
>  	---help---
>  	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
>  	  supposed to run on these EM64T-based machines.  Only choose this
> option
> diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
> index a1d804b..8eeb55a 100644
> --- a/arch/x86/kernel/vsmp_64.c
> +++ b/arch/x86/kernel/vsmp_64.c
> @@ -15,6 +15,7 @@
>  #include <linux/init.h>
>  #include <linux/pci_ids.h>
>  #include <linux/pci_regs.h>
> +#include <linux/smp.h>
> 
>  #include <asm/apic.h>
>  #include <asm/pci-direct.h>
> @@ -22,6 +23,8 @@
>  #include <asm/paravirt.h>
>  #include <asm/setup.h>
> 
> +#define TOPOLOGY_REGISTER_OFFSET 0x10
> +
>  #if defined CONFIG_PCI && defined CONFIG_PARAVIRT
>  /*
>   * Interrupt control on vSMPowered systems:
> @@ -149,12 +152,49 @@ int is_vsmp_box(void)
>  	return 0;
>  }
>  #endif
> +
> +static void __init vsmp_cap_cpus(void)
> +{
> +#if !defined(CONFIG_X86_VSMP) && defined(CONFIG_SMP)
> +	void __iomem *address;
> +	unsigned int cfg, topology, node_shift, maxcpus;
> +
> +	/*
> +	 * CONFIG_X86_VSMP is not configured, so limit the number CPUs to
> the
> +	 * ones present in the first board, unless explicitly overridden by
> +	 * setup_max_cpus
> +	 */
> +	if (setup_max_cpus != NR_CPUS)
> +		return;
> +
> +	/* Read the vSMP Foundation topology register */
> +	cfg = read_pci_config(0, 0x1f, 0, PCI_BASE_ADDRESS_0);
> +	address = early_ioremap(cfg + TOPOLOGY_REGISTER_OFFSET, 4);
> +	if (WARN_ON(!address))
> +		return;
> +
> +	topology = readl(address);
> +	node_shift = (topology >> 16) & 0x7;
> +	if (!node_shift)
> +		/* The value 0 should be decoded as 8 */
> +		node_shift = 8;
> +	maxcpus = (topology & ((1 << node_shift) - 1)) + 1;
> +
> +	pr_info("vSMP CTL: Capping CPUs to %d (CONFIG_X86_VSMP is
> unset)\n",
> +		maxcpus);
> +	setup_max_cpus = maxcpus;
> +	early_iounmap(address, 4);
> +#endif
> +}
> +
>  void __init vsmp_init(void)
>  {
>  	detect_vsmp_box();
>  	if (!is_vsmp_box())
>  		return;
> 
> +	vsmp_cap_cpus();
> +
>  	set_vsmp_pv_ops();
>  	return;
>  }
> --
> 1.7.6.5

