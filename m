Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab2IJNNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:13:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:53908 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab2IJNNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:13:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,398,1344236400"; 
   d="scan'208";a="220245325"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Cc: Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v2 00/10] Introduce huge zero page
Date: Mon, 10 Sep 2012 16:13:23 +0300
Message-Id: <1347282813-21935-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

During testing I noticed big (up to 2.5 times) memory consumption overhead
on some workloads (e.g. ft.A from NPB) if THP is enabled.

The main reason for that big difference is lacking zero page in THP case.
We have to allocate a real page on read page fault.

A program to demonstrate the issue:
#include <assert.h>
#include <stdlib.h>
#include <unistd.h>

#define MB 1024*1024

int main(int argc, char **argv)
{
        char *p;
        int i;

        posix_memalign((void **)&p, 2 * MB, 200 * MB);
        for (i = 0; i < 200 * MB; i+= 4096)
                assert(p[i] == 0);
        pause();
        return 0;
}

With thp-never RSS is about 400k, but with thp-always it's 200M.
After the patcheset thp-always RSS is 400k too.

v2:
 - Avoid find_vma() if we've already had vma on stack.
   Suggested by Andrea Arcangeli.
 - Implement refcounting for huge zero page.

Kirill A. Shutemov (10):
  thp: huge zero page: basic preparation
  thp: zap_huge_pmd(): zap huge zero pmd
  thp: copy_huge_pmd(): copy huge zero page
  thp: do_huge_pmd_wp_page(): handle huge zero page
  thp: change_huge_pmd(): keep huge zero page write-protected
  thp: change split_huge_page_pmd() interface
  thp: implement splitting pmd for huge zero page
  thp: setup huge zero page on non-write page fault
  thp: lazy huge zero page allocation
  thp: implement refcounting for huge zero page

 Documentation/vm/transhuge.txt |    4 +-
 arch/x86/kernel/vm86_32.c      |    2 +-
 fs/proc/task_mmu.c             |    2 +-
 include/linux/huge_mm.h        |   14 ++-
 include/linux/mm.h             |    8 +
 mm/huge_memory.c               |  303 ++++++++++++++++++++++++++++++++++++----
 mm/memory.c                    |   11 +--
 mm/mempolicy.c                 |    2 +-
 mm/mprotect.c                  |    2 +-
 mm/mremap.c                    |    2 +-
 mm/pagewalk.c                  |    2 +-
 11 files changed, 301 insertions(+), 51 deletions(-)

-- 
1.7.7.6

