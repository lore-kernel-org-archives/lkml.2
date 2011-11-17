Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab1KQL2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:28:46 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59247 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab1KQL2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:28:44 -0500
Subject: [RFC PATCH v2 1/4] cpuidle: (powerpc) Add cpu_idle_wait() to allow
 switching of idle routines
To: linuxppc-dev@ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-pm@vger.kernel.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 17 Nov 2011 16:58:34 +0530
Message-ID: <20111117112830.9191.1951.stgit@localhost6.localdomain6>
In-Reply-To: <20111117112815.9191.2322.stgit@localhost6.localdomain6>
References: <20111117112815.9191.2322.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11111701-5140-0000-0000-00000045CE7C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides cpu_idle_wait() routine for the powerpc
platform which is required by the cpuidle subsystem. This
routine is requied to change the idle handler on SMP systems.
The equivalent routine for x86 is in arch/x86/kernel/process.c
but the powerpc implementation is different.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Signed-off-by: Trinabh Gupta <g.trinabh@gmail.com>
Signed-off-by: Arun R Bharadwaj <arun.r.bharadwaj@gmail.com>
---
 arch/powerpc/Kconfig                 |    4 ++++
 arch/powerpc/include/asm/processor.h |    2 ++
 arch/powerpc/include/asm/system.h    |    1 +
 arch/powerpc/kernel/idle.c           |   26 ++++++++++++++++++++++++++
 4 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index b177caa..87f8604 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -87,6 +87,10 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default y if 64BIT
 
+config ARCH_HAS_CPU_IDLE_WAIT
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index eb11a44..811b7e7 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -382,6 +382,8 @@ static inline unsigned long get_clean_sp(struct pt_regs *regs, int is_32)
 }
 #endif
 
+enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_POWERSAVE_OFF};
+
 #endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_POWERPC_PROCESSOR_H */
diff --git a/arch/powerpc/include/asm/system.h b/arch/powerpc/include/asm/system.h
index e30a13d..ff66680 100644
--- a/arch/powerpc/include/asm/system.h
+++ b/arch/powerpc/include/asm/system.h
@@ -221,6 +221,7 @@ extern unsigned long klimit;
 extern void *zalloc_maybe_bootmem(size_t size, gfp_t mask);
 
 extern int powersave_nap;	/* set if nap mode can be used in idle loop */
+void cpu_idle_wait(void);
 
 /*
  * Atomic exchange
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 39a2baa..b478c72 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -39,9 +39,13 @@
 #define cpu_should_die()	0
 #endif
 
+unsigned long boot_option_idle_override = IDLE_NO_OVERRIDE;
+EXPORT_SYMBOL(boot_option_idle_override);
+
 static int __init powersave_off(char *arg)
 {
 	ppc_md.power_save = NULL;
+	boot_option_idle_override = IDLE_POWERSAVE_OFF;
 	return 0;
 }
 __setup("powersave=off", powersave_off);
@@ -102,6 +106,28 @@ void cpu_idle(void)
 	}
 }
 
+
+/*
+ * cpu_idle_wait - Used to ensure that all the CPUs come out of the old
+ * idle loop and start using the new idle loop.
+ * Required while changing idle handler on SMP systems.
+ * Caller must have changed idle handler to the new value before the call.
+ */
+void cpu_idle_wait(void)
+{
+	int cpu;
+	smp_mb();
+
+	/* kick all the CPUs so that they exit out of old idle routine */
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		if (cpu != smp_processor_id())
+			smp_send_reschedule(cpu);
+	}
+	put_online_cpus();
+}
+EXPORT_SYMBOL_GPL(cpu_idle_wait);
+
 int powersave_nap;
 
 #ifdef CONFIG_SYSCTL

