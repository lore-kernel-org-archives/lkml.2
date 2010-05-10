Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824Ab0EJXNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:13:47 -0400
Received: from kroah.org ([198.145.64.141]:45266 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932904Ab0EJW6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:18 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:40 2010
Message-Id: <20100510223540.247466151@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>
Subject: [65/98] ACPI: introduce kernel parameter acpi_sleep=sci_force_enable
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit d7f0eea9e431e1b8b0742a74db1a9490730b2a25 upstream.

Introduce kernel parameter acpi_sleep=sci_force_enable

some laptop requires SCI_EN being set directly on resume,
or else they hung somewhere in the resume code path.

We already have a blacklist for these laptops but we still need
this option, especially when debugging some suspend/resume problems,
in case there are systems that need this workaround and are not yet
in the blacklist.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/kernel-parameters.txt |    5 ++++-
 arch/x86/kernel/acpi/sleep.c        |    2 ++
 drivers/acpi/sleep.c                |   29 +++++++++++++++++------------
 include/linux/acpi.h                |    1 +
 4 files changed, 24 insertions(+), 13 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -241,7 +241,7 @@ and is between 256 and 4096 characters.
 
 	acpi_sleep=	[HW,ACPI] Sleep options
 			Format: { s3_bios, s3_mode, s3_beep, s4_nohwsig,
-				  old_ordering, s4_nonvs }
+				  old_ordering, s4_nonvs, sci_force_enable }
 			See Documentation/power/video.txt for information on
 			s3_bios and s3_mode.
 			s3_beep is for debugging; it makes the PC's speaker beep
@@ -254,6 +254,9 @@ and is between 256 and 4096 characters.
 			of _PTS is used by default).
 			s4_nonvs prevents the kernel from saving/restoring the
 			ACPI NVS memory during hibernation.
+			sci_force_enable causes the kernel to set SCI_EN directly
+			on resume from S1/S3 (which is against the ACPI spec,
+			but some broken systems don't work without it).
 
 	acpi_use_timer_override [HW,ACPI]
 			Use timer override. For some broken Nvidia NF5 boards
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -162,6 +162,8 @@ static int __init acpi_sleep_setup(char
 #endif
 		if (strncmp(str, "old_ordering", 12) == 0)
 			acpi_old_suspend_ordering();
+		if (strncmp(str, "sci_force_enable", 16) == 0)
+			acpi_set_sci_en_on_resume();
 		str = strchr(str, ',');
 		if (str != NULL)
 			str += strspn(str, ", \t");
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -81,6 +81,23 @@ static int acpi_sleep_prepare(u32 acpi_s
 #ifdef CONFIG_ACPI_SLEEP
 static u32 acpi_target_sleep_state = ACPI_STATE_S0;
 /*
+ * According to the ACPI specification the BIOS should make sure that ACPI is
+ * enabled and SCI_EN bit is set on wake-up from S1 - S3 sleep states.  Still,
+ * some BIOSes don't do that and therefore we use acpi_enable() to enable ACPI
+ * on such systems during resume.  Unfortunately that doesn't help in
+ * particularly pathological cases in which SCI_EN has to be set directly on
+ * resume, although the specification states very clearly that this flag is
+ * owned by the hardware.  The set_sci_en_on_resume variable will be set in such
+ * cases.
+ */
+static bool set_sci_en_on_resume;
+
+void __init acpi_set_sci_en_on_resume(void)
+{
+	set_sci_en_on_resume = true;
+}
+
+/*
  * ACPI 1.0 wants us to execute _PTS before suspending devices, so we allow the
  * user to request that behavior by using the 'acpi_old_suspend_ordering'
  * kernel command line option that causes the following variable to be set.
@@ -170,18 +187,6 @@ static void acpi_pm_end(void)
 #endif /* CONFIG_ACPI_SLEEP */
 
 #ifdef CONFIG_SUSPEND
-/*
- * According to the ACPI specification the BIOS should make sure that ACPI is
- * enabled and SCI_EN bit is set on wake-up from S1 - S3 sleep states.  Still,
- * some BIOSes don't do that and therefore we use acpi_enable() to enable ACPI
- * on such systems during resume.  Unfortunately that doesn't help in
- * particularly pathological cases in which SCI_EN has to be set directly on
- * resume, although the specification states very clearly that this flag is
- * owned by the hardware.  The set_sci_en_on_resume variable will be set in such
- * cases.
- */
-static bool set_sci_en_on_resume;
-
 extern void do_suspend_lowlevel(void);
 
 static u32 acpi_suspend_states[] = {
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -251,6 +251,7 @@ int acpi_check_mem_region(resource_size_
 void __init acpi_no_s4_hw_signature(void);
 void __init acpi_old_suspend_ordering(void);
 void __init acpi_s4_no_nvs(void);
+void __init acpi_set_sci_en_on_resume(void);
 #endif /* CONFIG_PM_SLEEP */
 
 struct acpi_osc_context {


