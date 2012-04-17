Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab2DQLfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:35:16 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:42361 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab2DQLfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:35:14 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
Organization: ScaleMP Ltd.
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: [PATCH] x86, amd: Probe CPUs by APICID instead of initial APICID
Date: Tue, 17 Apr 2012 13:06:36 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.32-40-generic; KDE/4.4.5; i686; ; )
Cc: andreas.herrmann3@amd.com, borislav.petkov@amd.com,
        Ravikiran.Thirumalai@amd.com,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204171306.37426.vlad@scalemp.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shai Fultheim <shai@scalemp.com>

Make AMD identify processors using APICID (32 bit) rather than the initial 
APICID (8 bit).  This is critical to make sure the last level cache (llc), 
which is used for sibling detection, will be different between boards - on 
aggregated systems with more than 8 processors.


Signed-off-by: Shai Fultheim <shai@scalemp.com>
Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
---
 arch/x86/kernel/cpu/amd.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 0bab2b1..33d9502 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -277,7 +277,7 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 
 		cpuid(0x8000001e, &eax, &ebx, &ecx, &edx);
 		nodes = ((ecx >> 8) & 7) + 1;
-		node_id = ecx & 7;
+		node_id = (ecx & 7) + (c->phys_proc_id << 3);
 
 		/* get compute unit information */
 		smp_num_siblings = ((ebx >> 8) & 3) + 1;
@@ -288,7 +288,7 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 
 		rdmsrl(MSR_FAM10H_NODE_ID, value);
 		nodes = ((value >> 3) & 7) + 1;
-		node_id = value & 7;
+		node_id = (value & 7) + (c->phys_proc_id << 3);
 	} else
 		return;
 
@@ -323,9 +323,9 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 
 	bits = c->x86_coreid_bits;
 	/* Low order bits define the core id (index of core in socket) */
-	c->cpu_core_id = c->initial_apicid & ((1 << bits)-1);
-	/* Convert the initial APIC ID into the socket ID */
-	c->phys_proc_id = c->initial_apicid >> bits;
+	c->cpu_core_id = c->apicid & ((1 << bits)-1);
+	/* Convert the APIC ID into the socket ID */
+	c->phys_proc_id = c->apicid >> bits;
 	/* use socket ID also for last level cache */
 	per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
 	amd_get_topology(c);
-- 
1.7.7.6

