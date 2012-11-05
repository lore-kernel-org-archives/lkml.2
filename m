Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab2KETDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:03:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:51124 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab2KETDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:03:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,716,1344236400"; 
   d="scan'208";a="215452751"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v3 0/8] Improve performance of VM translation on x86_64
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Mon, 05 Nov 2012 11:03:25 -0800
Message-ID: <20121105185657.10205.27419.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
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
my routing tests.  Without my earlier swiotlb changes applied it was getting as
high as 6-7% because that code originally relied heavily on virt_to_phys.

The overall effect on size varies depending on what kernel options are
enabled.  I have notices that almost all of the network device drivers have
dropped in size by around 100 bytes.  I suspect this is due to the fact that
the virt_to_page call in dma_map_single is now less expensive.  However the
default build for x86_64 increases the vmlinux size by 3.5K with this change
applied.

---

Alexander Duyck (8):
      x86/lguest: Use __pa_symbol instead of __pa on C visible symbols
      x86/acpi: Use __pa_symbol instead of __pa on C visible symbols
      x86/xen: Use __pa_symbol instead of __pa on C visible symbols
      x86/ftrace: Use __pa_symbol instead of __pa on C visible symbols
      x86: Use __pa_symbol instead of __pa on C visible symbols
      x86: Drop 4 unnecessary calls to __pa_symbol
      x86: Make it so that __pa_symbol can only process kernel symbols on x86_64
      x86: Improve __phys_addr performance by making use of carry flags and inlining


 arch/x86/include/asm/page.h          |    3 +-
 arch/x86/include/asm/page_32.h       |    1 +
 arch/x86/include/asm/page_64_types.h |   20 +++++++++++-
 arch/x86/kernel/acpi/sleep.c         |    2 +
 arch/x86/kernel/cpu/intel.c          |    2 +
 arch/x86/kernel/ftrace.c             |    4 +-
 arch/x86/kernel/head32.c             |    4 +-
 arch/x86/kernel/head64.c             |    4 +-
 arch/x86/kernel/setup.c              |   16 +++++-----
 arch/x86/kernel/x8664_ksyms_64.c     |    3 ++
 arch/x86/lguest/boot.c               |    3 +-
 arch/x86/mm/init_64.c                |   18 +++++------
 arch/x86/mm/pageattr.c               |    8 ++---
 arch/x86/mm/physaddr.c               |   55 +++++++++++++++++++++++++---------
 arch/x86/platform/efi/efi.c          |    4 +-
 arch/x86/realmode/init.c             |    8 ++---
 arch/x86/xen/mmu.c                   |   21 +++++++------
 17 files changed, 111 insertions(+), 65 deletions(-)

-- 
