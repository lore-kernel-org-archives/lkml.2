Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab1CKQXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:23:50 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:30467 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754943Ab1CKQXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:23:37 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 1muGMzEVM1mcfCPRqx7OvWhtxsxCXr1jIFlpaanCwqsPLAK
 TCGea60Q020vFXAnJDiOdDmu8uyfVx9gfJDfIll_qzUrEapNwiXzIbuGRGEt
 yPLVA4arLri1eHD1I93X0uX6b8Vg1JEz29DtVo.U5wq2NAmlAaupQPoqWwCx
 lDoBaH1DxJGetE.sA2YAiCzB0c9.BcYA8NltAME4nqU4iTNE3K6cmNKsnOhH
 D51MbtwDaa_CTWWCFytnV2ioXcSwLQMYe.UwRtug5iHuTxqsBoGIGIwEIRut
 Skl0lPu.zbeQbel8W2wh6xi7qKJ_P8lDOlFZh77Kpv0wpdJw-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110311162335.393215316@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 11 Mar 2011 10:23:14 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [x86 this_cpu_has V1 4/4] acpi throttling: Use this_cpu_has and simplify code
References: <20110311162310.124405247@linux.com>
Content-Disposition: inline; filename=acpui
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the this_cpu information we no longer need to pass an acpi
structure to the msr management code. Simplifies code and improves
performance.

NOTE: This code is x86 specific (see #ifdef CONFIG_X86) but not under arch/x86.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 drivers/acpi/processor_throttling.c |   32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

Index: linux-2.6/drivers/acpi/processor_throttling.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_throttling.c	2011-01-14 08:55:53.000000000 -0600
+++ linux-2.6/drivers/acpi/processor_throttling.c	2011-01-14 09:05:26.000000000 -0600
@@ -710,20 +710,14 @@ static int acpi_processor_get_throttling
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
@@ -738,18 +732,13 @@ static int acpi_throttling_rdmsr(struct
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
@@ -761,15 +750,14 @@ static int acpi_throttling_wrmsr(struct
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
@@ -801,7 +789,7 @@ static int acpi_read_throttling_status(s
 		ret = 0;
 		break;
 	case ACPI_ADR_SPACE_FIXED_HARDWARE:
-		ret = acpi_throttling_rdmsr(pr, value);
+		ret = acpi_throttling_rdmsr(value);
 		break;
 	default:
 		printk(KERN_ERR PREFIX "Unknown addr space %d\n",
@@ -834,7 +822,7 @@ static int acpi_write_throttling_state(s
 		ret = 0;
 		break;
 	case ACPI_ADR_SPACE_FIXED_HARDWARE:
-		ret = acpi_throttling_wrmsr(pr, value);
+		ret = acpi_throttling_wrmsr(value);
 		break;
 	default:
 		printk(KERN_ERR PREFIX "Unknown addr space %d\n",

