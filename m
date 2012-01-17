Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2AQM02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:26:28 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:43854 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab2AQMWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:20 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Kurt Garloff <kurt@garloff.de>, Len Brown <len.brown@intel.com>
Subject: [PATCH 38/50] ACPI, ia64: Use SRAT table rev to use 8bit or 16/32bit
 PXM fields (ia64)
Date: Tue, 17 Jan 2012 07:21:30 -0500
Message-id: <9f10f6a520deb3639fac78d81151a3ade88b4e7f.1326802230.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kurt Garloff <kurt@garloff.de>

In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
32bits for these. The new fields were reserved before.
According to the ACPI spec, the OS must disregrard reserved fields.

ia64 did handle the PXM fields almost consistently, but depending on
sgi's sn2 platform. This patch leaves the sn2 logic in, but does also
use 16/32 bits for PXM if the SRAT has rev 2 or higher.

The patch also adds __init to the two pxm accessor functions, as they
access __initdata now and are called from an __init function only anyway.

Note that the code only uses 16 bits for the PXM field in the processor
proximity field; the patch does not address this as 16 bits are more than
enough.

Signed-off-by: Kurt Garloff <kurt@garloff.de>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/ia64/kernel/acpi.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index bfb4d01..5207035 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -429,22 +429,24 @@ static u32 __devinitdata pxm_flag[PXM_FLAG_LEN];
 static struct acpi_table_slit __initdata *slit_table;
 cpumask_t early_cpu_possible_map = CPU_MASK_NONE;
 
-static int get_processor_proximity_domain(struct acpi_srat_cpu_affinity *pa)
+static int __init
+get_processor_proximity_domain(struct acpi_srat_cpu_affinity *pa)
 {
 	int pxm;
 
 	pxm = pa->proximity_domain_lo;
-	if (ia64_platform_is("sn2"))
+	if (ia64_platform_is("sn2") || acpi_srat_revision >= 2)
 		pxm += pa->proximity_domain_hi[0] << 8;
 	return pxm;
 }
 
-static int get_memory_proximity_domain(struct acpi_srat_mem_affinity *ma)
+static int __init
+get_memory_proximity_domain(struct acpi_srat_mem_affinity *ma)
 {
 	int pxm;
 
 	pxm = ma->proximity_domain;
-	if (!ia64_platform_is("sn2"))
+	if (!ia64_platform_is("sn2") && acpi_srat_revision <= 1)
 		pxm &= 0xff;
 
 	return pxm;
-- 
1.7.9.rc1

