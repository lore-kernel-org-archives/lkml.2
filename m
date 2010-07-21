Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab0GUFvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:51:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34013 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab0GUFvE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 01:51:04 -0400
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "stepanm@codeaurora.org" <stepanm@codeaurora.org>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "mel@csn.ul.ie" <mel@csn.ul.ie>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>, Tim HRM <zt.tmzt@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
Date: Wed, 21 Jul 2010 11:19:58 +0530
Subject: RE: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
	memory management
Thread-Topic: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
	memory management
Thread-Index: AcsoW9A0NGgcSm0YSrmyPm7PWpn3MgAPAEHw
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02C61C5FCA@dbde02.ent.ti.com>
References: <20100714104353B.fujita.tomonori@lab.ntt.co.jp>
	<20100714201149.GA14008@codeaurora.org>
	<20100714220536.GE18138@n2100.arm.linux.org.uk>
	<20100715012958.GB2239@codeaurora.org>
	<20100715085535.GC26212@n2100.arm.linux.org.uk>
	<AANLkTinVZeaZxt_lWKhjKa0dqhu3_j3BRNySO-2LvMdw@mail.gmail.com>
	<20100716075856.GC16124@n2100.arm.linux.org.uk>
	<4C449183.20000@codeaurora.org>
	<20100719184002.GA21608@n2100.arm.linux.org.uk>
	<bb667e285fd8be82ea8cc9cc25cf335b.squirrel@www.codeaurora.org>
 <20100720222952.GD10553@n2100.arm.linux.org.uk>
In-Reply-To: <20100720222952.GD10553@n2100.arm.linux.org.uk>
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

> -----Original Message-----
> From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-
> kernel-bounces@lists.infradead.org] On Behalf Of Russell King - ARM Linux
> Sent: Wednesday, July 21, 2010 4:00 AM
> To: stepanm@codeaurora.org
> Cc: linux-arch@vger.kernel.org; dwalker@codeaurora.org; mel@csn.ul.ie;
> linux-arm-msm@vger.kernel.org; linux-kernel@vger.kernel.org; FUJITA
> Tomonori; linux-mm@kvack.org; andi@firstfloor.org; Zach Pfeffer; Michael
> Bohan; Tim HRM; linux-omap@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; ebiederm@xmission.com
> Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
> memory management
> 
> On Tue, Jul 20, 2010 at 03:02:34PM -0700, stepanm@codeaurora.org wrote:
> > Russell-
> >
> > If a driver wants to allow a device to access memory (and cache
> coherency
> > is off/not present for device addesses), the driver needs to remap that
> > memory as non-cacheable.
> 
> If that memory is not part of the kernel's managed memory, then that's
> fine.  But if it _is_ part of the kernel's managed memory, then it is
> not permitted by the ARM architecture specification to allow maps of
> the memory with differing [memory type, sharability, cache] attributes.
> 
> Basically, if a driver wants to create these kinds of mappings, then
> they should expect the system to become unreliable and unpredictable.
> That's not something any sane person should be aiming to do.
> 
> > Suppose there exists a chunk of
> > physically-contiguous memory (say, memory reserved for device use) that
> > happened to be already mapped into the kernel as normal memory
> (cacheable,
> > etc). One way to remap this memory is to use ioremap (and then never
> touch
> > the original virtual mapping, which would now have conflicting
> > attributes).
> 
> This doesn't work, and is unpredictable on ARMv6 and ARMv7.  Not touching
> the original mapping is _not_ _sufficient_ to guarantee that the mapping
> is not used.  (We've seen problems on OMAP as a result of this.)
> 
> Any mapping which exists can be speculatively prefetched by such CPUs
> at any time, which can lead it to be read into the cache.  Then, your
> different attributes for your "other" mapping can cause problems if you
> hit one of these cache lines - and then you can have (possibly silent)
> data corruption.
> 
> > I feel as if there should be a better way to remap memory for
> > device access, either by altering the attributes on the original
> mapping,
> > or removing the original mapping and creating a new one with attributes
> > set to non-cacheable.
> 
> This is difficult to achieve without remapping kernel memory using L2
> page tables, so we can unmap pages on 4K page granularity.  That's
> going to increase TLB overhead and result in lower system performance
> as there'll be a greater number of MMU misses.
> 
> However, one obvious case would be to use highmem-only pages for
> remapping - but you then have to ensure that those pages are never
> kmapped in any way, because those mappings will fall into the same
> unpredictable category that we're already trying to avoid.  This
> may be possible, but you'll have to ensure that most of the system
> RAM is in highmem - which poses other problems (eg, if lowmem gets
> low.)
> 
Why can't we consider an option of removing the old mappings when 
we need to create new ones with different attributes as suggested
by Catalin on similar thread previously. This will avoid the duplicate
mapping with different attributes issue on newer ARMs.

Is this something can't be worked out?

Regards,
Santosh
