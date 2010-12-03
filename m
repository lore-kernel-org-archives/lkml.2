Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab0LCPQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:16:00 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:13092 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0LCPP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:15:58 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86/PCI: never allocate PCI space from the last 1M below 4G
Date: Fri, 3 Dec 2010 08:15:48 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Matthew Garrett <mjg@redhat.com>, Yinghai Lu <yinghai@kernel.org>
References: <20101129183009.11256.33739.stgit@bob.kio> <201011291504.40536.bjorn.helgaas@hp.com> <AANLkTinJhVj7sY6wC1tFRA+rYW72j7GqKvxfRsyRC=Vs@mail.gmail.com>
In-Reply-To: <AANLkTinJhVj7sY6wC1tFRA+rYW72j7GqKvxfRsyRC=Vs@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012030815.52203.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 02, 2010 06:19:20 pm Linus Torvalds wrote:
> On Mon, Nov 29, 2010 at 2:04 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> >
> > I think we're talking about whether to reserve the top 1MB or top 2MB.
> > I freely admit I don't know the right answer.  My point is merely that
> > since we're using a heuristic anyway, copying Windows is a pretty good
> > starting point.  In my mind, doing something different requires a
> > stronger argument than "it might fix some machines where Windows is
> > broken."
> 
> What's the status of this? The original patch is pretty nasty, and I
> think that hack to put things in the bios_align_resource() function is
> just disgusting.
> 
> And why is the fix not the really _trivial_ one, which does just this:
> 
>   diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
>   index ca0437c..aef9f77 100644
>   --- a/arch/x86/include/asm/pci.h
>   +++ b/arch/x86/include/asm/pci.h
>   @@ -141,7 +141,7 @@ void dma32_reserve_bootmem(void);
> 
>    /* generic pci stuff */
>    #include <asm-generic/pci.h>
>   -#define PCIBIOS_MAX_MEM_32 0xffffffff
>   +#define PCIBIOS_MAX_MEM_32 0xfff00000
> 
>    #ifdef CONFIG_NUMA
>    /* Returns the node based on pci bus */
> 
> Hmm?
> 
> (Ok, so that doesn't protect a 64-bit resource that just happens to be
> inside a window that ends at 0xffffffff, but if you have those kinds
> of bus windows, that means that there's nothing there at the 4GB mark
> anyway, no?)

Huh.  That is a nice simple change, and I suspect it would work for
Matthew.

But it's a PCI-specific solution to a general problem.  We want to
protect that resource from all allocate_resource() calls, and PCI is
the most important but not the only caller.

Maybe cluttering bios_align_resource() is less disgusting if we think
of it as "arch_allocate_resource()" instead of merely "align_resource()"?

I think we're going to need even more stuff there soon ...the current
way we handle E820 "reserved" areas is broken.  (I have some evidence
that Windows ignores E820 reservations when allocating device resources,
so I'm not 100% convinced that Linux should pay attention to them, but
historically, we've certainly tried to.)

We try to put E820 reservations in iomem_resource, but that's not a
good fit because the resource tree is strictly hierarchical, and E820
reserved areas are not.  An E820 entry might cover part of, all of, or
even several device resources.

This leads to ugliness like reserve_region_with_split(),
insert_resource_expand_to_fit(), and the confusing situation with
e820_reserve_resources() and e820_reserve_resources_late().  If we're
going to look at E820 reservations, I think we'd be better off if we
left them out of iomem_resource and had an arch hook in allocate_resource()
that could trim them out.

Bjorn
