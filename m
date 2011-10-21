Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1JUMWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 08:22:12 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:55212 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab1JUMWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 08:22:11 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz4015Lzz1202hzz8275bh5eeeMz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LTF10U-01-LZ8-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        <akpm@linux-foundation.org>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <joro@8bytes.org>
Subject: [RFC][PATCH 0/3] Add support for non-CPU TLBs in MMU-Notifiers
Date: Fri, 21 Oct 2011 14:21:45 +0200
Message-ID: <1319199708-17777-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is my first attempt to add support for non-CPU TLBs to the
MMU-Notifier framework. This will be used by the AMD IOMMU driver for
the next generation of hardware. The next version of the AMD IOMMU can
walk page-tables in AMD64 long-mode format (with setting
accessed/dirty-bits atomically) and save the translations in its own
TLB. Page faulting for IO devices is supported too. This will be used to
let hardware devices share page-tables with CPU processes and access
their memory directly. Please look at

	http://support.amd.com/us/Processor_TechDocs/48882.pdf

for details. The link points to the specification for the next version
of the IOMMU.

The current problem with the MMU-Notifiers is the definition of the
invalidate_range_start/end call-backs.  The invalidate_range_start()
function is called when the pages are still mapped while
invalidate_range_end() is called when the pages are unmapped and already
freed. This is too late to flush any external TLB.  The TLB needs to be
flushed when the pages are unmapped but not yet freed.

Holding a reference to the pages in the range is no option because the
subsystem has to keep the pointer to these pages then. This doesn't
really scale with the size of the range to be unmapped. A related
problem is that the memory to hold the page-pointers can't be easily
allocated in the invalidate_range_start() notifier because it is not
allowed to preempt (because it is called under rcu_read_lock).

A simpler approach is to add a new notifier which is called between
invalidate_range_start/end by the VM every time it is about to free
pages that it has unmapped. This is the same point in time when the VM
would flush the TLB on any remote CPUs, so this is a logical point to
also flush any non-CPU TLB for an MM. This approach is implemented by
this patch-set.

As a side requirement it is necessary to disable the tlb_fast_mode when
an mm has notifers. The first patch in this series implements this. The
second patch implements the new callback into the MMU-Notifier framework
and the last patch adds the calls to the notifier into the MM code where
necessary.

A known limitation of this patch-set is that it only disables
tlb_fast_mode for the generic implementation of mmu_gather. I will add
support for the architectures with their own implementation in the next
version. I wanted to keep this one small to get your feedback on the
general idea.

Any feedback greatly appreciated.

Thanks,

	Joerg

Diffstat:

 include/asm-generic/tlb.h    |    2 +-
 include/linux/mmu_notifier.h |   33 ++++++++++++++++++++++++++++-----
 mm/hugetlb.c                 |    1 +
 mm/memory.c                  |   13 ++++++++++++-
 mm/mmu_notifier.c            |   13 +++++++++++++
 5 files changed, 55 insertions(+), 7 deletions(-)


