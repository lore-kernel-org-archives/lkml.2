Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab0LJVYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 16:24:21 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:7504 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab0LJVYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 16:24:20 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/5] resources: add arch hook for preventing allocation in reserved areas
Date: Fri, 10 Dec 2010 14:07:24 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-26-generic; KDE/4.4.2; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>,
        Matthew Garrett <mjg@redhat.com>, Dan Williams <dcbw@redhat.com>,
        rjw@sisk.pl
References: <20101208213606.13026.47657.stgit@bob.kio> <20101210123008.7fed582d@jbarnes-desktop> <20101210123609.73c12a23@jbarnes-desktop>
In-Reply-To: <20101210123609.73c12a23@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012101407.24419.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 10, 2010 01:36:09 pm Jesse Barnes wrote:
> [Actually cc'ing Matthew this time]
> 
> On Fri, 10 Dec 2010 12:30:08 -0800
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > On Wed, 08 Dec 2010 14:36:06 -0700
> > Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > 
> > > 
> > > This adds arch_remove_reservations(), which an arch can implement if it
> > > needs to protect part of the address space from allocation.
> > > 
> > > Sometimes that can be done by just requesting a resource.  This hook is to
> > > cover cases where protected area doesn't fit well in the hierarchical
> > > resource tree.  For example, x86 BIOS E820 reservations are not related
> > > to devices, so they may overlap part of, all of, or more than a device
> > > resource.
> > > 
> > > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > > ---
> > 
> > Hm, this is bigger than the simple change of just avoiding the high 2M;
> > Linus have you checked it out yet?  It's nicer than simply adjusting
> > PCIBIOS_MAX_MEM since it will affect all resource callers rather than
> > just PCI, but it's definitely bigger.

Dan Williams also reproduced the problem on a 2530p and tested this
series (though I think he actually tested a backport in Fedora):
  https://bugzilla.kernel.org/show_bug.cgi?id=23542#c7
  https://bugzilla.kernel.org/show_bug.cgi?id=23542#c23

The simple PCIBIOS_MAX_MEM_32 change below will fix the 2530p problem,
but it won't help fix the nx6325 problem Rafael reported; details at:
  https://bugzilla.kernel.org/show_bug.cgi?id=23332#c20

Rafael did confirm on #acpi Wednesday that the full series fixed
his nx6325.

Bjorn

> > If you want just the simple change for 2.6.37 I can push that, but
> > we'll need to get a tested-by from Matthew:
> > 
> >   diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
> >   index ca0437c..aef9f77 100644
> >   --- a/arch/x86/include/asm/pci.h
> >   +++ b/arch/x86/include/asm/pci.h
> >   @@ -141,7 +141,7 @@ void dma32_reserve_bootmem(void);
> > 
> >    /* generic pci stuff */
> >    #include <asm-generic/pci.h>
> >   -#define PCIBIOS_MAX_MEM_32 0xffffffff
> >   +#define PCIBIOS_MAX_MEM_32 0xfff00000
> > 
> >    #ifdef CONFIG_NUMA
> >    /* Returns the node based on pci bus */
> > 
> > and I'll queue up this set for 2.6.38.
> > 
> > Thanks,
> 
> 
> 
