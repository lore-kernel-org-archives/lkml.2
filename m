Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab2AQNWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:22:41 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:43865 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab2AQNWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:22:38 -0500
X-Greylist: delayed 3603 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jan 2012 08:22:38 EST
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Lin Ming <ming.m.lin@intel.com>, stable@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 47/50] ACPI: processor: fix acpi_get_cpuid for UP processor
Date: Tue, 17 Jan 2012 07:21:39 -0500
Message-id: <d640113fe80e45ebd4a5b420b220d3f6bf37f682.1326802230.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

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

Cc: stable@vger.kernel.org
Reported-and-tested-by: wallak@free.fr
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_core.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 3a0428e..c850de4 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -173,8 +173,30 @@ int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
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
-- 
1.7.9.rc1

