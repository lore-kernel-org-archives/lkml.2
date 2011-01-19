Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab1ASXBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 18:01:20 -0500
Received: from relay2.sgi.com ([192.48.179.30]:51981 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755132Ab1ASXBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 18:01:18 -0500
Message-Id: <20110119230106.667109717@gulag1.americas.sgi.com>
References: <20110119230106.341785959@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 19 Jan 2011 17:01:08 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Len Brown <len.brown@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Lori Gilbertson <loriann@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH 2/6] ACPI: Minimize X2APIC initial messages
Content-Disposition: inline; filename=minimize-x2apic-msgs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minimize X2APIC messages by printing 8 per line and dropping
the "enabled" flag since that's assumed.  It will still print
"disabled" if necessary.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Jack Steiner <steiner@sgi.com>
Reviewed-by: Robin Holt <holt@sgi.com>
---
 arch/x86/kernel/acpi/boot.c |    3 +++
 drivers/acpi/tables.c       |   13 +++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

--- linux-2.6.32.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6.32/arch/x86/kernel/acpi/boot.c
@@ -848,6 +848,9 @@ static int __init acpi_parse_madt_lapic_
 	if (!count) {
 		x2count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC,
 						acpi_parse_x2apic, MAX_APICS);
+		/* insure trailing newline is output */
+		pr_cont("\n");
+
 		count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC,
 					      acpi_parse_lapic, MAX_APICS);
 	}
--- linux-2.6.32.orig/drivers/acpi/tables.c
+++ linux-2.6.32/drivers/acpi/tables.c
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
