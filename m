Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab2AQNZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:25:03 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:43625 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab2AQNWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:22:16 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jan 2012 08:22:13 EST
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Kurt Garloff <kurt@garloff.de>, x86@kernel.org,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 37/50] ACPI, x86: Use SRAT table rev to use 8bit or 32bit PXM
 fields (x86/x86-64)
Date: Tue, 17 Jan 2012 07:21:29 -0500
Message-id: <cd298f60a2451a16e0f077404bf69b62ec868733.1326802230.git.len.brown@intel.com>
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

x86/x86-64 was rather inconsistent prior to this patch; it used 8 bits
for the pxm field in cpu_affinity, but 32 bits in mem_affinity.
This patch makes it consistent: Either use 8 bits consistently (SRAT
rev 1 or lower) or 32 bits (SRAT rev 2 or higher).

cc: x86@kernel.org
Signed-off-by: Kurt Garloff <kurt@garloff.de>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/mm/srat.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 81dbfde..7efd0c6 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -104,6 +104,8 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
 		return;
 	pxm = pa->proximity_domain_lo;
+	if (acpi_srat_revision >= 2)
+		pxm |= *((unsigned int*)pa->proximity_domain_hi) << 8;
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
@@ -155,6 +157,8 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	start = ma->base_address;
 	end = start + ma->length;
 	pxm = ma->proximity_domain;
+	if (acpi_srat_revision <= 1)
+		pxm &= 0xff;
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
-- 
1.7.9.rc1

