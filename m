Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab2DBOHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:07:08 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:36004 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2DBOHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:07:05 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] x86: Make mwait_usable() respect "idle=nomwait" kernel
 parameter
To: lenb@kernel.org
Cc: venki@google.com, suresh.b.siddha@intel.com, bp@amd64.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        ben@decadent.org.uk, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        deepthi@linux.vnet.ibm.com
Date: Mon, 02 Apr 2012 19:36:45 +0530
Message-ID: <20120402140645.6283.21190.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12040204-7014-0000-0000-000000D3D2F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mwait_usable() returns 1 even if the "idle=nomwait" kernel parameter is passed.
Fix it by adding a check for boot_option_idle_override == IDLE_NOMWAIT and
returning 0 if it is set.

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

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kernel/process.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index a33afaa..945fbf0 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -621,6 +621,9 @@ int mwait_usable(const struct cpuinfo_x86 *c)
 	if (boot_option_idle_override == IDLE_FORCE_MWAIT)
 		return 1;
 
+	if (boot_option_idle_override == IDLE_NOMWAIT)
+		return 0;
+
 	if (c->cpuid_level < MWAIT_INFO)
 		return 0;
 

