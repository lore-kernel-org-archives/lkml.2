Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab0EDKqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 06:46:55 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:22929 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab0EDKqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 06:46:49 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1W5XR-01-7XL-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 5/7] oprofile/x86: return -EBUSY if counters are already reserved
Date: Tue, 4 May 2010 12:44:51 +0200
Message-ID: <1272969893-29233-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1272969893-29233-1-git-send-email-robert.richter@amd.com>
References: <1272969893-29233-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case a counter is already reserved by the watchdog or perf_event
subsystem, oprofile ignored this counters silently. This case is
handled now and oprofile_setup() now reports an error.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c       |    5 ++++-
 arch/x86/oprofile/op_model_amd.c  |   24 +++++++++++++-----------
 arch/x86/oprofile/op_model_p4.c   |   14 +++++++++++++-
 arch/x86/oprofile/op_model_ppro.c |   24 +++++++++++++-----------
 arch/x86/oprofile/op_x86_model.h  |    2 +-
 5 files changed, 44 insertions(+), 25 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index c0c21f2..9f001d9 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -357,7 +357,10 @@ static int nmi_setup(void)
 	 */
 
 	/* Assume saved/restored counters are the same on all CPUs */
-	model->fill_in_addresses(&per_cpu(cpu_msrs, 0));
+	err = model->fill_in_addresses(&per_cpu(cpu_msrs, 0));
+	if (err)
+		goto fail;
+
 	for_each_possible_cpu(cpu) {
 		if (!cpu)
 			continue;
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 7e5886d..536d0b0 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -138,21 +138,30 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 	}
 }
 
-static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
+static int op_amd_fill_in_addresses(struct op_msrs * const msrs)
 {
 	int i;
 
 	for (i = 0; i < NUM_COUNTERS; i++) {
 		if (!reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
-			continue;
+			goto fail;
 		if (!reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i)) {
 			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-			continue;
+			goto fail;
 		}
 		/* both registers must be reserved */
 		msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
 		msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
+		continue;
+	fail:
+		if (!counter_config[i].enabled)
+			continue;
+		op_x86_warn_reserved(i);
+		op_amd_shutdown(msrs);
+		return -EBUSY;
 	}
+
+	return 0;
 }
 
 static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
@@ -172,15 +181,8 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* clear all counters */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if (unlikely(!msrs->controls[i].addr)) {
-			if (counter_config[i].enabled && !smp_processor_id())
-				/*
-				 * counter is reserved, this is on all
-				 * cpus, so report only for cpu #0
-				 */
-				op_x86_warn_reserved(i);
+		if (!msrs->controls[i].addr)
 			continue;
-		}
 		rdmsrl(msrs->controls[i].addr, val);
 		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
 			op_x86_warn_in_use(i);
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 7cc80df..182558d 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -404,7 +404,7 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 	}
 }
 
-static void p4_fill_in_addresses(struct op_msrs * const msrs)
+static int p4_fill_in_addresses(struct op_msrs * const msrs)
 {
 	unsigned int i;
 	unsigned int addr, cccraddr, stag;
@@ -486,6 +486,18 @@ static void p4_fill_in_addresses(struct op_msrs * const msrs)
 			msrs->controls[i++].addr = MSR_P4_CRU_ESCR5;
 		}
 	}
+
+	for (i = 0; i < num_counters; ++i) {
+		if (!counter_config[i].enabled)
+			continue;
+		if (msrs->controls[i].addr)
+			continue;
+		op_x86_warn_reserved(i);
+		p4_shutdown(msrs);
+		return -EBUSY;
+	}
+
+	return 0;
 }
 
 
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index b07d25a..1fd17cf 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -46,21 +46,30 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 	}
 }
 
-static void ppro_fill_in_addresses(struct op_msrs * const msrs)
+static int ppro_fill_in_addresses(struct op_msrs * const msrs)
 {
 	int i;
 
 	for (i = 0; i < num_counters; i++) {
 		if (!reserve_perfctr_nmi(MSR_P6_PERFCTR0 + i))
-			continue;
+			goto fail;
 		if (!reserve_evntsel_nmi(MSR_P6_EVNTSEL0 + i)) {
 			release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
-			continue;
+			goto fail;
 		}
 		/* both registers must be reserved */
 		msrs->counters[i].addr = MSR_P6_PERFCTR0 + i;
 		msrs->controls[i].addr = MSR_P6_EVNTSEL0 + i;
+		continue;
+	fail:
+		if (!counter_config[i].enabled)
+			continue;
+		op_x86_warn_reserved(i);
+		ppro_shutdown(msrs);
+		return -EBUSY;
 	}
+
+	return 0;
 }
 
 
@@ -96,15 +105,8 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* clear all counters */
 	for (i = 0; i < num_counters; ++i) {
-		if (unlikely(!msrs->controls[i].addr)) {
-			if (counter_config[i].enabled && !smp_processor_id())
-				/*
-				 * counter is reserved, this is on all
-				 * cpus, so report only for cpu #0
-				 */
-				op_x86_warn_reserved(i);
+		if (!msrs->controls[i].addr)
 			continue;
-		}
 		rdmsrl(msrs->controls[i].addr, val);
 		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
 			op_x86_warn_in_use(i);
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index ff82a75..5514013 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -41,7 +41,7 @@ struct op_x86_model_spec {
 	u16		event_mask;
 	int		(*init)(struct oprofile_operations *ops);
 	void		(*exit)(void);
-	void		(*fill_in_addresses)(struct op_msrs * const msrs);
+	int		(*fill_in_addresses)(struct op_msrs * const msrs);
 	void		(*setup_ctrs)(struct op_x86_model_spec const *model,
 				      struct op_msrs const * const msrs);
 	int		(*check_ctrs)(struct pt_regs * const regs,
-- 
1.7.0.3


