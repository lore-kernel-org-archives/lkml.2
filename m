Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761930Ab0GUAoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 20:44:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18568 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761501Ab0GUAoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 20:44:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6049"; a="48105359"
Date: Tue, 20 Jul 2010 17:44:09 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
To: Tim HRM <zt.tmzt@gmail.com>
Cc: Larry Bassel <lbassel@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, ebiederm@xmission.com,
        linux-arch@vger.kernel.org, dwalker@codeaurora.org, mel@csn.ul.ie,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, andi@firstfloor.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
 memory management
Message-ID: <20100721004407.GA14176@codeaurora.org>
References: <20100713121420.GB4263@codeaurora.org>
 <20100714104353B.fujita.tomonori@lab.ntt.co.jp>
 <20100714201149.GA14008@codeaurora.org>
 <20100714220536.GE18138@n2100.arm.linux.org.uk>
 <20100715012958.GB2239@codeaurora.org>
 <20100715085535.GC26212@n2100.arm.linux.org.uk>
 <AANLkTinVZeaZxt_lWKhjKa0dqhu3_j3BRNySO-2LvMdw@mail.gmail.com>
 <20100716075856.GC16124@n2100.arm.linux.org.uk>
 <20100717000108.GB21293@labbmf-linux.quicinc.com>
 <AANLkTinTQXbsD91JDHiSFrvDoUeHbaGUGSWA-5aT5ZCr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinTQXbsD91JDHiSFrvDoUeHbaGUGSWA-5aT5ZCr@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 05:21:35AM -0400, Tim HRM wrote:
> On Fri, Jul 16, 2010 at 8:01 PM, Larry Bassel <lbassel@codeaurora.org> wrote:
> > On 16 Jul 10 08:58, Russell King - ARM Linux wrote:
> >> On Thu, Jul 15, 2010 at 08:48:36PM -0400, Tim HRM wrote:
> >> > Interesting, since I seem to remember the MSM devices mostly conduct
> >> > IO through regions of normal RAM, largely accomplished through
> >> > ioremap() calls.
> >> >
> >> > Without more public domain documentation of the MSM chips and AMSS
> >> > interfaces I wouldn't know how to avoid this, but I can imagine it
> >> > creates a bit of urgency for Qualcomm developers as they attempt to
> >> > upstream support for this most interesting SoC.
> >>
> >> As the patch has been out for RFC since early April on the linux-arm-kernel
> >> mailing list (Subject: [RFC] Prohibit ioremap() on kernel managed RAM),
> >> and no comments have come back from Qualcomm folk.
> >
> > We are investigating the impact of this change on us, and I
> > will send out more detailed comments next week.
> >
> >>
> >> The restriction on creation of multiple V:P mappings with differing
> >> attributes is also fairly hard to miss in the ARM architecture
> >> specification when reading the sections about caches.
> >>
> >
> > Larry Bassel
> >
> > --
> > Sent by an employee of the Qualcomm Innovation Center, Inc.
> > The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> >
> 
> Hi Larry and Qualcomm people.
> I'm curious what your reason for introducing this new api (or adding
> to dma) is.  Specifically how this would be used to make the memory
> mapping of the MSM chip dynamic in contrast to the fixed _PHYS defines
> in the Android and Codeaurora trees.

The MSM has many integrated engines that allow offloading a variety of
workloads. These engines have always addressed memory using physical
addresses, because of this we had to reserve large (10's MB) buffers
at boot. These buffers are never freed regardless of whether an engine
is actually using them. As you can imagine, needing to reserve memory
for all time on a device that doesn't have a lot of memory in the
first place is not ideal because that memory could be used for other
things, running apps, etc.

To solve this problem we put IOMMUs in front of a lot of the
engines. IOMMUs allow us to map physically discontiguous memory into a
virtually contiguous address range. This means that we could ask the
OS for 10 MB of pages and map all of these into our IOMMU space and
the engine would still see a contiguous range.

In reality, limitations in the hardware meant that we needed to map
memory using larger mappings to minimize the number of TLB
misses. This, plus the number of IOMMUs and the extreme use cases we
needed to design for led us to a generic design.

This generic design solved our problem and the general mapping
problem. We thought other people, who had this same big-buffer
interoperation problem would also appreciate a common API that was
built with their needs in mind so we pushed our idea up.

> 
> I'm also interested in how this ability to map memory regions as files
> for devices like KGSL/DRI or PMEM might work and why this is better
> suited to that purpose than existing methods, where this fits into
> camera preview and other issues that have been dealt with in these
> trees in novel ways (from my perspective).

The file based approach was driven by Android's buffer passing scheme
and the need to write userspace drivers for multimedia, etc...

