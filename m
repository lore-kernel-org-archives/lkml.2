Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab1LHAnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:43:24 -0500
Received: from mga03.intel.com ([143.182.124.21]:18938 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874Ab1LHAlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:41:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="45021401"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: kay.sievers@vrfy.org, trenn@suse.de, Andi Kleen <ak@linux.intel.com>,
        lenb@kernel.org
Subject: [PATCH 04/10] ACPI: Load acpi-cpufreq from processor driver automatically
Date: Wed,  7 Dec 2011 16:41:17 -0800
Message-Id: <1323304882-27953-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The only left over hole in automatic cpufreq driver loading was the loading
of ACPI cpufreq. This driver should be loaded when ACPI supports a _PDC
method and the CPU vendor wants to use acpi cpufreq.

Simply add a request module call to the acpi processor core driver
when this is true. This seems like the simplest solution for this.

Cc: lenb@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/acpi/processor_driver.c  |    1 +
 drivers/acpi/processor_perflib.c |   22 ++++++++++++++++++++++
 include/acpi/processor.h         |    1 +
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 9d7bc9f..9e933ed 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -499,6 +499,7 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 
 #ifdef CONFIG_CPU_FREQ
 	acpi_processor_ppc_has_changed(pr, 0);
+	acpi_processor_load_module(pr);
 #endif
 	acpi_processor_get_throttling_info(pr);
 	acpi_processor_get_limit_info(pr);
diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 85b3237..a533512 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -240,6 +240,28 @@ void acpi_processor_ppc_exit(void)
 	acpi_processor_ppc_status &= ~PPC_REGISTERED;
 }
 
+/* 
+ * Do a quick check if the systems looks like it should use ACPI 
+ * cpufreq. We look at a _PCT method being available, but don't
+ * do a whole lot of sanity checks. 
+ */
+void acpi_processor_load_module(struct acpi_processor *pr)
+{
+	static int requested;
+	acpi_status status = 0;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+
+	if (!arch_has_acpi_pdc() || requested)
+		return;
+	status = acpi_evaluate_object(pr->handle, "_PCT", NULL, &buffer);
+	if (!ACPI_FAILURE(status)) {
+		printk(KERN_INFO PREFIX "Requesting acpi_cpufreq\n");
+		request_module_nowait("acpi_cpufreq");
+		requested = 1;
+	}
+	kfree(buffer.pointer);
+}
+
 static int acpi_processor_get_performance_control(struct acpi_processor *pr)
 {
 	int result = 0;
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 610f6fb..da57fdc 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -224,6 +224,7 @@ struct acpi_processor_errata {
 	} piix4;
 };
 
+extern void acpi_processor_load_module(struct acpi_processor *pr);
 extern int acpi_processor_preregister_performance(struct
 						  acpi_processor_performance
 						  __percpu *performance);
-- 
1.7.4.4

