Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab3AIB2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 20:28:31 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63837 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab3AIB22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 20:28:28 -0500
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Matt Turner <mattst88@gmail.com>, David Howells <dhowells@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-parisc@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: [PATCH 0/8] vm_unmapped_area: finish the mission
Date: Tue,  8 Jan 2013 17:28:07 -0800
Message-Id: <1357694895-520-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches, which apply on top of v3.8-rc kernels, are to complete the
VMA gap finding code I introduced (following Rik's initial proposal) in
v3.8-rc1.

First 5 patches introduce the use of vm_unmapped_area() to replace brute
force searches on parisc, alpha, frv and ia64 architectures (all relatively
trivial uses of the vm_unmapped_area() infrastructure)

Next 2 patches do the same as above for the powerpc architecture. This
change is not as trivial as for the other architectures, because we
need to account for each address space slice potentially having a
different page size.

The last patch removes the free_area_cache, which was used by all the
brute force searches before they got converted to the
vm_unmapped_area() infrastructure.

I did some basic testing on x86 and powerpc; however the first 5 (simpler)
patches for parisc, alpha, frv and ia64 architectures are untested.

Michel Lespinasse (8):
  mm: use vm_unmapped_area() on parisc architecture
  mm: use vm_unmapped_area() on alpha architecture
  mm: use vm_unmapped_area() on frv architecture
  mm: use vm_unmapped_area() on ia64 architecture
  mm: use vm_unmapped_area() in hugetlbfs on ia64 architecture
  mm: remove free_area_cache use in powerpc architecture
  mm: use vm_unmapped_area() on powerpc architecture
  mm: remove free_area_cache

 arch/alpha/kernel/osf_sys.c              |   20 ++--
 arch/arm/mm/mmap.c                       |    2 -
 arch/arm64/mm/mmap.c                     |    2 -
 arch/frv/mm/elf-fdpic.c                  |   49 +++----
 arch/ia64/kernel/sys_ia64.c              |   37 ++----
 arch/ia64/mm/hugetlbpage.c               |   20 ++--
 arch/mips/mm/mmap.c                      |    2 -
 arch/parisc/kernel/sys_parisc.c          |   46 +++----
 arch/powerpc/include/asm/page_64.h       |    3 +-
 arch/powerpc/mm/hugetlbpage.c            |    2 +-
 arch/powerpc/mm/mmap_64.c                |    2 -
 arch/powerpc/mm/slice.c                  |  228 +++++++++++++-----------------
 arch/powerpc/platforms/cell/spufs/file.c |    2 +-
 arch/s390/mm/mmap.c                      |    4 -
 arch/sparc/kernel/sys_sparc_64.c         |    2 -
 arch/tile/mm/mmap.c                      |    2 -
 arch/x86/ia32/ia32_aout.c                |    2 -
 arch/x86/mm/mmap.c                       |    2 -
 fs/binfmt_aout.c                         |    2 -
 fs/binfmt_elf.c                          |    2 -
 include/linux/mm_types.h                 |    3 -
 include/linux/sched.h                    |    2 -
 kernel/fork.c                            |    4 -
 mm/mmap.c                                |   28 ----
 mm/nommu.c                               |    4 -
 mm/util.c                                |    1 -
 26 files changed, 163 insertions(+), 310 deletions(-)

-- 
1.7.7.3
