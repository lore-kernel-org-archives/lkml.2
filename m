Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab0LUXBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:01:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:37590 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab0LUXBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:01:43 -0500
Subject: Re: [ANNOUNCE] VFIO V6 & public VFIO repositorie
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: pugs@ieee.org, linux-pci@vger.kernel.org, mbranton@gmail.com,
        alexey.zaytsev@gmail.com, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        randy.dunlap@oracle.com, arnd@arndb.de, joro@8bytes.org,
        hjk@linutronix.de, avi@redhat.com, gregkh@suse.de, chrisw@sous-sol.org,
        mst@redhat.com
In-Reply-To: <1292966127.2906.53.camel@x201>
References: <4ceafaf4.pffTeLx1ndqdBH3c%pugs@cisco.com>
	 <1292909368.16694.722.camel@pasglop>  <1292966127.2906.53.camel@x201>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 10:00:57 +1100
Message-ID: <1292972457.16694.766.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It seems like vfio could still work for you.  You have a restricted
> iommu address space, but you can also expect your guests to make use of
> hcalls to setup mappings, which gives you a way to use your resources
> more sparingly.  So I could imagine a model where your hcalls end up
> calling into qemu vfio userspace, which does the guest physical to host
> virtual translation (or some kind of allocator function).  That calls
> the vfio VFIO_DMA_MAP_IOVA ioctl to map or unmap the region. 

That would be way too much overhead ... ie we could do it today as a
proof of concept, but ultimately, we want the H-calls to be done in real
mode and directly populate the TCE table (iommu translation table).

IE. We have a guest on one side doing H_PUT_TCE giving us a value and a
table index, so all we really need is "validate" that index, translate
the GPA to a HPA, and write to the real TCE table. This is a very hot
code path, especially in networking, so I'd like as much as possible to
do it in the kernel in real mode.

We essentially have to do a partition switch when exiting from the guest
into the host linux, so that's costly. Anything we can handle in "real
mode" (ie, MMU off, right when taking the "interrupt" from the guest as
the result of the hcall for example) will be a win.

When we eventually implement non-pinned user memory, things will be a
bit more nasty I suppose. We can try to "pin" the pages at H_PUT_TCE
time, but that means either doing an exit to linux, or trying to walk
the sparse memmap and do a speculative page reference all in real
mode... not impossible but nasty (since we can't use the vmemmap region
without the MMU on).

But for now, our user memory is all pinned huge pages, so we can have a
nice fast path there.
 
>  You then
> need to implement an iommu interface in the host that performs the hand
> waving of inserting that mapping into the translation for the device.
> You probably still want something like the uiommu interface and
> VFIO_DOMAIN_SET call to create a context for a device for the security
> restrictions that Tom mentions, even if the mapping back to hardware
> page tables is less direct than it is on x86.

Well, yes and no...

The HW has additional fancy isolation features, for example, MMIOs are
also split into domains associated with the MMU window etc... this is so
that the HW can immediately isolate a device on error, making it less
likely for corrupted data to propagate in the system and allowing for
generally more reliably error recovery mechanisms.

That means that in the end, I have a certain amount of "domains"
grouping those MMIO, DMA regions, etc... generally containing one device
each, but the way I see things, all those domains are pre-existing. They
are setup in the host, with or without KVM, when PCIe is enumerated (or
on hotplug).

IE. The host linux without KVM benefits from that isolation as well in
term of added reliability and recovery services (as it does today under
pHyp).

KVM guests then are purely a matter of making such pre-existing domains
accessible to a guest.

I don't think KVM (or VFIO for that matter) should be involved in the
creation and configuration of those domains, it's a tricky exercise
already due to the MMIO domain thing coupled with funny HW limitations,
and I'd rather keep that totally orthogonal from the act of mapping
those into KVM guests.

Cheers,
Ben.

> Alex
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


