Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363Ab2JKUth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:49:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:53033 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759263Ab2JKUte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:49:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,573,1344236400"; 
   d="scan'208";a="203427539"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v2 0/8] Improve performance of VM translation on x86_64
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Thu, 11 Oct 2012 13:49:52 -0700
Message-ID: <20121011204324.12787.30514.stgit@gitlad.jf.intel.com>
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


 arch/x86/include/asm/page.h          |    3 ++-
 arch/x86/include/asm/page_32.h       |    1 +
 arch/x86/include/asm/page_64_types.h |   20 +++++++++++++++++--
 arch/x86/kernel/acpi/sleep.c         |    2 +-
 arch/x86/kernel/cpu/intel.c          |    2 +-
 arch/x86/kernel/ftrace.c             |    4 ++--
 arch/x86/kernel/head32.c             |    4 ++--
 arch/x86/kernel/head64.c             |    4 ++--
 arch/x86/kernel/setup.c              |   16 ++++++++--------
 arch/x86/kernel/x8664_ksyms_64.c     |    3 +++
 arch/x86/lguest/boot.c               |    3 ++-
 arch/x86/mm/pageattr.c               |    8 ++++----
 arch/x86/mm/physaddr.c               |   35 ++++++++++++++++++++++++++++------
 arch/x86/platform/efi/efi.c          |    4 ++--
 arch/x86/realmode/init.c             |    8 ++++----
 arch/x86/xen/mmu.c                   |   19 ++++++++++--------
 16 files changed, 91 insertions(+), 45 deletions(-)

-- 
