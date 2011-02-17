Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab1BQRhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:37:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:35447 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab1BQRhI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:37:08 -0500
Subject: Re: [PATCH 00/17] mm: mmu_gather rework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
In-Reply-To: <20110217162327.434629380@chello.nl>
References: <20110217162327.434629380@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 17 Feb 2011 18:36:20 +0100
Message-ID: <1297964180.2413.2028.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 17:23 +0100, Peter Zijlstra wrote:
> Rework the existing mmu_gather infrastructure.
> 
> The direct purpose of these patches was to allow preemptible mmu_gather,
> but even without that I think these patches provide an improvement to the
> status quo.
> 
> The first patch is a fix to the tile architecture, the subsequent 9 patches
> rework the mmu_gather infrastructure. For review purpose I've split them
> into generic and per-arch patches with the last of those a generic cleanup.
> 
> For the final commit I would provide a roll-up of these patches so as not
> to wreck bisectability of non generic archs.
> 
> The next patch provides generic RCU page-table freeing, and the follow up
> is a patch converting s390 to use this. I've also got 4 patches from
> DaveM lined up (not included in this series) that uses this to implement
> gup_fast() for sparc64.
> 
> Then there is one patch that extends the generic mmu_gather batching.
> 
> Finally there are 4 patches that convert various architectures over
> to asm-generic/tlb.h, these are compile tested only and basically RFC.
> 
> After this only um and s390 are left -- um should be straight forward,
> s390 wants a bit more, but more on that in another email.

---
 arch/Kconfig                           |    6 
 arch/alpha/mm/init.c                   |    2 
 arch/arm/Kconfig                       |    1 
 arch/arm/include/asm/tlb.h             |   83 ------------
 arch/arm/include/asm/tlbflush.h        |    5 
 arch/arm/mm/mmu.c                      |    2 
 arch/avr32/mm/init.c                   |    2 
 arch/cris/mm/init.c                    |    2 
 arch/frv/mm/init.c                     |    2 
 arch/ia64/Kconfig                      |    1 
 arch/ia64/include/asm/tlb.h            |  147 +--------------------
 arch/ia64/mm/init.c                    |    2 
 arch/m32r/mm/init.c                    |    2 
 arch/m68k/mm/init.c                    |    2 
 arch/microblaze/mm/init.c              |    2 
 arch/mips/mm/init.c                    |    2 
 arch/mn10300/mm/init.c                 |    2 
 arch/parisc/mm/init.c                  |    2 
 arch/powerpc/Kconfig                   |    1 
 arch/powerpc/include/asm/pgalloc.h     |   21 ++-
 arch/powerpc/include/asm/thread_info.h |    2 
 arch/powerpc/kernel/process.c          |   23 +++
 arch/powerpc/mm/pgtable.c              |  104 ---------------
 arch/powerpc/mm/tlb_hash32.c           |    3 
 arch/powerpc/mm/tlb_hash64.c           |   11 -
 arch/powerpc/mm/tlb_nohash.c           |    3 
 arch/s390/Kconfig                      |    1 
 arch/s390/include/asm/pgalloc.h        |   19 +-
 arch/s390/include/asm/tlb.h            |  100 +++++++-------
 arch/s390/mm/pgtable.c                 |  193 +++-------------------------
 arch/score/mm/init.c                   |    2 
 arch/sh/Kconfig                        |    1 
 arch/sh/include/asm/tlb.h              |   92 -------------
 arch/sh/mm/init.c                      |    1 
 arch/sparc/include/asm/pgalloc_64.h    |    3 
 arch/sparc/include/asm/pgtable_64.h    |   15 +-
 arch/sparc/include/asm/tlb_64.h        |   91 -------------
 arch/sparc/include/asm/tlbflush_64.h   |   12 +
 arch/sparc/mm/init_32.c                |    2 
 arch/sparc/mm/tlb.c                    |   43 +++---
 arch/sparc/mm/tsb.c                    |   15 +-
 arch/tile/mm/init.c                    |    2 
 arch/tile/mm/pgtable.c                 |   15 --
 arch/um/include/asm/tlb.h              |   29 +---
 arch/um/kernel/smp.c                   |    3 
 arch/x86/mm/init.c                     |    2 
 arch/xtensa/mm/mmu.c                   |    2 
 fs/exec.c                              |   10 -
 include/asm-generic/tlb.h              |  227 +++++++++++++++++++++++++++------
 include/linux/mm.h                     |    2 
 mm/memory.c                            |  119 +++++++++++++----
 mm/mmap.c                              |   18 +-
 52 files changed, 536 insertions(+), 918 deletions(-)

