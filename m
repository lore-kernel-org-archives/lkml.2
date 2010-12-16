Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab0LPSQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:16:21 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:43118 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754759Ab0LPSQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:16:20 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: x50yssEVM1mcnPdzSZQdGGGLRG_zcrp2GppLob7Lu_9taX7
 X0g7RNPH4DpLIFuZ6QP6P7R4EpxbErXl1vNdktDMYGt3sk.xCrj3s8bI92Qv
 Xn6C.g.vVrUrWxAwBPxYYbSq9dCWvHpnFS0s9PZeOg3wPotklXI2dVeIeweb
 WBgl5j45yaB9k0VNTkCam.gKlSZ9OllbK1Mv9Dea8dtDuK7KQ4cfyd5HC_Fn
 tXqXClWURMGcmcTIjVhdDPxFWXPJh1DueH3CocB5jaNw7eztr._1BhhwXDVm
 delBCu29gm1RdEP_A9bwXMHXk2CCzFX2EXFQhC4Q0h1LxE8c-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 16 Dec 2010 12:16:16 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <htejun@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: acpi throttling: Use this_cpu_has and simplify code
In-Reply-To: <4D0A3AF2.50508@gmail.com>
Message-ID: <alpine.DEB.2.00.1012161215200.21588@router.home>
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop> <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com> <alpine.DEB.2.00.1012141109470.17229@router.home>
 <4D07A7CB.7010205@zytor.com> <4D07A95C.7030703@kernel.org> <4D0814AF.7080209@zytor.com> <4D08ECEF.3040909@kernel.org> <4D08EE57.8010602@zytor.com> <4D08EF4E.8070403@kernel.org> <4D0A3AF2.50508@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With the this_cpu_xx we no longer need to pass an acpi
structure to the msr management code. Simplifies code and improves
performance.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 drivers/acpi/processor_throttling.c |   32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

Index: linux-2.6/drivers/acpi/processor_throttling.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_throttling.c	2010-12-16 11:56:57.000000000 -0600
+++ linux-2.6/drivers/acpi/processor_throttling.c	2010-12-16 12:00:17.000000000 -0600
@@ -662,20 +662,14 @@ static int acpi_processor_get_throttling
 }

 #ifdef CONFIG_X86
-static int acpi_throttling_rdmsr(struct acpi_processor *pr,
-					u64 *value)
+static int acpi_throttling_rdmsr(u64 *value)
 {
-	struct cpuinfo_x86 *c;
 	u64 msr_high, msr_low;
-	unsigned int cpu;
 	u64 msr = 0;
 	int ret = -1;

-	cpu = pr->id;
-	c = &cpu_data(cpu);
-
-	if ((c->x86_vendor != X86_VENDOR_INTEL) ||
-		!cpu_has(c, X86_FEATURE_ACPI)) {
+	if ((this_cpu_read(cpu_info.x86_vendor) != X86_VENDOR_INTEL) ||
+		!this_cpu_has(X86_FEATURE_ACPI)) {
 		printk(KERN_ERR PREFIX
 			"HARDWARE addr space,NOT supported yet\n");
 	} else {
@@ -690,18 +684,13 @@ static int acpi_throttling_rdmsr(struct
 	return ret;
 }

-static int acpi_throttling_wrmsr(struct acpi_processor *pr, u64 value)
+static int acpi_throttling_wrmsr(u64 value)
 {
-	struct cpuinfo_x86 *c;
-	unsigned int cpu;
 	int ret = -1;
 	u64 msr;

-	cpu = pr->id;
-	c = &cpu_data(cpu);
-
-	if ((c->x86_vendor != X86_VENDOR_INTEL) ||
-		!cpu_has(c, X86_FEATURE_ACPI)) {
+	if ((this_cpu_read(cpu_info.x86_vendor) != X86_VENDOR_INTEL) ||
+		!this_cpu_has(X86_FEATURE_ACPI)) {
 		printk(KERN_ERR PREFIX
 			"HARDWARE addr space,NOT supported yet\n");
 	} else {
@@ -713,15 +702,14 @@ static int acpi_throttling_wrmsr(struct
 	return ret;
 }
 #else
-static int acpi_throttling_rdmsr(struct acpi_processor *pr,
-				u64 *value)
+static int acpi_throttling_rdmsr(u64 *value)
 {
 	printk(KERN_ERR PREFIX
 		"HARDWARE addr space,NOT supported yet\n");
 	return -1;
 }

-static int acpi_throttling_wrmsr(struct acpi_processor *pr, u64 value)
+static int acpi_throttling_wrmsr(u64 value)
 {
 	printk(KERN_ERR PREFIX
 		"HARDWARE addr space,NOT supported yet\n");
@@ -753,7 +741,7 @@ static int acpi_read_throttling_status(s
 		ret = 0;
 		break;
 	case ACPI_ADR_SPACE_FIXED_HARDWARE:
-		ret = acpi_throttling_rdmsr(pr, value);
+		ret = acpi_throttling_rdmsr(value);
 		break;
 	default:
 		printk(KERN_ERR PREFIX "Unknown addr space %d\n",
@@ -786,7 +774,7 @@ static int acpi_write_throttling_state(s
 		ret = 0;
 		break;
 	case ACPI_ADR_SPACE_FIXED_HARDWARE:
-		ret = acpi_throttling_wrmsr(pr, value);
+		ret = acpi_throttling_wrmsr(value);
 		break;
 	default:
 		printk(KERN_ERR PREFIX "Unknown addr space %d\n",

