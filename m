Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab0HTIJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:09:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab0HTIIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:08:52 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 21/35] Track max tsc_khz
Date: Thu, 19 Aug 2010 22:07:35 -1000
Message-Id: <1282291669-25709-22-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 718bed9..517daf3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -898,6 +898,7 @@ static void kvm_get_time_scale(uint32_t scaled_khz, uint32_t base_khz,
 }
 
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
+unsigned long max_tsc_khz;
 
 static inline int kvm_tsc_changes_freq(void)
 {
@@ -4351,11 +4352,20 @@ static void kvm_timer_init(void)
 {
 	int cpu;
 
+	max_tsc_khz = tsc_khz;
 	register_hotcpu_notifier(&kvmclock_cpu_notifier_block);
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
+#ifdef CONFIG_CPU_FREQ
+		struct cpufreq_policy policy;
+		memset(&policy, 0, sizeof(policy));
+		cpufreq_get_policy(&policy, get_cpu());
+		if (policy.cpuinfo.max_freq)
+			max_tsc_khz = policy.cpuinfo.max_freq;
+#endif
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
 					  CPUFREQ_TRANSITION_NOTIFIER);
 	}
+	pr_debug("kvm: max_tsc_khz = %ld\n", max_tsc_khz);
 	for_each_online_cpu(cpu)
 		smp_call_function_single(cpu, tsc_khz_changed, NULL, 1);
 }
-- 
1.7.1

