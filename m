Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab2GZM3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 08:29:11 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:56478
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751977Ab2GZM3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 08:29:00 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M7RPC5-02-2A2-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: <cpufreq@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Matthew Garrett <mjg@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Renninger <trenn@suse.de>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH 4/8] ACPI: Add fixups for AMD P-state figures
Date: Thu, 26 Jul 2012 14:28:40 +0200
Message-ID: <1343305724-2809-5-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1343305724-2809-1-git-send-email-andre.przywara@amd.com>
References: <1343305724-2809-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

Some AMD systems may round the frequencies in ACPI tables to 100MHz
boundaries. We can obtain the real frequencies from MSRs, so add a quirk
to fix these frequencies up on AMD systems.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andre Przywara <andre.przywara@amd.com>
---
 arch/x86/include/asm/msr-index.h |    1 +
 drivers/acpi/processor_perflib.c |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1e1f3eb..fbee971 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -248,6 +248,7 @@
 
 #define MSR_IA32_PERF_STATUS		0x00000198
 #define MSR_IA32_PERF_CTL		0x00000199
+#define MSR_AMD_PSTATE_DEF_BASE		0xc0010064
 #define MSR_AMD_PERF_STATUS		0xc0010063
 #define MSR_AMD_PERF_CTL		0xc0010062
 
diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index a093dc1..836bfe0 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -324,6 +324,34 @@ static int acpi_processor_get_performance_control(struct acpi_processor *pr)
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
+		rdmsr(MSR_AMD_PSTATE_DEF_BASE + index, lo, hi);
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
@@ -379,6 +407,8 @@ static int acpi_processor_get_performance_states(struct acpi_processor *pr)
 			goto end;
 		}
 
+		amd_fixup_frequency(px, i);
+
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "State [%d]: core_frequency[%d] power[%d] transition_latency[%d] bus_master_latency[%d] control[0x%x] status[0x%x]\n",
 				  i,
-- 
1.7.4.4


