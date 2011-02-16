Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab1BPLT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 06:19:29 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:48409 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab1BPLT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 06:19:27 -0500
Message-Id: <20110216111923.853921231@linux.vnet.ibm.com>
User-Agent: quilt/0.47-1
Date: Wed, 16 Feb 2011 12:01:21 +0100
From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
To: robert.richter@amd.com
Cc: mingo@elte.hu, oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: [patch v2 3/3] This patch changes the signature of oprofile_add_ext_sample() 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,
References: <20110216110118.316927092@linux.vnet.ibm.com>
Content-Disposition: inline; filename=oprofile_add_ext_sample.patch

From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>

This patch merges oprofile_add_ext_sample() and oprofile_add_ext_hw_sample().
It changes the signature of oprofile_add_ext_sample() and changes also 
all references.

---
 arch/powerpc/oprofile/op_model_7450.c    |    9 ++++++++-
 arch/powerpc/oprofile/op_model_cell.c    |    9 ++++++++-
 arch/powerpc/oprofile/op_model_fsl_emb.c |    9 ++++++++-
 arch/powerpc/oprofile/op_model_pa6t.c    |   12 ++++++++++--
 arch/powerpc/oprofile/op_model_power4.c  |    9 ++++++++-
 arch/powerpc/oprofile/op_model_rs64.c    |    9 ++++++++-
 arch/s390/oprofile/hwsampler.c           |    9 +++++++--
 drivers/oprofile/cpu_buffer.c            |   22 ++--------------------
 drivers/oprofile/cpu_buffer.h            |    9 ---------
 include/linux/oprofile.h                 |   18 ++++++++++--------
 10 files changed, 69 insertions(+), 46 deletions(-)

Index: s390/include/linux/oprofile.h
===================================================================
--- s390.orig/include/linux/oprofile.h
+++ s390/include/linux/oprofile.h
@@ -96,6 +96,15 @@ void oprofile_arch_exit(void);
  */
 void oprofile_add_sample(struct pt_regs * const regs, unsigned long event);
 
+struct oprofile_sample_parms {
+	int is_kernel;
+	unsigned long pc;
+	unsigned long backtrace;
+	unsigned long event;
+	struct task_struct *task;
+	struct pt_regs *regs;
+};
+
 /**
  * Add an extended sample.  Use this when the PC is not from the regs, and
  * we cannot determine if we're in kernel mode from the regs.
@@ -103,15 +112,8 @@ void oprofile_add_sample(struct pt_regs
  * This function does perform a backtrace.
  *
  */
-void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
-				unsigned long event, int is_kernel);
 
-/**
- * Add an hardware sample.
- */
-void oprofile_add_ext_hw_sample(unsigned long pc, struct pt_regs * const regs,
-	unsigned long event, int is_kernel,
-	struct task_struct *task);
+void oprofile_add_ext_sample(struct oprofile_sample_parms *sample_parms);
 
 /* Use this instead when the PC value is not from the regs. Doesn't
  * backtrace. */
Index: s390/drivers/oprofile/cpu_buffer.h
===================================================================
--- s390.orig/drivers/oprofile/cpu_buffer.h
+++ s390/drivers/oprofile/cpu_buffer.h
@@ -51,15 +51,6 @@ struct oprofile_cpu_buffer {
 	struct delayed_work work;
 };
 
-struct oprofile_sample_parms {
-	int is_kernel;
-	unsigned long pc;
-	unsigned long backtrace;
-	unsigned long event;
-	struct task_struct *task;
-	struct pt_regs *regs;
-};
-
 DECLARE_PER_CPU(struct oprofile_cpu_buffer, op_cpu_buffer);
 
 /*
Index: s390/arch/powerpc/oprofile/op_model_7450.c
===================================================================
--- s390.orig/arch/powerpc/oprofile/op_model_7450.c
+++ s390/arch/powerpc/oprofile/op_model_7450.c
@@ -178,6 +178,7 @@ static void fsl7450_handle_interrupt(str
 	int is_kernel;
 	int val;
 	int i;
+        struct oprofile_sample_parms parms;
 
 	/* set the PMM bit (see comment below) */
 	mtmsr(mfmsr() | MSR_PMM);
