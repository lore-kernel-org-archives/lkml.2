Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab0KKLDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:03:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:41219 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab0KKLDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:03:17 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Subject: [PATCHSET RFC] x86: unify x86_32 and 64 NUMA init paths
Date: Thu, 11 Nov 2010 12:02:34 +0100
Message-Id: <1289473363-29440-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Nov 2010 11:02:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset started as an attempt to fix percpu setup problem on
x86_32 NUMA configurations reported by Eric Dumazet.  On x86_32, NUMA
configuration is initialized during SMP bringup which happens way
later than percpu setup.  As percpu setup code doesn't have access to
NUMA configuration, it gets set up as if the system is UMA.

The NUMA init paths differ subtly yet significantly between x86_32 and
64 making it quite difficult to follow.  Custom apic configurations on
x86_32 worsens the problem.

There is no fundamental reason why x86_32 can't be initialized in the
same steps as x86_64.  They just were written differently and just
weren't unified during x86_32/64 code merge.  This patchset unifies
them and in the process fixes percpu setup problem on 32bit NUMA.

This patchset contains the following nine patches.

 0001-x86-Kill-unused-static-boot_cpu_logical_apicid-in-sm.patch
 0002-x86-Rename-x86_32-MAX_APICID-to-MAX_LOCAL_APIC.patch
 0003-x86-Make-default_send_IPI_mask_sequence-allbutself_l.patch
 0004-x86-Initialize-32bit-logical-apicid-mapping-early-du.patch
 0005-x86-Replace-apic-apicid_to_node-with-numa_cpu_node.patch
 0006-x86-Unify-cpu-apicid-NUMA-node-mapping-between-32-an.patch
 0007-x86-Unify-CPU-NUMA-node-mapping-between-32-and-64bit.patch
 0008-x86-Unify-node_to_cpumask_map-handling-between-32-an.patch
 0009-x86-Unify-NUMA-initialization-between-32-and-64bit.patch

0001-0003 are small preparation patches.

0004 changes the role of apic->cpu_to_logical_apicid().  It's now
called once for each cpu early during boot and the output is recorded.
apic works fine but I couldn't test other apic configurations.  If you
know and can test one of bigsmp, numaq, es7000 and summit, please
review and test this one.

Please note that I couldn't figure out how to determine logical_apicid
early for numaq and just made it return BAD_APICID which would result
in suboptimal percpu configuration.  NUMA configuration is still
updated during SMP bringup, so the situation isn't worse than the
patch, but if someone knows how to convert this one, please go ahead.

0005 replaces apic->apicid_to_node() with ->numa_cpu_node() as some
need physical apicid while others logical and both can be easily found
from cpu.

0006-0009 unify different parts of NUMA initialization/handling step
by step.  Afterwards, x86_32 and 64 behave mostly the same regarding
NUMA initialization making the whole thing much easier to understand
and percpu setup works correctly on x86_32 too.

This patchset is on top of the current mainline
(f6614b7bb405a9b35dd28baea989a749492c46b2) and also avaialbe in the
following git branch,

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_32-numa

and contains the following changes.

 arch/x86/Kconfig                      |    2 
 arch/x86/include/asm/apic.h           |   22 ++-
 arch/x86/include/asm/apicdef.h        |    1 
 arch/x86/include/asm/mpspec.h         |    3 
 arch/x86/include/asm/numa.h           |   61 ++++++++++
 arch/x86/include/asm/numa_32.h        |    7 -
 arch/x86/include/asm/numa_64.h        |   16 --
 arch/x86/include/asm/smp.h            |    3 
 arch/x86/include/asm/topology.h       |   17 --
 arch/x86/kernel/acpi/boot.c           |    8 -
 arch/x86/kernel/apic/apic.c           |   46 +++++--
 arch/x86/kernel/apic/apic_flat_64.c   |    4 
 arch/x86/kernel/apic/apic_noop.c      |    4 
 arch/x86/kernel/apic/bigsmp_32.c      |   33 ++---
 arch/x86/kernel/apic/es7000_32.c      |   34 +----
 arch/x86/kernel/apic/ipi.c            |   12 -
 arch/x86/kernel/apic/numaq_32.c       |   26 ++--
 arch/x86/kernel/apic/probe_32.c       |    2 
 arch/x86/kernel/apic/summit_32.c      |   47 ++-----
 arch/x86/kernel/apic/x2apic_cluster.c |    2 
 arch/x86/kernel/apic/x2apic_phys.c    |    2 
 arch/x86/kernel/apic/x2apic_uv_x.c    |    2 
 arch/x86/kernel/cpu/amd.c             |   18 +-
 arch/x86/kernel/cpu/common.c          |    2 
 arch/x86/kernel/cpu/intel.c           |    5 
 arch/x86/kernel/setup.c               |    2 
 arch/x86/kernel/setup_percpu.c        |    4 
 arch/x86/kernel/smpboot.c             |   68 -----------
 arch/x86/mm/k8topology_64.c           |    2 
 arch/x86/mm/numa.c                    |  179 +++++++++++++++++++++++++++++
 arch/x86/mm/numa_32.c                 |    7 +
 arch/x86/mm/numa_64.c                 |  205 ----------------------------------
 arch/x86/mm/srat_32.c                 |    6 
 arch/x86/mm/srat_64.c                 |   10 -
 34 files changed, 413 insertions(+), 449 deletions(-)

Thanks.

--
tejun
