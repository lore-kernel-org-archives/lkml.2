Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab1DKPLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 11:11:15 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33489 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab1DKPLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 11:11:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oRiuobKpk/3Nj6POGvtl6/jCRjHtGv1j5sAz/Hz7dlqeM6fKKGss7hehFDlqaJLYaI
         WPOpe7fv9uT5KbZptlubYqX7Mdz1kF+RKCgiH1e8hsTVJHFGWglU2Vh1VwaLatu2YzA5
         6PTFJxWdFOCthu3u+y1+h8fe1T6yjakyJgZYs=
From: wanlong.gao@gmail.com
To: steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] misc:sgi-gru:removed the unused arch definition
Date: Mon, 11 Apr 2011 23:09:56 +0800
Message-Id: <1302534596-31250-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

Because SGI_GRU depends on X86_UV, and X86_UV
depends on X86_64.
So the code under the "#ifdef CONFIG_IA64" in
sgi-gru will always unused .

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/misc/sgi-gru/gru.h              |    4 +-
 drivers/misc/sgi-gru/gru_instructions.h |   12 +-----
 drivers/misc/sgi-gru/grufile.c          |   72 -------------------------------
 drivers/misc/sgi-gru/gruhandles.c       |    6 ---
 drivers/misc/sgi-gru/grumain.c          |    4 --
 5 files changed, 2 insertions(+), 96 deletions(-)

diff --git a/drivers/misc/sgi-gru/gru.h b/drivers/misc/sgi-gru/gru.h
index 3ad76cd..9650249
--- a/drivers/misc/sgi-gru/gru.h
+++ b/drivers/misc/sgi-gru/gru.h
@@ -30,9 +30,7 @@
 /*
  * Size used to map GRU GSeg
  */
-#if defined(CONFIG_IA64)
-#define GRU_GSEG_PAGESIZE	(256 * 1024UL)
-#elif defined(CONFIG_X86_64)
+#ifdef	CONFIG_X86_64
 #define GRU_GSEG_PAGESIZE	(256 * 1024UL)		/* ZZZ 2MB ??? */
 #else
 #error "Unsupported architecture"
diff --git a/drivers/misc/sgi-gru/gru_instructions.h b/drivers/misc/sgi-gru/gru_instructions.h
index d95587c..bf44419
--- a/drivers/misc/sgi-gru/gru_instructions.h
+++ b/drivers/misc/sgi-gru/gru_instructions.h
@@ -29,17 +29,7 @@ extern void gru_wait_abort_proc(void *cb);
  * Architecture dependent functions
  */
 
-#if defined(CONFIG_IA64)
-#include <linux/compiler.h>
-#include <asm/intrinsics.h>
-#define __flush_cache(p)		ia64_fc((unsigned long)p)
-/* Use volatile on IA64 to ensure ordering via st4.rel */
-#define gru_ordered_store_ulong(p, v)					\
-		do {							\
-			barrier();					\
-			*((volatile unsigned long *)(p)) = v; /* force st.rel */	\
-		} while (0)
-#elif defined(CONFIG_X86_64)
+#ifdef	CONFIG_X86_64
 #define __flush_cache(p)		clflush(p)
 #define gru_ordered_store_ulong(p, v)					\
 		do {							\
diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index 20e4e93..544f05e
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -344,72 +344,6 @@ static unsigned long gru_chiplet_cpu_to_mmr(int chiplet, int cpu, int *corep)
 	return mmr;
 }
 
