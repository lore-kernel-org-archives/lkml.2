Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab2EHE0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 00:26:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51340 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab2EHE0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 00:26:09 -0400
Date: Mon, 7 May 2012 21:25:47 -0700
From: "tip-bot for Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Message-ID: <tip-19209bbb8612004bc20a1f70ff12926f99fe2643@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, bp@amd64.org, tglx@linutronix.de,
        rjw@sisk.pl, deepthi@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com, rjw@sisk.pl,
        bp@amd64.org, deepthi@linux.vnet.ibm.com
In-Reply-To: <4F9E37B8.30001@linux.vnet.ibm.com>
References: <4F9E37B8.30001@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] x86/sched: Make mwait_usable() heed to "idle="
  kernel parameters properly
Git-Commit-ID: 19209bbb8612004bc20a1f70ff12926f99fe2643
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 07 May 2012 21:25:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  19209bbb8612004bc20a1f70ff12926f99fe2643
Gitweb:     http://git.kernel.org/tip/19209bbb8612004bc20a1f70ff12926f99fe2643
Author:     Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
AuthorDate: Mon, 30 Apr 2012 12:26:56 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 7 May 2012 16:27:20 +0200

x86/sched: Make mwait_usable() heed to "idle=" kernel parameters properly

The checks that exist in mwait_usable() for "idle=" kernel
parameters are insufficient. As a result, mwait_usable() can
return 1 even if "idle=nomwait" or "idle=poll" or "idle=halt"
parameters are passed.

Of these cases, incorrect handling of idle=nomwait is a
universal problem since mwait can get used for usual CPU idling.
However the rest of the cases are problematic only during CPU
Hotplug (offline) because, in the CPU offline path, the function
mwait_play_dead() is called, which might result in mwait being
used in the offline CPUs, if mwait_usable() happens to return 1.

Fix these issues by checking for the boot time "idle=" kernel
parameter properly in mwait_usable().

The first issue (usual cpu idling) is demonstrated below:

Before applying the patch (dmesg snippet):

 [    0.000000] Command line: [...] idle=nomwait
 [    0.000000] Kernel command line: [...] idle=nomwait
 [    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
 [    0.140606] using mwait in idle threads.  <======= mwait being used
 [    4.303986] cpuidle: using governor ladder
 [    4.308232] cpuidle: using governor menu

After applying the patch:

 [    0.000000] Command line: [...] idle=nomwait
 [    0.000000] Kernel command line: [...] idle=nomwait
 [    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
 [    4.264100] cpuidle: using governor ladder
 [    4.268342] cpuidle: using governor menu

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: venki@google.com
Cc: suresh.b.siddha@intel.com
Cc: Borislav Petkov <bp@amd64.org>
Cc: lenb@kernel.org
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Link: http://lkml.kernel.org/r/4F9E37B8.30001@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/process.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1d92a5a..ad57d83 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -594,9 +594,17 @@ int mwait_usable(const struct cpuinfo_x86 *c)
 {
 	u32 eax, ebx, ecx, edx;
 
+	/* Use mwait if idle=mwait boot option is given */
 	if (boot_option_idle_override == IDLE_FORCE_MWAIT)
 		return 1;
 
+	/*
+	 * Any idle= boot option other than idle=mwait means that we must not
+	 * use mwait. Eg: idle=halt or idle=poll or idle=nomwait
+	 */
+	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
+		return 0;
+
 	if (c->cpuid_level < MWAIT_INFO)
 		return 0;
 
