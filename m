Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab1BCJvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 04:51:37 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:55559 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab1BCJvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 04:51:36 -0500
Message-ID: <4D4A7A82.8020402@kernel.org>
Date: Thu, 03 Feb 2011 01:50:58 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Cleanup generic_processor_info()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D4A7A98.0002,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Found version print out pass version instead of cpu index, if the version is
not valid.

Move version validation down after We get right cpu index.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/apic.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -1947,17 +1947,6 @@ void __cpuinit generic_processor_info(in
 {
 	int cpu;
 
-	/*
-	 * Validate version
-	 */
-	if (version == 0x0) {
-		pr_warning("BIOS bug, APIC version is 0 for CPU#%d! "
-			   "fixing up to 0x10. (tell your hw vendor)\n",
-				version);
-		version = 0x10;
-	}
-	apic_version[apicid] = version;
-
 	if (num_processors >= nr_cpu_ids) {
 		int max = nr_cpu_ids;
 		int thiscpu = max + disabled_cpus;
@@ -1972,13 +1961,6 @@ void __cpuinit generic_processor_info(in
 
 	num_processors++;
 	cpu = cpumask_next_zero(-1, cpu_present_mask);
-
-	if (version != apic_version[boot_cpu_physical_apicid])
-		WARN_ONCE(1,
-			"ACPI: apic version mismatch, bootcpu: %x cpu %d: %x\n",
-			apic_version[boot_cpu_physical_apicid], cpu, version);
-
-	physid_set(apicid, phys_cpu_present_map);
 	if (apicid == boot_cpu_physical_apicid) {
 		/*
 		 * x86_bios_cpu_apicid is required to have processors listed
@@ -1987,6 +1969,24 @@ void __cpuinit generic_processor_info(in
 		 */
 		cpu = 0;
 	}
+
+	/*
+	 * Validate version
+	 */
+	if (version == 0x0) {
+		pr_warning("BIOS bug, APIC version is 0 for Processor %d/0x%x "
+			   "fixing up to 0x10. (tell your hw vendor)\n",
+				cpu, apicid);
+		version = 0x10;
+	}
+	apic_version[apicid] = version;
+
+	if (version != apic_version[boot_cpu_physical_apicid])
+		WARN_ONCE(1,
+			"ACPI: apic version mismatch, bootcpu: %x cpu %d: %x\n",
+			apic_version[boot_cpu_physical_apicid], cpu, version);
+
+	physid_set(apicid, phys_cpu_present_map);
 	if (apicid > max_physical_apicid)
 		max_physical_apicid = apicid;
 
