Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab1JKVNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 17:13:08 -0400
Received: from na3sys010aog114.obsmtp.com ([74.125.245.96]:40152 "HELO
	na3sys010aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751998Ab1JKVNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 17:13:07 -0400
From: Roland Dreier <roland@purestorage.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Help debugging possible cache coherency bug with Intel IOMMU (DMAR / VT-d)?
Date: Tue, 11 Oct 2011 14:11:36 -0700
Message-Id: <1318367496-24641-1-git-send-email-roland@purestorage.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@kernel.org>

Hi Dave (and other VT-d hackers),

I'm chasing a bug that is beginning to look like a problem with the
intel-iommu cache flushing.  We're running a kernel that is basically
2.6.39.3 (but I don't see any relevant intel-iommu changes in any
newer kernels) with some qla2xxx patches to add target mode support --
and that qla2xxx target mode support is our heaviest DMA API user.

The problem I'm chasing is that every so often we see stuff like:

    [ 7734.074535] DRHD: handling fault status reg 2
    [ 7734.078994] DMAR:[DMA Read] Request device [05:00.1] fault addr ff8fe000 
    [ 7734.078996] DMAR:[fault reason 06] PTE Read access is not set

(Sometimes the problem is a write fault -- I've seen it both ways)

In any case, 05:00.1 is our qla2xxx HBA.  I've stared at our qla2xxx
code until my eyes cross, and I don't see how it could unmap DMA
memory before the HBA is done.  I enabled CONFIG_DMA_API_DEBUG and
also added a debug_dma_dump_mappings() call to the end of
dmar_fault_do_one(); in the run above I do see

    [ 7734.723764] qla2xxx 0000:05:00.1: scather-gather idx 127 P=47f252000 D=ff8fe000 L=1000 DMA_TO_DEVICE

in the output that triggers (along with a bunch of other mappings of
course).  I think the implication is that the DMA API thinks there is
a valid mapping with read permission set at the time the IOMMU gives
us a DMA read fault.

Now, this is happening with VT-d coherency turned off on this box:

    [    0.221281] IOMMU 0: reg_base_addr fbffe000 ver 1:0 cap c90780106f0462 ecap f020fe

I've kicked off some tests with the coherency option turned on in the
BIOS, and not hit this fault yet (but that's not conclusive -- this
problem is pretty intermittent and I haven't run long enough yet to
convince myself it never happens with coherency enabled).

But let's suppose there is a cache coherency problem with the IOMMU
(maybe the qla2xxx target code exposes it because of hitting things in
a strange multithreaded way or something).  Do you have any thoughts
about how we could track it down and fix it?  Or maybe the bug is in
our hacked qla2xxx but I'm too blind to see it -- any thoughts on
getting better diagnostics about what it is doing wrong?

Thanks!
  Roland