-#ifdef CONFIG_IA64
-
-static int gru_irq_count[GRU_CHIPLETS_PER_BLADE];
-
-static void gru_noop(unsigned int irq)
-{
-}
-
-static struct irq_chip gru_chip[GRU_CHIPLETS_PER_BLADE] = {
-	[0 ... GRU_CHIPLETS_PER_BLADE - 1] {
-		.mask		= gru_noop,
-		.unmask		= gru_noop,
-		.ack		= gru_noop
-	}
-};
-
-static int gru_chiplet_setup_tlb_irq(int chiplet, char *irq_name,
-			irq_handler_t irq_handler, int cpu, int blade)
-{
-	unsigned long mmr;
-	int irq = IRQ_GRU + chiplet;
-	int ret, core;
-
-	mmr = gru_chiplet_cpu_to_mmr(chiplet, cpu, &core);
-	if (mmr == 0)
-		return 0;
-
-	if (gru_irq_count[chiplet] == 0) {
-		gru_chip[chiplet].name = irq_name;
-		ret = irq_set_chip(irq, &gru_chip[chiplet]);
-		if (ret) {
-			printk(KERN_ERR "%s: set_irq_chip failed, errno=%d\n",
-			       GRU_DRIVER_ID_STR, -ret);
-			return ret;
-		}
-
-		ret = request_irq(irq, irq_handler, 0, irq_name, NULL);
-		if (ret) {
-			printk(KERN_ERR "%s: request_irq failed, errno=%d\n",
-			       GRU_DRIVER_ID_STR, -ret);
-			return ret;
-		}
-	}
-	gru_irq_count[chiplet]++;
-
-	return 0;
-}
-
-static void gru_chiplet_teardown_tlb_irq(int chiplet, int cpu, int blade)
-{
-	unsigned long mmr;
-	int core, irq = IRQ_GRU + chiplet;
-
-	if (gru_irq_count[chiplet] == 0)
-		return;
-
-	mmr = gru_chiplet_cpu_to_mmr(chiplet, cpu, &core);
-	if (mmr == 0)
-		return;
-
-	if (--gru_irq_count[chiplet] == 0)
-		free_irq(irq, NULL);
-}
-
-#elif defined CONFIG_X86_64
-
 static int gru_chiplet_setup_tlb_irq(int chiplet, char *irq_name,
 			irq_handler_t irq_handler, int cpu, int blade)
 {
@@ -454,8 +388,6 @@ static void gru_chiplet_teardown_tlb_irq(int chiplet, int cpu, int blade)
 	}
 }
 
-#endif
-
 static void gru_teardown_tlb_irqs(void)
 {
 	int blade;
@@ -521,12 +453,8 @@ static int __init gru_init(void)
 	if (!is_uv_system())
 		return 0;
 
-#if defined CONFIG_IA64
-	gru_start_paddr = 0xd000000000UL; /* ZZZZZZZZZZZZZZZZZZZ fixme */
-#else
 	gru_start_paddr = uv_read_local_mmr(UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR) &
 				0x7fffffffffffUL;
-#endif
 	gru_start_vaddr = __va(gru_start_paddr);
 	gru_end_paddr = gru_start_paddr + GRU_MAX_BLADES * GRU_SIZE;
 	printk(KERN_INFO "GRU space: 0x%lx - 0x%lx\n",
diff --git a/drivers/misc/sgi-gru/gruhandles.c b/drivers/misc/sgi-gru/gruhandles.c
index 2f30bad..e17a9e6
--- a/drivers/misc/sgi-gru/gruhandles.c
+++ b/drivers/misc/sgi-gru/gruhandles.c
@@ -24,15 +24,9 @@
 #include "grutables.h"
 
 /* 10 sec */
-#ifdef CONFIG_IA64
-#include <asm/processor.h>
-#define GRU_OPERATION_TIMEOUT	(((cycles_t) local_cpu_data->itc_freq)*10)
-#define CLKS2NSEC(c)		((c) *1000000000 / local_cpu_data->itc_freq)
-#else
 #include <asm/tsc.h>
 #define GRU_OPERATION_TIMEOUT	((cycles_t) tsc_khz*10*1000)
 #define CLKS2NSEC(c)		((c) * 1000000 / tsc_khz)
-#endif
 
 /* Extract the status field from a kernel handle */
 #define GET_MSEG_HANDLE_STATUS(h)	(((*(unsigned long *)(h)) >> 16) & 3)
diff --git a/drivers/misc/sgi-gru/grumain.c b/drivers/misc/sgi-gru/grumain.c
index f8538bb..f8b65e6
--- a/drivers/misc/sgi-gru/grumain.c
+++ b/drivers/misc/sgi-gru/grumain.c
@@ -53,16 +53,12 @@ struct device *grudev = &gru_device;
  */
 int gru_cpu_fault_map_id(void)
 {
-#ifdef CONFIG_IA64
-	return uv_blade_processor_id() % GRU_NUM_TFM;
-#else
 	int cpu = smp_processor_id();
 	int id, core;
 
 	core = uv_cpu_core_number(cpu);
 	id = core + UV_MAX_INT_CORES * uv_cpu_socket_number(cpu);
 	return id;
-#endif
 }
 
 /*--------- ASID Management -------------------------------------------
-- 
1.7.3

