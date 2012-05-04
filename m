Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab2EDNqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 09:46:03 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:45205 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756857Ab2EDNqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 09:46:01 -0400
MIME-Version: 1.0
Date: Fri, 4 May 2012 10:46:01 -0300
X-Google-Sender-Auth: HJR4KnZjDCz4Ap7LAI0qmH0S1pw
Message-ID: <CAEe-dwgCR55urie0c1MdBWTS6-E=3faXj68=WMcb6NvQCQX0rg@mail.gmail.com>
Subject: [RFC][PATCH] ACPI: Ignore invalid _PSS entries, but use valid ones
From: Marco Aurelio da Costa <costa@gamic.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Aurelio da Costa <costa@gamic.com>
Signed-off-by: Marco Aurelio da Costa <costa@gamic.com>

The EliteBook 8560W has non-initialized entries in its _PSS ACPI
table. Instead of bailing out when the first non-initialized entry is
found, ignore it and use only  the valid entries. Only bail out if there
is no valid entry at all.

---
--- linux-3.3.3/drivers/acpi/processor_perflib.c.orig   2012-04-24
22:18:23.288041268 +0200
+++ linux-3.3.3/drivers/acpi/processor_perflib.c        2012-04-24
22:19:25.912042603 +0200
@@ -311,6 +311,7 @@ static int acpi_processor_get_performanc
       struct acpi_buffer state = { 0, NULL };
       union acpi_object *pss = NULL;
       int i;
+       int last_invalid = -1;


       status = acpi_evaluate_object(pr->handle, "_PSS", NULL, &buffer);
@@ -374,12 +375,30 @@ static int acpi_processor_get_performanc
                       printk(KERN_ERR FW_BUG PREFIX
                              "Invalid BIOS _PSS frequency: 0x%llx MHz\n",
                              px->core_frequency);
-                       result = -EFAULT;
-                       kfree(pr->performance->states);
-                       goto end;
+                       if (-1 == last_invalid)
+                               last_invalid = i;
+               } else {
+                       if (last_invalid != -1) {
+                               /*
+                                * Copy this valid entry over last_invalid entry
+                                */
+                               memcpy(&(pr->performance->states[last_invalid]),
+                                      px, sizeof(struct acpi_processor_px));
+                               ++last_invalid;
+                       }
               }
       }

+       if (0 == last_invalid) {
+               printk(KERN_ERR FW_BUG PREFIX
+                      "No valid BIOS _PSS frequency found\n");
+               result = -EFAULT;
+               kfree(pr->performance->states);
+       }
+
+       if (last_invalid > 0)
+               pr->performance->state_count = last_invalid;
+
      end:
       kfree(buffer.pointer);
