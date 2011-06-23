Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab1FWIbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 04:31:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41681 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab1FWIbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 04:31:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E02F9A2.4040204@jp.fujitsu.com>
Date: Thu, 23 Jun 2011 17:30:26 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: kosaki.motohiro@jp.fujitsu.com
CC: catalin.marinas@arm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] arm,integrator: replace old cpumask functions with new
 one.
References: <4E02F92C.7070203@jp.fujitsu.com>
In-Reply-To: <4E02F92C.7070203@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We plant to change task->cpus_allowed implementation in future.
Therefore this patch replace it with tsk_cpus_allowed() helper
macro.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/mach-integrator/cpu.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-integrator/cpu.c b/arch/arm/mach-integrator/cpu.c
index fbb4577..de7c0ea 100644
--- a/arch/arm/mach-integrator/cpu.c
+++ b/arch/arm/mach-integrator/cpu.c
@@ -92,13 +92,13 @@ static int integrator_set_target(struct cpufreq_policy *policy,
 	/*
 	 * Save this threads cpus_allowed mask.
 	 */
-	cpus_allowed = current->cpus_allowed;
+	cpumask_copy(&cpus_allowed, tsk_cpus_allowed(current));

 	/*
 	 * Bind to the specified CPU.  When this call returns,
 	 * we should be running on the right CPU.
 	 */
-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 	BUG_ON(cpu != smp_processor_id());

 	/* get current setting */
@@ -126,7 +126,7 @@ static int integrator_set_target(struct cpufreq_policy *policy,
 	freqs.cpu = policy->cpu;

 	if (freqs.old == freqs.new) {
-		set_cpus_allowed(current, cpus_allowed);
+		set_cpus_allowed_ptr(current, &cpus_allowed);
 		return 0;
 	}

@@ -149,7 +149,7 @@ static int integrator_set_target(struct cpufreq_policy *policy,
 	/*
 	 * Restore the CPUs allowed mask.
 	 */
-	set_cpus_allowed(current, cpus_allowed);
+	set_cpus_allowed_ptr(current, &cpus_allowed);

 	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);

@@ -163,9 +163,9 @@ static unsigned int integrator_get(unsigned int cpu)
 	u_int cm_osc;
 	struct icst_vco vco;

-	cpus_allowed = current->cpus_allowed;
+	cpumask_copy(&cpus_allowed, tsk_cpus_allowed(current));

-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 	BUG_ON(cpu != smp_processor_id());

 	/* detect memory etc. */
@@ -181,7 +181,7 @@ static unsigned int integrator_get(unsigned int cpu)

 	current_freq = icst_hz(&cclk_params, vco) / 1000; /* current freq */

-	set_cpus_allowed(current, cpus_allowed);
+	set_cpus_allowed_ptr(current, &cpus_allowed);

 	return current_freq;
 }
-- 
1.7.3.1



