Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab2GQFBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:01:06 -0400
Received: from ozlabs.org ([203.10.76.45]:48830 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab2GQFA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:00:59 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <kvm@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <matt@ozlabs.org>, <penberg@kernel.org>,
        <kvm-ppc@vger.kernel.org>, <prerna@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 08/10] kvm tools, powerpc: Use MMU info from the kernel for ibm,segment-page-sizes
Date: Tue, 17 Jul 2012 15:00:18 +1000
Message-Id: <1342501220-10209-9-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
References: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent kernels (>= v3.5-rc1) have an ioctl which allows us to retrieve the
list of page sizes supported for the guest.

So rework the cpu info code to use that ioctl when available, falling
back to the same values we used previously if the ioctl is not present.

We may also need to filter the list of page sizes against the page size
of the memory backing guest RAM - this accounts for the unfortunate amount
of code in setup_mmu_info().

Finally we need to turn the structure as returned by the kernel into the
format expected in the device tree.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/kvm/powerpc/cpu_info.c |  132 ++++++++++++++++++++++++++++++++++++++----
 tools/kvm/powerpc/cpu_info.h |    4 +-
 tools/kvm/powerpc/kvm.c      |   81 +++++++++++++++++++++++++-
 3 files changed, 200 insertions(+), 17 deletions(-)

diff --git a/tools/kvm/powerpc/cpu_info.c b/tools/kvm/powerpc/cpu_info.c
index 5015a4b..1cfb50d 100644
--- a/tools/kvm/powerpc/cpu_info.c
+++ b/tools/kvm/powerpc/cpu_info.c
@@ -15,24 +15,19 @@
  * by the Free Software Foundation.
  */
 
+#include <kvm/kvm.h>
+#include <sys/ioctl.h>
+
 #include "cpu_info.h"
 #include "kvm/util.h"
 
 /* POWER7 */
 
