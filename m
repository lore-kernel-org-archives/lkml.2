Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848Ab2HPPRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:17:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:13555 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964826Ab2HPPQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:16:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,778,1336374000"; 
   d="scan'208";a="181825003"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: linux-mm@kvack.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Alex Shi <alex.shu@intel.com>,
        Jan Beulich <jbeulich@novell.com>,
        Robert Richter <robert.richter@amd.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org
Subject: [PATCH v3 0/7] Avoid cache trashing on clearing huge/gigantic page
Date: Thu, 16 Aug 2012 18:15:47 +0300
Message-Id: <1345130154-9602-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Clearing a 2MB huge page will typically blow away several levels of CPU
caches.  To avoid this only cache clear the 4K area around the fault
address and use a cache avoiding clears for the rest of the 2MB area.

This patchset implements cache avoiding version of clear_page only for
x86. If an architecture wants to provide cache avoiding version of
clear_page it should to define ARCH_HAS_USER_NOCACHE to 1 and implement
clear_page_nocache() and clear_user_highpage_nocache().

v3:
  - Rebased to current Linus' tree. kmap_atomic() build issue is fixed;
  - Pass fault address to clear_huge_page(). v2 had problem with clearing
    for sizes other than HPAGE_SIZE
  - x86: fix 32bit variant. Fallback version of clear_page_nocache() has
    been added for non-SSE2 systems;
  - x86: clear_page_nocache() moved to clear_page_{32,64}.S;
  - x86: use pushq_cfi/popq_cfi instead of push/pop;
v2:
  - No code change. Only commit messages are updated.
  - RFC mark is dropped.

Andi Kleen (5):
  THP: Use real address for NUMA policy
  THP: Pass fault address to __do_huge_pmd_anonymous_page()
  x86: Add clear_page_nocache
  mm: make clear_huge_page cache clear only around the fault address
  x86: switch the 64bit uncached page clear to SSE/AVX v2

Kirill A. Shutemov (2):
  hugetlb: pass fault address to hugetlb_no_page()
  mm: pass fault address to clear_huge_page()

 arch/x86/include/asm/page.h      |    2 +
 arch/x86/include/asm/string_32.h |    5 ++
 arch/x86/include/asm/string_64.h |    5 ++
 arch/x86/lib/Makefile            |    3 +-
 arch/x86/lib/clear_page_32.S     |   72 +++++++++++++++++++++++++++++++++++
 arch/x86/lib/clear_page_64.S     |   78 ++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/fault.c              |    7 +++
 include/linux/mm.h               |    2 +-
 mm/huge_memory.c                 |   17 ++++----
 mm/hugetlb.c                     |   39 ++++++++++---------
 mm/memory.c                      |   37 +++++++++++++++---
 11 files changed, 232 insertions(+), 35 deletions(-)
 create mode 100644 arch/x86/lib/clear_page_32.S

-- 
1.7.7.6

