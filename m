Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab1BGWXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 17:23:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51704 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439Ab1BGWXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 17:23:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 5/6] ACPI / PM: Merge do_suspend_lowlevel() into acpi_save_state_mem()
Date: Mon, 7 Feb 2011 23:21:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
References: <201102072316.41270.rjw@sisk.pl>
In-Reply-To: <201102072316.41270.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102072321.37565.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The function do_suspend_lowlevel() is specific to x86 and defined in
assembly code, so it should be called from the x86 low-level suspend
code rather than from acpi_suspend_enter().

Merge do_suspend_lowlevel() into the x86's acpi_save_state_mem() and
change the name of the latter to acpi_suspend_lowlevel(), so that the
function's purpose is better reflected by its name.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/ia64/include/asm/acpi.h |    4 ++--
 arch/ia64/kernel/acpi.c      |    9 ++-------
 arch/x86/include/asm/acpi.h  |    4 ++--
 arch/x86/kernel/acpi/sleep.c |    5 +++--
 arch/x86/kernel/acpi/sleep.h |    2 ++
 drivers/acpi/sleep.c         |    5 +----
 6 files changed, 12 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/acpi/sleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep.c
+++ linux-2.6/drivers/acpi/sleep.c
@@ -199,8 +199,6 @@ static void acpi_pm_end(void)
 #endif /* CONFIG_ACPI_SLEEP */
 
 #ifdef CONFIG_SUSPEND
-extern void do_suspend_lowlevel(void);
-
 static u32 acpi_suspend_states[] = {
 	[PM_SUSPEND_ON] = ACPI_STATE_S0,
 	[PM_SUSPEND_STANDBY] = ACPI_STATE_S1,
@@ -255,10 +253,9 @@ static int acpi_suspend_enter(suspend_st
 		break;
 
 	case ACPI_STATE_S3:
-		error = acpi_save_state_mem();
+		error = acpi_suspend_lowlevel();
 		if (error)
 			return error;
-		do_suspend_lowlevel();
 		pr_info(PREFIX "Low-level resume complete\n");
 		break;
 	}
Index: linux-2.6/arch/ia64/include/asm/acpi.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/acpi.h
+++ linux-2.6/arch/ia64/include/asm/acpi.h
@@ -128,8 +128,8 @@ static inline const char *acpi_get_sysna
 int acpi_request_vector (u32 int_type);
 int acpi_gsi_to_irq (u32 gsi, unsigned int *irq);
 
-/* Routine for saving kernel state during suspend. */
-extern int acpi_save_state_mem(void);
+/* Low-level suspend routine. */
+extern int acpi_suspend_lowlevel(void);
 
 extern unsigned long acpi_wakeup_address;
 
Index: linux-2.6/arch/ia64/kernel/acpi.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/acpi.c
+++ linux-2.6/arch/ia64/kernel/acpi.c
@@ -1034,13 +1034,8 @@ int acpi_unregister_ioapic(acpi_handle h
 EXPORT_SYMBOL(acpi_unregister_ioapic);
 
 /*
- * acpi_save_state_mem() - save kernel state
+ * acpi_suspend_lowlevel() - save kernel state and suspend.
  *
  * TBD when when IA64 starts to support suspend...
  */
-int acpi_save_state_mem(void) { return 0; } 
-
-/*
- * do_suspend_lowlevel()
- */
-void do_suspend_lowlevel(void) {}
+int acpi_suspend_lowlevel(void) { return 0; }
Index: linux-2.6/arch/x86/include/asm/acpi.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/acpi.h
+++ linux-2.6/arch/x86/include/asm/acpi.h
@@ -112,8 +112,8 @@ static inline void acpi_disable_pci(void
 	acpi_noirq_set();
 }
 
-/* Routine for saving kernel state during suspend. */
-extern int acpi_save_state_mem(void);
+/* Low-level suspend routine. */
+extern int acpi_suspend_lowlevel(void);
 
 extern unsigned long acpi_wakeup_address;
 
Index: linux-2.6/arch/x86/kernel/acpi/sleep.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/sleep.c
+++ linux-2.6/arch/x86/kernel/acpi/sleep.c
@@ -31,14 +31,14 @@ static char temp_stack[4096];
 #endif
 
 /**
- * acpi_save_state_mem - save kernel state
+ * acpi_suspend_lowlevel - save kernel state
  *
  * Create an identity mapped page table and copy the wakeup routine to
  * low memory.
  *
  * Note that this is too late to change acpi_wakeup_address.
  */
-int acpi_save_state_mem(void)
+int acpi_suspend_lowlevel(void)
 {
 	struct wakeup_header *header;
 
@@ -109,6 +109,7 @@ int acpi_save_state_mem(void)
        saved_magic = 0x123456789abcdef0L;
 #endif /* CONFIG_64BIT */
 
+	do_suspend_lowlevel();
 	return 0;
 }
 
Index: linux-2.6/arch/x86/kernel/acpi/sleep.h
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/sleep.h
+++ linux-2.6/arch/x86/kernel/acpi/sleep.h
@@ -14,3 +14,5 @@ extern char swsusp_pg_dir[PAGE_SIZE];
 
 extern unsigned long acpi_copy_wakeup_routine(unsigned long);
 extern void wakeup_long64(void);
+
+extern void do_suspend_lowlevel(void);