-/*
- * Basic set of pages for POWER7.  It actually supports more but there were some
- * limitations as to which may be advertised to the guest.  FIXME when this
- * settles down -- for now use basic set:
- */
-static u32 power7_page_sizes_prop[] = {0xc, 0x0, 0x1, 0xc, 0x0, 0x18, 0x100, 0x1, 0x18, 0x0};
 /* POWER7 has 1T segments, so advertise these */
 static u32 power7_segment_sizes_prop[] = {0x1c, 0x28, 0xffffffff, 0xffffffff};
 
 static struct cpu_info cpu_power7_info = {
 	.name = "POWER7",
-	.page_sizes_prop = power7_page_sizes_prop,
-	.page_sizes_prop_len = sizeof(power7_segment_sizes_prop),
 	.segment_sizes_prop = power7_segment_sizes_prop,
 	.segment_sizes_prop_len = sizeof(power7_segment_sizes_prop),
 	.slb_size = 32,
@@ -40,16 +35,15 @@ static struct cpu_info cpu_power7_info = {
 	.d_bsize = 128,
 	.i_bsize = 128,
 	.flags = CPUINFO_FLAG_DFP | CPUINFO_FLAG_VSX | CPUINFO_FLAG_VMX,
+	.mmu_info = {
+		.flags = KVM_PPC_PAGE_SIZES_REAL | KVM_PPC_1T_SEGMENTS,
+	},
 };
 
 /* PPC970/G5 */
 
-static u32 g5_page_sizes_prop[] = {0xc, 0x0, 0x1, 0xc, 0x0, 0x18, 0x100, 0x1, 0x18, 0x0};
-
 static struct cpu_info cpu_970_info = {
 	.name = "G5",
-	.page_sizes_prop = g5_page_sizes_prop,
-	.page_sizes_prop_len = sizeof(g5_page_sizes_prop),
 	.segment_sizes_prop = NULL /* no segment sizes prop, use defaults */,
 	.segment_sizes_prop_len = 0,
 	.slb_size = 0,
@@ -72,6 +66,118 @@ static struct pvr_info host_pvr_info[] = {
         { 0xffff0000, 0x00450000, &cpu_970_info },
 };
 
+/* If we can't query the kernel for supported page sizes assume 4K and 16M */
+static struct kvm_ppc_one_seg_page_size fallback_sps[] = {
+	[0] = {
+		.page_shift = 12,
+		.slb_enc    = 0,
+		.enc =  {
+			[0] = {
+				.page_shift = 12,
+				.pte_enc    = 0,
+			},
+		},
+	},
+	[1] = {
+		.page_shift = 24,
+		.slb_enc    = 0x100,
+		.enc =  {
+			[0] = {
+				.page_shift = 24,
+				.pte_enc    = 0,
+			},
+		},
+	},
+};
+
+
+static void setup_mmu_info(struct kvm *kvm, struct cpu_info *cpu_info)
+{
+	static struct kvm_ppc_smmu_info *mmu_info;
+	struct kvm_ppc_one_seg_page_size *sps;
+	int i, j, k, valid;
+
+	if (!kvm__supports_extension(kvm, KVM_CAP_PPC_GET_SMMU_INFO)) {
+		memcpy(&cpu_info->mmu_info.sps, fallback_sps, sizeof(fallback_sps));
+	} else if (ioctl(kvm->vm_fd, KVM_PPC_GET_SMMU_INFO, &cpu_info->mmu_info) < 0) {
+			die_perror("KVM_PPC_GET_SMMU_INFO failed");
+	}
+
+	mmu_info = &cpu_info->mmu_info;
+
+	if (!(mmu_info->flags & KVM_PPC_PAGE_SIZES_REAL))
+		/* Guest pages are not restricted by the backing page size */
+		return;
+
+	/* Filter based on backing page size */
+
+	for (i = 0; i < KVM_PPC_PAGE_SIZES_MAX_SZ; i++) {
+		sps = &mmu_info->sps[i];
+
+		if (!sps->page_shift)
+			break;
+
+		if (kvm->ram_pagesize < (1ul << sps->page_shift)) {
+			/* Mark the whole segment size invalid */
+			sps->page_shift = 0;
+			continue;
+		}
+
+		/* Check each page size for the segment */
+		for (j = 0, valid = 0; j < KVM_PPC_PAGE_SIZES_MAX_SZ; j++) {
+			if (!sps->enc[j].page_shift)
+				break;
+
+			if (kvm->ram_pagesize < (1ul << sps->enc[j].page_shift))
+				sps->enc[j].page_shift = 0;
+			else
+				valid++;
+		}
+
+		if (!valid) {
+			/* Mark the whole segment size invalid */
+			sps->page_shift = 0;
+			continue;
+		}
+
+		/* Mark any trailing entries invalid if we broke out early */
+		for (k = j; k < KVM_PPC_PAGE_SIZES_MAX_SZ; k++)
+			sps->enc[k].page_shift = 0;
+
+		/* Collapse holes */
+		for (j = 0; j < KVM_PPC_PAGE_SIZES_MAX_SZ; j++) {
+			if (sps->enc[j].page_shift)
+				continue;
+
+			for (k = j + 1; k < KVM_PPC_PAGE_SIZES_MAX_SZ; k++) {
+				if (sps->enc[k].page_shift) {
+					sps->enc[j] = sps->enc[k];
+					sps->enc[k].page_shift = 0;
+					break;
+				}
+			}
+		}
+	}
+
+	/* Mark any trailing entries invalid if we broke out early */
+	for (j = i; j < KVM_PPC_PAGE_SIZES_MAX_SZ; j++)
+		mmu_info->sps[j].page_shift = 0;
+
+	/* Collapse holes */
+	for (i = 0; i < KVM_PPC_PAGE_SIZES_MAX_SZ; i++) {
+		if (mmu_info->sps[i].page_shift)
+			continue;
+
+		for (j = i + 1; j < KVM_PPC_PAGE_SIZES_MAX_SZ; j++) {
+			if (mmu_info->sps[j].page_shift) {
+				mmu_info->sps[i] = mmu_info->sps[j];
+				mmu_info->sps[j].page_shift = 0;
+				break;
+			}
+		}
+	}
+}
+
 struct cpu_info *find_cpu_info(struct kvm *kvm)
 {
 	struct cpu_info *info;
@@ -91,5 +197,7 @@ struct cpu_info *find_cpu_info(struct kvm *kvm)
 		info = &cpu_dummy_info;
 	}
 
+	setup_mmu_info(kvm, info);
+
 	return info;
 }
diff --git a/tools/kvm/powerpc/cpu_info.h b/tools/kvm/powerpc/cpu_info.h
index 439f3940..9da6afe 100644
--- a/tools/kvm/powerpc/cpu_info.h
+++ b/tools/kvm/powerpc/cpu_info.h
@@ -15,11 +15,10 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/kvm.h>
 
 struct cpu_info {
 	const char	*name;
-	u32 		*page_sizes_prop;
-	u32		page_sizes_prop_len;
 	u32 		*segment_sizes_prop;
 	u32		segment_sizes_prop_len;
 	u32		slb_size;
@@ -27,6 +26,7 @@ struct cpu_info {
 	u32		d_bsize; /* d-cache block size */
 	u32		i_bsize; /* i-cache block size */
 	u32		flags;
+	struct kvm_ppc_smmu_info mmu_info;
 };
 
 struct pvr_info {
diff --git a/tools/kvm/powerpc/kvm.c b/tools/kvm/powerpc/kvm.c
index dbfea3e..293812a 100644
--- a/tools/kvm/powerpc/kvm.c
+++ b/tools/kvm/powerpc/kvm.c
@@ -211,6 +211,74 @@ bool load_bzimage(struct kvm *kvm, int fd_kernel,
 	return false;
 }
 
+struct fdt_prop {
+	void *value;
+	int size;
+};
+
+static void generate_segment_page_sizes(struct kvm_ppc_smmu_info *info, struct fdt_prop *prop)
+{
+	struct kvm_ppc_one_seg_page_size *sps;
+	int i, j, size;
+	u32 *p;
+
+	for (size = 0, i = 0; i < KVM_PPC_PAGE_SIZES_MAX_SZ; i++) {
+		sps = &info->sps[i];
+
+		if (sps->page_shift == 0)
+			break;
+
+		/* page shift, slb enc & count */
+		size += 3;
+
+		for (j = 0; j < KVM_PPC_PAGE_SIZES_MAX_SZ; j++) {
+			if (info->sps[i].enc[j].page_shift == 0)
+				break;
+
+			/* page shift & pte enc */
+			size += 2;
+		}
+	}
+
+	if (!size) {
+		prop->value = NULL;
+		prop->size = 0;
+		return;
+	}
+
+	/* Convert size to bytes */
+	prop->size = size * sizeof(u32);
+
+	prop->value = malloc(prop->size);
+	if (!prop->value)
+		die_perror("malloc failed");
+
+	p = (u32 *)prop->value;
+	for (i = 0; i < KVM_PPC_PAGE_SIZES_MAX_SZ; i++) {
+		sps = &info->sps[i];
+
+		if (sps->page_shift == 0)
+			break;
+
+		*p++ = sps->page_shift;
+		*p++ = sps->slb_enc;
+
+		for (j = 0; j < KVM_PPC_PAGE_SIZES_MAX_SZ; j++)
+			if (!info->sps[i].enc[j].page_shift)
+				break;
+
+		*p++ = j;	/* count of enc */
+
+		for (j = 0; j < KVM_PPC_PAGE_SIZES_MAX_SZ; j++) {
+			if (!info->sps[i].enc[j].page_shift)
+				break;
+
+			*p++ = info->sps[i].enc[j].page_shift;
+			*p++ = info->sps[i].enc[j].pte_enc;
+		}
+	}
+}
+
 #define SMT_THREADS 4
 
 /*
@@ -230,6 +298,7 @@ static void setup_fdt(struct kvm *kvm)
 	char 		cpu_name[30];
 	u8		staging_fdt[FDT_MAX_SIZE];
 	struct cpu_info *cpu_info = find_cpu_info(kvm);
+	struct fdt_prop segment_page_sizes;
 
 	/* Generate an appropriate DT at kvm->fdt_gra */
 	void *fdt_dest = guest_flat_to_host(kvm, kvm->fdt_gra);
@@ -293,6 +362,8 @@ static void setup_fdt(struct kvm *kvm)
 			  sizeof(mem_reg_property)));
 	_FDT(fdt_end_node(fdt));
 
+	generate_segment_page_sizes(&cpu_info->mmu_info, &segment_page_sizes);
+
 	/* CPUs */
 	_FDT(fdt_begin_node(fdt, "cpus"));
 	_FDT(fdt_property_cell(fdt, "#address-cells", 0x1));
@@ -347,10 +418,12 @@ static void setup_fdt(struct kvm *kvm)
 		_FDT(fdt_property(fdt, "ibm,ppc-interrupt-gserver#s",
 				  gservers_prop,
 				  threads * 2 * sizeof(uint32_t)));
-		if (cpu_info->page_sizes_prop)
+
+		if (segment_page_sizes.value)
 			_FDT(fdt_property(fdt, "ibm,segment-page-sizes",
-					  cpu_info->page_sizes_prop,
-					  cpu_info->page_sizes_prop_len));
+					  segment_page_sizes.value,
+					  segment_page_sizes.size));
+
 		if (cpu_info->segment_sizes_prop)
 			_FDT(fdt_property(fdt, "ibm,processor-segment-sizes",
 					  cpu_info->segment_sizes_prop,
@@ -411,6 +484,8 @@ static void setup_fdt(struct kvm *kvm)
 
 	_FDT(fdt_add_mem_rsv(fdt_dest, kvm->rtas_gra, kvm->rtas_size));
 	_FDT(fdt_pack(fdt_dest));
+
+	free(segment_page_sizes.value);
 }
 
 /**
-- 
1.7.9.5

