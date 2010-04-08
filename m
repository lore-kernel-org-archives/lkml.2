Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414Ab0DHXjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 19:39:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41596 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758650Ab0DHXis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 19:38:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 2/2] ACPI / EC / PM: Fix names of functions that block/unblock EC transactions
Date: Fri, 9 Apr 2010 01:40:38 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
References: <201004090138.13522.rjw@sisk.pl>
In-Reply-To: <201004090138.13522.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004090140.38499.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The names of the functions used for blocking/unblocking EC
transactions during suspend/hibernation suggest that the transactions
are suspended and resumed by them, while in fact they are disabled
and enabled.  Rename the functions (and the flag used by them) to
better reflect what they really do.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/ec.c       |   16 ++++++++--------
 drivers/acpi/internal.h |    6 +++---
 drivers/acpi/sleep.c    |   12 ++++++------
 3 files changed, 17 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/acpi/ec.c
===================================================================
--- linux-2.6.orig/drivers/acpi/ec.c
+++ linux-2.6/drivers/acpi/ec.c
@@ -79,7 +79,7 @@ enum {
 	EC_FLAGS_GPE_STORM,		/* GPE storm detected */
 	EC_FLAGS_HANDLERS_INSTALLED,	/* Handlers for GPE and
 					 * OpReg are installed */
-	EC_FLAGS_FROZEN,		/* Transactions are suspended */
+	EC_FLAGS_BLOCKED,		/* Transactions are blocked */
 };
 
 /* If we find an EC via the ECDT, we need to keep a ptr to its context */
@@ -293,7 +293,7 @@ static int acpi_ec_transaction(struct ac
 	if (t->rdata)
 		memset(t->rdata, 0, t->rlen);
 	mutex_lock(&ec->lock);
-	if (test_bit(EC_FLAGS_FROZEN, &ec->flags)) {
+	if (test_bit(EC_FLAGS_BLOCKED, &ec->flags)) {
 		status = -EINVAL;
 		goto unlock;
 	}
@@ -459,7 +459,7 @@ int ec_transaction(u8 command,
 
 EXPORT_SYMBOL(ec_transaction);
 
-void acpi_ec_suspend_transactions(void)
+void acpi_ec_block_transactions(void)
 {
 	struct acpi_ec *ec = first_ec;
 
@@ -468,11 +468,11 @@ void acpi_ec_suspend_transactions(void)
 
 	mutex_lock(&ec->lock);
 	/* Prevent transactions from being carried out */
-	set_bit(EC_FLAGS_FROZEN, &ec->flags);
+	set_bit(EC_FLAGS_BLOCKED, &ec->flags);
 	mutex_unlock(&ec->lock);
 }
 
-void acpi_ec_resume_transactions(void)
+void acpi_ec_unblock_transactions(void)
 {
 	struct acpi_ec *ec = first_ec;
 
@@ -481,18 +481,18 @@ void acpi_ec_resume_transactions(void)
 
 	mutex_lock(&ec->lock);
 	/* Allow transactions to be carried out again */
-	clear_bit(EC_FLAGS_FROZEN, &ec->flags);
+	clear_bit(EC_FLAGS_BLOCKED, &ec->flags);
 	mutex_unlock(&ec->lock);
 }
 
-void acpi_ec_resume_transactions_early(void)
+void acpi_ec_unblock_transactions_early(void)
 {
 	/*
 	 * Allow transactions to happen again (this function is called from
 	 * atomic context during wakeup, so we don't need to acquire the mutex).
 	 */
 	if (first_ec)
-		clear_bit(EC_FLAGS_FROZEN, &first_ec->flags);
+		clear_bit(EC_FLAGS_BLOCKED, &first_ec->flags);
 }
 
 static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 * data)
Index: linux-2.6/drivers/acpi/internal.h
===================================================================
--- linux-2.6.orig/drivers/acpi/internal.h
+++ linux-2.6/drivers/acpi/internal.h
@@ -49,9 +49,9 @@ void acpi_early_processor_set_pdc(void);
 int acpi_ec_init(void);
 int acpi_ec_ecdt_probe(void);
 int acpi_boot_ec_enable(void);
-void acpi_ec_suspend_transactions(void);
-void acpi_ec_resume_transactions(void);
-void acpi_ec_resume_transactions_early(void);
+void acpi_ec_block_transactions(void);
+void acpi_ec_unblock_transactions(void);
+void acpi_ec_unblock_transactions_early(void);
 
 /*--------------------------------------------------------------------------
                                   Suspend/Resume
Index: linux-2.6/drivers/acpi/sleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep.c
+++ linux-2.6/drivers/acpi/sleep.c
@@ -116,7 +116,7 @@ static int acpi_pm_freeze(void)
 {
 	acpi_disable_all_gpes();
 	acpi_os_wait_events_complete(NULL);
-	acpi_ec_suspend_transactions();
+	acpi_ec_block_transactions();
 	return 0;
 }
 
@@ -279,7 +279,7 @@ static int acpi_suspend_enter(suspend_st
 	 */
 	acpi_disable_all_gpes();
 	/* Allow EC transactions to happen. */
-	acpi_ec_resume_transactions_early();
+	acpi_ec_unblock_transactions_early();
 
 	local_irq_restore(flags);
 	printk(KERN_DEBUG "Back to C!\n");
@@ -293,7 +293,7 @@ static int acpi_suspend_enter(suspend_st
 
 static void acpi_suspend_finish(void)
 {
-	acpi_ec_resume_transactions();
+	acpi_ec_unblock_transactions();
 	acpi_pm_finish();
 }
 
@@ -541,7 +541,7 @@ static int acpi_hibernation_enter(void)
 static void acpi_hibernation_finish(void)
 {
 	hibernate_nvs_free();
-	acpi_ec_resume_transactions();
+	acpi_ec_unblock_transactions();
 	acpi_pm_finish();
 }
 
@@ -563,12 +563,12 @@ static void acpi_hibernation_leave(void)
 	/* Restore the NVS memory area */
 	hibernate_nvs_restore();
 	/* Allow EC transactions to happen. */
-	acpi_ec_resume_transactions_early();
+	acpi_ec_unblock_transactions_early();
 }
 
 static void acpi_pm_thaw(void)
 {
-	acpi_ec_resume_transactions();
+	acpi_ec_unblock_transactions();
 	acpi_enable_all_runtime_gpes();
 }
 

