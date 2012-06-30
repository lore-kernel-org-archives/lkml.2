Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab2F3FO2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 01:14:28 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52182 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2F3FO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 01:14:26 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 3/8] ACPI: Make acpi_skip_timer_override cover all source_irq==0 cases
Date: Sat, 30 Jun 2012 01:07:30 -0400
Message-Id: <ae10ccdc3093486f8c2369d227583f9d79f628e5.1341032550.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.11.1.104.ge7b44f1
In-Reply-To: <1341032855-27139-1-git-send-email-lenb@kernel.org>
References: <1341032855-27139-1-git-send-email-lenb@kernel.org>
In-Reply-To: <9f132652d94c96476b0b0a8caf0c10e96ab10fa8.1341032550.git.len.brown@intel.com>
References: <9f132652d94c96476b0b0a8caf0c10e96ab10fa8.1341032550.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Currently when acpi_skip_timer_override is set, it only cover the
(source_irq == 0 && global_irq == 2) cases. While there is also
platform which need use this option and its global_irq is not 2.
This patch will extend acpi_skip_timer_override to cover all
timer overriding cases as long as the source irq is 0.

This is the first part of a fix to kernel bug bugzilla 40002:
	"IRQ 0 assigned to VGA"
https://bugzilla.kernel.org/show_bug.cgi?id=40002

Reported-and-tested-by: Szymon Kowalczyk <fazerxlo@o2.pl>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/acpi/boot.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 8afb693..e7c698e 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -422,12 +422,14 @@ acpi_parse_int_src_ovr(struct acpi_subtable_header * header,
 		return 0;
 	}
 
-	if (intsrc->source_irq == 0 && intsrc->global_irq == 2) {
+	if (intsrc->source_irq == 0) {
 		if (acpi_skip_timer_override) {
-			printk(PREFIX "BIOS IRQ0 pin2 override ignored.\n");
+			printk(PREFIX "BIOS IRQ0 override ignored.\n");
 			return 0;
 		}
-		if (acpi_fix_pin2_polarity && (intsrc->inti_flags & ACPI_MADT_POLARITY_MASK)) {
+
+		if ((intsrc->global_irq == 2) && acpi_fix_pin2_polarity
+			&& (intsrc->inti_flags & ACPI_MADT_POLARITY_MASK)) {
 			intsrc->inti_flags &= ~ACPI_MADT_POLARITY_MASK;
 			printk(PREFIX "BIOS IRQ0 pin2 override: forcing polarity to high active.\n");
 		}
@@ -1334,7 +1336,7 @@ static int __init dmi_disable_acpi(const struct dmi_system_id *d)
 }
 
 /*
- * Force ignoring BIOS IRQ0 pin2 override
+ * Force ignoring BIOS IRQ0 override
  */
 static int __init dmi_ignore_irq0_timer_override(const struct dmi_system_id *d)
 {
@@ -1344,7 +1346,7 @@ static int __init dmi_ignore_irq0_timer_override(const struct dmi_system_id *d)
 	 */
 	if (!acpi_skip_timer_override) {
 		WARN(1, KERN_ERR "ati_ixp4x0 quirk not complete.\n");
-		pr_notice("%s detected: Ignoring BIOS IRQ0 pin2 override\n",
+		pr_notice("%s detected: Ignoring BIOS IRQ0 override\n",
 			d->ident);
 		acpi_skip_timer_override = 1;
 	}
@@ -1438,7 +1440,7 @@ static struct dmi_system_id __initdata acpi_dmi_table_late[] = {
 	 * is enabled.  This input is incorrectly designated the
 	 * ISA IRQ 0 via an interrupt source override even though
 	 * it is wired to the output of the master 8259A and INTIN0
-	 * is not connected at all.  Force ignoring BIOS IRQ0 pin2
+	 * is not connected at all.  Force ignoring BIOS IRQ0
 	 * override in that cases.
 	 */
 	{
-- 
1.7.11.1.104.ge7b44f1

