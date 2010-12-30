Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab0L3Rtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 12:49:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45973 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab0L3Rte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 12:49:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=qkBCGB3ZQzDUCdAkf40N64oRoZfbRnva+hq/XFj21WBwXmz5nVjluO2QT1CLAoJdz+
         T0TwqVdmO6UNsOMDi4xnT0NrdWNOd7xzu7+iSGnPnMrrW5GGStMkWxuMBiN4Af0F77mr
         10D4X8CkcYRzIsqCfOHahX6V/pJlV+mJEzMWE=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com, rientjes@google.com
Subject: [PATCHSET] x86: unify x86_32 and 64 NUMA init paths, take#4
Date: Thu, 30 Dec 2010 18:49:13 +0100
Message-Id: <1293731369-10851-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the fourth take of unify-x86_32-and-64-NUMA-init-paths
patchset.

The only change from the last take[L] is that it's now based on
tip/x86/numa.  Unfortunately, some of the collisions weren't trivial
and led to some ugliness.

Commit c1c3443c ("x86, numa: Fake node-to-cpumask for NUMA emulation")
introduced hard dependency on x86_64 into numa_add/remove_cpu() when
CONFIG_NUMA_EMU is enabled.  0015 has been updated so that the 32/64
bit common versions used when !CONFIG_NUMA_EMU are in numa.c while
CONFIG_NUMA_EMU variants are in numa_64.c.

This is ugly but still better than before.  IIUC, Shaohui's patchsets
is going to unify NUMA emulation across 32 and 64bit, which should
remove the above ugliness.  I haven't looked through the patchset yet
but after skimming through the current NUMA_EMU code, here are some of
my thoughts, FWIW.

* There's no reason for different NUMA config methods to construct
  different data structures.  They all, including 32bit, can build a
  single set of data structures.

* Then, unification of NUMA_EMU would naturally follow.  There's no
  reason to think about whether the underlying NUMA and proximity
  information is provided by ACPI, AMD or whatever.  It just needs to
  manipulate the processed data.

Let's _please_ head that way instead of adding more gluing codes and
hacks everywhere.  It would be a bit more churn but I don't think
there's any other sustainable way.

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

It's based on top of the current tip/x86/numa (d50e8fc7) and available
in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git unify-numa

Diffstat follows.

 arch/x86/Kconfig                      |    2 
 arch/x86/include/asm/apic.h           |   36 +++---
 arch/x86/include/asm/apicdef.h        |    1 
 arch/x86/include/asm/ipi.h            |    8 -
 arch/x86/include/asm/mpspec.h         |    3 
 arch/x86/include/asm/numa.h           |   45 +++++++
 arch/x86/include/asm/numa_32.h        |    7 +
 arch/x86/include/asm/numa_64.h        |   16 --
 arch/x86/include/asm/smp.h            |    3 
 arch/x86/include/asm/topology.h       |   17 --
 arch/x86/kernel/acpi/boot.c           |    8 -
 arch/x86/kernel/apic/apic.c           |   39 ++++++
 arch/x86/kernel/apic/apic_flat_64.c   |    4 
 arch/x86/kernel/apic/apic_noop.c      |   26 ++--
 arch/x86/kernel/apic/bigsmp_32.c      |   34 ++---
 arch/x86/kernel/apic/es7000_32.c      |   35 ++----
 arch/x86/kernel/apic/ipi.c            |   12 +-
 arch/x86/kernel/apic/numaq_32.c       |   21 ++-
 arch/x86/kernel/apic/probe_32.c       |   10 +
 arch/x86/kernel/apic/summit_32.c      |   47 ++------
 arch/x86/kernel/apic/x2apic_cluster.c |    2 
 arch/x86/kernel/apic/x2apic_phys.c    |    2 
 arch/x86/kernel/apic/x2apic_uv_x.c    |    2 
 arch/x86/kernel/cpu/amd.c             |   51 +++++---
 arch/x86/kernel/cpu/common.c          |    2 
 arch/x86/kernel/cpu/intel.c           |    5 
 arch/x86/kernel/setup.c               |    2 
 arch/x86/kernel/setup_percpu.c        |   11 +
 arch/x86/kernel/smpboot.c             |   68 -----------
 arch/x86/mm/amdtopology_64.c          |    4 
 arch/x86/mm/numa.c                    |  197 +++++++++++++++++++++++++++++++++-
 arch/x86/mm/numa_32.c                 |    7 +
 arch/x86/mm/numa_64.c                 |  192 +++------------------------------
 arch/x86/mm/srat_32.c                 |    6 -
 arch/x86/mm/srat_64.c                 |   12 +-
 35 files changed, 484 insertions(+), 453 deletions(-)

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/1081199
