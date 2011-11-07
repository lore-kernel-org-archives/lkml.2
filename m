Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab1KGV3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 16:29:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab1KGV3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 16:29:49 -0500
Message-ID: <4EB84DC9.8010106@redhat.com>
Date: Mon, 07 Nov 2011 19:29:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix sb_edac compilation with 32 bits kernels
References: <20111103140716.GF19809@zod.bos.redhat.com>
In-Reply-To: <20111103140716.GF19809@zod.bos.redhat.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 03-11-2011 12:07, Josh Boyer escreveu:
> Hi,
> 
> It seems the newly added EDAC driver for SandyBridge won't build on
> 32-bit x86 because of a 64-bit divide somewhere:
> 
> 	drivers/edac/sb_edac.c: In function 'get_memory_error_data':
> 	drivers/edac/sb_edac.c:861:2: warning: left shift count >= width of type
> 	[enabled by default]
> 	<snip>
> 	ERROR: "__udivdi3" [drivers/edac/sb_edac.ko] undefined!
> 	make[1]: *** [__modpost] Error 1
> 	make: *** [modules] Error 2
> 
> You can find the full build log here:
> 
> http://koji.fedoraproject.org/koji/getfile?taskID=3482579&name=build.log
> 
> Before I go digging into where this is done and what to do about it, I
> do want to confirm that it is supposed to work on a 32-bit kernel,
> correct?

Ok, I found some spare time to work on a patch for fixing it.
As Tony pointed, it probably doesn't make much sense on running
this driver with 32 bits, nor I tested the patch, but, in any case, 
the fix is trivial.

Regards,
Mauro

-

From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Mon, 7 Nov 2011 19:26:53 -0200

As reported by Josh Boyer <jwboyer@redhat.com>:
>	drivers/edac/sb_edac.c: In function 'get_memory_error_data':
> 	drivers/edac/sb_edac.c:861:2: warning: left shift count >= width of type
> 	[enabled by default]
> 	<snip>
> 	ERROR: "__udivdi3" [drivers/edac/sb_edac.ko] undefined!
> 	make[1]: *** [__modpost] Error 1
> 	make: *** [modules] Error 2

PS.: compile-tested only

Reported-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 5948a21..203361e 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -214,7 +214,7 @@ config EDAC_I7300
 
 config EDAC_SBRIDGE
 	tristate "Intel Sandy-Bridge Integrated MC"
-	depends on EDAC_MM_EDAC && PCI && X86_64 && X86_MCE_INTEL
+	depends on EDAC_MM_EDAC && PCI && X86 && X86_MCE_INTEL
 	depends on EXPERIMENTAL
 	help
 	  Support for error detection and correction the Intel
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 7a402bf..10927ff 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -20,6 +20,7 @@
 #include <linux/mmzone.h>
 #include <linux/smp.h>
 #include <linux/bitmap.h>
+#include <linux/math64.h>
 #include <asm/processor.h>
 #include <asm/mce.h>
 
@@ -670,6 +671,7 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 	u32 reg;
 	u64 limit, prv = 0;
 	u64 tmp_mb;
