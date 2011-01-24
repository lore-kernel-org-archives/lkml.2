Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab1AXRZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:25:17 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42500 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab1AXRZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:25:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NwoGdmzF4yyXnQsOmv8iobuXEYPbqBa/UzBlrbTXyfoB5+/E58fiAHdaaWzadAlstV
         3aqJ4A6yY9kU61NfPKFlUdPiaOHfA2gxSMuOafD1X5wPbW7cbB69JbhW/s2oM25zQ8RD
         SmcQCgWXc/yAeCvI35iGybPRlDPd4Xtd4NWzk=
Date: Mon, 24 Jan 2011 18:25:05 +0100
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: cl@linux.com, Pekka Enbeerg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org
Subject: [PATCH 3/3] acpi throttling: Use this_cpu_has and simplify code
 current cpu
Message-ID: <20110124172505.GK27510@htj.dyndns.org>
References: <20110124172357.GI27510@htj.dyndns.org>
 <20110124172428.GJ27510@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124172428.GJ27510@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

With the this_cpu_xx we no longer need to pass an acpi
structure to the msr management code. Simplifies code and improves
performance.

Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 drivers/acpi/processor_throttling.c |   32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

Index: work/drivers/acpi/processor_throttling.c
===================================================================
--- work.orig/drivers/acpi/processor_throttling.c
+++ work/drivers/acpi/processor_throttling.c
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
