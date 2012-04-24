Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab2DXUfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 16:35:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36301 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab2DXUfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 16:35:09 -0400
MIME-Version: 1.0
Date: Tue, 24 Apr 2012 22:35:08 +0200
X-Google-Sender-Auth: DXEYj8ZAbW0b5UU8rufi3c7ZIcE
Message-ID: <CAEe-dwgnLDzO_r4FAL4=6oggOQ8M2sPJYTERKwF6M2jR31uRUg@mail.gmail.com>
Subject: [RFC PATCH 001/001] ACPI: Ignore invalid _PSS entries, but use valid ones
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
table. Instead of
bailing out when the first non-initialized entry is found, ignore it
and use only  the
valid entries. Only bail out if there is no valid entry at all.

---
--- linux-3.3.3/drivers/acpi/processor_perflib.c.orig	2012-04-24
22:18:23.288041268 +0200
+++ linux-3.3.3/drivers/acpi/processor_perflib.c	2012-04-24
22:19:25.912042603 +0200
@@ -311,6 +311,7 @@ static int acpi_processor_get_performanc
 	struct acpi_buffer state = { 0, NULL };
 	union acpi_object *pss = NULL;
 	int i;
+	int last_invalid = -1;


 	status = acpi_evaluate_object(pr->handle, "_PSS", NULL, &buffer);
@@ -374,12 +375,30 @@ static int acpi_processor_get_performanc
 			printk(KERN_ERR FW_BUG PREFIX
 			       "Invalid BIOS _PSS frequency: 0x%llx MHz\n",
 			       px->core_frequency);
-			result = -EFAULT;
-			kfree(pr->performance->states);
-			goto end;
+			if (-1 == last_invalid)
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

