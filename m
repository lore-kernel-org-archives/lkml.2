Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1LTB2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:28:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49780 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1LTB2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:28:14 -0500
Date: Mon, 19 Dec 2011 17:28:04 -0800
From: tip-bot for Andi Kleen <ak@linux.intel.com>
Message-ID: <tip-848fd8ee1881650226f11113e17b0118a792e12f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1324338394-4670-5-git-send-email-andi@firstfloor.org>
References: <1324338394-4670-5-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/autoprobe] x86, acpi:
  Load acpi-cpufreq from processor driver automatically
Git-Commit-ID: 848fd8ee1881650226f11113e17b0118a792e12f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Dec 2011 17:28:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  848fd8ee1881650226f11113e17b0118a792e12f
Gitweb:     http://git.kernel.org/tip/848fd8ee1881650226f11113e17b0118a792e12f
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 19 Dec 2011 15:46:30 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 19 Dec 2011 15:49:43 -0800

x86, acpi: Load acpi-cpufreq from processor driver automatically

The only left over hole in automatic cpufreq driver loading was the loading
of ACPI cpufreq. This driver should be loaded when ACPI supports a _PDC
method and the CPU vendor wants to use acpi cpufreq.

Simply add a request module call to the acpi processor core driver
when this is true. This seems like the simplest solution for this.

Cc: lenb@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1324338394-4670-5-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
index 85b3237..0af48a8 100644
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
