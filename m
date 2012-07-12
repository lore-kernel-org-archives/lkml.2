Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162870Ab2GLXJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:09:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46543 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934308Ab2GLXGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:06:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [ 67/68] ACPI: Make acpi_skip_timer_override cover all source_irq==0 cases
Date: Thu, 12 Jul 2012 16:02:41 -0700
Message-Id: <20120712175041.327236599@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Tang <feng.tang@intel.com>

commit ae10ccdc3093486f8c2369d227583f9d79f628e5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/acpi/boot.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -416,12 +416,14 @@ acpi_parse_int_src_ovr(struct acpi_subta
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
@@ -1327,7 +1329,7 @@ static int __init dmi_disable_acpi(const
 }
 
 /*
- * Force ignoring BIOS IRQ0 pin2 override
+ * Force ignoring BIOS IRQ0 override
  */
 static int __init dmi_ignore_irq0_timer_override(const struct dmi_system_id *d)
 {
@@ -1337,7 +1339,7 @@ static int __init dmi_ignore_irq0_timer_
 	 */
 	if (!acpi_skip_timer_override) {
 		WARN(1, KERN_ERR "ati_ixp4x0 quirk not complete.\n");
-		pr_notice("%s detected: Ignoring BIOS IRQ0 pin2 override\n",
+		pr_notice("%s detected: Ignoring BIOS IRQ0 override\n",
 			d->ident);
 		acpi_skip_timer_override = 1;
 	}
@@ -1431,7 +1433,7 @@ static struct dmi_system_id __initdata a
 	 * is enabled.  This input is incorrectly designated the
 	 * ISA IRQ 0 via an interrupt source override even though
 	 * it is wired to the output of the master 8259A and INTIN0
-	 * is not connected at all.  Force ignoring BIOS IRQ0 pin2
+	 * is not connected at all.  Force ignoring BIOS IRQ0
 	 * override in that cases.
 	 */
 	{


