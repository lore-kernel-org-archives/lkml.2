Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab0GTUqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:46:38 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7258 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758376Ab0GTUp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:45:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6049"; a="48083224"
Date: Tue, 20 Jul 2010 13:45:17 -0700
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
Message-ID: <20100720204515.GA12250@codeaurora.org>
References: <4C3C0032.5020702@codeaurora.org>
 <20100713150311B.fujita.tomonori@lab.ntt.co.jp>
 <20100713121420.GB4263@codeaurora.org>
 <20100714104353B.fujita.tomonori@lab.ntt.co.jp>
 <20100714201149.GA14008@codeaurora.org>
 <20100714220536.GE18138@n2100.arm.linux.org.uk>
 <20100715012958.GB2239@codeaurora.org>
 <20100715085535.GC26212@n2100.arm.linux.org.uk>
 <AANLkTinVZeaZxt_lWKhjKa0dqhu3_j3BRNySO-2LvMdw@mail.gmail.com>
 <20100716075856.GC16124@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100716075856.GC16124@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 08:58:56AM +0100, Russell King - ARM Linux wrote:
> On Thu, Jul 15, 2010 at 08:48:36PM -0400, Tim HRM wrote:
> > Interesting, since I seem to remember the MSM devices mostly conduct
> > IO through regions of normal RAM, largely accomplished through
> > ioremap() calls.
> > 
> > Without more public domain documentation of the MSM chips and AMSS
> > interfaces I wouldn't know how to avoid this, but I can imagine it
> > creates a bit of urgency for Qualcomm developers as they attempt to
> > upstream support for this most interesting SoC.
> 
> As the patch has been out for RFC since early April on the linux-arm-kernel
> mailing list (Subject: [RFC] Prohibit ioremap() on kernel managed RAM),
> and no comments have come back from Qualcomm folk.
> 
> The restriction on creation of multiple V:P mappings with differing
> attributes is also fairly hard to miss in the ARM architecture
> specification when reading the sections about caches.

As you mention in your patch the things that can't conflict are memory
type (strongly- ordered/device/normal), cache policy
(cacheable/non-cacheable, copy- back/write-through), and coherency
realm (non-shareable/inner- shareable/outer-shareable). You can
conflict in allocation preferences (write-allocate/write-no-allocate),
as those are just "hints".

You can also conflict in access permissions which can and do conflict
(which are what multiple mappings are all about...some buffer can get
some access, while others get different access).

The VCM API allows the same memory to be mapped as long as it makes
sense and allows those attributes that can change to be specified. It
could be the alternative, globally applicable approach, your looking
for and request in your patch.

Without the VCM API (or something like it) there will just be a bunch
of duplicated code that's basically doing ioremap. This code will
probably fail to configure its mappings correctly, in which case your
patch is a bad idea because it'll spawn bugs all over the place
instead of at a know location. We could instead change ioremap to
match the attributes of System RAM if that's what its mapping.



