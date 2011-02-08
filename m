Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1BHVY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 16:24:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54954 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab1BHVYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 16:24:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/5] ACPI / PM: Move references to pm_flags into sleep.c
Date: Tue, 8 Feb 2011 22:20:24 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20110208122159.GA8284@elte.hu> <201102082218.28015.rjw@sisk.pl>
In-Reply-To: <201102082218.28015.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102082220.25240.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If direct references to pm_flags are moved from bus.c to sleep.c,
CONFIG_ACPI will not need to depend on CONFIG_PM any more.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/Kconfig    |    1 -
 drivers/acpi/bus.c      |    4 +---
 drivers/acpi/internal.h |    6 ++++++
 drivers/acpi/sleep.c    |   12 ++++++++++++
 4 files changed, 19 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/acpi/bus.c
===================================================================
--- linux-2.6.orig/drivers/acpi/bus.c
+++ linux-2.6/drivers/acpi/bus.c
@@ -1025,9 +1025,7 @@ static int __init acpi_init(void)
 
 	if (!result) {
 		pci_mmcfg_late_init();
-		if (!(pm_flags & PM_APM))
-			pm_flags |= PM_ACPI;
-		else {
+		if (!acpi_pm_enabled()) {
 			printk(KERN_INFO PREFIX
 			       "APM is already active, exiting\n");
 			disable_acpi();
Index: linux-2.6/drivers/acpi/internal.h
===================================================================
--- linux-2.6.orig/drivers/acpi/internal.h
+++ linux-2.6/drivers/acpi/internal.h
@@ -82,12 +82,18 @@ void acpi_ec_unblock_transactions_early(
 extern int acpi_sleep_init(void);
 
 #ifdef CONFIG_ACPI_SLEEP
+/* drivers/acpi/sleep.c */
+bool acpi_pm_enabled(void);
+
+/* drivers/acpi/nvs.c */
 int acpi_sleep_proc_init(void);
 int suspend_nvs_alloc(void);
 void suspend_nvs_free(void);
 int suspend_nvs_save(void);
 void suspend_nvs_restore(void);
 #else
+static inline bool acpi_pm_enabled(void) { return true; }
+
 static inline int acpi_sleep_proc_init(void) { return 0; }
 static inline int suspend_nvs_alloc(void) { return 0; }
 static inline void suspend_nvs_free(void) {}
Index: linux-2.6/drivers/acpi/sleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep.c
+++ linux-2.6/drivers/acpi/sleep.c
@@ -657,6 +657,18 @@ int acpi_pm_device_sleep_state(struct de
 
 #ifdef CONFIG_PM_SLEEP
 /**
+ *
+ */
+bool acpi_pm_enabled(void)
+{
+	if (!(pm_flags & PM_APM)) {
+		pm_flags |= PM_ACPI;
+		return true;
+	}
+	return false;
+}
+
+/**
  *	acpi_pm_device_sleep_wake - enable or disable the system wake-up
  *                                  capability of given device
  *	@dev: device to handle
Index: linux-2.6/drivers/acpi/Kconfig
===================================================================
--- linux-2.6.orig/drivers/acpi/Kconfig
+++ linux-2.6/drivers/acpi/Kconfig
@@ -7,7 +7,6 @@ menuconfig ACPI
 	depends on !IA64_HP_SIM
 	depends on IA64 || X86
 	depends on PCI
-	depends on PM
 	select PNP
 	default y
 	help

