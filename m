Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab1FQImi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:42:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53303 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab1FQImf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:42:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DFB1359.9000204@jp.fujitsu.com>
Date: Fri, 17 Jun 2011 17:42:01 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>
Subject: [PATCH 2/8] x86, mce: remove redundant mce_available() checks
References: <4DFB1242.90404@jp.fujitsu.com>
In-Reply-To: <4DFB1242.90404@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that there is no need to check mce_available() on runtime.
In fact we don't support asymmetric configuration such as mixture of
varied processors which some are MCE capable while others are not.

Finally only 2 checks in init code path are enough for now.

When !mce_available():
  - in mcheck_cpu_init():
    - mce timer is not initialized
    - cmci is not enabled
  - and later in mce_init_device():
    - sysfs files are not created
    - hotplug notifier is not registered
So we don't need checks at all in these functions which is never
called when !mce_available().

For safety I also add a warning which is given when bad unsupported
asymmetric configuration is detected.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/mce.h             |    2 -
 arch/x86/kernel/cpu/mcheck/mce.c       |   34 ++++++++++---------------------
 arch/x86/kernel/cpu/mcheck/mce_intel.c |    2 +-
 3 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 716b48a..77825dd 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -180,8 +180,6 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c);
 static inline void mce_amd_feature_init(struct cpuinfo_x86 *c) { }
 #endif
 
-int mce_available(struct cpuinfo_x86 *c);
-
 DECLARE_PER_CPU(unsigned, mce_exception_count);
 DECLARE_PER_CPU(unsigned, mce_poll_count);
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 42fc8d2..205b334 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -449,7 +449,7 @@ static int mce_ring_add(unsigned long pfn)
 	return 0;
 }
 
-int mce_available(struct cpuinfo_x86 *c)
+static int mce_available(struct cpuinfo_x86 *c)
 {
 	if (mce_disabled)
 		return 0;
@@ -1121,10 +1121,7 @@ static void mce_start_timer(unsigned long data)
 
 	WARN_ON(smp_processor_id() != data);
 
-	if (mce_available(__this_cpu_ptr(&cpu_info))) {
-		machine_check_poll(MCP_TIMESTAMP,
-				&__get_cpu_var(mce_poll_banks));
-	}
+	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_poll_banks));
 
 	/*
 	 * Alert userspace if needed.  If we logged an MCE, reduce the
@@ -1146,8 +1143,7 @@ static void mce_timer_delete_all(void)
 	int cpu;
 
 	for_each_online_cpu(cpu) {
-		if (mce_available(&per_cpu(cpu_info, cpu)))
-			del_timer_sync(&per_cpu(mce_timer, cpu));
+		del_timer_sync(&per_cpu(mce_timer, cpu));
 	}
 }
 
@@ -1418,8 +1414,15 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 	if (__mcheck_cpu_ancient_init(c))
 		return;
 
-	if (!mce_available(c))
+	if (!mce_available(c)) {
+		/*
+		 * Asymmetric configurations are not supported today.
+		 * If mce_banks is allocated there must be a cpu passed here.
+		 */
+		WARN_ON(!mce_disabled && mce_banks);
+		mce_disabled = 1;
 		return;
+	}
 
 	if (__mcheck_cpu_cap_init() < 0 || __mcheck_cpu_apply_quirks(c) < 0) {
 		mce_disabled = 1;
@@ -1761,8 +1764,6 @@ static struct syscore_ops mce_syscore_ops = {
 
 static void mce_cpu_restart(void *data)
 {
-	if (!mce_available(__this_cpu_ptr(&cpu_info)))
-		return;
 	__mcheck_cpu_init_generic();
 	__mcheck_cpu_init_timer();
 }
@@ -1777,15 +1778,11 @@ static void mce_restart(void)
 /* Toggle features for corrected errors */
 static void mce_disable_cmci(void *data)
 {
-	if (!mce_available(__this_cpu_ptr(&cpu_info)))
-		return;
 	cmci_clear();
 }
 
 static void mce_enable_ce(void *all)
 {
-	if (!mce_available(__this_cpu_ptr(&cpu_info)))
-		return;
 	cmci_reenable();
 	cmci_recheck();
 	if (all)
@@ -1946,9 +1943,6 @@ static __cpuinit int mce_sysdev_create(unsigned int cpu)
 	int err;
 	int i, j;
 
-	if (!mce_available(&boot_cpu_data))
-		return -EIO;
-
 	memset(&sysdev->kobj, 0, sizeof(struct kobject));
 	sysdev->id  = cpu;
 	sysdev->cls = &mce_sysdev_class;
@@ -2006,9 +2000,6 @@ static void __cpuinit mce_disable_cpu(void *h)
 	unsigned long action = *(unsigned long *)h;
 	int i;
 
-	if (!mce_available(__this_cpu_ptr(&cpu_info)))
-		return;
-
 	if (!(action & CPU_TASKS_FROZEN))
 		cmci_clear();
 	for (i = 0; i < banks; i++) {
@@ -2024,9 +2015,6 @@ static void __cpuinit mce_reenable_cpu(void *h)
 	unsigned long action = *(unsigned long *)h;
 	int i;
 
-	if (!mce_available(__this_cpu_ptr(&cpu_info)))
-		return;
-
 	if (!(action & CPU_TASKS_FROZEN))
 		cmci_reenable();
 	for (i = 0; i < banks; i++) {
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 8694ef5..393516c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -130,7 +130,7 @@ void cmci_recheck(void)
 	unsigned long flags;
 	int banks;
 
-	if (!mce_available(__this_cpu_ptr(&cpu_info)) || !cmci_supported(&banks))
+	if (!cmci_supported(&banks))
 		return;
 	local_irq_save(flags);
 	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
-- 
1.7.1


