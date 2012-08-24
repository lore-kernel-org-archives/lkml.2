Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2HXBK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 21:10:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:50010 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab2HXBK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 21:10:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,301,1344236400"; 
   d="scan'208";a="184254129"
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
Subject: [PATCH v7 0/12] x86: Arbitrary CPU hot(un)plug support
Date: Thu, 23 Aug 2012 17:55:59 -0700
Message-Id: <1345769771-27019-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

CPU0 or BSP (Bootstrap Processor) has been the last processor that can not be
hot removed on x86. This patch set implements CPU0 or BSP online and offline
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
  Documentations/cpu-hotplug.tx, kernel-parameters.txt: Add x86 CPU0
    online/offline feature
  x86/Kconfig: Add config switch for CPU0 hotplug
  x86/topology.c: Support functions for CPU0 online/offline
  Don't offline CPU0 if any PIC irq can not be migrated out of it.
  Because x86 BIOS requires CPU0 to resume from sleep, suspend or
    hibernate can't be executed if CPU0 is detected offline. To make
    suspend or hibernate and further resume succeed, CPU0 must be
    online.
  start_cpu0() is defined in head_64.S for 64-bit. The function sets up
    stack and jumps to start_secondary() for CPU0 wake up.
  start_cpu0() is defined in head_32.S for 32-bit. The function sets up
    stack and jumps to start_secondary() for CPU0 wake up.
  Instead of waiting for STARTUP after INITs, BSP will execute the BIOS
    boot-strap code which is not a desired behavior for waking up BSP.
    To avoid the boot-strap code, wake up CPU0 by NMI instead.
  During CPU0 online, enable x2apic, set_numa_node.
  Ask the first online CPU to save mtrr instead of asking BSP. BSP
    could be offline when mtrr_save_state() is called.
  x86/i387.c: Thread xstate is initialized only on CPU0 once
  x86/topology.c: debug CPU0 hotplug

 Documentation/cpu-hotplug.txt       |   24 ++++++
 Documentation/kernel-parameters.txt |   14 ++++
 arch/x86/Kconfig                    |   44 +++++++++++
 arch/x86/include/asm/cpu.h          |    4 +
 arch/x86/include/asm/smp.h          |    2 +-
 arch/x86/kernel/cpu/common.c        |    5 +-
 arch/x86/kernel/cpu/mtrr/main.c     |    9 ++-
 arch/x86/kernel/head_32.S           |   12 +++
 arch/x86/kernel/head_64.S           |   15 ++++
 arch/x86/kernel/i387.c              |    6 +-
 arch/x86/kernel/smpboot.c           |  144 ++++++++++++++++++++++++++++-------
 arch/x86/kernel/topology.c          |   92 ++++++++++++++++++++--
 arch/x86/power/cpu.c                |   82 ++++++++++++++++++++
 13 files changed, 412 insertions(+), 41 deletions(-)

-- 
1.7.2

