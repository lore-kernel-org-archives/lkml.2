Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab2GRUaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 16:30:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54294 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab2GRUa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 16:30:28 -0400
MIME-Version: 1.0
In-Reply-To: <50071834.2030408@tilera.com>
References: <201206162036.q5GKacEK017774@lab-41.internal.tilera.com>
 <201206162037.q5GKbFg0017781@lab-41.internal.tilera.com> <CAErSpo6Sws6AeZiW=-OW-6_wUO0LuJ1FMxU=yuu-7srN0+TL3g@mail.gmail.com>
 <5000442B.7090208@tilera.com> <20120713172508.GA18587@google.com>
 <5006E133.5090100@tilera.com> <CAErSpo6XEwQcVFUBHAZO6R2wZvCSmG3w1G6va7FRcnrbc=nAfg@mail.gmail.com>
 <50071834.2030408@tilera.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 18 Jul 2012 14:30:03 -0600
Message-ID: <CAErSpo7Vegj0MnTw=cjUXNWPZOFTXVSzH1V=4+-Qs80=1at5nA@mail.gmail.com>
Subject: Re: [PATCH 3/3] tile pci: enable IOMMU to support DMA for legacy devices
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 2:10 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> On 7/18/2012 12:50 PM, Bjorn Helgaas wrote:
>> On Wed, Jul 18, 2012 at 10:15 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>>> On 7/13/2012 1:25 PM, Bjorn Helgaas wrote:
>>>> On Fri, Jul 13, 2012 at 11:52:11AM -0400, Chris Metcalf wrote:
>>>>> We use the same pci_iomem_resource for different domains or host
>>>>> bridges, but the MMIO apertures for each bridge do not overlap because
>>>>> non-overlapping resource ranges are allocated for each domains.
>>>> You should not use the same pci_iomem_resource for different host bridges
>>>> because that tells the PCI core that everything in pci_iomem_resource is
>>>> available for devices under every host bridge, which I doubt is the case.
>>>>
>>>> The fact that your firmware assigns non-overlapping resources is good and
>>>> works now, but if the kernel ever needs to allocate resources itself,
>>> Actually, we were not using any firmware. It was indeed the kernel which
>>> allocates resources from the shared pci_iomem_resource.
>> Wow.  I wonder how that managed to work.  Is there some information
>> that would have helped the PCI core do the right allocations?  Or
>> maybe the host bridges forward everything they receive to PCI,
>> regardless of address, and any given MMIO address is only routed to
>> one of the host bridges because of the routing info in the page
>> tables?
>
> Since each host bridge contains non-overlapping ranges in its bridge config
> header, ioremap() locates the right host bridge for the target PCI resource
> address and programs the host bridge info into the MMIO mapping. The end
> result is the MMIO address is routed to the right host bridge. On Tile
> processors, different host bridges are like separate IO devices, in
> completely separate domains.
>
>> I guess in that case, the "apertures" would basically be
>> defined by the page tables, not by the host bridges.  But that still
>> doesn't explain how we would assign non-overlapping ranges to each
>> domain.
>
> Since all domains share the single resource, allocate_resource() "allocate
> empty slot in the resource tree", giving non-overlapping ranges to each
> devices.
>
> Just to confirm, I'm assuming I'll ask Linus to pull this code out of my
> tile tree when the merge window opens, right?  Would you like me to add
> your name to the commit as acked or reviewed?  Thanks!

Yep, just ask Linus to pull it; I don't think there's any need to
coordinate with my PCI tree since you're not using any interfaces we
changed in this cycle.

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
