Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468Ab2DJD1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 23:27:40 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:22336 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab2DJD1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 23:27:37 -0400
Date: Mon, 9 Apr 2012 23:22:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, konrad.r.wilk@gmail.com
Subject: Re: [PATCH 1/2] ACPI: Convert wake_sleep_flags to a value instead of
 function (v2)
Message-ID: <20120410032246.GB17300@phenom.dumpdata.com>
References: <1334025246-8811-1-git-send-email-konrad.wilk@oracle.com>
 <1334025246-8811-2-git-send-email-konrad.wilk@oracle.com>
 <1334026226.3044.4.camel@minggr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334026226.3044.4.camel@minggr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4F83A8A6.0072,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 10:50:26AM +0800, Lin Ming wrote:
> On Mon, 2012-04-09 at 22:34 -0400, Konrad Rzeszutek Wilk wrote:
> > With commit a2ef5c4fd44ce3922435139393b89f2cce47f576
> > "ACPI: Move module parameter gts and bfs to sleep.c" the wake_sleep_flags
> > is required when calling acpi_enter_sleep_state, which means
> > that if there are functions outside the sleep.c code they
> > can't get get the wake_sleep_flags values.
> > 
> > This converts the function in to a exported value and converts
> > the module config operands to a function.
> > 
> > [v2: Parameters can be turned on/off dynamically]

v3 version:

commit 667c0e7d85ac2fb8b852b9b777b78e392e6a72e9
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Fri Apr 6 17:53:51 2012 -0400

    ACPI: Convert wake_sleep_flags to a value instead of function (v2)
    
    With commit a2ef5c4fd44ce3922435139393b89f2cce47f576
    "ACPI: Move module parameter gts and bfs to sleep.c" the wake_sleep_flags
    is required when calling acpi_enter_sleep_state, which means
    that if there are functions outside the sleep.c code they
    can't get get the wake_sleep_flags values.
    
    This converts the function in to a exported value and converts
    the module config operands to a function.
    
    Acked-by: Lin Ming <ming.m.lin@intel.com>
    [v2: Parameters can be turned on/off dynamically]
    [v3: unsigned char -> u8]
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/arch/x86/kernel/acpi/sleep.h b/arch/x86/kernel/acpi/sleep.h
index 416d4be..fe5fdda 100644
--- a/arch/x86/kernel/acpi/sleep.h
+++ b/arch/x86/kernel/acpi/sleep.h
@@ -9,6 +9,8 @@ extern long saved_magic;
 
 extern int wakeup_pmode_return;
 
+extern u8 wake_sleep_flags;
+
 extern unsigned long acpi_copy_wakeup_routine(unsigned long);
 extern void wakeup_long64(void);
 
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 1d661b5..f81f5d4 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -28,23 +28,33 @@
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
 
-	if (gts)
-		flags |= ACPI_EXECUTE_GTS;
-	if (bfs)
-		flags |= ACPI_EXECUTE_BFS;
+	if (ret)
+		return ret;
 
-	return flags;
+	if (val == (const char *)&gts) {
+		if (gts)
+			wake_sleep_flags |= ACPI_EXECUTE_GTS;
+		else
+			wake_sleep_flags &= ~ACPI_EXECUTE_GTS;
+	}
+	if (val == (const char *)&bfs) {
+		if (bfs)
+			wake_sleep_flags |= ACPI_EXECUTE_BFS;
+		else
+			wake_sleep_flags &= ~ACPI_EXECUTE_BFS;
+	}
+	return ret;
 }
+module_param_call(gts, set_param_wake_flag, param_get_int, &gts, 0644);
+module_param_call(bfs, set_param_wake_flag, param_get_int, &bfs, 0644);
+MODULE_PARM_DESC(gts, "Enable evaluation of _GTS on suspend.");
+MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
 
 static u8 sleep_states[ACPI_S_STATE_COUNT];
 
@@ -263,7 +273,6 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
 {
 	acpi_status status = AE_OK;
 	u32 acpi_state = acpi_target_sleep_state;
-	u8 flags = wake_sleep_flags();
 	int error;
 
 	ACPI_FLUSH_CPU_CACHE();
@@ -271,7 +280,7 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
 	switch (acpi_state) {
 	case ACPI_STATE_S1:
 		barrier();
-		status = acpi_enter_sleep_state(acpi_state, flags);
+		status = acpi_enter_sleep_state(acpi_state, wake_sleep_flags);
 		break;
 
 	case ACPI_STATE_S3:
@@ -286,7 +295,7 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
 	acpi_write_bit_register(ACPI_BITREG_SCI_ENABLE, 1);
 
 	/* Reprogram control registers and execute _BFS */
-	acpi_leave_sleep_state_prep(acpi_state, flags);
+	acpi_leave_sleep_state_prep(acpi_state, wake_sleep_flags);
 
 	/* ACPI 3.0 specs (P62) says that it's the responsibility
 	 * of the OSPM to clear the status bit [ implying that the
@@ -550,30 +559,27 @@ static int acpi_hibernation_begin(void)
 
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
@@ -828,12 +834,10 @@ static void acpi_power_off_prepare(void)
 
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
