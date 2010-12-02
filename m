Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab0LBQnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:43:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab0LBQml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:42:41 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: Thomas Renninger <trenn@suse.de>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] X86: Cleanup idle= internal variables by getting rid of idle_halt idle_nomwait
Date: Thu,  2 Dec 2010 17:42:24 +0100
Message-Id: <1291308148-28628-5-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1291308148-28628-4-git-send-email-trenn@suse.de>
References: <1291308148-28628-1-git-send-email-trenn@suse.de>
 <1291308148-28628-2-git-send-email-trenn@suse.de>
 <1291308148-28628-3-git-send-email-trenn@suse.de>
 <1291308148-28628-4-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having four variables for the same thing:
  idle_halt, idle_nomwait, force_mwait and boot_option_idle_overrides
is rather confusing and unnecessary complex.

if idle= boot param is passed, only set up one variable:
boot_option_idle_overrides

Introduces following functional changes/fixes:
  - intel_idle driver does not register if any idle=xy
    boot param is passed.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: lenb@kernel.org
CC: linux-acpi@vger.kernel.org
CC: linux-pm@lists.linux-foundation.org
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
---
 arch/ia64/include/asm/processor.h |    5 +++--
 arch/ia64/kernel/process.c        |    6 +-----
 arch/x86/include/asm/processor.h  |    5 +++--
 arch/x86/kernel/process.c         |   24 ++++++++----------------
 drivers/acpi/processor_core.c     |    4 ++--
 drivers/acpi/processor_idle.c     |   17 ++++++++++++-----
 drivers/idle/intel_idle.c         |    4 ++++
 7 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index 348e44d..b34e5eb 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -717,8 +717,9 @@ prefetchw (const void *x)
 #define spin_lock_prefetch(x)	prefetchw(x)
 
 extern unsigned long boot_option_idle_override;
-extern unsigned long idle_halt;
-extern unsigned long idle_nomwait;
+
+enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_HALT, IDLE_FORCE_MWAIT,
+			 IDLE_NOMWAIT, IDLE_POLL};
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 16f1c7b..6d33c5c 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -53,12 +53,8 @@
 
 void (*ia64_mark_idle)(int);
 
-unsigned long boot_option_idle_override = 0;
+unsigned long boot_option_idle_override = IDLE_NO_OVERRIDE;
 EXPORT_SYMBOL(boot_option_idle_override);
-unsigned long idle_halt;
-EXPORT_SYMBOL(idle_halt);
-unsigned long idle_nomwait;
-EXPORT_SYMBOL(idle_nomwait);
 void (*pm_idle) (void);
 EXPORT_SYMBOL(pm_idle);
 void (*pm_power_off) (void);
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index cae9c3c..77d902a 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -762,10 +762,11 @@ extern void select_idle_routine(const struct cpuinfo_x86 *c);
 extern void init_c1e_mask(void);
 
 extern unsigned long		boot_option_idle_override;
-extern unsigned long		idle_halt;
-extern unsigned long		idle_nomwait;
 extern bool			c1e_detected;
 
+enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_HALT, IDLE_NOMWAIT,
+			 IDLE_POLL, IDLE_FORCE_MWAIT};
+
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index b618548..62f82de 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -22,11 +22,6 @@
 #include <asm/i387.h>
 #include <asm/debugreg.h>
 
-unsigned long idle_halt;
-EXPORT_SYMBOL(idle_halt);
-unsigned long idle_nomwait;
-EXPORT_SYMBOL(idle_nomwait);
-
 struct kmem_cache *task_xstate_cachep;
 EXPORT_SYMBOL_GPL(task_xstate_cachep);
 
