Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab1BQSvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:51:39 -0500
Received: from relay1.sgi.com ([192.48.179.29]:39365 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853Ab1BQSvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:51:35 -0500
Message-Id: <20110217185132.137154887@gulag1.americas.sgi.com>
References: <20110217185131.960038922@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 17 Feb 2011 12:51:32 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ACPI: Minimize X2APIC initial messages
Content-Disposition: inline; filename=minimize-x2apic-msgs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minimize X2APIC messages by printing 8 per line and dropping
the "enabled" flag since that's assumed.  It will still print
"disabled" if necessary.

v2: updated to apply to x86-tip

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Jack Steiner <steiner@sgi.com>
Reviewed-by: Robin Holt <holt@sgi.com>
---
 arch/x86/kernel/acpi/boot.c |    3 +++
 drivers/acpi/tables.c       |   13 +++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

--- linux.orig/arch/x86/kernel/acpi/boot.c
+++ linux/arch/x86/kernel/acpi/boot.c
@@ -903,6 +903,9 @@ static int __init acpi_parse_madt_lapic_
 	if (!count) {
 		x2count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC,
 					acpi_parse_x2apic, MAX_LOCAL_APIC);
+		/* insure trailing newline is output */
+		pr_cont("\n");
+
 		count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC,
 					acpi_parse_lapic, MAX_LOCAL_APIC);
 	}
--- linux.orig/drivers/acpi/tables.c
+++ linux/drivers/acpi/tables.c
@@ -66,11 +66,16 @@ void acpi_table_print_madt_entry(struct
 		{
 			struct acpi_madt_local_x2apic *p =
 			    (struct acpi_madt_local_x2apic *)header;
-			printk(KERN_INFO PREFIX
-			       "X2APIC (apic_id[0x%02x] uid[0x%02x] %s)\n",
+
+			if ((p->uid & 7) == 0)
+				pr_info(PREFIX "X2APIC apic_id=uid:");
+
+			pr_cont(" %02x=%02x%s%s",
 			       p->local_apic_id, p->uid,
-			       (p->lapic_flags & ACPI_MADT_ENABLED) ?
-			       "enabled" : "disabled");
+			       /* assume "enabled" unless "disabled" */
+				(p->lapic_flags & ACPI_MADT_ENABLED) ?
+				"" : " disabled",
+				(p->uid & 7) == 7 ? "\n" : "");
 		}
 		break;
 

-- 
