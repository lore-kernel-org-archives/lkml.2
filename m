Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab2DCBSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 21:18:31 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58046 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2DCBSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 21:18:30 -0400
Message-ID: <1333415903.860.0.camel@mop>
Subject: [PATCH] printk(): add KERN_CONT where needed
From: Kay Sievers <kay@vrfy.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <lenb@kernel.org>
Date: Tue, 03 Apr 2012 03:18:23 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.3.91 (3.3.91-1.fc17)
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay@vrfy.org>
Subject: printk(): add KERN_CONT where needed

A prototype for kmsg records instead of a byte-stream buffer revealed
a couple of missing printk(KERN_CONT ...) uses. Subsequent calls produce
one record per printk() call, while all should have ended up in a single
record.

Instead of:
  ACPI: (supports S0 S5)
  ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
  hpet0: at MMIO 0xfed00000, IRQs 2 , 8 , 0

It prints:
  ACPI: (supports S0
   S5
  )
  ACPI: PCI Interrupt Link [LNKA] (IRQs
   5
   *10
   11
  )
  hpet0: at MMIO 0xfed00000, IRQs
   2
  , 8
  , 0

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kay Sievers <kay@vrfy.org>
---
 drivers/acpi/pci_link.c |   12 ++++++------
 drivers/acpi/sleep.c    |    8 ++++----
 drivers/char/hpet.c     |    4 ++--
 drivers/tty/vt/vt.c     |    3 +--
 mm/page_alloc.c         |    6 +++---
 5 files changed, 16 insertions(+), 17 deletions(-)

--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -720,21 +720,21 @@ static int acpi_pci_link_add(struct acpi
 	       acpi_device_bid(device));
 	for (i = 0; i < link->irq.possible_count; i++) {
 		if (link->irq.active == link->irq.possible[i]) {
-			printk(" *%d", link->irq.possible[i]);
+			printk(KERN_CONT " *%d", link->irq.possible[i]);
 			found = 1;
 		} else
-			printk(" %d", link->irq.possible[i]);
+			printk(KERN_CONT " %d", link->irq.possible[i]);
 	}
 
-	printk(")");
+	printk(KERN_CONT ")");
 
 	if (!found)
-		printk(" *%d", link->irq.active);
+		printk(KERN_CONT " *%d", link->irq.active);
 
 	if (!link->device->status.enabled)
-		printk(", disabled.");
+		printk(KERN_CONT ", disabled.");
 
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	list_add_tail(&link->list, &acpi_link_list);
 
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -883,7 +883,7 @@ int __init acpi_sleep_init(void)
 		status = acpi_get_sleep_type_data(i, &type_a, &type_b);
 		if (ACPI_SUCCESS(status)) {
 			sleep_states[i] = 1;
-			printk(" S%d", i);
+			printk(KERN_CONT " S%d", i);
 		}
 	}
 
@@ -897,7 +897,7 @@ int __init acpi_sleep_init(void)
 		hibernation_set_ops(old_suspend_ordering ?
 			&acpi_hibernation_ops_old : &acpi_hibernation_ops);
 		sleep_states[ACPI_STATE_S4] = 1;
-		printk(" S4");
+		printk(KERN_CONT " S4");
 		if (!nosigcheck) {
 			acpi_get_table(ACPI_SIG_FACS, 1,
 				(struct acpi_table_header **)&facs);
@@ -910,11 +910,11 @@ int __init acpi_sleep_init(void)
 	status = acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
 	if (ACPI_SUCCESS(status)) {
 		sleep_states[ACPI_STATE_S5] = 1;
-		printk(" S5");
+		printk(KERN_CONT " S5");
 		pm_power_off_prepare = acpi_power_off_prepare;
 		pm_power_off = acpi_power_off;
 	}
-	printk(")\n");
+	printk(KERN_CONT ")\n");
 	/*
 	 * Register the tts_notifier to reboot notifier list so that the _TTS
 	 * object can also be evaluated when the system enters S5.
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -906,8 +906,8 @@ int hpet_alloc(struct hpet_data *hdp)
 		hpetp->hp_which, hdp->hd_phys_address,
 		hpetp->hp_ntimer > 1 ? "s" : "");
 	for (i = 0; i < hpetp->hp_ntimer; i++)
-		printk("%s %d", i > 0 ? "," : "", hdp->hd_irq[i]);
-	printk("\n");
+		printk(KERN_CONT "%s %d", i > 0 ? "," : "", hdp->hd_irq[i]);
+	printk(KERN_CONT "\n");
 
 	temp = hpetp->hp_tick_freq;
 	remainder = do_div(temp, 1000000);
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2932,11 +2932,10 @@ static int __init con_init(void)
 	gotoxy(vc, vc->vc_x, vc->vc_y);
 	csi_J(vc, 0);
 	update_screen(vc);
-	pr_info("Console: %s %s %dx%d",
+	pr_info("Console: %s %s %dx%d\n",
 		vc->vc_can_do_color ? "colour" : "mono",
 		display_desc, vc->vc_cols, vc->vc_rows);
 	printable = 1;
-	printk("\n");
 
 	console_unlock();
 
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4763,12 +4763,12 @@ void __init free_area_init_nodes(unsigne
 	for (i = 0; i < MAX_NR_ZONES; i++) {
 		if (i == ZONE_MOVABLE)
 			continue;
-		printk("  %-8s ", zone_names[i]);
+		printk(KERN_CONT "  %-8s ", zone_names[i]);
 		if (arch_zone_lowest_possible_pfn[i] ==
 				arch_zone_highest_possible_pfn[i])
-			printk("empty\n");
+			printk(KERN_CONT "empty\n");
 		else
-			printk("%0#10lx -> %0#10lx\n",
+			printk(KERN_CONT "%0#10lx -> %0#10lx\n",
 				arch_zone_lowest_possible_pfn[i],
 				arch_zone_highest_possible_pfn[i]);
 	}