+	if (0 == last_invalid) {
+		printk(KERN_ERR FW_BUG PREFIX
+		       "No valid BIOS _PSS frequency found\n");
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
I tested this change on my notebook, using the debian source 3.2.12,
but there where no changes in this file from that version to the
3.3.3.
Result from cpufreq-info after the patch:

cpufrequtils 007: cpufreq-info (C) Dominik Brodowski 2004-2009
Report errors and bugs to cpufreq@vger.kernel.org, please.
analyzing CPU 0:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0 1 2 3 4 5 6 7
  CPUs which need to have their frequency coordinated by software: 0
  maximum transition latency: 10.0 us.
  hardware limits: 800 MHz - 2.20 GHz
  available frequency steps: 2.20 GHz, 2.20 GHz, 2.10 GHz, 2.00 GHz,
1.90 GHz, 1.80 GHz, 1.70 GHz, 1.60 GHz, 1.50 GHz, 1.40 GHz, 1.30 GHz,
1.20 GHz, 1.10 GHz, 1000 MHz, 900 MHz, 800 MHz
  available cpufreq governors: powersave, conservative, userspace,
ondemand, performance
  current policy: frequency should be within 800 MHz and 2.20 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz.
  cpufreq stats: 2.20 GHz:1.62%, 2.20 GHz:3.28%, 2.10 GHz:0.04%, 2.00
GHz:0.09%, 1.90 GHz:0.07%, 1.80 GHz:0.06%, 1.70 GHz:0.04%, 1.60
GHz:0.10%, 1.50 GHz:0.13%, 1.40 GHz:0.11%, 1.30 GHz:0.18%, 1.20
GHz:0.13%, 1.10 GHz:0.15%, 1000 MHz:0.13%, 900 MHz:0.16%, 800
MHz:93.70%  (11691)
analyzing CPU 1:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0 1 2 3 4 5 6 7
  CPUs which need to have their frequency coordinated by software: 1
  maximum transition latency: 10.0 us.
  hardware limits: 800 MHz - 2.20 GHz
  available frequency steps: 2.20 GHz, 2.20 GHz, 2.10 GHz, 2.00 GHz,
1.90 GHz, 1.80 GHz, 1.70 GHz, 1.60 GHz, 1.50 GHz, 1.40 GHz, 1.30 GHz,
1.20 GHz, 1.10 GHz, 1000 MHz, 900 MHz, 800 MHz
  available cpufreq governors: powersave, conservative, userspace,
ondemand, performance
  current policy: frequency should be within 800 MHz and 2.20 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz.
  cpufreq stats: 2.20 GHz:3.97%, 2.20 GHz:0.12%, 2.10 GHz:0.00%, 2.00
GHz:0.00%, 1.90 GHz:0.00%, 1.80 GHz:0.02%, 1.70 GHz:0.00%, 1.60
GHz:0.01%, 1.50 GHz:0.02%, 1.40 GHz:0.04%, 1.30 GHz:0.03%, 1.20
GHz:0.05%, 1.10 GHz:0.12%, 1000 MHz:0.06%, 900 MHz:0.03%, 800
MHz:95.53%  (530)
analyzing CPU 2:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0 1 2 3 4 5 6 7
  CPUs which need to have their frequency coordinated by software: 2
  maximum transition latency: 10.0 us.
  hardware limits: 800 MHz - 2.20 GHz
  available frequency steps: 2.20 GHz, 2.20 GHz, 2.10 GHz, 2.00 GHz,
1.90 GHz, 1.80 GHz, 1.70 GHz, 1.60 GHz, 1.50 GHz, 1.40 GHz, 1.30 GHz,
1.20 GHz, 1.10 GHz, 1000 MHz, 900 MHz, 800 MHz
  available cpufreq governors: powersave, conservative, userspace,
ondemand, performance
  current policy: frequency should be within 800 MHz and 2.20 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz.
  cpufreq stats: 2.20 GHz:5.85%, 2.20 GHz:0.12%, 2.10 GHz:0.00%, 2.00
GHz:0.03%, 1.90 GHz:0.02%, 1.80 GHz:0.05%, 1.70 GHz:0.04%, 1.60
GHz:0.04%, 1.50 GHz:0.04%, 1.40 GHz:0.12%, 1.30 GHz:0.09%, 1.20
GHz:0.19%, 1.10 GHz:0.13%, 1000 MHz:0.11%, 900 MHz:0.08%, 800
MHz:93.10%  (2971)
analyzing CPU 3:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0 1 2 3 4 5 6 7
  CPUs which need to have their frequency coordinated by software: 3
  maximum transition latency: 10.0 us.
  hardware limits: 800 MHz - 2.20 GHz
  available frequency steps: 2.20 GHz, 2.20 GHz, 2.10 GHz, 2.00 GHz,
1.90 GHz, 1.80 GHz, 1.70 GHz, 1.60 GHz, 1.50 GHz, 1.40 GHz, 1.30 GHz,
1.20 GHz, 1.10 GHz, 1000 MHz, 900 MHz, 800 MHz
  available cpufreq governors: powersave, conservative, userspace,
ondemand, performance
  current policy: frequency should be within 800 MHz and 2.20 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz.
  cpufreq stats: 2.20 GHz:3.24%, 2.20 GHz:0.11%, 2.10 GHz:0.00%, 2.00
GHz:0.00%, 1.90 GHz:0.00%, 1.80 GHz:0.02%, 1.70 GHz:0.00%, 1.60
GHz:0.00%, 1.50 GHz:0.00%, 1.40 GHz:0.00%, 1.30 GHz:0.01%, 1.20
GHz:0.02%, 1.10 GHz:0.00%, 1000 MHz:0.01%, 900 MHz:0.01%, 800
MHz:96.57%  (368)
analyzing CPU 4:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0 1 2 3 4 5 6 7
  CPUs which need to have their frequency coordinated by software: 4
  maximum transition latency: 10.0 us.
  hardware limits: 800 MHz - 2.20 GHz
  available frequency steps: 2.20 GHz, 2.20 GHz, 2.10 GHz, 2.00 GHz,
1.90 GHz, 1.80 GHz, 1.70 GHz, 1.60 GHz, 1.50 GHz, 1.40 GHz, 1.30 GHz,
1.20 GHz, 1.10 GHz, 1000 MHz, 900 MHz, 800 MHz
  available cpufreq governors: powersave, conservative, userspace,
ondemand, performance
  current policy: frequency should be within 800 MHz and 2.20 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz.
  cpufreq stats: 2.20 GHz:7.67%, 2.20 GHz:0.12%, 2.10 GHz:0.01%, 2.00
GHz:0.04%, 1.90 GHz:0.03%, 1.80 GHz:0.02%, 1.70 GHz:0.03%, 1.60
GHz:0.07%, 1.50 GHz:0.04%, 1.40 GHz:0.06%, 1.30 GHz:0.16%, 1.20
GHz:0.26%, 1.10 GHz:0.08%, 1000 MHz:0.05%, 900 MHz:0.13%, 800
MHz:91.25%  (2605)
analyzing CPU 5:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0 1 2 3 4 5 6 7
  CPUs which need to have their frequency coordinated by software: 5
  maximum transition latency: 10.0 us.
  hardware limits: 800 MHz - 2.20 GHz
  available frequency steps: 2.20 GHz, 2.20 GHz, 2.10 GHz, 2.00 GHz,
1.90 GHz, 1.80 GHz, 1.70 GHz, 1.60 GHz, 1.50 GHz, 1.40 GHz, 1.30 GHz,
1.20 GHz, 1.10 GHz, 1000 MHz, 900 MHz, 800 MHz
  available cpufreq governors: powersave, conservative, userspace,
ondemand, performance
  current policy: frequency should be within 800 MHz and 2.20 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz.
  cpufreq stats: 2.20 GHz:0.96%, 2.20 GHz:0.11%, 2.10 GHz:0.00%, 2.00
GHz:0.00%, 1.90 GHz:0.00%, 1.80 GHz:0.00%, 1.70 GHz:0.00%, 1.60
GHz:0.00%, 1.50 GHz:0.00%, 1.40 GHz:0.01%, 1.30 GHz:0.01%, 1.20
GHz:0.01%, 1.10 GHz:0.01%, 1000 MHz:0.01%, 900 MHz:0.00%, 800
MHz:98.86%  (273)
analyzing CPU 6:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0 1 2 3 4 5 6 7
  CPUs which need to have their frequency coordinated by software: 6
  maximum transition latency: 10.0 us.
  hardware limits: 800 MHz - 2.20 GHz
  available frequency steps: 2.20 GHz, 2.20 GHz, 2.10 GHz, 2.00 GHz,
1.90 GHz, 1.80 GHz, 1.70 GHz, 1.60 GHz, 1.50 GHz, 1.40 GHz, 1.30 GHz,
1.20 GHz, 1.10 GHz, 1000 MHz, 900 MHz, 800 MHz
  available cpufreq governors: powersave, conservative, userspace,
ondemand, performance
  current policy: frequency should be within 800 MHz and 2.20 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz.
  cpufreq stats: 2.20 GHz:9.34%, 2.20 GHz:0.11%, 2.10 GHz:0.03%, 2.00
GHz:0.09%, 1.90 GHz:0.01%, 1.80 GHz:0.10%, 1.70 GHz:0.04%, 1.60
GHz:0.02%, 1.50 GHz:0.02%, 1.40 GHz:0.01%, 1.30 GHz:0.05%, 1.20
GHz:0.13%, 1.10 GHz:0.16%, 1000 MHz:0.07%, 900 MHz:0.12%, 800
MHz:89.69%  (2883)
analyzing CPU 7:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0 1 2 3 4 5 6 7
  CPUs which need to have their frequency coordinated by software: 7
  maximum transition latency: 10.0 us.
  hardware limits: 800 MHz - 2.20 GHz
  available frequency steps: 2.20 GHz, 2.20 GHz, 2.10 GHz, 2.00 GHz,
1.90 GHz, 1.80 GHz, 1.70 GHz, 1.60 GHz, 1.50 GHz, 1.40 GHz, 1.30 GHz,
1.20 GHz, 1.10 GHz, 1000 MHz, 900 MHz, 800 MHz
  available cpufreq governors: powersave, conservative, userspace,
ondemand, performance
  current policy: frequency should be within 800 MHz and 2.20 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz.
  cpufreq stats: 2.20 GHz:4.60%, 2.20 GHz:0.11%, 2.10 GHz:0.00%, 2.00
GHz:0.00%, 1.90 GHz:0.00%, 1.80 GHz:0.01%, 1.70 GHz:0.00%, 1.60
GHz:0.00%, 1.50 GHz:0.00%, 1.40 GHz:0.00%, 1.30 GHz:0.00%, 1.20
GHz:0.00%, 1.10 GHz:0.01%, 1000 MHz:0.01%, 900 MHz:0.03%, 800
MHz:95.22%  (502)
