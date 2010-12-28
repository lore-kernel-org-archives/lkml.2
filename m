Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0L1Ls5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 06:48:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38779 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab0L1Lsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 06:48:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=XnwcLURimK3/sxam14DxEa6KfUKjoUYKnp49qO0nhTY4MOxOpj5TjvKW0wFKP2+6/n
         65/Vwr5Jwtepl+9tpw8DAwGKCqS2pQHJXrdLeeokkLvBGFnqptFOX1tzv3L/K1387F6Y
         SyRUav37YCdLuMm6JOdE/z7QUcMJngbHeLMM0=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com
Subject: [PATCHSET REPOST] x86: unify x86_32 and 64 NUMA init paths, take#3
Date: Tue, 28 Dec 2010 12:48:33 +0100
Message-Id: <1293536929-31683-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a repost of 3rd take of unify-x86_32-and-64-NUMA-init-paths
patchset which was initially posted on 11st Dec but didn't get
archived anywhere because vger had its disk full at the time.  Nothing
has changed since the first posting.

Most changes from the last take[L] are to reflect comments from tglx.

* Rebased on top of tip/x86/apic-cleanup.

* "x86: apic: Cleanup and simplify setup_local_APIC()" is already
  merged into x86/apic-cleanup and dropped from this series.

* Instead of repurposing apic->cpu_to_logical_apicid(), replace it
  with a new 32bit specific callback
  apic->x86_32_early_logical_apicid().

* For consistency, in 0012, apic->apicid_to_node() is renamed to
  x86_32_numa_cpu_node() and put inside CONFIG_X86_32.

* NULL assignments for unimplemented apic ops dropped.

* 0013 now explicitly describes why amd srat_detect_node() accesses
  __apicid_to_node[] directly.  Also, add a comment in the function
  noting the ugliness.

* Patch description updated in 0014.

* Other misc updates.

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

This patchset contains the following sixteen patches.

 0001-x86-Kill-unused-static-boot_cpu_logical_apicid-in-sm.patch
 0002-x86-Rename-x86_32-MAX_APICID-to-MAX_LOCAL_APIC.patch
 0003-x86-Make-default_send_IPI_mask_sequence-allbutself_l.patch
 0004-x86-Replace-cpu_2_logical_apicid-with-early-percpu-v.patch
 0005-x86-Always-use-x86_cpu_to_logical_apicid-for-cpu-log.patch
 0006-x86-Kill-apic-cpu_to_logical_apicid.patch
 0007-x86-Add-apic-x86_32_early_logical_apicid.patch
 0008-x86-Implement-the-default-x86_32_early_logical_apici.patch
 0009-x86-Implement-x86_32_early_logical_apicid-for-bigsmp.patch
 0010-x86-Implement-x86_32_early_logical_apicid-for-summit.patch
 0011-x86-Implement-x86_32_early_logical_apicid-for-numaq_.patch
 0012-x86-Replace-apic-apicid_to_node-with-x86_32_numa_cpu.patch
 0013-x86-Unify-cpu-apicid-NUMA-node-mapping-between-32-an.patch
 0014-x86-Unify-CPU-NUMA-node-mapping-between-32-and-64bit.patch
 0015-x86-Unify-node_to_cpumask_map-handling-between-32-an.patch
 0016-x86-Unify-NUMA-initialization-between-32-and-64bit.patch

0001-0003 are small preparation patches.

0004-0011 kills apic->cpu_to_logical_apicid() and adds
->x86_32_early_logical_apicid() which is called once for each cpu
early during boot and the output is recorded.  The default apic works
fine but I couldn't test other apic configurations.

I couldn't figure out how to determine logical_apicid early for numaq
and it still has the stub cpu_to_logical_apicid() implementation which
would result in suboptimal percpu configuration.  NUMA configuration
is still updated during SMP bringup, so the situation is the same as
before the series, but if someone knows how to convert this one,
please go ahead.

0012-0016 unify different parts of NUMA initialization/handling step
by step.  Afterwards, x86_32 and 64 behave mostly the same regarding
NUMA initialization making the whole thing much easier to understand
and percpu setup works correctly on x86_32 too.

This patchset is on top of tip/x86/apic-cleanup
(0aa002fe602939370e9476e5ec32b562000a0425) and also available in the
following git branch,

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_32-numa

and contains the following changes.

 arch/x86/Kconfig                      |    2 
 arch/x86/include/asm/apic.h           |   36 +++--
 arch/x86/include/asm/apicdef.h        |    1 
 arch/x86/include/asm/ipi.h            |    8 -
 arch/x86/include/asm/mpspec.h         |    3 
 arch/x86/include/asm/numa.h           |   58 +++++++++
 arch/x86/include/asm/numa_32.h        |    7 -
 arch/x86/include/asm/numa_64.h        |   16 --
 arch/x86/include/asm/smp.h            |    3 
 arch/x86/include/asm/topology.h       |   17 --
 arch/x86/kernel/acpi/boot.c           |    8 -
 arch/x86/kernel/apic/apic.c           |   39 +++++-
 arch/x86/kernel/apic/apic_flat_64.c   |    4 
 arch/x86/kernel/apic/apic_noop.c      |   26 ++--
 arch/x86/kernel/apic/bigsmp_32.c      |   34 ++---
 arch/x86/kernel/apic/es7000_32.c      |   35 ++---
 arch/x86/kernel/apic/ipi.c            |   12 -
 arch/x86/kernel/apic/numaq_32.c       |   21 +--
 arch/x86/kernel/apic/probe_32.c       |   10 +
 arch/x86/kernel/apic/summit_32.c      |   47 ++-----
 arch/x86/kernel/apic/x2apic_cluster.c |    2 
 arch/x86/kernel/apic/x2apic_phys.c    |    2 
 arch/x86/kernel/apic/x2apic_uv_x.c    |    2 
 arch/x86/kernel/cpu/amd.c             |   51 +++++---
 arch/x86/kernel/cpu/common.c          |    2 
 arch/x86/kernel/cpu/intel.c           |    5 
 arch/x86/kernel/setup.c               |    2 
 arch/x86/kernel/setup_percpu.c        |   11 +
 arch/x86/kernel/smpboot.c             |   68 -----------
 arch/x86/mm/amdtopology_64.c          |    2 
 arch/x86/mm/numa.c                    |  179 +++++++++++++++++++++++++++++
 arch/x86/mm/numa_32.c                 |    7 +
 arch/x86/mm/numa_64.c                 |  205 ----------------------------------
 arch/x86/mm/srat_32.c                 |    6 
 arch/x86/mm/srat_64.c                 |   10 -
 35 files changed, 464 insertions(+), 477 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/1068909


