Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab0I2Fxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 01:53:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56054 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab0I2Fxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 01:53:48 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, edgar.iglesias@gmail.com, duyl@xilinx.com,
        linnj@xilinx.com, grant.likely@secretlab.ca,
        microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 5/7] microblaze: Add PVR for endians plus detection
Date: Wed, 29 Sep 2010 15:52:16 +1000
Message-Id: <1285739538-29058-6-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1285739538-29058-5-git-send-email-monstr@monstr.eu>
References: <1285739538-29058-1-git-send-email-monstr@monstr.eu>
 <1285739538-29058-2-git-send-email-monstr@monstr.eu>
 <1285739538-29058-3-git-send-email-monstr@monstr.eu>
 <1285739538-29058-4-git-send-email-monstr@monstr.eu>
 <1285739538-29058-5-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upcomming microblaze version will support little-endian.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/cpuinfo.h         |    1 +
 arch/microblaze/include/asm/pvr.h             |    3 +++
 arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c |    1 +
 arch/microblaze/kernel/cpu/cpuinfo-static.c   |    1 +
 arch/microblaze/kernel/cpu/mb.c               |    3 ++-
 arch/microblaze/platform/generic/system.dts   |    1 +
 6 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/include/asm/cpuinfo.h b/arch/microblaze/include/asm/cpuinfo.h
index b4f5ca3..0d4f0ce 100644
--- a/arch/microblaze/include/asm/cpuinfo.h
+++ b/arch/microblaze/include/asm/cpuinfo.h
@@ -38,6 +38,7 @@ struct cpuinfo {
 	u32 use_exc;
 	u32 ver_code;
 	u32 mmu;
+	u32 endian;
 
 	/* CPU caches */
 	u32 use_icache;
diff --git a/arch/microblaze/include/asm/pvr.h b/arch/microblaze/include/asm/pvr.h
index 3161055..37db96a 100644
--- a/arch/microblaze/include/asm/pvr.h
+++ b/arch/microblaze/include/asm/pvr.h
@@ -32,6 +32,7 @@ struct pvr_s {
 #define PVR0_USE_DCACHE_MASK		0x01000000
 #define PVR0_USE_MMU			0x00800000
 #define PVR0_USE_BTC			0x00400000
+#define PVR0_ENDI			0x00200000
 #define PVR0_VERSION_MASK		0x0000FF00
 #define PVR0_USER1_MASK			0x000000FF
 
@@ -209,6 +210,8 @@ struct pvr_s {
 #define PVR_MMU_TLB_ACCESS(pvr)	(pvr.pvr[11] & PVR11_MMU_TLB_ACCESS)
 #define PVR_MMU_ZONES(pvr)	(pvr.pvr[11] & PVR11_MMU_ZONES)
 
+/* endian */
+#define PVR_ENDIAN(pvr)	(pvr.pvr[0] & PVR0_ENDI)
 
 int cpu_has_pvr(void);
 void get_pvr(struct pvr_s *pvr);
diff --git a/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c b/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
index f72dbd6..f70a604 100644
--- a/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
+++ b/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
@@ -72,6 +72,7 @@ void set_cpuinfo_pvr_full(struct cpuinfo *ci, struct device_node *cpu)
 	CI(pvr_user2, USER2);
 
 	CI(mmu, USE_MMU);
+	CI(endian, ENDIAN);
 
 	CI(use_icache, USE_ICACHE);
 	CI(icache_tagbits, ICACHE_ADDR_TAG_BITS);
diff --git a/arch/microblaze/kernel/cpu/cpuinfo-static.c b/arch/microblaze/kernel/cpu/cpuinfo-static.c
index 6095aa6..b16b994 100644
--- a/arch/microblaze/kernel/cpu/cpuinfo-static.c
+++ b/arch/microblaze/kernel/cpu/cpuinfo-static.c
@@ -119,6 +119,7 @@ void __init set_cpuinfo_static(struct cpuinfo *ci, struct device_node *cpu)
 	ci->pvr_user2 = fcpu(cpu, "xlnx,pvr-user2");
 
 	ci->mmu = fcpu(cpu, "xlnx,use-mmu");
+	ci->endian = fcpu(cpu, "xlnx,endianness");
 
 	ci->ver_code = 0;
 	ci->fpga_family_code = 0;
diff --git a/arch/microblaze/kernel/cpu/mb.c b/arch/microblaze/kernel/cpu/mb.c
index 7086e35..b4048af 100644
--- a/arch/microblaze/kernel/cpu/mb.c
+++ b/arch/microblaze/kernel/cpu/mb.c
@@ -51,11 +51,12 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	count = seq_printf(m,
 			"CPU-Family:	MicroBlaze\n"
 			"FPGA-Arch:	%s\n"
-			"CPU-Ver:	%s\n"
+			"CPU-Ver:	%s, %s endian\n"
 			"CPU-MHz:	%d.%02d\n"
 			"BogoMips:	%lu.%02lu\n",
 			fpga_family,
 			cpu_ver,
+			cpuinfo.endian ? "little" : "big",
 			cpuinfo.cpu_clock_freq /
 			1000000,
 			cpuinfo.cpu_clock_freq %
diff --git a/arch/microblaze/platform/generic/system.dts b/arch/microblaze/platform/generic/system.dts
index ef667d1..3f85df2 100644
--- a/arch/microblaze/platform/generic/system.dts
+++ b/arch/microblaze/platform/generic/system.dts
@@ -85,6 +85,7 @@
 			xlnx,dynamic-bus-sizing = <0x1>;
 			xlnx,edge-is-positive = <0x1>;
 			xlnx,family = "virtex5";
+			xlnx,endianness = <0x1>;
 			xlnx,fpu-exception = <0x1>;
 			xlnx,fsl-data-size = <0x20>;
 			xlnx,fsl-exception = <0x0>;
-- 
1.5.5.1

