Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab0DAO3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 10:29:12 -0400
Received: from 8bytes.org ([88.198.83.132]:39555 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab0DAO3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 10:29:05 -0400
Date: Thu, 1 Apr 2010 16:29:02 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] amd iommu: force flush of iommu prior during shutdown
Message-ID: <20100401142902.GF24846@8bytes.org>
References: <20100331152417.GB13406@hmsreliant.think-freely.org> <20100331155430.GF14011@redhat.com> <20100331182824.GC13406@hmsreliant.think-freely.org> <m1wrwsuxn9.fsf@fess.ebiederm.org> <20100331191811.GD13406@hmsreliant.think-freely.org> <m1sk7guv5u.fsf@fess.ebiederm.org> <20100331202745.GE13406@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331202745.GE13406@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

first some general words about the problem you discovered: The problem
is not caused by in-flight DMA. The problem is that the IOMMU hardware
has cached the old DTE entry for the device (including the old
page-table root pointer) and is using it still when the kdump kernel has
booted. We had this problem once and fixed it by flushing a DTE in the
IOMMU before it is used for the first time. This seems to be broken
now. Which kernel have you seen this on?

I am back in office next tuesday and will look into this problem too.

On Wed, Mar 31, 2010 at 04:27:45PM -0400, Neil Horman wrote:
> So I'm officially rescinding this patch.

Yeah, the right solution to this problem is to find out why every DTE is
not longer flushed before first use.

> It apparently just covered up the problem, rather than solved it
> outright.  This is going to take some more thought on my part.  I read
> the code a bit closer, and the amd iommu on boot up currently marks
> all its entries as valid and having a valid translation (because if
> they're marked as invalid they're passed through untranslated which
> strikes me as dangerous, since it means a dma address treated as a bus
> address could lead to memory corruption.  The saving grace is that
> they are marked as non-readable and non-writeable, so any device doing
> a dma after the reinit should get logged (which it does), and then
> target aborted (which should effectively squash the translation)

Right. The default for all devices is to forbid DMA.

> I'm starting to wonder if:
> 
> 1) some dmas are so long lived they start aliasing new dmas that get mapped in
> the kdump kernel leading to various erroneous behavior

At least not in this case. Even when this is true the DMA would target
memory of the crashed kernel and not the kdump area. This is not even
memory corruption because the device will write to memory the driver has
allocated for it.

> 2) a slew of target aborts to some hardware results in them being in an
> inconsistent state

Thats indeed true. I have seen that with ixgbe cards for example. They
seem to be really confused after an target abort.

> I'm going to try marking the dev table on shutdown such that all devices have no
> read/write permissions to see if that changes the situation.  It should I think
> give me a pointer as to weather (1) or (2) is the more likely problem.

Probably not. You still need to flush the old entries out of the IOMMU.

Thanks,

	Joerg

