Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0LFRSC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:18:02 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:36787 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753336Ab0LFRQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:16:40 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: mHhrgUkVM1mVKQ3gcH6My7TBuJr7DYcVhYGuk0TebsCzw81
 ka6WlIOZndYH5Tawl1DiVJ4ofimWpRsc4ir14tfnTKvX8THxG_Xd1gwke_iS
 4rLNsIUJW9ohTPkTfU8QPSRTHCScctqNUPeyPd2rb03f9eXQ.SKcmDcji.AK
 mND.HV7UovMK23WxI4rc0fAk53t2bGFul0ohXray6E3IseAF_5CpsQ3hKOnx
 pZNl13wzWaZIKEWoE3TbpF.Gq6WUR2XT6LlSk8RoBjFzm.XBDN5wvwu9Itod
 puFgut_rNzraLJvT8fw--
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206171638.595205962@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:16:22 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [Use cpuops V1 04/11] x86: Use this_cpu_ops for current_cpu_data accesses
References: <20101206171618.302060721@linux.com>
Content-Disposition: inline; filename=cpuops_x86_current_cpu_data
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current_cpu_data accesses are per cpu accesses. We can also use
this_cpu_ops if a scalar is retrieved.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c     |    4 ++--
 arch/x86/kernel/smpboot.c                 |   10 +++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c	2010-11-30 11:53:03.000000000 -0600
+++ linux-2.6/arch/x86/kernel/smpboot.c	2010-11-30 11:57:02.000000000 -0600
@@ -430,7 +430,7 @@ void __cpuinit set_cpu_sibling_map(int c
 
 	cpumask_set_cpu(cpu, c->llc_shared_map);
 
-	if (current_cpu_data.x86_max_cores == 1) {
+	if (__this_cpu_read(cpu_info.x86_max_cores) == 1) {
 		cpumask_copy(cpu_core_mask(cpu), cpu_sibling_mask(cpu));
 		c->booted_cores = 1;
 		return;
@@ -1377,7 +1377,7 @@ void play_dead_common(void)
 
 	mb();
 	/* Ack it */
-	__get_cpu_var(cpu_state) = CPU_DEAD;
+	__this_cpu_write(cpu_state, CPU_DEAD);
 
 	/*
 	 * With physical CPU hotplug, we should halt the cpu
@@ -1401,7 +1401,7 @@ static inline void mwait_play_dead(void)
 		return;
 	if (!cpu_has(&current_cpu_data, X86_FEATURE_CLFLSH))
 		return;
-	if (current_cpu_data.cpuid_level < CPUID_MWAIT_LEAF)
+	if (__this_cpu_read(cpu_info.cpuid_level) < CPUID_MWAIT_LEAF)
 		return;
 
 	eax = CPUID_MWAIT_LEAF;
@@ -1452,7 +1452,7 @@ static inline void mwait_play_dead(void)
 
 static inline void hlt_play_dead(void)
 {
-	if (current_cpu_data.x86 >= 4)
+	if (__this_cpu_read(cpu_info.x86) >= 4)
 		wbinvd();
 
 	while (1) {
Index: linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c	2010-11-30 11:53:03.000000000 -0600
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k8.c	2010-11-30 11:53:33.000000000 -0600
@@ -521,7 +521,7 @@ static void check_supported_cpu(void *_r
 
 	*rc = -ENODEV;
 
-	if (current_cpu_data.x86_vendor != X86_VENDOR_AMD)
+	if (__this_cpu_read(cpu_info.x86_vendor) != X86_VENDOR_AMD)
 		return;
 
 	eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
Index: linux-2.6/arch/x86/kernel/cpu/intel_cacheinfo.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel_cacheinfo.c	2010-11-30 11:53:03.000000000 -0600
+++ linux-2.6/arch/x86/kernel/cpu/intel_cacheinfo.c	2010-11-30 11:53:33.000000000 -0600
@@ -266,7 +266,7 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_
 		line_size = l2.line_size;
 		lines_per_tag = l2.lines_per_tag;
 		/* cpu_data has errata corrections for K7 applied */
-		size_in_kb = current_cpu_data.x86_cache_size;
+		size_in_kb = __this_cpu_read(cpu_info.x86_cache_size);
 		break;
 	case 3:
 		if (!l3.val)
@@ -288,7 +288,7 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_
 	eax->split.type = types[leaf];
 	eax->split.level = levels[leaf];
 	eax->split.num_threads_sharing = 0;
-	eax->split.num_cores_on_die = current_cpu_data.x86_max_cores - 1;
+	eax->split.num_cores_on_die = __this_cpu_read(cpu_info.x86_max_cores) - 1;
 
 
 	if (assoc == 0xffff)

