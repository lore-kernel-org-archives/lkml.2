Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2D3G5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 02:57:42 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:51838 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab2D3G5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 02:57:40 -0400
Message-ID: <4F9E37B8.30001@linux.vnet.ibm.com>
Date: Mon, 30 Apr 2012 12:26:56 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: lenb@kernel.org, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
CC: venki@google.com, suresh.b.siddha@intel.com,
        Borislav Petkov <bp@amd64.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2][RESEND] x86: Make mwait_usable() heed to "idle=" kernel
 parameters properly
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12042920-6102-0000-0000-000001581CA0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

The checks that exist in mwait_usable() for "idle=" kernel parameters
are insufficient. As a result, mwait_usable() can return 1 even if
"idle=nomwait" or "idle=poll" or "idle=halt" parameters are passed.

Of these cases, incorrect handling of idle=nomwait is a universal problem
since mwait can get used for usual CPU idling. However the rest of the
cases are problematic only during CPU Hotplug (offline) because, in the
CPU offline path, the function mwait_play_dead() is called, which might
result in mwait being used in the offline CPUs, if mwait_usable() happens
to return 1.

Fix these issues by checking for the boot time "idle=" kernel parameter
properly in mwait_usable().

The first issue (usual cpu idling) is demonstrated below:

Before applying the patch (dmesg snippet):
[    0.000000] Command line: [...] idle=nomwait
[    0.000000] Kernel command line: [...] idle=nomwait
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.140606] using mwait in idle threads.         <======= mwait being used
[    4.303986] cpuidle: using governor ladder
[    4.308232] cpuidle: using governor menu

After applying the patch:
[    0.000000] Command line: [...] idle=nomwait
[    0.000000] Kernel command line: [...] idle=nomwait
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    4.264100] cpuidle: using governor ladder
[    4.268342] cpuidle: using governor menu

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kernel/process.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index a33afaa..b526c4e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -618,9 +618,17 @@ int mwait_usable(const struct cpuinfo_x86 *c)
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

