Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab2DFW2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 18:28:12 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46645 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab2DFW2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 18:28:10 -0400
Date: Fri, 6 Apr 2012 18:23:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ming.m.lin@intel.com, linux-kernel@vger.kernel.org
Subject: Re: ACPI: Move module parameter gts and bfs to sleep.c
Message-ID: <20120406222329.GA19837@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090209.4F7F6DF9.0099,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Lin,

I was wondering if you are OK with exporting the wake_sleep_flags
function so that other callers of acpi_enter_sleep (which are
outside the sleep.c) could use it?

Specifically this patch
http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=blobdiff;f=include/xen/acpi.h;h=ebaabbbe91877cc9d7188254463b4a591f6bb81d;hp=48a9c0171b658904b33a82df0d4aa31fe8b8ed81;hb=331a7ed09457ca7b6c31170c5d59a09e6f1e02c2;hpb=68504cdd16c26735078f65a0bdc8eeb9f0c493ea

[which I was hoping to post for v3.5]
.. which in 3.3 would call acpi_enter_sleep_state without
trouble but with 3.4 it needs a parameter.

This little patch (compile tested, but not actually run):

commit 8f9f29819fa71de17e2e6f38fc50c4156dc3dada
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Fri Apr 6 17:53:51 2012 -0400

    ACPI: Convert wake_sleep_flags to a value instead of function.
    
    With commit a2ef5c4fd44ce3922435139393b89f2cce47f576
    "ACPI: Move module parameter gts and bfs to sleep.c" the wake_sleep_flags
    is required when calling acpi_enter_sleep_state, which means
    that if there are functions outside the sleep.c code they
    can't get get the wake_sleep_flags values.
    
    This converts the function in to a exported value and converts
    the module config operands to a function.
    
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/arch/x86/kernel/acpi/sleep.h b/arch/x86/kernel/acpi/sleep.h
index 4d3feb5..f84e9cd 100644
--- a/arch/x86/kernel/acpi/sleep.h
+++ b/arch/x86/kernel/acpi/sleep.h
@@ -9,6 +9,8 @@ extern long saved_magic;
 
 extern int wakeup_pmode_return;
 
+extern unsigned wake_sleep_flags;
+
 extern unsigned long acpi_copy_wakeup_routine(unsigned long);
 extern void wakeup_long64(void);
 
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 6a8d4d3..dcee73a 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -28,23 +28,23 @@
 #include "internal.h"
 #include "sleep.h"
 
+u8 wake_sleep_flags = ACPI_NO_OPTIONAL_METHODS;
 static unsigned int gts, bfs;
-module_param(gts, uint, 0644);
-module_param(bfs, uint, 0644);
-MODULE_PARM_DESC(gts, "Enable evaluation of _GTS on suspend.");
-MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
-
-static u8 wake_sleep_flags(void)
+static int set_param_wake_flag(const char *val, struct kernel_param *kp)
 {
-	u8 flags = ACPI_NO_OPTIONAL_METHODS;
+	int ret = param_set_int(val, kp);
 
 	if (gts)
-		flags |= ACPI_EXECUTE_GTS;
+		wake_sleep_flags |= ACPI_EXECUTE_GTS;
 	if (bfs)
-		flags |= ACPI_EXECUTE_BFS;
+		wake_sleep_flags |= ACPI_EXECUTE_BFS;
 
-	return flags;
+	return ret;
 }
+module_param_call(gts, set_param_wake_flag, param_get_int, &gts, 0644);
+module_param_call(bfs, set_param_wake_flag, param_get_int, &bfs, 0644);
+MODULE_PARM_DESC(gts, "Enable evaluation of _GTS on suspend.");
+MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
 
 static u8 sleep_states[ACPI_S_STATE_COUNT];
 
@@ -263,7 +263,6 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
 {
 	acpi_status status = AE_OK;
 	u32 acpi_state = acpi_target_sleep_state;
-	u8 flags = wake_sleep_flags();
 	int error;
 
 	ACPI_FLUSH_CPU_CACHE();
@@ -271,7 +270,7 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
 	switch (acpi_state) {
 	case ACPI_STATE_S1:
 		barrier();
-		status = acpi_enter_sleep_state(acpi_state, flags);
+		status = acpi_enter_sleep_state(acpi_state, wake_sleep_flags);
 		break;
 
 	case ACPI_STATE_S3:
@@ -288,7 +287,7 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
 	acpi_write_bit_register(ACPI_BITREG_SCI_ENABLE, 1);
 
 	/* Reprogram control registers and execute _BFS */
-	acpi_leave_sleep_state_prep(acpi_state, flags);
+	acpi_leave_sleep_state_prep(acpi_state, wake_sleep_flags);
 
 	/* ACPI 3.0 specs (P62) says that it's the responsibility
 	 * of the OSPM to clear the status bit [ implying that the
@@ -552,30 +551,27 @@ static int acpi_hibernation_begin(void)
 
 static int acpi_hibernation_enter(void)
 {
-	u8 flags = wake_sleep_flags();
 	acpi_status status = AE_OK;
 
 	ACPI_FLUSH_CPU_CACHE();
 
 	/* This shouldn't return.  If it returns, we have a problem */
-	status = acpi_enter_sleep_state(ACPI_STATE_S4, flags);
+	status = acpi_enter_sleep_state(ACPI_STATE_S4, wake_sleep_flags);
 	/* Reprogram control registers and execute _BFS */
-	acpi_leave_sleep_state_prep(ACPI_STATE_S4, flags);
+	acpi_leave_sleep_state_prep(ACPI_STATE_S4, wake_sleep_flags);
 
 	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
 }
 
 static void acpi_hibernation_leave(void)
 {
-	u8 flags = wake_sleep_flags();
-
 	/*
 	 * If ACPI is not enabled by the BIOS and the boot kernel, we need to
 	 * enable it here.
 	 */
 	acpi_enable();
 	/* Reprogram control registers and execute _BFS */
-	acpi_leave_sleep_state_prep(ACPI_STATE_S4, flags);
+	acpi_leave_sleep_state_prep(ACPI_STATE_S4, wake_sleep_flags);
 	/* Check the hardware signature */
 	if (facs && s4_hardware_signature != facs->hardware_signature) {
 		printk(KERN_EMERG "ACPI: Hardware changed while hibernated, "
@@ -830,12 +826,10 @@ static void acpi_power_off_prepare(void)
 
 static void acpi_power_off(void)
 {
-	u8 flags = wake_sleep_flags();
-
 	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
 	printk(KERN_DEBUG "%s called\n", __func__);
 	local_irq_disable();
-	acpi_enter_sleep_state(ACPI_STATE_S5, flags);
+	acpi_enter_sleep_state(ACPI_STATE_S5, wake_sleep_flags);
 }
 
 /*
