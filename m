Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab1FQTwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 15:52:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932986Ab1FQTvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 15:51:21 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: borislav.petkov@amd.com, davej@redhat.com, mark.langsdorf@amd.com,
        cpufreq@vger.kernel.org, andreas.herrmann3@amd.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V2 4/6] ACPI: Add fixups for AMD P-state figures
Date: Fri, 17 Jun 2011 15:50:55 -0400
Message-Id: <1308340257-10117-4-git-send-email-mjg@redhat.com>
In-Reply-To: <1308340257-10117-1-git-send-email-mjg@redhat.com>
References: <1308340257-10117-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:8a9f:faff:fefa:2632
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some AMD systems may round the frequencies in ACPI tables to 100MHz
boundaries. We can obtain the real frequencies from MSRs, so add a quirk
to fix these frequencies up on AMD systems.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/processor_perflib.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 85b3237..9e18173 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -302,6 +302,34 @@ static int acpi_processor_get_performance_control(struct acpi_processor *pr)
 	return result;
 }
 
+#ifdef CONFIG_X86
+/*
+ * Some AMDs have 50MHz frequency multiples, but only provide 100MHz rounding
+ * in their ACPI data. Calculate the real values and fix up the _PSS data.
+ */
+static void amd_fixup_frequency(struct acpi_processor_px *px, int i)
+{
+	u32 hi, lo, fid, did;
+	int index = px->control & 0x00000007;
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
+		return;
+
+	if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
+	    || boot_cpu_data.x86 == 0x11) {
+		rdmsr(0xc0010064 + index, lo, hi);
+		fid = lo & 0x3f;
+		did = (lo >> 6) & 7;
+		if (boot_cpu_data.x86 == 0x10)
+			px->core_frequency = (100 * (fid + 0x10)) >> did;
+		else
+			px->core_frequency = (100 * (fid + 8)) >> did;
+	}
+}
+#else
+static void amd_fixup_frequency(struct acpi_processor_px *px, int i) {};
+#endif
+
 static int acpi_processor_get_performance_states(struct acpi_processor *pr)
 {
 	int result = 0;
@@ -356,6 +384,8 @@ static int acpi_processor_get_performance_states(struct acpi_processor *pr)
 			goto end;
 		}
 
+		amd_fixup_frequency(px, i);
+
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "State [%d]: core_frequency[%d] power[%d] transition_latency[%d] bus_master_latency[%d] control[0x%x] status[0x%x]\n",
 				  i,
-- 
1.7.5.2

