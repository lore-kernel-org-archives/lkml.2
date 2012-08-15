Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab2HOTD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:03:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55731 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2HOTD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:03:27 -0400
Date: Wed, 15 Aug 2012 12:03:28 -0700
From: Olof Johansson <olof@lixom.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 02/31] arm64: Kernel booting and initialisation
Message-ID: <20120815190328.GA6714@quad.lixom.net>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-3-git-send-email-catalin.marinas@arm.com>
 <20120814230645.GA19607@quad.lixom.net>
 <20120815173711.GC14264@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815173711.GC14264@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 15, 2012 at 06:37:11PM +0100, Catalin Marinas wrote:
> Hi Olof,
> 
> > Given the recent development of ARM platforms, you might want to mandate
> > the state of IOMMUs as well (they should probably be off, since there
> > should be no active DMA activity). Graphics would be the exception to
> > this, since if you want to keep scanning out a splash screen, you'll
> > have to keep doing DMA...
> 
> We'll enhance this document as we get hardware as it's not clear whether
> we can simply mandate it to be off. We may have situations with some
> simple IOMMU that is previously set up by the firmware and the kernel
> doesn't get access to it. One example is the System MMU from ARM that
> supports stage 2 (hypervisor) translations and you just run a guest
> kernel without any control of the IOMMU.

Ok, fair enough.

> > > +/*
> > > + * Setup common bits before finally enabling the MMU. Essentially this is just
> > > + * loading the page table pointer and vector base registers.
> > > + *
> > > + * On entry to this code, x0 must contain the SCTLR_EL1 value for turning on
> > > + * the MMU.
> > > + */
> > > +__enable_mmu:
> > 
> > ENTRY()?
> 
> __enable_mmu is not used outside this file, so no need for ENTRY().
> 
> > > +	ldr	x5, =vectors
> > > +	msr	vbar_el1, x5
> > > +	msr	ttbr0_el1, x25			// load TTBR0
> > > +	msr	ttbr1_el1, x26			// load TTBR1
> > > +	isb
> > > +	b	__turn_mmu_on
> > > +ENDPROC(__enable_mmu)
> > 
> > ...or just END()? Same for a few of the other functions below.
> 
> ENDPROC() gives us ".type @function" in addition to END(). This proved
> to be useful in the past for debugging symbols, unwind table (though we
> don't have the latter on AArch64).

A good as reason as any, sounds good.

> > > +static void __init setup_processor(void)
> > > +{
> > > +	struct proc_info_list *list;
> > > +
> > > +	/*
> > > +	 * locate processor in the list of supported processor
> > > +	 * types.  The linker builds this table for us from the
> > > +	 * entries in arch/arm/mm/proc.S
> > > +	 */
> > 
> > Probably from arch/arm64/... somewhere?
> 
> Yes, I did a grep and found a few more.

Yeah, I pointed out some other stale ARM-derived comments in other patches.

> > > +	printk("CPU: %s [%08x] revision %d\n",
> > > +	       cpu_name, read_cpuid_id(), read_cpuid_id() & 15);
> > > +
> > > +	sprintf(init_utsname()->machine, "aarch64");
> > 
> > > +	initial_boot_params = devtree;
> > > +	dt_root = of_get_flat_dt_root();
> > > +
> > > +	machine_name = of_get_flat_dt_prop(dt_root, "model", NULL);
> > > +	if (!machine_name)
> > > +		machine_name = of_get_flat_dt_prop(dt_root, "compatible", NULL);
> > > +	if (!machine_name)
> > > +		machine_name = "<unknown>";
> > > +	pr_info("Machine: %s\n", machine_name);
> > 
> > This property is an array of strings. It would be more valuable to print out
> > the entry that was matched for a platform instead of the provided one from the
> > device tree.
> 
> If we add machine_desc structure back, we could print which machine was
> matched. But so far I try to keep the SoC code to a minimum and just do
> the probing later in the SoC code (of_find_matching_node). Ideally we
> shouldn't have any SoC code and just keep code in drivers but we'll see
> how far we can get. We can discuss more details at the KS as I would
> like the arm-soc team to get involved here.

Interesting approach, I wonder if it'll scale, in particular if it comes
to needing to do early setup and init. For device-level setup, generic
will probably work just fine. And if it doesn't, things can be changed
later. So it sounds like a good start.

Definitely something we should discuss. I suggest not doing it at KS
though, since only half of the arm-soc team is invited there. So the
ARM mini-summit or hallway around LPC is a better venue.


-Olof

