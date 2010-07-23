Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab0GWVBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 17:01:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54015 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab0GWVBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 17:01:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI / Sleep: Allow the NVS saving to be skipped during suspend to RAM
Date: Fri, 23 Jul 2010 22:59:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <len.brown@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org, Matthew Garrett <mjg@redhat.com>,
        "Linux-kernel" <linux-kernel@vger.kernel.org>,
        tomas m <tmezzadra@gmail.com>
References: <201007210035.02688.rjw@sisk.pl>
In-Reply-To: <201007210035.02688.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007232259.09783.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit 2a6b69765ad794389f2fc3e14a0afa1a995221c2
(ACPI: Store NVS state even when entering suspend to RAM) caused the
ACPI suspend code save the NVS area during suspend and restore it
during resume unconditionally, although it is known that some systems
need to use acpi_sleep=s4_nonvs for hibernation to work.  To allow
the affected systems to avoid saving and restoring the NVS area
during suspend to RAM and resume, introduce kernel command line
option acpi_sleep=nonvs and make acpi_sleep=s4_nonvs work as its
alias temporarily (add acpi_sleep=s4_nonvs to the feature removal
file).

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16396 .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-and-tested-by: tomas m <tmezzadra@gmail.com>
---

Hi Len,

As requested, I made a warning message be printed when s4_nonvs is used.

Please apply.

Rafael

---
 Documentation/feature-removal-schedule.txt |    8 ++++++
 Documentation/kernel-parameters.txt        |    4 +--
 arch/x86/kernel/acpi/sleep.c               |    9 +++++--
 drivers/acpi/sleep.c                       |   35 ++++++++++++++---------------
 include/linux/acpi.h                       |    2 -
 5 files changed, 35 insertions(+), 23 deletions(-)

Index: linux-2.6/drivers/acpi/sleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep.c
+++ linux-2.6/drivers/acpi/sleep.c
@@ -82,6 +82,20 @@ static int acpi_sleep_prepare(u32 acpi_s
 static u32 acpi_target_sleep_state = ACPI_STATE_S0;
 
 /*
+ * The ACPI specification wants us to save NVS memory regions during hibernation
+ * and to restore them during the subsequent resume.  Windows does that also for
+ * suspend to RAM.  However, it is known that this mechanism does not work on
+ * all machines, so we allow the user to disable it with the help of the
+ * 'acpi_sleep=nonvs' kernel command line option.
+ */
+static bool nvs_nosave;
+
+void __init acpi_nvs_nosave(void)
+{
+	nvs_nosave = true;
+}
+
+/*
  * ACPI 1.0 wants us to execute _PTS before suspending devices, so we allow the
  * user to request that behavior by using the 'acpi_old_suspend_ordering'
  * kernel command line option that causes the following variable to be set.
@@ -204,8 +218,7 @@ static int acpi_suspend_begin(suspend_st
 	u32 acpi_state = acpi_suspend_states[pm_state];
 	int error = 0;
 
-	error = suspend_nvs_alloc();
-
+	error = nvs_nosave ? 0 : suspend_nvs_alloc();
 	if (error)
 		return error;
 
@@ -389,20 +402,6 @@ static struct dmi_system_id __initdata a
 #endif /* CONFIG_SUSPEND */
 
 #ifdef CONFIG_HIBERNATION
-/*
- * The ACPI specification wants us to save NVS memory regions during hibernation
- * and to restore them during the subsequent resume.  However, it is not certain
- * if this mechanism is going to work on all machines, so we allow the user to
- * disable this mechanism using the 'acpi_sleep=s4_nonvs' kernel command line
- * option.
- */
-static bool s4_no_nvs;
-
-void __init acpi_s4_no_nvs(void)
-{
-	s4_no_nvs = true;
-}
-
 static unsigned long s4_hardware_signature;
 static struct acpi_table_facs *facs;
 static bool nosigcheck;
@@ -416,7 +415,7 @@ static int acpi_hibernation_begin(void)
 {
 	int error;
 
-	error = s4_no_nvs ? 0 : suspend_nvs_alloc();
+	error = nvs_nosave ? 0 : suspend_nvs_alloc();
 	if (!error) {
 		acpi_target_sleep_state = ACPI_STATE_S4;
 		acpi_sleep_tts_switch(acpi_target_sleep_state);
@@ -500,7 +499,7 @@ static int acpi_hibernation_begin_old(vo
 	error = acpi_sleep_prepare(ACPI_STATE_S4);
 
 	if (!error) {
-		if (!s4_no_nvs)
+		if (!nvs_nosave)
 			error = suspend_nvs_alloc();
 		if (!error)
 			acpi_target_sleep_state = ACPI_STATE_S4;
Index: linux-2.6/arch/x86/kernel/acpi/sleep.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/sleep.c
+++ linux-2.6/arch/x86/kernel/acpi/sleep.c
@@ -157,9 +157,14 @@ static int __init acpi_sleep_setup(char 
 #ifdef CONFIG_HIBERNATION
 		if (strncmp(str, "s4_nohwsig", 10) == 0)
 			acpi_no_s4_hw_signature();
-		if (strncmp(str, "s4_nonvs", 8) == 0)
-			acpi_s4_no_nvs();
+		if (strncmp(str, "s4_nonvs", 8) == 0) {
+			pr_warning("ACPI: acpi_sleep=s4_nonvs is deprecated, "
+					"please use acpi_sleep=nonvs instead");
+			acpi_nvs_nosave();
+		}
 #endif
+		if (strncmp(str, "nonvs", 5) == 0)
+			acpi_nvs_nosave();
 		if (strncmp(str, "old_ordering", 12) == 0)
 			acpi_old_suspend_ordering();
 		str = strchr(str, ',');
Index: linux-2.6/include/linux/acpi.h
===================================================================
--- linux-2.6.orig/include/linux/acpi.h
+++ linux-2.6/include/linux/acpi.h
@@ -253,7 +253,7 @@ int acpi_resources_are_enforced(void);
 #ifdef CONFIG_PM_SLEEP
 void __init acpi_no_s4_hw_signature(void);
 void __init acpi_old_suspend_ordering(void);
-void __init acpi_s4_no_nvs(void);
+void __init acpi_nvs_nosave(void);
 #endif /* CONFIG_PM_SLEEP */
 
 struct acpi_osc_context {
Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -254,8 +254,8 @@ and is between 256 and 4096 characters. 
 			control method, with respect to putting devices into
 			low power states, to be enforced (the ACPI 2.0 ordering
 			of _PTS is used by default).
-			s4_nonvs prevents the kernel from saving/restoring the
-			ACPI NVS memory during hibernation.
+			nonvs prevents the kernel from saving/restoring the
+			ACPI NVS memory during suspend/hibernation and resume.
 			sci_force_enable causes the kernel to set SCI_EN directly
 			on resume from S1/S3 (which is against the ACPI spec,
 			but some broken systems don't work without it).
Index: linux-2.6/Documentation/feature-removal-schedule.txt
===================================================================
--- linux-2.6.orig/Documentation/feature-removal-schedule.txt
+++ linux-2.6/Documentation/feature-removal-schedule.txt
@@ -647,3 +647,11 @@ Who:	Stefan Richter <stefanr@s5r6.in-ber
 
 ----------------------------
 
+What:	The acpi_sleep=s4_nonvs command line option
+When:	2.6.37
+Files:	arch/x86/kernel/acpi/sleep.c
+Why:	superseded by acpi_sleep=nonvs
+Who:	Rafael J. Wysocki <rjw@sisk.pl>
+
+----------------------------
+

