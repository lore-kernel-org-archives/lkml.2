Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab2KNWpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:45:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45529 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997Ab2KNWp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:45:29 -0500
Date: Wed, 14 Nov 2012 13:21:36 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-f78cff48c3d13636705851b0a9e733db117d58ee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1352835171-3958-2-git-send-email-fenghua.yu@intel.com>
References: <1352835171-3958-2-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/bsp-hotplug] doc: Add x86 CPU0 online/offline feature
Git-Commit-ID: f78cff48c3d13636705851b0a9e733db117d58ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 14 Nov 2012 14:45:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f78cff48c3d13636705851b0a9e733db117d58ee
Gitweb:     http://git.kernel.org/tip/f78cff48c3d13636705851b0a9e733db117d58ee
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 13 Nov 2012 11:32:38 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 14 Nov 2012 09:39:44 -0800

doc: Add x86 CPU0 online/offline feature

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
Link: http://lkml.kernel.org/r/1352835171-3958-2-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/cpu-hotplug.txt       | 24 ++++++++++++++++++++++++
 Documentation/kernel-parameters.txt | 14 ++++++++++++++
 2 files changed, 38 insertions(+)

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
index 9776f06..f7cbe1d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1984,6 +1984,20 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
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
