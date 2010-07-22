Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab0GVEZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 00:25:32 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56932 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab0GVEZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 00:25:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6050"; a="48244007"
Date: Wed, 21 Jul 2010 21:25:28 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-arch@vger.kernel.org, dwalker@codeaurora.org, mel@csn.ul.ie,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, andi@firstfloor.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
 memory management
Message-ID: <20100722042528.GB22559@codeaurora.org>
References: <4C3C0032.5020702@codeaurora.org>
 <20100713150311B.fujita.tomonori@lab.ntt.co.jp>
 <20100713121420.GB4263@codeaurora.org>
 <20100714104353B.fujita.tomonori@lab.ntt.co.jp>
 <20100714201149.GA14008@codeaurora.org>
 <20100714220536.GE18138@n2100.arm.linux.org.uk>
 <20100715012958.GB2239@codeaurora.org>
 <20100715085535.GC26212@n2100.arm.linux.org.uk>
 <20100719065233.GD11054@codeaurora.org>
 <m1mxtndifi.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1mxtndifi.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 12:44:49AM -0700, Eric W. Biederman wrote:
> Zach Pfeffer <zpfeffer@codeaurora.org> writes:
> 
> > On Thu, Jul 15, 2010 at 09:55:35AM +0100, Russell King - ARM Linux wrote:
> >> On Wed, Jul 14, 2010 at 06:29:58PM -0700, Zach Pfeffer wrote:
> >> > The VCM ensures that all mappings that map a given physical buffer:
> >> > IOMMU mappings, CPU mappings and one-to-one device mappings all map
> >> > that buffer using the same (or compatible) attributes. At this point
> >> > the only attribute that users can pass is CACHED. In the absence of
> >> > CACHED all accesses go straight through to the physical memory.
> >> 
> >> So what you're saying is that if I have a buffer in kernel space
> >> which I already have its virtual address, I can pass this to VCM and
> >> tell it !CACHED, and it'll setup another mapping which is not cached
> >> for me?
> >
> > Not quite. The existing mapping will be represented by a reservation
> > from the prebuilt VCM of the VM. This reservation has been marked
> > non-cached. Another reservation on a IOMMU VCM, also marked non-cached
> > will be backed with the same physical memory. This is legal in ARM,
> > allowing the vcm_back call to succeed. If you instead passed cached on
> > the second mapping, the first mapping would be non-cached and the
> > second would be cached. If the underlying architecture supported this
> > than the vcm_back would go through.
> 
> How does this compare with the x86 pat code?

First, thanks for asking this question. I wasn't aware of the x86 pat
code and I got to read about it. From my initial read the VCM differs in 2 ways:

1. The attributes are explicitly set on virtual address ranges. These
reservations can then map physical memory with these attributes.

2. We explicitly allow multiple mappings (as long as the attributes are
compatible). One such mapping may come from a IOMMU's virtual address
space while another comes from the CPUs virtual address space. These
mappings may exist at the same time.

> 
> >> You are aware that multiple V:P mappings for the same physical page
> >> with different attributes are being outlawed with ARMv6 and ARMv7
> >> due to speculative prefetching.  The cache can be searched even for
> >> a mapping specified as 'normal, uncached' and you can get cache hits
> >> because the data has been speculatively loaded through a separate
> >> cached mapping of the same physical page.
> >
> > I didn't know that. Thanks for the heads up.
> >
> >> FYI, during the next merge window, I will be pushing a patch which makes
> >> ioremap() of system RAM fail, which should be the last core code creator
> >> of mappings with different memory types.  This behaviour has been outlawed
> >> (as unpredictable) in the architecture specification and does cause
> >> problems on some CPUs.
> >
> > That's fair enough, but it seems like it should only be outlawed for
> > those processors on which it breaks.
> 
> To my knowledge mismatch of mapping attributes is a problem on most
> cpus on every architecture.  I don't see it making sense to encourage
> coding constructs that will fail in the strangest most difficult to
> debug ways.

Yes it is a problem, as Russell has brought up, but there's something
I probably haven't communicated well. I'll use the following example:

There are 3 devices: A CPU, a decoder and a video output device. All 3
devices need to map the same 12 MB buffer at the same time. Once this
buffer has served its purpose it gets freed and goes back into the
pool of big buffers. When the same usage case exists again the buffer
needs to get reallocated and the same devices need to map to it.

This usage case does exist, not only for Qualcomm but for all of these
SoC media engines that have started running Linux. The VCM API
attempts to cover this case for the Linux kernel.
