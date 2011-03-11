Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab1CKQXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:23:55 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:45686 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754890Ab1CKQXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:23:37 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: qy.q_AsVM1lKfuq14t944i7nIS.thf8GMj8nRtAtdTuJh9D
 tRcQm6MPJ_PsyrYYuKnsgiZTmjyaGoZlyDrgomSACOt.bByYi9_CJ8HipQCw
 kr0cCr0xp7.Na_NhZuz_o622ITKwakQFq0dV7h0AtpO5utD9Six6dnpBD4w1
 9fJxSxltSlZAmPy3deLF2iMVSJYXU5gHOQdHz0DL.Jteav8u8eyG8XfCHj10
 oAKhGDqBWx7CQOCJCWTzBf0IPKRvrgxu3KkiZMlQaVjd7Uf1rg7QW3LIuUyb
 nvifvZTVnG3M6LTPZEQMA_D9M2_FNivmjLkG90DzB4Cgb1GM-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110311162334.774583751@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 11 Mar 2011 10:23:13 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [x86 this_cpu_has V1 3/4] x86: Use this_cpu_has for thermal_interrupt
References: <20110311162310.124405247@linux.com>
Content-Disposition: inline; filename=thermal_interrupt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is more effective to use a segment prefix instead of calculating the
address of the current cpu area amd then testing flags.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mcheck/therm_throt.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/therm_throt.c	2011-03-11 10:17:42.000000000 -0600
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/therm_throt.c	2011-03-11 10:18:34.000000000 -0600
@@ -355,7 +355,6 @@ static void notify_thresholds(__u64 msr_
 static void intel_thermal_interrupt(void)
 {
 	__u64 msr_val;
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 
 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
 
@@ -367,19 +366,19 @@ static void intel_thermal_interrupt(void
 				CORE_LEVEL) != 0)
 		mce_log_therm_throt_event(CORE_THROTTLED | msr_val);
 
-	if (cpu_has(c, X86_FEATURE_PLN))
+	if (this_cpu_has(X86_FEATURE_PLN))
 		if (therm_throt_process(msr_val & THERM_STATUS_POWER_LIMIT,
 					POWER_LIMIT_EVENT,
 					CORE_LEVEL) != 0)
 			mce_log_therm_throt_event(CORE_POWER_LIMIT | msr_val);
 
-	if (cpu_has(c, X86_FEATURE_PTS)) {
+	if (this_cpu_has(X86_FEATURE_PTS)) {
 		rdmsrl(MSR_IA32_PACKAGE_THERM_STATUS, msr_val);
 		if (therm_throt_process(msr_val & PACKAGE_THERM_STATUS_PROCHOT,
 					THERMAL_THROTTLING_EVENT,
 					PACKAGE_LEVEL) != 0)
 			mce_log_therm_throt_event(PACKAGE_THROTTLED | msr_val);
-		if (cpu_has(c, X86_FEATURE_PLN))
+		if (this_cpu_has(X86_FEATURE_PLN))
 			if (therm_throt_process(msr_val &
 					PACKAGE_THERM_STATUS_POWER_LIMIT,
 					POWER_LIMIT_EVENT,

