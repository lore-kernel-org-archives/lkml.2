Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab1BNSHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:07:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:45603 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab1BNSHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:07:18 -0500
Date: Mon, 14 Feb 2011 13:55:08 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4D5240A9.4080703@kernel.org>
References: <4D5240A9.4080703@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Fix and clean up generic_processor_info()
Message-ID: <tip-e5fea868e6c04343e501176a373d568c1c0094aa@git.kernel.org>
Git-Commit-ID: e5fea868e6c04343e501176a373d568c1c0094aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Feb 2011 18:06:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5fea868e6c04343e501176a373d568c1c0094aa
Gitweb:     http://git.kernel.org/tip/e5fea868e6c04343e501176a373d568c1c0094aa
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 8 Feb 2011 23:22:17 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Feb 2011 13:23:51 +0100

x86: Fix and clean up generic_processor_info()

One of the error printouts in generic_processor_info() prints out
the APIC version instead of the cpu index the warning text describes.

Move version validation down, after we get the right cpu index.

-v2: add comments about reason why we can have cpu=0 there.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4D5240A9.4080703@kernel.org>
[ Cleaned up and made the BIOS bug printouts more consistent ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/apic.c |   39 ++++++++++++++++++++-------------------
 1 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 06c196d..628dcdb 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1925,17 +1925,6 @@ void __cpuinit generic_processor_info(int apicid, int version)
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
@@ -1949,22 +1938,34 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	}
 
 	num_processors++;
-	cpu = cpumask_next_zero(-1, cpu_present_mask);
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
 		 * in same order as logical cpu numbers. Hence the first
 		 * entry is BSP, and so on.
+		 * boot_cpu_init() already hold bit 0 in cpu_present_mask
+		 * for BSP.
 		 */
 		cpu = 0;
+	} else
+		cpu = cpumask_next_zero(-1, cpu_present_mask);
+
+	/*
+	 * Validate version
+	 */
+	if (version == 0x0) {
+		pr_warning("BIOS bug: APIC version is 0 for CPU %d/0x%x, fixing up to 0x10\n",
+			   cpu, apicid);
+		version = 0x10;
 	}
+	apic_version[apicid] = version;
+
+	if (version != apic_version[boot_cpu_physical_apicid]) {
+		pr_warning("BIOS bug: APIC version mismatch, boot CPU: %x, CPU %d: version %x\n",
+			apic_version[boot_cpu_physical_apicid], cpu, version);
+	}
+
+	physid_set(apicid, phys_cpu_present_map);
 	if (apicid > max_physical_apicid)
 		max_physical_apicid = apicid;
 
