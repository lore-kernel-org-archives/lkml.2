Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab2EDPZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 11:25:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50917 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab2EDPZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 11:25:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAEe-dwg5pG2aDHopeHA2yiACUjS3cba5Vm1GyOaM4y=gpvpmMQ@mail.gmail.com>
References: <CAEe-dwgCR55urie0c1MdBWTS6-E=3faXj68=WMcb6NvQCQX0rg@mail.gmail.com>
	<20120504135217.GB1049@phenom.dumpdata.com>
	<CAEe-dwj4JP-U0tc3wpmHvzv=aQU5zy3cG_E9FrriPw_sdfg2bg@mail.gmail.com>
	<CAEe-dwg5pG2aDHopeHA2yiACUjS3cba5Vm1GyOaM4y=gpvpmMQ@mail.gmail.com>
Date: Fri, 4 May 2012 17:25:13 +0200
X-Google-Sender-Auth: m3jWYlx32EDZ1c8tv_THbqdbtHA
Message-ID: <CAEe-dwjVsqn-XyXfhRacEF5gh_5GCX_MeNafPkSGFu_eeA3Pfw@mail.gmail.com>
Subject: [RFC][PATCH v2] ACPI: Ignore invalid _PSS entries, but use valid ones
From: Marco Aurelio da Costa <costa@gamic.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Aurelio da Costa <costa@gamic.com>
[v2: Fixes suggested by Konrad]
Signed-off-by: Marco Aurelio da Costa <costa@gamic.com>

The EliteBook 8560W has non-initialized entries in its _PSS ACPI
table. Instead of bailing out when the first non-initialized entry is
found, ignore it and use only  the valid entries. Only bail out if there
is no valid entry at all.

---
--- linux-3.3.3/drivers/acpi/processor_perflib.c.orig	2012-04-24
22:18:23.288041268 +0200
+++ linux-3.3.3/drivers/acpi/processor_perflib.c	2012-05-04
17:22:57.400034613 +0200
@@ -311,6 +311,7 @@ static int acpi_processor_get_performanc
 	struct acpi_buffer state = { 0, NULL };
 	union acpi_object *pss = NULL;
 	int i;
+	int last_invalid = -1;


 	status = acpi_evaluate_object(pr->handle, "_PSS", NULL, &buffer);
@@ -372,14 +373,32 @@ static int acpi_processor_get_performanc
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
+			if (last_invalidi == -1)
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
+	}
+
+	if (last_invalid > 0)
+		pr->performance->state_count = last_invalid;
+
       end:
 	kfree(buffer.pointer);

-- 
Marco Costa
Customer Support
--
GAMIC mbH
Roermonder Strasse, 151
52072 Aachen
Germany
