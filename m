Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab2FAJKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:10:55 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:42141 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2FAJKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:10:52 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 00/27] Generic framework for SMP booting/CPU hotplug related
 code
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com
Cc: rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com
Date: Fri, 01 Jun 2012 14:40:03 +0530
Message-ID: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12060109-3864-0000-0000-000003247015
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is an effort to reduce the SMP booting/CPU hotplug related code
duplication in various architectures and pull them out into core code.
Consolidating the code at one place makes it more maintainable and less
error-prone.

There is still a lot of opportunity to pull out more stuff from the arch/
directories into core code than what this patchset does, but this does the
ground-work on top of which we can make more and more code generic.

This applies on top of tip tree's smp/hotplug branch + Yong's ipi_call_lock
cleanup patches[1].

The patch descriptions of some of the arch/ patches contain a section called
"Notes" which documents some of the non-trivial changes implemented in that
patch. This section is to help bring maintainer attention to those code
pieces so that if its wrong for that arch, they can point it out and I'll
work on fixing it.


Acknowledgements:
----------------

Thanks a lot to Paul McKenney for his guidance and for consolidating a
comprehensive list of what needs to be done to make CPU Hotplug better [2]
and [3]. Many thanks to Peter Zijlstra for complaining about the code
duplication in various architectures and pointing out what is missing and
what needs to be worked on.

Also, many thanks to Thomas Gleixner for his initiative to make smp booting
generic and sane, and for his whole bunch of cleanups in that direction.
I hope this patchset can contribute to that effort :-)

References:
[1]. http://marc.info/?l=linux-kernel&m=133827595625509&w=2
[2]. https://lkml.org/lkml/2012/4/9/198
[3]. https://lkml.org/lkml/2012/4/5/379
--
 Nikunj A. Dadhania (9):
      um, smpboot: Use generic SMP booting infrastructure
      sparc64, smpboot: Use generic SMP booting infrastructure
      blackfin, smpboot: Use generic SMP booting infrastructure
      powerpc, smpboot: Use generic SMP booting infrastructure
      mn10300, smpboot: Use generic SMP booting infrastructure
      ia64, smpboot: Use generic SMP booting infrastructure
      hexagon, smpboot: Use generic SMP booting infrastructure
      x86, smpboot: Use generic SMP booting infrastructure
      smpboot: Provide a generic method to boot secondary processors

Srivatsa S. Bhat (18):
      alpha, smpboot: Use generic SMP booting infrastructure
      arm, smpboot: Use generic SMP booting infrastructure
      s390, smpboot: Use generic SMP booting infrastructure
      parisc, smpboot: Use generic SMP booting infrastructure
      cris, smpboot: Use generic SMP booting infrastructure
      sparc32, smpboot: Use generic SMP booting infrastructure
      mn10300: Fix horrible logic in smp_prepare_cpus()
      ia64: Move holding of vector_lock to __setup_vector_irq()
      tile, smpboot: Use generic SMP booting infrastructure
      sh, smpboot: Use generic SMP booting infrastructure
      mips, smpboot: Use generic SMP booting infrastructure
      m32r, smpboot: Use generic SMP booting infrastructure
      m32r: Fix horrible logic in smp_prepare_cpus()
      xen, smpboot: Use generic SMP booting infrastructure
      xen, cpu hotplug: Don't call cpu_bringup() in xen_play_dead()
      smpboot, x86, xen: Determine smp booting implementations at run-time
      smpboot: Define and use cpu_state per-cpu variable in generic code
      smpboot: Add provisions for arch-specific locking around cpu_online_mask


  arch/alpha/kernel/smp.c           |   27 ++++++-----
 arch/arm/kernel/smp.c             |   26 +++++------
 arch/blackfin/mach-bf561/smp.c    |    1 
 arch/blackfin/mach-common/smp.c   |   16 ++++---
 arch/cris/arch-v32/kernel/smp.c   |   14 ++----
 arch/hexagon/kernel/smp.c         |   18 +++----
 arch/ia64/include/asm/cpu.h       |    2 -
 arch/ia64/kernel/irq_ia64.c       |   21 ++++++++-
 arch/ia64/kernel/process.c        |    1 
 arch/ia64/kernel/smpboot.c        |   46 +++++++++----------
 arch/m32r/kernel/smpboot.c        |   50 ++++++++++----------
 arch/mips/cavium-octeon/smp.c     |    4 --
 arch/mips/kernel/smp-cmp.c        |    8 ++-
 arch/mips/kernel/smp-mt.c         |    2 -
 arch/mips/kernel/smp.c            |   23 ++++++---
 arch/mips/kernel/sync-r4k.c       |    3 +
 arch/mn10300/kernel/smp.c         |   36 +++++----------
 arch/parisc/kernel/smp.c          |   30 ++++++------
 arch/powerpc/kernel/smp.c         |   32 +++++++------
 arch/s390/kernel/smp.c            |   12 ++---
 arch/sh/include/asm/smp.h         |    2 -
 arch/sh/kernel/smp.c              |   23 ++++-----
 arch/sparc/kernel/hvtramp.S       |    1 
 arch/sparc/kernel/leon_smp.c      |   25 ++++++----
 arch/sparc/kernel/smp_64.c        |   18 ++++---
 arch/sparc/kernel/sun4d_smp.c     |   26 +++++------
 arch/sparc/kernel/sun4m_smp.c     |   26 ++++++-----
 arch/sparc/kernel/trampoline_32.S |    1 
 arch/sparc/kernel/trampoline_64.S |    1 
 arch/tile/kernel/smpboot.c        |   26 ++++-------
 arch/um/kernel/smp.c              |   12 +++--
 arch/x86/include/asm/cpu.h        |    2 -
 arch/x86/include/asm/smp.h        |   25 ++++++++++
 arch/x86/kernel/apic/io_apic.c    |   15 ++++++
 arch/x86/kernel/smp.c             |    4 ++
 arch/x86/kernel/smpboot.c         |   43 ++++++-----------
 arch/x86/xen/smp.c                |   30 ++----------
 include/linux/smpboot.h           |   11 ++++
 kernel/smpboot.c                  |   91 +++++++++++++++++++++++++++++++++++++
 kernel/smpboot.h                  |    4 +-
 40 files changed, 437 insertions(+), 321 deletions(-)
 create mode 100644 include/linux/smpboot.h



Thanks,
Srivatsa S. Bhat
IBM Linux Technology Center

