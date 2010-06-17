Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab0FQPJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 11:09:05 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54122 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab0FQPJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 11:09:03 -0400
Date: Thu, 17 Jun 2010 09:08:54 -0600
From: Alex Chiang <achiang@canonical.com>
To: lenb@kernel.org, Jan Pogadl <pogadl.jan@googlemail.com>
Cc: gong.chen@linux.intel.com, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI: processor: fix processor_physically_present on UP
Message-ID: <20100617150853.GF2138@canonical.com>
Mail-Followup-To: Alex Chiang <achiang@canonical.com>, lenb@kernel.org,
	Jan Pogadl <pogadl.jan@googlemail.com>, gong.chen@linux.intel.com,
	linux-acpi@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 5d554a7bb06 (ACPI: processor: add internal
processor_physically_present()) is broken on uniprocessor (UP)
configurations, as acpi_get_cpuid() will always return -1.

We use the value of num_possible_cpus() to tell us whether we got
an invalid cpuid from acpi_get_cpuid() in the SMP case, or if
instead, we are UP, in which case num_possible_cpus() is #defined
as 1.

We use num_possible_cpus() instead of num_online_cpus() to
protect ourselves against the scenario of CPU hotplug, and we've
taken down all the CPUs except one.

Thanks to Jan Pogadl for initial report and analysis and Chen
Gong for review.

Reported-by: Jan Pogadl <pogadl.jan@googlemail.com>:
Cc: Chen Gong <gong.chen@linux.intel.com>
Signed-off-by: Alex Chiang <achiang@canonical.com>
---
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 5128435..e9699aa 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -223,7 +223,7 @@ static bool processor_physically_present(acpi_handle handle)
 	type = (acpi_type == ACPI_TYPE_DEVICE) ? 1 : 0;
 	cpuid = acpi_get_cpuid(handle, type, acpi_id);
 
-	if (cpuid == -1)
+	if ((cpuid == -1) && (num_possible_cpus() > 1))
 		return false;
 
 	return true;
