Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993Ab2JLQwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:52:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:2449 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759864Ab2JLQtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:49:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,577,1344236400"; 
   d="scan'208";a="233264028"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Arjan Dan De Ven" <arjan@linux.intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v9 0/12] x86: Arbitrary CPU hot(un)plug support
Date: Fri, 12 Oct 2012 09:09:37 -0700
Message-Id: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

CPU0 or BSP (Bootstrap Processor) has been the last processor that can not be
hot removed on x86. This patchset implements CPU0 or BSP online and offline
and removes this obstacle to CPU hotplug.

RAS needs the feature. If socket0 needs to be hotplugged for any reason (any
thread on socket0 is bad, shared cache issue, uncore issue, etc), CPU0 is
required to be offline or hot replaced to keep the system run. For example,
starting with Core Duo, if you have a system that is reporting cache problems
via the "yellow" status in the MCi_STATUS msr, then there is benefit in simply
soft off-lining the cores that share that cache - assuming that leaves you at
least one online core. A single socket system with L3 cache troubles is not
helped - but problems in L1/L2 cache, or on multi-socket systems can be avoided.
They are already being avoided for the cases where CPU0 is not involved.
This patchset can help L1/L2 cache problem in CPU0 or L3 cache problem on the
socket with CPU0 in a multi-socket system.

v9: Add Intel vendor check to support the feature on Intel platforms only.

v8: Add smp_store_boot_cpu_info() and change smp_store_cpu_info() back to avoid
a compilation error. Fix a few messy subject issues.

v7: Change smp_store_cpu_info() to allow store cpuinfo for CPU0 when online.
Change PIC irq detection in native_cpu_disable().

v6: If CPU0 is offlined during boot time in CPU0 hotplug debug mode, put CPU0
online again before resuming from hibernation and disable x2apic and xapic.Don't
set __CPUINIT for start_cpu0() in head_32.S. Clean up CPU0 wake up nmi handler
after callin and callout sync. In a period (3 seconds), check if CPU0 wake up
NMI is handled after offlined CPU0 exits from mwait.

v5: Add CONFIG_BOOTPARAM_HOTPLUG_CPU0 and CONFIG_DEBUG_HOTPLUG_CPU0. Simplify
duplicate xstate_size init check. Wakeup CPU0 via nmi instead INITs. Add
mcheck_cpu_init when CPU0 online. Change variable bsp_hotpluggable to
cpu0_hotpluggable with __initdata qualifier.

v4: Add __read_mostly for internal bsp_hotpluggable variable. Add my email
address in cpu-hotplug.txt document. A wording change in comment.

v3: Register a pm notifier to check if CPU0 is online before hibernate/suspend.
Small wording changes in document and print info.

v2: Add locking changes between cpu hotplug and hibernate/suspend. Change PIC
irq bound to CPU0 detection.

Fenghua Yu (12):
  doc: Add x86 CPU0 online/offline feature
  x86, Kconfig: Add config switch for CPU0 hotplug
  x86, topology: Don't offline CPU0 if any PIC irq can not be migrated
    out of it
  x86, hotplug: Support functions for CPU0 online/offline
  x86, hotplug, suspend: Online CPU0 for suspend or hibernate
  x86-64, hotplug: Add start_cpu0() entry point to head_64.S
  x86-32, hotplug: Add start_cpu0() entry point to head_32.S
  x86, hotplug: Wake up CPU0 via NMI instead of INIT, SIPI, SIPI
  x86, hotplug: During CPU0 online, enable x2apic, set_numa_node.
  x86, hotplug: The first online processor saves the MTRR state
  x86/i387.c: Initialize thread xstate only on CPU0 only once
  x86, topology: Debug CPU00 hotplug

 Documentation/cpu-hotplug.txt       |   24 ++++++
 Documentation/kernel-parameters.txt |   14 +++
 arch/x86/Kconfig                    |   44 ++++++++++
 arch/x86/include/asm/cpu.h          |    4 +
 arch/x86/include/asm/smp.h          |    1 +
 arch/x86/kernel/cpu/common.c        |    5 +-
 arch/x86/kernel/cpu/mtrr/main.c     |    9 ++-
 arch/x86/kernel/head_32.S           |   12 +++
 arch/x86/kernel/head_64.S           |   15 ++++
 arch/x86/kernel/i387.c              |    6 +-
 arch/x86/kernel/smpboot.c           |  150 +++++++++++++++++++++++++++++------
 arch/x86/kernel/topology.c          |  101 ++++++++++++++++++++++--
 arch/x86/power/cpu.c                |   82 +++++++++++++++++++
 13 files changed, 428 insertions(+), 39 deletions(-)

-- 
1.7.2

