Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab0E1GEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 02:04:36 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:18095 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759521Ab0E1GDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 02:03:46 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 4/8] ACPI: allow a native cpuidle driver to displace ACPI
Date: Fri, 28 May 2010 02:01:57 -0400
Message-id: <541adf7cd937b3895c7645406a9b060504df453b.1275026041.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-reply-to: <1275026521-30835-1-git-send-email-lenb@kernel.org>
References: <1275026521-30835-1-git-send-email-lenb@kernel.org>
In-reply-to: <6b2c676bf32be91f43215d5874c07c1becaba013.1275026041.git.len.brown@intel.com>
References: <6b2c676bf32be91f43215d5874c07c1becaba013.1275026041.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

The ACPI driver would fail probe when it found that
another driver had previously registered with cpuidle.

But this is a natural situation, as a native hardware
cpuidle driver should be able to bind instead of ACPI,
and the ACPI processor driver should be able to handle
yielding control of C-states while still handling
P-states and T-states.

Add a KERN_DEBUG line showing when acpi_idle
does successfully register.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_driver.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 5675d97..deefa85 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -616,7 +616,8 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 	acpi_processor_get_limit_info(pr);
 
 
-	acpi_processor_power_init(pr, device);
+	if (cpuidle_get_driver() == &acpi_idle_driver)
+		acpi_processor_power_init(pr, device);
 
 	pr->cdev = thermal_cooling_device_register("Processor", device,
 						&processor_cooling_ops);
@@ -920,9 +921,10 @@ static int __init acpi_processor_init(void)
 	if (!acpi_processor_dir)
 		return -ENOMEM;
 #endif
-	result = cpuidle_register_driver(&acpi_idle_driver);
-	if (result < 0)
-		goto out_proc;
+
+	if (!cpuidle_register_driver(&acpi_idle_driver))
+		printk(KERN_DEBUG "ACPI: %s registered with cpuidle\n",
+			acpi_idle_driver.name);
 
 	result = acpi_bus_register_driver(&acpi_processor_driver);
 	if (result < 0)
@@ -941,7 +943,6 @@ static int __init acpi_processor_init(void)
 out_cpuidle:
 	cpuidle_unregister_driver(&acpi_idle_driver);
 
-out_proc:
 #ifdef CONFIG_ACPI_PROCFS
 	remove_proc_entry(ACPI_PROCESSOR_CLASS, acpi_root_dir);
 #endif
-- 
1.6.0.6

