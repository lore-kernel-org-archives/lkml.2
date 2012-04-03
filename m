Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2DCLuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:50:08 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:48720 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab2DCLuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:50:06 -0400
Message-ID: <4F7AE3CA.7080201@linux.vnet.ibm.com>
Date: Tue, 03 Apr 2012 17:19:30 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: lenb@kernel.org
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, venki@google.com,
        suresh.b.siddha@intel.com, bp@amd64.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, ben@decadent.org.uk,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        deepthi@linux.vnet.ibm.com, Daniel Lezcano <daniel.lezcano@linaro.org>,
        amit.kucheria@linaro.org
Subject: Re: [PATCH] x86: Make mwait_usable() respect "idle=nomwait" kernel
 parameter
References: <20120402140645.6283.21190.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120402140645.6283.21190.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12040301-5490-0000-0000-000001116131
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 07:36 PM, Srivatsa S. Bhat wrote:

> mwait_usable() returns 1 even if the "idle=nomwait" kernel parameter is passed.
> Fix it by adding a check for boot_option_idle_override == IDLE_NOMWAIT and
> returning 0 if it is set.
> 
> Before applying the patch (dmesg snippet):
> [    0.000000] Command line: [...] idle=nomwait
> [    0.000000] Kernel command line: [...] idle=nomwait
> [    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
> [    0.140606] using mwait in idle threads.         <======= mwait being used
> [    4.303986] cpuidle: using governor ladder
> [    4.308232] cpuidle: using governor menu
> 
> After applying the patch:
> [    0.000000] Command line: [...] idle=nomwait
> [    0.000000] Kernel command line: [...] idle=nomwait
> [    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
> [    4.264100] cpuidle: using governor ladder
> [    4.268342] cpuidle: using governor menu
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  arch/x86/kernel/process.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index a33afaa..945fbf0 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -621,6 +621,9 @@ int mwait_usable(const struct cpuinfo_x86 *c)
>  	if (boot_option_idle_override == IDLE_FORCE_MWAIT)
>  		return 1;
> 
> +	if (boot_option_idle_override == IDLE_NOMWAIT)
> +		return 0;
> +
>  	if (c->cpuid_level < MWAIT_INFO)
>  		return 0;
> 
> 


I realized that actually more stuff is broken than what the above patch fixes.

So here is the updated patch:

---

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [v2] x86: Make mwait_usable() heed to "idle=" kernel parameters properly

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
 


