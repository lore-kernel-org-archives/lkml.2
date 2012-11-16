Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2KPVxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:53:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:59410 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab2KPVxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:53:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,266,1352102400"; 
   d="scan'208";a="220836845"
Subject: [PATCH v4 0/8] Improve performance of VM translation on x86_64
To: tglx@linutronix.de, mingo@redhat.com, andi@firstfloor.org, hpa@zytor.com
From: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 16 Nov 2012 13:52:39 -0800
Message-ID: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is meant to address several issues I encountered with VM
translations on x86_64.  In my testing I found that swiotlb was incurring up
to a 5% processing overhead due to calls to __phys_addr.  To address that I
have updated swiotlb to use physical addresses instead of virtual addresses
to reduce the need to call __phys_addr.  However those patches didn't address
the other callers.  With these patches applied I am able to achieve an
additional 1% to 2% performance gain on top of the changes to swiotlb.

The first 2 patches are the performance optimizations that result in the 1% to
2% increase in overall performance.  The remaining patches are various
cleanups for a number of spots where __pa or virt_to_phys was being called
and was not needed or __pa_symbol could have been used.

It doesn't seem like the v2 patch set was accepted so I am submitting an
updated v3 set that is rebased off of linux-next with a few additional
improvements to the existing patches.  Specifically the first patch now also
updates __virt_addr_valid so that it is almost identical in layout to
__phys_addr.  Also I found one additional spot in init_64.c that could use
__pa_symbol instead of virt_to_page calls so I updated the first __pa_symbol
patch for the x86 init calls.

With this patch set applied I am noticing a 1-2% improvement in performance in
my routing tests.  Without my earlier swiotlb changes applied it was getting
as high as 6-7% because that code originally relied heavily on virt_to_phys.

The overall effect on size varies depending on what kernel options are
enabled.  I have notices that almost all of the network device drivers have
dropped in size by around 100 bytes.  I suspect this is due to the fact that
the virt_to_page call in dma_map_single is now less expensive.  However the
default build for x86_64 increases the vmlinux size by 3.5K with this change
applied.

v2:  Rebased changes onto linux-next due to changes in x86/xen tree.
v3:  Changes to __virt_addr_valid so it was in sync with __phys_addr.
     Changes to init_64.c function mark_rodata_ro to avoid virt_to_page calls.
v4:  Spun x86/xen changes off as a separate patch.
     Added new patch to push address translation into page_64.h.
     Minor change to __phys_addr_symbol to avoid unnecessary second > check.
---

Alexander Duyck (8):
      x86: Move some contents of page_64_types.h into pgtable_64.h and page_64.h
      x86: Improve __phys_addr performance by making use of carry flags and inlining
      x86: Make it so that __pa_symbol can only process kernel symbols on x86_64
      x86: Drop 4 unnecessary calls to __pa_symbol
      x86: Use __pa_symbol instead of __pa on C visible symbols
      x86/ftrace: Use __pa_symbol instead of __pa on C visible symbols
      x86/acpi: Use __pa_symbol instead of __pa on C visible symbols
      x86/lguest: Use __pa_symbol instead of __pa on C visible symbols


 arch/x86/include/asm/page.h          |    3 +-
 arch/x86/include/asm/page_32.h       |    1 +
 arch/x86/include/asm/page_64.h       |   36 ++++++++++++++++++++++++
 arch/x86/include/asm/page_64_types.h |   22 ---------------
 arch/x86/include/asm/pgtable_64.h    |    5 +++
 arch/x86/kernel/acpi/sleep.c         |    2 +
 arch/x86/kernel/cpu/intel.c          |    2 +
 arch/x86/kernel/ftrace.c             |    4 +--
 arch/x86/kernel/head32.c             |    4 +--
 arch/x86/kernel/head64.c             |    4 +--
 arch/x86/kernel/setup.c              |   16 +++++------
 arch/x86/kernel/x8664_ksyms_64.c     |    3 ++
 arch/x86/lguest/boot.c               |    3 +-
 arch/x86/mm/init_64.c                |   18 +++++-------
 arch/x86/mm/pageattr.c               |    8 +++--
 arch/x86/mm/physaddr.c               |   51 ++++++++++++++++++++++++----------
 arch/x86/platform/efi/efi.c          |    4 +--
 arch/x86/realmode/init.c             |    8 +++--
 18 files changed, 119 insertions(+), 75 deletions(-)

-- 
Signature