+	u32 mb, kb;
 	u32 rir_way;
 
 	/*
@@ -682,8 +684,9 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 	pvt->tolm = GET_TOLM(reg);
 	tmp_mb = (1 + pvt->tolm) >> 20;
 
-	debugf0("TOLM: %Lu.%03Lu GB (0x%016Lx)\n",
-		tmp_mb / 1000, tmp_mb % 1000, (u64)pvt->tolm);
+	mb = div_u64_rem(tmp_mb, 1000, &kb);
+	debugf0("TOLM: %u.%03u GB (0x%016Lx)\n",
+		mb, kb, (u64)pvt->tolm);
 
 	/* Address range is already 45:25 */
 	pci_read_config_dword(pvt->pci_sad1, TOHM,
@@ -691,8 +694,9 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 	pvt->tohm = GET_TOHM(reg);
 	tmp_mb = (1 + pvt->tohm) >> 20;
 
-	debugf0("TOHM: %Lu.%03Lu GB (0x%016Lx)",
-		tmp_mb / 1000, tmp_mb % 1000, (u64)pvt->tohm);
+	mb = div_u64_rem(tmp_mb, 1000, &kb);
+	debugf0("TOHM: %u.%03u GB (0x%016Lx)",
+		mb, kb, (u64)pvt->tohm);
 
 	/*
 	 * Step 2) Get SAD range and SAD Interleave list
@@ -714,10 +718,11 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 			break;
 
 		tmp_mb = (limit + 1) >> 20;
-		debugf0("SAD#%d %s up to %Lu.%03Lu GB (0x%016Lx) %s reg=0x%08x\n",
+		mb = div_u64_rem(tmp_mb, 1000, &kb);
+		debugf0("SAD#%d %s up to %u.%03u GB (0x%016Lx) %s reg=0x%08x\n",
 			n_sads,
 			get_dram_attr(reg),
-			tmp_mb / 1000, tmp_mb % 1000,
+			mb, kb,
 			((u64)tmp_mb) << 20L,
 			INTERLEAVE_MODE(reg) ? "Interleave: 8:6" : "Interleave: [8:6]XOR[18:16]",
 			reg);
@@ -747,8 +752,9 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 			break;
 		tmp_mb = (limit + 1) >> 20;
 
-		debugf0("TAD#%d: up to %Lu.%03Lu GB (0x%016Lx), socket interleave %d, memory interleave %d, TGT: %d, %d, %d, %d, reg=0x%08x\n",
-			n_tads, tmp_mb / 1000, tmp_mb % 1000,
+		mb = div_u64_rem(tmp_mb, 1000, &kb);
+		debugf0("TAD#%d: up to %u.%03u GB (0x%016Lx), socket interleave %d, memory interleave %d, TGT: %d, %d, %d, %d, reg=0x%08x\n",
+			n_tads, mb, kb,
 			((u64)tmp_mb) << 20L,
 			(u32)TAD_SOCK(reg),
 			(u32)TAD_CH(reg),
@@ -771,9 +777,10 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 					      tad_ch_nilv_offset[j],
 					      &reg);
 			tmp_mb = TAD_OFFSET(reg) >> 20;
-			debugf0("TAD CH#%d, offset #%d: %Lu.%03Lu GB (0x%016Lx), reg=0x%08x\n",
+			mb = div_u64_rem(tmp_mb, 1000, &kb);
+			debugf0("TAD CH#%d, offset #%d: %u.%03u GB (0x%016Lx), reg=0x%08x\n",
 				i, j,
-				tmp_mb / 1000, tmp_mb % 1000,
+				mb, kb,
 				((u64)tmp_mb) << 20L,
 				reg);
 		}
@@ -795,9 +802,10 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 
 			tmp_mb = RIR_LIMIT(reg) >> 20;
 			rir_way = 1 << RIR_WAY(reg);
-			debugf0("CH#%d RIR#%d, limit: %Lu.%03Lu GB (0x%016Lx), way: %d, reg=0x%08x\n",
+			mb = div_u64_rem(tmp_mb, 1000, &kb);
+			debugf0("CH#%d RIR#%d, limit: %u.%03u GB (0x%016Lx), way: %d, reg=0x%08x\n",
 				i, j,
-				tmp_mb / 1000, tmp_mb % 1000,
+				mb, kb,
 				((u64)tmp_mb) << 20L,
 				rir_way,
 				reg);
@@ -808,9 +816,10 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 						      &reg);
 				tmp_mb = RIR_OFFSET(reg) << 6;
 
-				debugf0("CH#%d RIR#%d INTL#%d, offset %Lu.%03Lu GB (0x%016Lx), tgt: %d, reg=0x%08x\n",
+				mb = div_u64_rem(tmp_mb, 1000, &kb);
+				debugf0("CH#%d RIR#%d INTL#%d, offset %u.%03u GB (0x%016Lx), tgt: %d, reg=0x%08x\n",
 					i, j, k,
-					tmp_mb / 1000, tmp_mb % 1000,
+					mb, kb,
 					((u64)tmp_mb) << 20L,
 					(u32)RIR_RNK_TGT(reg),
 					reg);
@@ -848,6 +857,7 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	u8			ch_way,sck_way;
 	u32			tad_offset;
 	u32			rir_way;
+	u32			mb, kb;
 	u64			ch_addr, offset, limit, prv = 0;
 
 
@@ -858,7 +868,7 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	 * range (e. g. VGA addresses). It is unlikely, however, that the
 	 * memory controller would generate an error on that range.
 	 */
-	if ((addr > (u64) pvt->tolm) && (addr < (1L << 32))) {
+	if ((addr > (u64) pvt->tolm) && (addr < (1LL << 32))) {
 		sprintf(msg, "Error at TOLM area, on addr 0x%08Lx", addr);
 		edac_mc_handle_ce_no_info(mci, msg);
 		return -EINVAL;
@@ -1053,7 +1063,7 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	ch_addr = addr & 0x7f;
 	/* Remove socket wayness and remove 6 bits */
 	addr >>= 6;
-	addr /= sck_xch;
+	addr = div_u64(addr, sck_xch);
 #if 0
 	/* Divide by channel way */
 	addr = addr / ch_way;
@@ -1073,10 +1083,10 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 			continue;
 
 		limit = RIR_LIMIT(reg);
-
-		debugf0("RIR#%d, limit: %Lu.%03Lu GB (0x%016Lx), way: %d\n",
+		mb = div_u64_rem(limit >> 20, 1000, &kb);
+		debugf0("RIR#%d, limit: %u.%03u GB (0x%016Lx), way: %d\n",
 			n_rir,
-			(limit >> 20) / 1000, (limit >> 20) % 1000,
+			mb, kb,
 			limit,
 			1 << RIR_WAY(reg));
 		if  (ch_addr <= limit)
