Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761678Ab0GTV4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 17:56:14 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35526 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761629Ab0GTV4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 17:56:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6049"; a="48090437"
Date: Tue, 20 Jul 2010 14:56:05 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tim HRM <zt.tmzt@gmail.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, ebiederm@xmission.com,
        linux-arch@vger.kernel.org, dwalker@codeaurora.org, mel@csn.ul.ie,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, andi@firstfloor.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
 memory management
Message-ID: <20100720215605.GB12250@codeaurora.org>
References: <20100713121420.GB4263@codeaurora.org>
 <20100714104353B.fujita.tomonori@lab.ntt.co.jp>
 <20100714201149.GA14008@codeaurora.org>
 <20100714220536.GE18138@n2100.arm.linux.org.uk>
 <20100715012958.GB2239@codeaurora.org>
 <20100715085535.GC26212@n2100.arm.linux.org.uk>
 <AANLkTinVZeaZxt_lWKhjKa0dqhu3_j3BRNySO-2LvMdw@mail.gmail.com>
 <20100716075856.GC16124@n2100.arm.linux.org.uk>
 <20100720204515.GA12250@codeaurora.org>
 <20100720205433.GA10553@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100720205433.GA10553@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 09:54:33PM +0100, Russell King - ARM Linux wrote:
> On Tue, Jul 20, 2010 at 01:45:17PM -0700, Zach Pfeffer wrote:
> > You can also conflict in access permissions which can and do conflict
> > (which are what multiple mappings are all about...some buffer can get
> > some access, while others get different access).
> 
> Access permissions don't conflict between mappings - each mapping has
> unique access permissions.

Yes. Bad choice of words.

> > The VCM API allows the same memory to be mapped as long as it makes
> > sense and allows those attributes that can change to be specified. It
> > could be the alternative, globally applicable approach, your looking
> > for and request in your patch.
> 
> I very much doubt it - there's virtually no call for creating an
> additional mapping of existing kernel memory with different permissions.
> The only time kernel memory gets remapped is with vmalloc(), where we
> want to create a virtually contiguous mapping from a collection of
> (possibly) non-contiguous pages.  Such allocations are always created
> with R/W permissions.
> 
> There are some cases where the vmalloc APIs are used to create mappings
> with different memory properties, but as already covered, this has become
> illegal with ARMv6 and v7 architectures.
> 
> So no, VCM doesn't help because there's nothing that could be solved here.
> Creating read-only mappings is pointless, and creating mappings with
> different memory type, sharability or cache attributes is illegal.

I don't think its pointless; it may have limited utility but things
like read-only mappings can be useful.

> > Without the VCM API (or something like it) there will just be a bunch
> > of duplicated code that's basically doing ioremap. This code will
> > probably fail to configure its mappings correctly, in which case your
> > patch is a bad idea because it'll spawn bugs all over the place
> > instead of at a know location. We could instead change ioremap to
> > match the attributes of System RAM if that's what its mapping.
> 
> And as I say, what is the point of creating another identical mapping to
> the one we already have?

As you say probably not much. We do still have a problem (and other
people have it as well) we need to map in large contiguous buffers
with various attributes and point the kernel and various engines at
them. This seems like something that would be globally useful. The
feedback I've gotten is that we should just keep our usage private to
our mach-msm branch. 

I've got a couple of questions:

Do you think a global solution to this problem is appropriate?

What would that solution need to look like, transparent huge pages?

How should people change various mapping attributes for these large
sections of memory?