@@ -328,7 +323,7 @@ long sys_execve(const char __user *name,
 /*
  * Idle related variables and functions
  */
-unsigned long boot_option_idle_override = 0;
+unsigned long boot_option_idle_override = IDLE_NO_OVERRIDE;
 EXPORT_SYMBOL(boot_option_idle_override);
 
 /*
@@ -506,7 +501,6 @@ static void poll_idle(void)
  *
  * idle=mwait overrides this decision and forces the usage of mwait.
  */
-static int __cpuinitdata force_mwait;
 
 #define MWAIT_INFO			0x05
 #define MWAIT_ECX_EXTENDED_INFO		0x01
@@ -516,7 +510,7 @@ static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 {
 	u32 eax, ebx, ecx, edx;
 
-	if (force_mwait)
+	if (boot_option_idle_override == IDLE_FORCE_MWAIT)
 		return 1;
 
 	if (c->cpuid_level < MWAIT_INFO)
@@ -636,9 +630,10 @@ static int __init idle_setup(char *str)
 	if (!strcmp(str, "poll")) {
 		printk("using polling idle threads.\n");
 		pm_idle = poll_idle;
-	} else if (!strcmp(str, "mwait"))
-		force_mwait = 1;
-	else if (!strcmp(str, "halt")) {
+		boot_option_idle_override = IDLE_POLL;
+	} else if (!strcmp(str, "mwait")) {
+		boot_option_idle_override = IDLE_FORCE_MWAIT;
+	} else if (!strcmp(str, "halt")) {
 		/*
 		 * When the boot option of idle=halt is added, halt is
 		 * forced to be used for CPU idle. In such case CPU C2/C3
@@ -647,8 +642,7 @@ static int __init idle_setup(char *str)
 		 * the boot_option_idle_override.
 		 */
 		pm_idle = default_idle;
-		idle_halt = 1;
-		return 0;
+		boot_option_idle_override = IDLE_HALT;
 	} else if (!strcmp(str, "nomwait")) {
 		/*
 		 * If the boot option of "idle=nomwait" is added,
@@ -656,12 +650,10 @@ static int __init idle_setup(char *str)
 		 * states. In such case it won't touch the variable
 		 * of boot_option_idle_override.
 		 */
-		idle_nomwait = 1;
-		return 0;
+		boot_option_idle_override = IDLE_NOMWAIT;
 	} else
 		return -1;
 
-	boot_option_idle_override = 1;
 	return 0;
 }
 early_param("idle", idle_setup);
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index bec561c..3c1a2fe 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -23,7 +23,7 @@ static int set_no_mwait(const struct dmi_system_id *id)
 {
 	printk(KERN_NOTICE PREFIX "%s detected - "
 		"disabling mwait for CPU C-states\n", id->ident);
-	idle_nomwait = 1;
+	boot_option_idle_override = IDLE_NOMWAIT;
 	return 0;
 }
 
@@ -283,7 +283,7 @@ acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
 {
 	acpi_status status = AE_OK;
 
-	if (idle_nomwait) {
+	if (boot_option_idle_override == IDLE_NOMWAIT) {
 		/*
 		 * If mwait is disabled for CPU C-states, the C2C3_FFH access
 		 * mode will be disabled in the parameter of _PDC object.
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 104ae77..dda3412 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -79,6 +79,12 @@ module_param(bm_check_disable, uint, 0000);
 static unsigned int latency_factor __read_mostly = 2;
 module_param(latency_factor, uint, 0644);
 
+static int disabled_by_idle_boot_param(void)
+{
+	return boot_option_idle_override == IDLE_POLL ||
+		boot_option_idle_override == IDLE_FORCE_MWAIT;
+}
+
 /*
  * IBM ThinkPad R40e crashes mysteriously when going into C2 or C3.
  * For now disable this. Probably a bug somewhere else.
@@ -455,7 +461,8 @@ static int acpi_processor_get_power_info_cst(struct acpi_processor *pr)
 				continue;
 			}
 			if (cx.type == ACPI_STATE_C1 &&
-					(idle_halt || idle_nomwait)) {
+			    (boot_option_idle_override == IDLE_HALT ||
+			     boot_option_idle_override == IDLE_NOMWAIT)) {
 				/*
 				 * In most cases the C1 space_id obtained from
 				 * _CST object is FIXED_HARDWARE access mode.
@@ -1060,7 +1067,7 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 {
 	int ret = 0;
 
-	if (boot_option_idle_override)
+	if (disabled_by_idle_boot_param())
 		return 0;
 
 	if (!pr)
@@ -1091,11 +1098,11 @@ int __cpuinit acpi_processor_power_init(struct acpi_processor *pr,
 	acpi_status status = 0;
 	static int first_run;
 
-	if (boot_option_idle_override)
+	if (disabled_by_idle_boot_param())
 		return 0;
 
 	if (!first_run) {
-		if (idle_halt) {
+		if (boot_option_idle_override == IDLE_HALT) {
 			/*
 			 * When the boot option of "idle=halt" is added, halt
 			 * is used for CPU IDLE.
@@ -1144,7 +1151,7 @@ int __cpuinit acpi_processor_power_init(struct acpi_processor *pr,
 int acpi_processor_power_exit(struct acpi_processor *pr,
 			      struct acpi_device *device)
 {
-	if (boot_option_idle_override)
+	if (disabled_by_idle_boot_param())
 		return 0;
 
 	cpuidle_unregister_device(&pr->power.dev);
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 60414ae..f0798ff 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -407,6 +407,10 @@ static int __init intel_idle_init(void)
 {
 	int retval;
 
+	/* Do not load intel_idle at all for now if idle= is passed */
+	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
+		return -ENODEV;
+
 	retval = intel_idle_probe();
 	if (retval)
 		return retval;
-- 
1.6.0.2

