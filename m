Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0LISm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:42:29 -0500
Received: from www17.your-server.de ([213.133.104.17]:42391 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab0LISm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:42:27 -0500
Subject: [PATCH] Fix preempt imbalance in kvm_timer_init()
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Cc: zamsden@redhat.com, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 19:42:35 +0100
Message-ID: <1291920155.8141.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---
 arch/x86/kvm/x86.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cdac9e5..2609c3d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4561,7 +4561,7 @@ static struct notifier_block kvmclock_cpu_notifier_block = {
 
 static void kvm_timer_init(void)
 {
-	int cpu;
+	int cpu = get_cpu();
 
 	max_tsc_khz = tsc_khz;
 	register_hotcpu_notifier(&kvmclock_cpu_notifier_block);
@@ -4569,13 +4569,14 @@ static void kvm_timer_init(void)
 #ifdef CONFIG_CPU_FREQ
 		struct cpufreq_policy policy;
 		memset(&policy, 0, sizeof(policy));
-		cpufreq_get_policy(&policy, get_cpu());
+		cpufreq_get_policy(&policy, cpu);
 		if (policy.cpuinfo.max_freq)
 			max_tsc_khz = policy.cpuinfo.max_freq;
 #endif
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
 					  CPUFREQ_TRANSITION_NOTIFIER);
 	}
+	put_cpu();
 	pr_debug("kvm: max_tsc_khz = %ld\n", max_tsc_khz);
 	for_each_online_cpu(cpu)
 		smp_call_function_single(cpu, tsc_khz_changed, NULL, 1);
-- 
1.7.3.3


