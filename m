Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab0LPSOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:14:05 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:44731 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752078Ab0LPSOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:14:01 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: EDTpppgVM1l1BcAF_tgfqwE0pBG.5z9TyGqRkiDz5n7O_EJ
 JLDp9w6KzhgKTx6S0LxC0A5OWecTcVgByzEK0GHE3Gky1p9n0V_9VqOX8XC.
 9nVah2tndu.3T5TEbqe913J.blpdAtcyATdM0Jufhx1U0BxHqPiIiz5P9zVA
 pQp_Lm4mrUpYhtuavPpQa7T4dsHCAs_F9tulO3FyDYyTYBh8b5QuLi0HQqh0
 0D.1WXFk0hG9KP1.n.lTsDoaE8B3J3.p8W_ZhgOgyJ3Jf8UAjXgzYTp6qkqA
 FctCDbPgdJSKS6o__fhKMsSXj.FPkzsdIJQYYDO0z0BAUoBc-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 16 Dec 2010 12:13:57 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <htejun@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: x86: Use this_cpu_has for thermal_interrupt
In-Reply-To: <4D0A3AF2.50508@gmail.com>
Message-ID: <alpine.DEB.2.00.1012161212130.21588@router.home>
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop> <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com> <alpine.DEB.2.00.1012141109470.17229@router.home>
 <4D07A7CB.7010205@zytor.com> <4D07A95C.7030703@kernel.org> <4D0814AF.7080209@zytor.com> <4D08ECEF.3040909@kernel.org> <4D08EE57.8010602@zytor.com> <4D08EF4E.8070403@kernel.org> <4D0A3AF2.50508@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/therm_throt.c	2010-12-16 11:41:48.000000000 -0600
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/therm_throt.c	2010-12-16 11:43:42.000000000 -0600
@@ -317,7 +317,6 @@ device_initcall(thermal_throttle_init_de
 static void intel_thermal_interrupt(void)
 {
 	__u64 msr_val;
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());

 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);

@@ -326,19 +325,19 @@ static void intel_thermal_interrupt(void
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

