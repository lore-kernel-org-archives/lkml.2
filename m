Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab2GQFBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:01:09 -0400
Received: from ozlabs.org ([203.10.76.45]:38066 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab2GQFBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:01:01 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <kvm@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <matt@ozlabs.org>, <penberg@kernel.org>,
        <kvm-ppc@vger.kernel.org>, <prerna@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 09/10] kvm tools, powerpc: Use MMU info for ibm,processor-segment-sizes
Date: Tue, 17 Jul 2012 15:00:19 +1000
Message-Id: <1342501220-10209-10-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
References: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/kvm/powerpc/cpu_info.c |    7 -------
 tools/kvm/powerpc/cpu_info.h |    2 --
 tools/kvm/powerpc/kvm.c      |    7 ++++---
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/tools/kvm/powerpc/cpu_info.c b/tools/kvm/powerpc/cpu_info.c
index 1cfb50d..82a9d4f 100644
--- a/tools/kvm/powerpc/cpu_info.c
+++ b/tools/kvm/powerpc/cpu_info.c
@@ -23,13 +23,8 @@
 
 /* POWER7 */
 
-/* POWER7 has 1T segments, so advertise these */
-static u32 power7_segment_sizes_prop[] = {0x1c, 0x28, 0xffffffff, 0xffffffff};
-
 static struct cpu_info cpu_power7_info = {
 	.name = "POWER7",
-	.segment_sizes_prop = power7_segment_sizes_prop,
-	.segment_sizes_prop_len = sizeof(power7_segment_sizes_prop),
 	.slb_size = 32,
 	.tb_freq = 512000000,
 	.d_bsize = 128,
@@ -44,8 +39,6 @@ static struct cpu_info cpu_power7_info = {
 
 static struct cpu_info cpu_970_info = {
 	.name = "G5",
-	.segment_sizes_prop = NULL /* no segment sizes prop, use defaults */,
-	.segment_sizes_prop_len = 0,
 	.slb_size = 0,
 	.tb_freq = 33333333,
 	.d_bsize = 128,
diff --git a/tools/kvm/powerpc/cpu_info.h b/tools/kvm/powerpc/cpu_info.h
index 9da6afe..00b9436b 100644
--- a/tools/kvm/powerpc/cpu_info.h
+++ b/tools/kvm/powerpc/cpu_info.h
@@ -19,8 +19,6 @@
 
 struct cpu_info {
 	const char	*name;
-	u32 		*segment_sizes_prop;
-	u32		segment_sizes_prop_len;
 	u32		slb_size;
 	u32		tb_freq; /* timebase frequency */
 	u32		d_bsize; /* d-cache block size */
diff --git a/tools/kvm/powerpc/kvm.c b/tools/kvm/powerpc/kvm.c
index 293812a..8353355 100644
--- a/tools/kvm/powerpc/kvm.c
+++ b/tools/kvm/powerpc/kvm.c
@@ -299,6 +299,7 @@ static void setup_fdt(struct kvm *kvm)
 	u8		staging_fdt[FDT_MAX_SIZE];
 	struct cpu_info *cpu_info = find_cpu_info(kvm);
 	struct fdt_prop segment_page_sizes;
+	u32 segment_sizes_1T[] = {0x1c, 0x28, 0xffffffff, 0xffffffff};
 
 	/* Generate an appropriate DT at kvm->fdt_gra */
 	void *fdt_dest = guest_flat_to_host(kvm, kvm->fdt_gra);
@@ -424,10 +425,10 @@ static void setup_fdt(struct kvm *kvm)
 					  segment_page_sizes.value,
 					  segment_page_sizes.size));
 
-		if (cpu_info->segment_sizes_prop)
+		if (cpu_info->mmu_info.flags & KVM_PPC_1T_SEGMENTS)
 			_FDT(fdt_property(fdt, "ibm,processor-segment-sizes",
-					  cpu_info->segment_sizes_prop,
-					  cpu_info->segment_sizes_prop_len));
+					  segment_sizes_1T, sizeof(segment_sizes_1T)));
+
 		/* VSX / DFP options: */
 		if (cpu_info->flags & CPUINFO_FLAG_VMX)
 			_FDT(fdt_property_cell(fdt, "ibm,vmx",
-- 
1.7.9.5