@@ -186,10 +187,16 @@ static void fsl7450_handle_interrupt(str
 	is_kernel = is_kernel_addr(pc);
 
 	for (i = 0; i < num_pmcs; ++i) {
+		parms.backtrace = 0;
+		parms.task = NULL;
 		val = classic_ctr_read(i);
 		if (val < 0) {
 			if (oprofile_running && ctr[i].enabled) {
-				oprofile_add_ext_sample(pc, regs, i, is_kernel);
+				parms.pc = pc;
+				parms.event = i;
+				parms.is_kernel = is_kernel;
+				parms.regs = regs;
+				oprofile_add_ext_sample(&parms);
 				classic_ctr_write(i, reset_value[i]);
 			} else {
 				classic_ctr_write(i, 0);
Index: s390/arch/powerpc/oprofile/op_model_cell.c
===================================================================
--- s390.orig/arch/powerpc/oprofile/op_model_cell.c
+++ s390/arch/powerpc/oprofile/op_model_cell.c
@@ -1613,6 +1613,7 @@ static void cell_handle_interrupt_ppu(st
 	unsigned long flags = 0;
 	u32 interrupt_mask;
 	int i;
+	struct oprofile_sample_parms parms;
 
 	cpu = smp_processor_id();
 
@@ -1645,9 +1646,15 @@ static void cell_handle_interrupt_ppu(st
 		is_kernel = is_kernel_addr(pc);
 
 		for (i = 0; i < num_counters; ++i) {
+			parms.backtrace = 0;
+			parms.task = NULL;
 			if ((interrupt_mask & CBE_PM_CTR_OVERFLOW_INTR(i))
 			    && ctr[i].enabled) {
-				oprofile_add_ext_sample(pc, regs, i, is_kernel);
+				parms.pc = pc;
+				parms.event = i;
+				parms.is_kernel = is_kernel;
+				parms.regs = regs;
+				oprofile_add_ext_sample(&parms);
 				cbe_write_ctr(cpu, i, reset_value[i]);
 			}
 		}
Index: s390/arch/powerpc/oprofile/op_model_fsl_emb.c
===================================================================
--- s390.orig/arch/powerpc/oprofile/op_model_fsl_emb.c
+++ s390/arch/powerpc/oprofile/op_model_fsl_emb.c
@@ -320,15 +320,22 @@ static void fsl_emb_handle_interrupt(str
 	int is_kernel;
 	int val;
 	int i;
+	struct oprofile_sample_parms parms;
 
 	pc = regs->nip;
 	is_kernel = is_kernel_addr(pc);
 
 	for (i = 0; i < num_counters; ++i) {
+		parms.backtrace = 0;
+		parms.task = NULL;
 		val = ctr_read(i);
 		if (val < 0) {
 			if (oprofile_running && ctr[i].enabled) {
-				oprofile_add_ext_sample(pc, regs, i, is_kernel);
+				parms.pc = pc;
+				parms.event = i;
+				parms.is_kernel = is_kernel;
+				parms.regs = regs;
+				oprofile_add_ext_sample(&parms);
 				ctr_write(i, reset_value[i]);
 			} else {
 				ctr_write(i, 0);
Index: s390/arch/powerpc/oprofile/op_model_pa6t.c
===================================================================
--- s390.orig/arch/powerpc/oprofile/op_model_pa6t.c
+++ s390/arch/powerpc/oprofile/op_model_pa6t.c
@@ -205,6 +205,7 @@ static void pa6t_handle_interrupt(struct
 	u64 val;
 	int i;
 	u64 mmcr0;
+	struct oprofile_sample_parms parms;
 
 	/* disable perfmon counting until rfid */
 	mmcr0 = mfspr(SPRN_PA6T_MMCR0);
@@ -214,11 +215,18 @@ static void pa6t_handle_interrupt(struct
 	 * was taken, so add it for any counter that triggered overflow.
 	 */
 	for (i = 0; i < cur_cpu_spec->num_pmcs; i++) {
+		parms.backtrace = 0;
+		parms.task = NULL;
 		val = ctr_read(i);
 		if (val & (0x1UL << 39)) { /* Overflow bit set */
 			if (oprofile_running && ctr[i].enabled) {
-				if (mmcr0 & PA6T_MMCR0_SIARLOG)
-					oprofile_add_ext_sample(pc, regs, i, is_kernel);
+				if (mmcr0 & PA6T_MMCR0_SIARLOG) {
+					parms.pc = pc;
+					parms.event = i;
+					parms.is_kernel = is_kernel;
+					parms.regs = regs;
+					oprofile_add_ext_sample(&parms);
+				}
 				ctr_write(i, reset_value[i]);
 			} else {
 				ctr_write(i, 0UL);
Index: s390/arch/powerpc/oprofile/op_model_power4.c
===================================================================
--- s390.orig/arch/powerpc/oprofile/op_model_power4.c
+++ s390/arch/powerpc/oprofile/op_model_power4.c
@@ -270,6 +270,7 @@ static void power4_handle_interrupt(stru
 	int i;
 	unsigned int mmcr0;
 	unsigned long mmcra;
+	struct oprofile_sample_parms parms;
 
 	mmcra = mfspr(SPRN_MMCRA);
 
@@ -280,10 +281,16 @@ static void power4_handle_interrupt(stru
 	mtmsrd(mfmsr() | MSR_PMM);
 
 	for (i = 0; i < cur_cpu_spec->num_pmcs; ++i) {
+		parms.backtrace = 0;
+		parms.task = NULL;
 		val = classic_ctr_read(i);
 		if (val < 0) {
 			if (oprofile_running && ctr[i].enabled) {
-				oprofile_add_ext_sample(pc, regs, i, is_kernel);
+				parms.pc = pc;
+				parms.event = i;
+				parms.is_kernel = is_kernel;
+				parms.regs = regs;
+				oprofile_add_ext_sample(&parms);
 				classic_ctr_write(i, reset_value[i]);
 			} else {
 				classic_ctr_write(i, 0);
Index: s390/arch/powerpc/oprofile/op_model_rs64.c
===================================================================
--- s390.orig/arch/powerpc/oprofile/op_model_rs64.c
+++ s390/arch/powerpc/oprofile/op_model_rs64.c
@@ -183,6 +183,7 @@ static void rs64_handle_interrupt(struct
 	int val;
 	int i;
 	unsigned long pc = mfspr(SPRN_SIAR);
+	struct oprofile_sample_parms parms;
 
 	is_kernel = is_kernel_addr(pc);
 
@@ -190,10 +191,16 @@ static void rs64_handle_interrupt(struct
 	mtmsrd(mfmsr() | MSR_PMM);
 
 	for (i = 0; i < num_counters; ++i) {
+		parms.backtrace = 0;
+		parms.task = NULL;
 		val = classic_ctr_read(i);
 		if (val < 0) {
 			if (ctr[i].enabled) {
-				oprofile_add_ext_sample(pc, regs, i, is_kernel);
+				parms.pc = pc;
+				parms.event = i;
+				parms.is_kernel = is_kernel;
+				parms.regs = regs;
+				oprofile_add_ext_sample(&parms);
 				classic_ctr_write(i, reset_value[i]);
 			} else {
 				classic_ctr_write(i, 0);
Index: s390/drivers/oprofile/cpu_buffer.c
===================================================================
--- s390.orig/drivers/oprofile/cpu_buffer.c
+++ s390/drivers/oprofile/cpu_buffer.c
@@ -315,27 +315,9 @@ __oprofile_add_ext_sample(struct oprofil
 	oprofile_end_trace(cpu_buf);
 }
 
-void oprofile_add_ext_hw_sample(unsigned long pc, struct pt_regs * const regs,
-				unsigned long event, int is_kernel,
-				struct task_struct *task)
+void oprofile_add_ext_sample( struct oprofile_sample_parms *parms)
 {
-	struct oprofile_sample_parms parms = {
-		.pc = pc, .backtrace = 0, .event = event,
-		.is_kernel = is_kernel, .regs = regs,
-		.task = task ? task : current
-	};
-
-	__oprofile_add_ext_sample(&parms);
-}
-
-void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
-			     unsigned long event, int is_kernel)
-{
-	struct oprofile_sample_parms parms = {
-		.pc = pc, .backtrace = 0, .event = event,
-		.is_kernel = is_kernel, .regs = regs, .task = NULL
-	};
-	__oprofile_add_ext_sample(&parms);
+	__oprofile_add_ext_sample(parms);
 }
 
 void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
Index: s390/arch/s390/oprofile/hwsampler.c
===================================================================
--- s390.orig/arch/s390/oprofile/hwsampler.c
+++ s390/arch/s390/oprofile/hwsampler.c
@@ -887,6 +887,8 @@ static void add_samples_to_oprofile(unsi
 	while ((unsigned long *)sample_data_ptr < trailer) {
 		struct pt_regs *regs = NULL;
 		struct task_struct *tsk = NULL;
+		struct oprofile_sample_parms parms = {
+				.backtrace = 0, .event = 0 };
 
 		/*
 		 * Check sampling mode, 1 indicates basic (=customer) sampling
@@ -916,8 +918,11 @@ static void add_samples_to_oprofile(unsi
 		}
 
 		mutex_lock(&hws_sem);
-		oprofile_add_ext_hw_sample(sample_data_ptr->ia, regs, 0,
-				!sample_data_ptr->P, tsk);
+		parms.pc = sample_data_ptr->ia;
+		parms.regs = regs;
+		parms.task = tsk;
+		parms.is_kernel = !sample_data_ptr->P;
+		oprofile_add_ext_sample(&parms);
 		mutex_unlock(&hws_sem);
 
 		sample_data_ptr++;

