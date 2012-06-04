Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab2FDS36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 14:29:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:2164 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248Ab2FDS3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 14:29:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="160493103"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Arjan Dan De Ven" <arjan@linux.intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or nmi
Date: Mon,  4 Jun 2012 11:17:49 -0700
Message-Id: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Since offline CPU is in wmait or hlt if mwait feature is not available, it can
be waken up by writing to monitored memory range or via nmi.

Compared to current INIT, INIT, STARTUP wake up sequence, waking up offline CPU
is faster via wmait or nmi. This is especially useful when offline CPU for
power saving and shorter waking up time is desired. On one tested desktop
machine, waking up time via mwait or nmi is reduced to 23% of waking up time
via INIT. Waking up time is measured from the beginning of store_online() to
the beginning of cpu_idle() after the CPU is waken up.

Waking up offline CPU via mwait or nmi is also useful to support BSP offline/
online because offline BSP can not be waken up by the INIT's sequence. The BSP
offline/online patchset will be sent out seperately.

Fenghua Yu (6):
  x86/Documentation/kernel-parameters.txt: Add wakeup_cpu_via_init
    kernel parameter help
  x86/head_32.S/head_64.S: Kernel entry code after waking up offline
    CPU via mwait or nmi
  x86/smpboot.c: Wake up offline CPU via mwait or nmi
  x86/apic_flat_64.c: Wakeup function in apic calls mwait or nmi method
  x86/x2apic_cluster.c: Wakeup function in x2apic_cluster calls mwait
    or nmi method
  x86/x2apic_phys.c: Wakeup function in x2apic_phys calls mwait or nmi
    method

 Documentation/kernel-parameters.txt   |    3 +
 arch/x86/include/asm/apic.h           |    5 +-
 arch/x86/include/asm/cpu.h            |    1 +
 arch/x86/kernel/apic/apic_flat_64.c   |    2 +
 arch/x86/kernel/apic/x2apic_cluster.c |    1 +
 arch/x86/kernel/apic/x2apic_phys.c    |    1 +
 arch/x86/kernel/head_32.S             |   12 ++
 arch/x86/kernel/head_64.S             |   14 +++
 arch/x86/kernel/smpboot.c             |  187 ++++++++++++++++++++++++++++-----
 9 files changed, 198 insertions(+), 28 deletions(-)

