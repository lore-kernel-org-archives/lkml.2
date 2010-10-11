Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab0JKIQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 04:16:44 -0400
Received: from www.tglx.de ([62.245.132.106]:37672 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab0JKIQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 04:16:42 -0400
Date: Mon, 11 Oct 2010 10:16:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Grant Likely <grant.likely@secretlab.ca>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 00/47] Sparse irq rework
In-Reply-To: <4CB28988.4090207@kernel.org>
Message-ID: <alpine.LFD.2.00.1010110953420.2909@localhost6.localdomain6>
References: <20100930221351.682772535@linutronix.de> <20101003112312.GB9844@angua.secretlab.ca> <20101003112920.GB32736@n2100.arm.linux.org.uk> <AANLkTingVuhgdaLZ8U3bM+F2vZJ_kScwKqNtHW=g6DcH@mail.gmail.com> <alpine.LFD.2.00.1010031544340.14550@localhost6.localdomain6>
 <alpine.LFD.2.00.1010051219580.2556@localhost6.localdomain6> <4CACFC23.4080504@kernel.org> <alpine.LFD.2.00.1010070050410.17015@localhost6.localdomain6> <4CAD082B.40908@kernel.org> <4CAD1154.3080403@kernel.org> <alpine.LFD.2.00.1010070559480.17015@localhost6.localdomain6>
 <4CAD4EC3.5060809@kernel.org> <alpine.LFD.2.00.1010082346310.13094@localhost6.localdomain6> <alpine.LFD.2.00.1010082351450.13094@localhost6.localdomain6> <4CAFEEFA.1070000@kernel.org> <4CB00122.3030301@kernel.org> <alpine.LFD.2.00.1010090829150.13094@localhost6.localdomain6>
 <4CB014F5.5080209@kernel.org> <alpine.LFD.2.00.1010101130160.2413@localhost6.localdomain6> <4CB28988.4090207@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Oct 2010, Yinghai Lu wrote:

> On 10/10/2010 02:32 AM, Thomas Gleixner wrote:
> > On Sat, 9 Oct 2010, Yinghai Lu wrote:
> >> On 10/08/2010 11:34 PM, Thomas Gleixner wrote:
> >>> On Fri, 8 Oct 2010, Yinghai Lu wrote:
> >>>> +	/* only handle fall out from setup_IO_APIC_irqs() */
> >>>
> >>> What's the fallout ? And why are we coming here in the first place
> >>> when the irq is < 16 ?
> >>
> >> setup_IO_APIC_irqs only handle apic_id == 0 or apic_id > 0 but irq < 16 via acpi override.
> >>
> >> it seems IBM's system have apic_id == 1, and sci irq is using 30.
> >>
> >> so at that time add that setup_IO_APIC_irq_extra() to workaround it.
> >> but it seems we set that two time when irq < 16.
> >>
> >>>
> >>>> +	if (!((apic_id > 0) && (irq > 16)))
> >>>> +		return;
> > 
> > I added this into the queue, but simplified it to 
> > 
> >   if (apic_id == 0 || irq < NR_IRQS_LEGACY)
> > 
> > Folded in the other fix and pushed out an updated tree.
> 
> still have the irq_2_iommu_alloc warning from pnpacpi

Hmm, that's probably a problem for all legacy interrupts which are
never torn down once they are set up. And we set them all up during
early boot.

So either we special case the legacy area or remove the warning
alltogether.

Another option I discussed with Suresh recently is to remove the
allocator in intr_remapping.c and just embedd irq_2_iommu into
irq_cfg.

Thanks,

	tglx


