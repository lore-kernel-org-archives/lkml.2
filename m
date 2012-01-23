Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab2AWX5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:57:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232Ab2AWXuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:50:19 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:29 2012
Message-Id: <20120123234029.128717922@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:39:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [73/90] ACPI: processor: fix acpi_get_cpuid for UP processor
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ming <ming.m.lin@intel.com>

commit d640113fe80e45ebd4a5b420b220d3f6bf37f682 upstream.

For UP processor, it is likely that no _MAT method or MADT table defined.
So currently acpi_get_cpuid(...) always return -1 for UP processor.
This is wrong. It should return valid value for CPU0.

In the other hand, BIOS may define multiple CPU handles even for UP
processor, for example

        Scope (_PR)
        {
            Processor (CPU0, 0x00, 0x00000410, 0x06) {}
            Processor (CPU1, 0x01, 0x00000410, 0x06) {}
            Processor (CPU2, 0x02, 0x00000410, 0x06) {}
            Processor (CPU3, 0x03, 0x00000410, 0x06) {}
        }

We should only return valid value for CPU0's acpi handle.
And return invalid value for others.

http://marc.info/?t=132329819900003&r=1&w=2

Reported-and-tested-by: wallak@free.fr
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/processor_core.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -172,8 +172,30 @@ int acpi_get_cpuid(acpi_handle handle, i
 	apic_id = map_mat_entry(handle, type, acpi_id);
 	if (apic_id == -1)
 		apic_id = map_madt_entry(type, acpi_id);
-	if (apic_id == -1)
-		return apic_id;
+	if (apic_id == -1) {
+		/*
+		 * On UP processor, there is no _MAT or MADT table.
+		 * So above apic_id is always set to -1.
+		 *
+		 * BIOS may define multiple CPU handles even for UP processor.
+		 * For example,
+		 *
+		 * Scope (_PR)
+                 * {
+		 *     Processor (CPU0, 0x00, 0x00000410, 0x06) {}
+		 *     Processor (CPU1, 0x01, 0x00000410, 0x06) {}
+		 *     Processor (CPU2, 0x02, 0x00000410, 0x06) {}
+		 *     Processor (CPU3, 0x03, 0x00000410, 0x06) {}
+		 * }
+		 *
+		 * Ignores apic_id and always return 0 for CPU0's handle.
+		 * Return -1 for other CPU's handle.
+		 */
+		if (acpi_id == 0)
+			return acpi_id;
+		else
+			return apic_id;
+	}
 
 #ifdef CONFIG_SMP
 	for_each_possible_cpu(i) {


