Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967Ab2JLQtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:49:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:22414 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759874Ab2JLQtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:49:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,577,1344236400"; 
   d="scan'208";a="233264034"
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
Subject: [PATCH v9 01/12] doc: Add x86 CPU0 online/offline feature
Date: Fri, 12 Oct 2012 09:09:38 -0700
Message-Id: <1350058189-6769-2-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

If CONFIG_BOOTPARAM_HOTPLUG_CPU0 is turned on, CPU0 is hotpluggable. Otherwise,
by default CPU0 is not hotpluggable and kernel parameter cpu0_hotplug enables
CPU0 online/offline feature.

The documentations point out two known CPU0 dependencies. First, resume from
hibernate or suspend always starts from CPU0. So hibernate and suspend are
prevented if CPU0 is offline. Another dependency is PIC interrupts always go
to CPU0.

It's said that some machines may depend on CPU0 to poweroff/reboot. But I
haven't seen such dependency on a few tested machines.

Please let me know if you see any CPU0 dependencies on your machine.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 Documentation/cpu-hotplug.txt       |   24 ++++++++++++++++++++++++
 Documentation/kernel-parameters.txt |   14 ++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
index 66ef8f3..9f40135 100644
--- a/Documentation/cpu-hotplug.txt
+++ b/Documentation/cpu-hotplug.txt
@@ -207,6 +207,30 @@ by making it not-removable.
 
 In such cases you will also notice that the online file is missing under cpu0.
 
+Q: Is CPU0 removable on X86?
+A: Yes. If kernel is compiled with CONFIG_BOOTPARAM_HOTPLUG_CPU0=y, CPU0 is
+removable by default. Otherwise, CPU0 is also removable by kernel option
+cpu0_hotplug.
+
+But some features depend on CPU0. Two known dependencies are:
+
+1. Resume from hibernate/suspend depends on CPU0. Hibernate/suspend will fail if
+CPU0 is offline and you need to online CPU0 before hibernate/suspend can
+continue.
+2. PIC interrupts also depend on CPU0. CPU0 can't be removed if a PIC interrupt
+is detected.
+
+It's said poweroff/reboot may depend on CPU0 on some machines although I haven't
+seen any poweroff/reboot failure so far after CPU0 is offline on a few tested
+machines.
+
+Please let me know if you know or see any other dependencies of CPU0.
+
+If the dependencies are under your control, you can turn on CPU0 hotplug feature
+either by CONFIG_BOOTPARAM_HOTPLUG_CPU0 or by kernel parameter cpu0_hotplug.
+
+--Fenghua Yu <fenghua.yu@intel.com>
+
 Q: How do i find out if a particular CPU is not removable?
 A: Depending on the implementation, some architectures may show this by the
 absence of the "online" file. This is done if it can be determined ahead of
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index df43807..20d7956 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1962,6 +1962,20 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
 
+	cpu0_hotplug	[X86] Turn on CPU0 hotplug feature when
+			CONFIG_BOOTPARAM_HOTPLUG_CPU0 is off.
+			Some features depend on CPU0. Known dependencies are:
+			1. Resume from suspend/hibernate depends on CPU0.
+			Suspend/hibernate will fail if CPU0 is offline and you
+			need to online CPU0 before suspend/hibernate.
+			2. PIC interrupts also depend on CPU0. CPU0 can't be
+			removed if a PIC interrupt is detected.
+			It's said poweroff/reboot may depend on CPU0 on some
+			machines although I haven't seen such issues so far
+			after CPU0 is offline on a few tested machines.
+			If the dependencies are under your control, you can
+			turn on cpu0_hotplug.
+
 	nptcg=		[IA-64] Override max number of concurrent global TLB
 			purges which is reported from either PAL_VM_SUMMARY or
 			SAL PALO.
-- 
1.7.2

