Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab1BBA6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:58:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34207 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab1BBA6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:58:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI: Avoid calling request_irq() many times for the same interrupt
Date: Wed, 2 Feb 2011 01:58:15 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102020158.15663.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

In principle acpi_os_install_interrupt_handler() may be called
multiple times for different interrupts, either from
acpi_ev_get_gpe_xrupt_block(), or from acpi_ev_install_sci_handler().
However, it always attempts to request the same interrupt,
acpi_gbl_FADT.sci_interrupt and it doesn't check whether or not this
interrupt has already been requested.

Modify this function so that it refuses to request interrupts other
than acpi_gbl_FADT.sci_interrupt and change
acpi_os_remove_interrupt_handler() so that it refuses to free such
interrupts.  Use the observation that the only supported ACPI
interrupt must be equal to acpi_gbl_FADT.sci_interrupt and drop an
unnecessary variable acpi_irq_irq.

This change has been tested on Toshiba Portege R500 and HP nx6325
without introducing any visible problems.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/osl.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

Index: linux-2.6/drivers/acpi/osl.c
===================================================================
--- linux-2.6.orig/drivers/acpi/osl.c
+++ linux-2.6/drivers/acpi/osl.c
@@ -76,7 +76,6 @@ EXPORT_SYMBOL(acpi_in_debugger);
 extern char line_buf[80];
 #endif				/*ENABLE_DEBUGGER */
 
-static unsigned int acpi_irq_irq;
 static acpi_osd_handler acpi_irq_handler;
 static void *acpi_irq_context;
 static struct workqueue_struct *kacpid_wq;
@@ -532,11 +531,15 @@ acpi_os_install_interrupt_handler(u32 gs
 	acpi_irq_stats_init();
 
 	/*
-	 * Ignore the GSI from the core, and use the value in our copy of the
-	 * FADT. It may not be the same if an interrupt source override exists
-	 * for the SCI.
+	 * ACPI interrupts different from the SCI in our copy of the FADT are
+	 * not supported.
 	 */
-	gsi = acpi_gbl_FADT.sci_interrupt;
+	if (gsi != acpi_gbl_FADT.sci_interrupt)
+		return AE_BAD_PARAMETER;
+
+	if (acpi_irq_handler)
+		return AE_ALREADY_ACQUIRED;
+
 	if (acpi_gsi_to_irq(gsi, &irq) < 0) {
 		printk(KERN_ERR PREFIX "SCI (ACPI GSI %d) not registered\n",
 		       gsi);
@@ -547,20 +550,20 @@ acpi_os_install_interrupt_handler(u32 gs
 	acpi_irq_context = context;
 	if (request_irq(irq, acpi_irq, IRQF_SHARED, "acpi", acpi_irq)) {
 		printk(KERN_ERR PREFIX "SCI (IRQ%d) allocation failed\n", irq);
+		acpi_irq_handler = NULL;
 		return AE_NOT_ACQUIRED;
 	}
-	acpi_irq_irq = irq;
 
 	return AE_OK;
 }
 
 acpi_status acpi_os_remove_interrupt_handler(u32 irq, acpi_osd_handler handler)
 {
-	if (irq) {
-		free_irq(irq, acpi_irq);
-		acpi_irq_handler = NULL;
-		acpi_irq_irq = 0;
-	}
+	if (irq != acpi_gbl_FADT.sci_interrupt)
+		return AE_BAD_PARAMETER;
+
+	free_irq(irq, acpi_irq);
+	acpi_irq_handler = NULL;
 
 	return AE_OK;
 }
@@ -1619,7 +1622,7 @@ acpi_status __init acpi_os_initialize1(v
 acpi_status acpi_os_terminate(void)
 {
 	if (acpi_irq_handler) {
-		acpi_os_remove_interrupt_handler(acpi_irq_irq,
+		acpi_os_remove_interrupt_handler(acpi_gbl_FADT.sci_interrupt,
 						 acpi_irq_handler);
 	}
 
