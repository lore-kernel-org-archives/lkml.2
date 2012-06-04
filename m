Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab2FDFkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:40:21 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:54747 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2FDFkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:40:18 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Marco Aurelio da Costa <costa@gamic.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 02/15] ACPI: Ignore invalid _PSS entries, but use valid ones
Date: Mon,  4 Jun 2012 01:39:53 -0400
Message-Id: <d8e725f356fd5f225ad97f21213fc007e409c9f5.1338786831.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.11.rc0.100.g5498c5f
In-Reply-To: <1338788406-29981-1-git-send-email-lenb@kernel.org>
References: <1338788406-29981-1-git-send-email-lenb@kernel.org>
In-Reply-To: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
References: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Aurelio da Costa <costa@gamic.com>

The EliteBook 8560W has non-initialized entries in its _PSS ACPI
table. Instead of bailing out when the first non-initialized entry is
found, ignore it and use only  the valid entries. Only bail out if there
is no valid entry at all.

[v3: Fixes suggested by Konrad]

Signed-off-by: Marco Aurelio da Costa <costa@gamic.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_perflib.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 0af48a8..a093dc1 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -333,6 +333,7 @@ static int acpi_processor_get_performance_states(struct acpi_processor *pr)
 	struct acpi_buffer state = { 0, NULL };
 	union acpi_object *pss = NULL;
 	int i;
+	int last_invalid = -1;
 
 
 	status = acpi_evaluate_object(pr->handle, "_PSS", NULL, &buffer);
@@ -394,14 +395,33 @@ static int acpi_processor_get_performance_states(struct acpi_processor *pr)
 		    ((u32)(px->core_frequency * 1000) !=
 		     (px->core_frequency * 1000))) {
 			printk(KERN_ERR FW_BUG PREFIX
-			       "Invalid BIOS _PSS frequency: 0x%llx MHz\n",
-			       px->core_frequency);
-			result = -EFAULT;
-			kfree(pr->performance->states);
-			goto end;
+			       "Invalid BIOS _PSS frequency found for processor %d: 0x%llx MHz\n",
+			       pr->id, px->core_frequency);
+			if (last_invalid == -1)
+				last_invalid = i;
+		} else {
+			if (last_invalid != -1) {
+				/*
+				 * Copy this valid entry over last_invalid entry
+				 */
+				memcpy(&(pr->performance->states[last_invalid]),
+				       px, sizeof(struct acpi_processor_px));
+				++last_invalid;
+			}
 		}
 	}
 
+	if (last_invalid == 0) {
+		printk(KERN_ERR FW_BUG PREFIX
+		       "No valid BIOS _PSS frequency found for processor %d\n", pr->id);
+		result = -EFAULT;
+		kfree(pr->performance->states);
+		pr->performance->states = NULL;
+	}
+
+	if (last_invalid > 0)
+		pr->performance->state_count = last_invalid;
+
       end:
 	kfree(buffer.pointer);
 
-- 
1.7.11.rc0.100.g5498c5f

