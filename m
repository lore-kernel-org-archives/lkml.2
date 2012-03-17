Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab2CQMaB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 08:30:01 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:51064 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099Ab2CQM34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 08:29:56 -0400
Message-ID: <4F6483BA.8050103@ti.com>
Date: Sat, 17 Mar 2012 17:59:46 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Kevin Hilman <khilman@ti.com>,
        Len Brown <len.brown@intel.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCHv2 3/5] cpuidle: add support for states that affect multiple
 cpus
References: <1331749794-8056-1-git-send-email-ccross@android.com> <1331749794-8056-4-git-send-email-ccross@android.com>
In-Reply-To: <1331749794-8056-4-git-send-email-ccross@android.com>
Content-Type: multipart/mixed;
 boundary="------------010003030608010006070203"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010003030608010006070203
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Colin,

On Wednesday 14 March 2012 11:59 PM, Colin Cross wrote:
> On some ARM SMP SoCs (OMAP4460, Tegra 2, and probably more), the
> cpus cannot be independently powered down, either due to
> sequencing restrictions (on Tegra 2, cpu 0 must be the last to
> power down), or due to HW bugs (on OMAP4460, a cpu powering up
> will corrupt the gic state unless the other cpu runs a work
> around).  Each cpu has a power state that it can enter without
> coordinating with the other cpu (usually Wait For Interrupt, or
> WFI), and one or more "coupled" power states that affect blocks
> shared between the cpus (L2 cache, interrupt controller, and
> sometimes the whole SoC).  Entering a coupled power state must
> be tightly controlled on both cpus.
> 
> The easiest solution to implementing coupled cpu power states is
> to hotplug all but one cpu whenever possible, usually using a
> cpufreq governor that looks at cpu load to determine when to
> enable the secondary cpus.  This causes problems, as hotplug is an
> expensive operation, so the number of hotplug transitions must be
> minimized, leading to very slow response to loads, often on the
> order of seconds.
> 
> This file implements an alternative solution, where each cpu will
> wait in the WFI state until all cpus are ready to enter a coupled
> state, at which point the coupled state function will be called
> on all cpus at approximately the same time.
> 
> Once all cpus are ready to enter idle, they are woken by an smp
> cross call.  At this point, there is a chance that one of the
> cpus will find work to do, and choose not to enter idle.  A
> final pass is needed to guarantee that all cpus will call the
> power state enter function at the same time.  During this pass,
> each cpu will increment the ready counter, and continue once the
> ready counter matches the number of online coupled cpus.  If any
> cpu exits idle, the other cpus will decrement their counter and
> retry.
> 
> To use coupled cpuidle states, a cpuidle driver must:
> 
>    Set struct cpuidle_device.coupled_cpus to the mask of all
>    coupled cpus, usually the same as cpu_possible_mask if all cpus
>    are part of the same cluster.  The coupled_cpus mask must be
>    set in the struct cpuidle_device for each cpu.
> 
>    Set struct cpuidle_device.safe_state to a state that is not a
>    coupled state.  This is usually WFI.
> 
>    Set CPUIDLE_FLAG_COUPLED in struct cpuidle_state.flags for each
>    state that affects multiple cpus.
> 
>    Provide a struct cpuidle_state.enter function for each state
>    that affects multiple cpus.  This function is guaranteed to be
>    called on all cpus at approximately the same time.  The driver
>    should ensure that the cpus all abort together if any cpu tries
>    to abort once the function is called.
> 
> Signed-off-by: Colin Cross <ccross@android.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Amit Kucheria <amit.kucheria@linaro.org>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Trinabh Gupta <g.trinabh@gmail.com>
> Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
> ---

[..]

> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
> new file mode 100644
> index 0000000..046fccb
> --- /dev/null
> +++ b/drivers/cpuidle/coupled.c
> @@ -0,0 +1,568 @@
> +/*
> + * coupled.c - helper functions to enter the same idle state on multiple cpus
> + *
> + * Copyright (c) 2011 Google, Inc.
> + *
> + * Author: Colin Cross <ccross@android.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */

[...]

