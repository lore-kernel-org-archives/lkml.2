Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab1DKP74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 11:59:56 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:52496 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab1DKP7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 11:59:55 -0400
Date: Mon, 11 Apr 2011 08:59:32 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Hellstrom <daniel@gaisler.com>, Ram Pai <linuxram@us.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>, Yinghai Lu <yinghai@kernel.org>,
        Kristoffer Glembo <kristoffer@gaisler.com>
Subject: Re: [PATCH 1/4] PCI: refactor io size calculation code
Message-ID: <20110411155932.GA2374@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <4DA2FFB6.3040209@gaisler.com>
 <BANLkTikqB2tr-jNTaqVtTpBkH5O1iYQS-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikqB2tr-jNTaqVtTpBkH5O1iYQS-Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 07:42:13AM -0700, Linus Torvalds wrote:
> On Mon, Apr 11, 2011 at 6:18 AM, Daniel Hellstrom <daniel@gaisler.com> wrote:
> >In commit 13583b16592a ("PCI: refactor io size calculation code"):
> >>
> >> refactor  code  that  calculates  the  io  size in pbus_size_io()
> >> and pbus_mem_io() into separate functions.
> >>
> >> Signed-off-by: Ram Pai <linuxram@xxxxxxxxxx>
> >> ---
> >> drivers/pci/setup-bus.c |   66
> >> ++++++++++++++++++++++++++++++-----------------
> >> 1 files changed, 42 insertions(+), 24 deletions(-)
> >>
> >> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> >> index 66cb8f4..2121215 100644
> >> --- a/drivers/pci/setup-bus.c
> >> +++ b/drivers/pci/setup-bus.c
> >> @@ -404,6 +404,43 @@ static struct resource *find_free_bus_resource(struct
> >> pci_bus *bus, unsigned lon
> >>        return NULL;
> >> }
> >>
> > ...
> >
> >> +
> >> +static resource_size_t calculate_memsize(resource_size_t size,
> >> +               resource_size_t min_size,
> >> +               resource_size_t size1,
> >> +               resource_size_t old_size,
> >> +               resource_size_t align)
> >> +{
> >> +       if (size < min_size)
> >> +               size = min_size;
> >> +       if (old_size == 1 )
> >> +               old_size = 0;
> >> +       if (size < old_size)
> >> +               size = old_size;
> >> +       size = ALIGN(size + size1, align);
> >> +       return size;
> >> +}
> >> +
> >> /* Sizing the IO windows of the PCI-PCI bridge is trivial,
> >>   since these windows have 4K granularity and the IO ranges
> >>   of non-bridge PCI devices are limited to 256 bytes.
> >>
> >>
> >
> > ...
> >
> >> @@ -516,14 +542,6 @@ static int pbus_size_mem(struct pci_bus *bus,
> >> unsigned long mask,
> >>                        mem64_mask &= r->flags & IORESOURCE_MEM_64;
> >>                }
> >>        }
> >> -       if (size < min_size)
> >> -               size = min_size;
> >> -       old_size = resource_size(b_res);
> >> -       if (old_size == 1)
> >> -               old_size = 0;
> >> -       if (size < old_size)
> >> -               size = old_size;
> >> -
> >>        align = 0;
> >>        min_align = 0;
> >>        for (order = 0; order <= max_order; order++) {
> >> @@ -537,7 +555,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned
> >> long mask,
> >>                        min_align = align1 >> 1;
> >>                align += aligns[order];
> >>        }
> >> -       size = ALIGN(size, min_align);
> >> +       size = calculate_memsize(size, min_size, 0, resource_size(b_res),
> >> align);
> >>
> >
> > On my SPARC32/LEON4 PCI system I get overlapped areas, double mapped
> > resources. Some BARs on PCIBUS0 are in the same non-prefetchable memory
> > range as the secondary bus PCIBUS1. Changing align to min_align in the above
> > call to calculate_memsize() fixes the problem, and the memory allocation is
> > the same as with 2.6.36.4 kernel.
> >
> > I belive this is just a typo.


Yes it is my mistake. I got the parameter wrong. Your fix should correct the problem.

RP
