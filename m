Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab2EDOKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 10:10:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39810 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332Ab2EDOKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 10:10:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/4] xen/apic: Return the APIC ID (and version) for CPU 0.
Date: Fri,  4 May 2012 10:04:25 -0400
Message-Id: <1336140267-7399-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1336140267-7399-1-git-send-email-konrad.wilk@oracle.com>
References: <1336140267-7399-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_64 on AMD machines where the first APIC_ID is not zero, we get:

ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
BIOS bug: APIC version is 0 for CPU 1/0x10, fixing up to 0x10
BIOS bug: APIC version mismatch, boot CPU: 0, CPU 1: version 10

which means that when the ACPI processor driver loads and
tries to parse the _Pxx states it fails to do as, as it
ends up calling acpi_get_cpuid which does this:

for_each_possible_cpu(i) {
        if (cpu_physical_id(i) == apic_id)
                return i;
}

And the bootup CPU, has not been found so it fails and returns -1
for the first CPU - which then subsequently in the loop that
"acpi_processor_get_info" does results in returning an error, which
means that "acpi_processor_add" failing and per_cpu(processor)
is never set (and is NULL).

That means that when xen-acpi-processor tries to load (much much
later on) and parse the P-states it gets -ENODEV from
acpi_processor_register_performance() (which tries to read
the per_cpu(processor)) and fails to parse the data.

Reported-by-and-Tested-by:  Stefan Bader <stefan.bader@canonical.com>
Suggested-by:  Boris Ostrovsky <boris.ostrovsky@amd.com>
[v2: Bit-shift APIC ID by 24 bits]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |   35 ++++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index a8f8844..4f437de 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -809,9 +809,40 @@ static void xen_io_delay(void)
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
+static unsigned long xen_set_apic_id(unsigned int x)
+{
+	WARN_ON(1);
+	return x;
+}
+static unsigned int xen_get_apic_id(unsigned long x)
+{
+	return ((x)>>24) & 0xFFu;
+}
 static u32 xen_apic_read(u32 reg)
 {
-	return 0;
+	struct xen_platform_op op = {
+		.cmd = XENPF_get_cpuinfo,
+		.interface_version = XENPF_INTERFACE_VERSION,
+		.u.pcpu_info.xen_cpuid = 0,
+	};
+	int ret = 0;
+
+	/* Shouldn't need this as APIC is turned off for PV, and we only
+	 * get called on the bootup processor. But just in case. */
+	if (!xen_initial_domain() || smp_processor_id())
+		return 0;
+
+	if (reg == APIC_LVR)
+		return 0x10;
+
+	if (reg != APIC_ID)
+		return 0;
+
+	ret = HYPERVISOR_dom0_op(&op);
+	if (ret)
+		return 0;
+
+	return op.u.pcpu_info.apic_id << 24;
 }
 
 static void xen_apic_write(u32 reg, u32 val)
@@ -849,6 +880,8 @@ static void set_xen_basic_apic_ops(void)
 	apic->icr_write = xen_apic_icr_write;
 	apic->wait_icr_idle = xen_apic_wait_icr_idle;
 	apic->safe_wait_icr_idle = xen_safe_apic_wait_icr_idle;
+	apic->set_apic_id = xen_set_apic_id;
+	apic->get_apic_id = xen_get_apic_id;
 }
 
 #endif
-- 
1.7.7.5