> +/**
> + * cpuidle_coupled_cpu_set_alive - adjust alive_count during hotplug transitions
> + * @cpu: target cpu number
> + * @alive: whether the target cpu is going up or down
> + *
> + * Run on the cpu that is bringing up the target cpu, before the target cpu
> + * has been booted, or after the target cpu is completely dead.
> + */
> +static void cpuidle_coupled_cpu_set_alive(int cpu, bool alive)
> +{
> +	struct cpuidle_device *dev;
> +	struct cpuidle_coupled *coupled;
> +
> +	mutex_lock(&cpuidle_lock);
> +
> +	dev = per_cpu(cpuidle_devices, cpu);
> +	if (!dev->coupled)
> +		goto out;
> +
> +	coupled = dev->coupled;
> +
> +	/*
> +	 * waiting_count must be at least 1 less than alive_count, because
> +	 * this cpu is not waiting.  Spin until all cpus have noticed this cpu
> +	 * is not idle and exited the ready loop before changing alive_count.
> +	 */
> +	while (atomic_read(&coupled->ready_count))
> +		cpu_relax();
> +
> +	smp_mb__before_atomic_inc();
> +	atomic_inc(&coupled->alive_count);
> +	smp_mb__after_atomic_inc();
> +
> +	if (alive)
> +		coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_NOT_IDLE;
> +	else
> +		coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_DEAD;
> +

While playing around with this version, I noticed that the
'alive_count' is ever incrementing which will lead to
coupled idle state not being attempted after one CPU offline
attempt.

Fix in end of the email for the same. With it, coupled states
continue to work with CPU online/offline transitions.

Feel free to fold it into original patch. Attached
the same in case mailer eat tabs.

Regards
Santosh

>>
cpuidle: coupled: Fix the alive_count based on CPU online/offline.

Currently the alive_count is ever incrementing which will lead to
coupled idle state not being attempted after one CPU offline
attempt.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/cpuidle/coupled.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index 3bc8a02..708bcfe 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -595,14 +595,18 @@ static void cpuidle_coupled_cpu_set_alive(int cpu,
bool alive)
        while (atomic_read(&coupled->ready_count))
                cpu_relax();

-       smp_mb__before_atomic_inc();
-       atomic_inc(&coupled->alive_count);
-       smp_mb__after_atomic_inc();

-       if (alive)
+       if (alive) {
+               smp_mb__before_atomic_inc();
+               atomic_inc(&coupled->alive_count);
+               smp_mb__after_atomic_inc();
                coupled->requested_state[dev->cpu] =
CPUIDLE_COUPLED_NOT_IDLE;
-       else
+       } else {
+               smp_mb__before_atomic_inc();
+               atomic_dec(&coupled->alive_count);
+               smp_mb__after_atomic_inc();
                coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_DEAD;
+       }

<upled-Fix-the-alive_count-based-on-CPU-onl.patch" 45L, 1387C 1,1
    Top





--------------010003030608010006070203
Content-Type: text/x-patch;
 name="0001-cpuidle-coupled-Fix-the-alive_count-based-on-CPU-onl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-cpuidle-coupled-Fix-the-alive_count-based-on-CPU-onl.pa";
 filename*1="tch"

>From 189e5862ea4f983313cbf6abb7aabab670267c83 Mon Sep 17 00:00:00 2001
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Sat, 17 Mar 2012 17:46:50 +0530
Subject: [PATCH] cpuidle: coupled: Fix the alive_count based on CPU online/offline.

Currently the alive_count is ever incrementing which will lead to
coupled idle state not being attempted after one CPU offline
attempt.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/cpuidle/coupled.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index 3bc8a02..708bcfe 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -595,14 +595,18 @@ static void cpuidle_coupled_cpu_set_alive(int cpu, bool alive)
 	while (atomic_read(&coupled->ready_count))
 		cpu_relax();
 
-	smp_mb__before_atomic_inc();
-	atomic_inc(&coupled->alive_count);
-	smp_mb__after_atomic_inc();
 
-	if (alive)
+	if (alive) {
+		smp_mb__before_atomic_inc();
+		atomic_inc(&coupled->alive_count);
+		smp_mb__after_atomic_inc();
 		coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_NOT_IDLE;
-	else
+	} else {
+		smp_mb__before_atomic_inc();
+		atomic_dec(&coupled->alive_count);
+		smp_mb__after_atomic_inc();
 		coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_DEAD;
+	}
 
 out:
 	mutex_unlock(&cpuidle_lock);
-- 
1.7.4.1


--------------010003030608010006070203--
