Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab0LSXdZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 18:33:25 -0500
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:58373 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932538Ab0LSXdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 18:33:24 -0500
Date: Sun, 19 Dec 2010 16:33:25 -0700
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Subject: Re: [PATCH 8/9] x86: avoid E820 regions when allocating address
 space
Message-ID: <20101219233325.GA2013@helgaas.com>
References: <20101216173614.8185.19462.stgit@bob.kio>
 <20101216173856.8185.98094.stgit@bob.kio>
 <AANLkTim68DbGeWbYKYx3_WOGFkA8KZFVHFyEFGtXt-cr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim68DbGeWbYKYx3_WOGFkA8KZFVHFyEFGtXt-cr@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 01:50:50AM -0800, Yinghai Lu wrote:
> On Thu, Dec 16, 2010 at 9:38 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> >
> > When we allocate address space, e.g., to assign it to a PCI device, don't
> > allocate anything mentioned in the BIOS E820 memory map.
> >
> > On recent machines (2008 and newer), we assign PCI resources from the
> > windows described by the ACPI PCI host bridge _CRS.  On many Dell
> > machines, these windows overlap some E820 reserved areas, e.g.,
> >
> >    BIOS-e820: 00000000bfe4dc00 - 00000000c0000000 (reserved)
> >    pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xdfffffff]
> >
> > If we put devices at 0xbff00000, they don't work, probably because
> > that's really RAM, not I/O memory.  This patch prevents that by removing
> > the 0xbfe4dc00-0xbfffffff area from the "available" resource.
> >
> > I'm not very happy with this solution because Windows solves the problem
> > differently (it seems to ignore E820 reserved areas and it allocates
> > top-down instead of bottom-up; details at comment 45 of the bugzilla
> > below).  That means we're vulnerable to BIOS defects that Windows would not
> > trip over.  For example, if BIOS described a device in ACPI but didn't
> > mention it in E820, Windows would work fine but Linux would fail.
> >
> > Reference: https://bugzilla.kernel.org/show_bug.cgi?id=16228
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > ---
> >
> >  arch/x86/kernel/resource.c |   38 +++++++++++++++++++++++++++++++++++++-
> >  1 files changed, 37 insertions(+), 1 deletions(-)
> >
> >
> > diff --git a/arch/x86/kernel/resource.c b/arch/x86/kernel/resource.c
> > index 407a900..89638af 100644
> > --- a/arch/x86/kernel/resource.c
> > +++ b/arch/x86/kernel/resource.c
> > @@ -1,11 +1,47 @@
> >  #include <linux/ioport.h>
> >  #include <asm/e820.h>
> >
> > +static void resource_clip(struct resource *res, resource_size_t start,
> > +                         resource_size_t end)
> > +{
> > +       resource_size_t low = 0, high = 0;
> > +
> > +       if (res->end < start || res->start > end)
> > +               return;         /* no conflict */
> > +
> > +       if (res->start < start)
> > +               low = start - res->start;
> > +
> > +       if (res->end > end)
> > +               high = res->end - end;
> > +
> > +       /* Keep the area above or below the conflict, whichever is larger */
> > +       if (low > high)
> > +               res->end = start - 1;
> > +       else
> > +               res->start = end + 1;
> > +}
> > +
> > +static void remove_e820_regions(struct resource *avail)
> > +{
> > +       int i;
> > +       struct e820entry *entry;
> > +
> > +       for (i = 0; i < e820.nr_map; i++) {
> > +               entry = &e820.map[i];
> > +
> > +               resource_clip(avail, entry->addr,
> > +                             entry->addr + entry->size - 1);
> > +       }
> > +}
> > +
> >  void arch_remove_reservations(struct resource *avail)
> >  {
> > -       /* Trim out BIOS area (low 1MB) */
> > +       /* Trim out BIOS area (low 1MB) and E820 regions */
> >        if (avail->flags & IORESOURCE_MEM) {
> >                if (avail->start < BIOS_END)
> >                        avail->start = BIOS_END;
> > +
> > +               remove_e820_regions(avail);
> >        }
> >  }
> 
> that looks expensive. it will keep going through e820 tables...

It's expensive when we do it, but we do it very rarely, i.e., only
when we call allocate_resource().

> but e820 should have been reserved in resource tree...

E820 regions don't fit very well in the resource tree.  The
tree normally contains devices, which are mutually exclusive
and fit nicely in a hierarchy.

The E820 RAM regions fit that description (they can't conflict
with anything else).  But generic "reserved" regions do not.
A reserved region might cover several devices, it might cover
part of a device, it might cover a piece of RAM, or it might
not be related to a device at all.  We do try to wedge those
reservations into the resource tree, but I think that's a
mistake because it doesn't work very well.

In this case, the E820 reservation *is* in the resource tree,
but we took the reasonable 0xbfe4dc00 - 0xc0000000 E820 entry
and turned it into the bogus 0xbfe4dc00-0xf7ffffff range:

  bfe4dc00-f7ffffff reserved (expanded)
    bff00000-f7ffffff PCI Bus 0000:00

More details here:

  https://bugzilla.kernel.org/show_bug.cgi?id=16228#c45

Bjorn
